#include <glib.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    uid_t uid = geteuid();
    struct passwd *pw = getpwuid(uid);
    if (pw->pw_dir == NULL) {
        perror("missing home directory");
        exit(EXIT_FAILURE);
    }
    const char *config_dir_path =
        g_getenv("XDG_CONFIG_PATH")
            ?: g_build_filename(pw->pw_dir, "/.config", NULL);

    const char *lxde_dir_path =
        g_build_filename(config_dir_path, "pcmanfm",
                         g_strconcat("LXDE-", pw->pw_name, NULL), NULL);
    g_mkdir_with_parents(lxde_dir_path, 0777);

    const char *pcmanfm_conf_path =
        g_build_filename(lxde_dir_path, "pcmanfm.conf", NULL);
    const char *pcmanfm_conf_bak_path =
        g_strconcat(pcmanfm_conf_path, ".video-pi.bak", NULL);

    printf("Restoring a backup of %s\n", pcmanfm_conf_path);
    rename(pcmanfm_conf_bak_path, pcmanfm_conf_path);

    const char *desktop_items_path =
        g_build_filename(lxde_dir_path, "desktop-items-0.conf", NULL);
    const char *desktop_items_bak_path =
        g_strconcat(desktop_items_path, ".video-pi.bak", NULL);

    printf("Restoring a backup of %s\n", desktop_items_path);
    rename(desktop_items_bak_path, desktop_items_path);

    printf("Uninstallation finished\n");
}
