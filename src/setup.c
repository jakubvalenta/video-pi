#include <glib.h>
#include <pwd.h>
#include <unistd.h>

void update_key_file(const char *path, const char *group_name,
                     const char *items[][2], const size_t size) {
    g_autoptr(GKeyFile) key_file = g_key_file_new();
    g_autoptr(GError) error = NULL;

    if (!g_key_file_load_from_file(
            key_file, path,
            G_KEY_FILE_KEEP_COMMENTS | G_KEY_FILE_KEEP_TRANSLATIONS, &error)) {
        g_warning("Error loading key file %s: %s", path, error->message);
    }

    for (size_t i = 0; i < size; i++) {
        g_key_file_set_string(key_file, group_name, items[i][0], items[i][1]);
    }

    if (!g_key_file_save_to_file(key_file, path, &error)) {
        g_warning("Error saving key file %s: %s", path, error->message);
    }
}

int main() {
    uid_t uid = geteuid();
    struct passwd *pw = getpwuid(uid);
    if (pw->pw_dir == NULL) {
        g_error("User is missing a home directory");
        return 1;
    }
    const char *config_path =
        g_getenv("XDG_CONFIG_PATH")
            ?: g_build_filename(pw->pw_dir, "/.config", NULL);

    const char *items_pcmanfm_conf[][2] = {
        {"mount_on_startup", "0"}, {"mount_removable", "0"}, {"autorun", "0"}};
    update_key_file(g_build_filename(config_path, "pcmanfm",
                                     g_strconcat("LXDE-", pw->pw_name, NULL),
                                     "pcmanfm.conf", NULL),
                    "volume", items_pcmanfm_conf, 3);

    const char *items_pcmanfm_desktop[][2] = {
        {"desktop_fg", "#ffffffffffff"},
        {"wallpaper", "/usr/share/video-pi/video-pi-wallpaper.svg"},
        {"wallpaper_mode", "crop"},
        {"show_trash", "0"}};
    update_key_file(g_build_filename(config_path, "pcmanfm",
                                     g_strconcat("LXDE-", pw->pw_name, NULL),
                                     "desktop-items-0.conf", NULL),
                    "*", items_pcmanfm_desktop, 4);
}
