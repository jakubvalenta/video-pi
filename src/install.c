#define _GNU_SOURCE
#include <fcntl.h>
#include <glib.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

void copy_file(const char *path_in, const char *path_out) {
    int fd_in, fd_out;
    off_t len, ret;
    struct stat stat;

    fd_in = open(path_in, O_RDONLY);
    if (fd_in == -1) {
        // If the source file doesn't exist, create an empty one.
        fd_in = open(path_in, O_CREAT | O_WRONLY | O_TRUNC, 0644);
        if (fd_in == -1) {
            perror("open (path_in)");
            exit(EXIT_FAILURE);
        }
    }

    if (fstat(fd_in, &stat) == -1) {
        perror("fstat");
        exit(EXIT_FAILURE);
    }

    len = stat.st_size;

    fd_out = open(path_out, O_CREAT | O_WRONLY | O_TRUNC, 0644);
    if (fd_out == -1) {
        perror("open (path_out)");
        exit(EXIT_FAILURE);
    }

    while (len > 0) {
        ret = copy_file_range(fd_in, NULL, fd_out, NULL, len, 0);
        if (ret == -1) {
            perror("copy_file_range");
            exit(EXIT_FAILURE);
        }
        if (ret <= 0) {
            break;
        }
        len -= ret;
    }

    close(fd_in);
    close(fd_out);
}

void update_key_file(const char *path, const char *group_name,
                     const char *vals[][2], const size_t size) {
    g_autoptr(GKeyFile) key_file = g_key_file_new();
    g_autoptr(GError) error = NULL;

    g_key_file_load_from_file(
        key_file, path, G_KEY_FILE_KEEP_COMMENTS | G_KEY_FILE_KEEP_TRANSLATIONS,
        NULL);

    for (size_t i = 0; i < size; i++) {
        g_key_file_set_string(key_file, group_name, vals[i][0], vals[i][1]);
    }

    if (!g_key_file_save_to_file(key_file, path, &error)) {
        fprintf(stderr, "error saving key file %s: %s", path, error->message);
        exit(EXIT_FAILURE);
    }
}

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
        g_strconcat(pcmanfm_conf_path, ".video-pi.bak", NULL);

    printf("Creating backup of %s\n", pcmanfm_conf_path);
    copy_file(pcmanfm_conf_path, pcmanfm_conf_bak_path);

    const char *pcmanfm_conf_vals[][2] = {
        {"mount_on_startup", "0"}, {"mount_removable", "0"}, {"autorun", "0"}};

    printf("Changing settings in %s\n", pcmanfm_conf_path);
    update_key_file(pcmanfm_conf_path, "volume", pcmanfm_conf_vals, 3);

    const char *desktop_items_path =
        g_build_filename(pcmanfm_dir_path, "desktop-items-0.conf", NULL);
    const char *desktop_items_bak_path =
        g_strconcat(desktop_items_path, ".video-pi.bak", NULL);

    printf("Creating backup of %s\n", desktop_items_path);
    copy_file(desktop_items_path, desktop_items_bak_path);

    const char *desktop_items_vals[][2] = {{"desktop_bg", "#000000"},
                                           {"desktop_fg", "#FFFFFF"},
                                           {"desktop_shadow", "#000000"},
                                           {"wallpaper_mode", "color"},
                                           {"show_documents", "0"},
                                           {"show_mounts", "0"},
                                           {"show_trash", "0"}};

    printf("Changing settings in %s\n", desktop_items_path);
    update_key_file(desktop_items_path, "*", desktop_items_vals, 7);

    const char *panels_dir_path = g_build_filename(
        config_dir_path, "lxpanel", g_strconcat("LXDE-", pw->pw_name, NULL),
        "panels", NULL);
    g_mkdir_with_parents(panels_dir_path, 0777);

    const char *panel_path = g_build_filename(panels_dir_path, "panel", NULL);
    const char *panel_bak_path = g_strconcat(panel_path, ".video-pi.bak", NULL);

    printf("Creating backup of %s\n", panel_path);
    copy_file(panel_path, panel_bak_path);

    printf("Changing settings in %s\n", panel_path);
    copy_file("/usr/share/video-pi/panel", panel_path);

    printf("Installation finished\n");
    printf("You should now log in and log out again\n");
}
