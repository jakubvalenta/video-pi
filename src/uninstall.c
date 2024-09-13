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

    const char *pcmanfm_dir_path =
        g_build_filename(config_dir_path, "pcmanfm",
                         g_strconcat("LXDE-", pw->pw_name, NULL), NULL);
    g_mkdir_with_parents(pcmanfm_dir_path, 0777);

    const char *pcmanfm_conf_path =
        g_build_filename(pcmanfm_dir_path, "pcmanfm.conf", NULL);
    const char *pcmanfm_conf_bak_path =
        g_build_filename(pcmanfm_dir_path, ".pcmanfm.conf.video-pi.bak", NULL);

    printf("Restoring backup of %s\n", pcmanfm_conf_path);
    rename(pcmanfm_conf_bak_path, pcmanfm_conf_path);

    const char *desktop_items_path =
        g_build_filename(pcmanfm_dir_path, "desktop-items-0.conf", NULL);
    const char *desktop_items_bak_path = g_build_filename(
        pcmanfm_dir_path, ".desktop-items-0.conf.video-pi.bak", NULL);

    printf("Restoring backup of %s\n", desktop_items_path);
    rename(desktop_items_bak_path, desktop_items_path);

    const char *panels_dir_path = g_build_filename(
        config_dir_path, "lxpanel", g_strconcat("LXDE-", pw->pw_name, NULL),
        "panels", NULL);
    g_mkdir_with_parents(panels_dir_path, 0777);

    const char *panel_path = g_build_filename(panels_dir_path, "panel", NULL);
    const char *panel_bak_path =
        g_build_filename(panels_dir_path, ".panel.video-pi.bak", NULL);

    printf("Restoring backup of %s\n", panel_bak_path);
    rename(panel_bak_path, panel_path);

    printf("Uninstallation finished\n");
    printf("You can now remove the udevil and video-pi packages using:\n");
    printf("sudo apt --purge remove udevil video-pi\n");
}
