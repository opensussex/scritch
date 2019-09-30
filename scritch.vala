public class Scritch : Gtk.Application {

    public Scritch () {
        Object (
            application_id: "com.github.opensussex.scritch",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected void on_buffer_changed (Gtk.TextBuffer buffer) {
        buffer_changed = true;
    }

    protected bool save_buffer() {
        try {
            if (buffer_changed) {
                FileUtils.set_contents("scritch.txt", buffer.text);
                buffer_changed = false;
            }
        } catch (Error e) {
            //print (e.message);
        }
        return true;
    }

    protected Gtk.TextBuffer buffer;
    protected bool buffer_changed;

    protected override void activate () {
        var main_window = new Gtk.ApplicationWindow (this);
        main_window.default_height = 500;
        main_window.default_width = 500;
        main_window.title = "Scritch";
        string initial_buffer_content;
        try {
            FileUtils.get_contents("scritch.txt", out initial_buffer_content);
        } catch (Error e) {

        }

        buffer = new Gtk.TextBuffer (null);
        buffer.set_text (initial_buffer_content);
        var textview = new Gtk.TextView.with_buffer (buffer);

        buffer.changed.connect (on_buffer_changed);
        GLib.Timeout.add_seconds_full(GLib.Priority.DEFAULT, 15, save_buffer);

        textview.set_wrap_mode (Gtk.WrapMode.WORD);

        var scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scrolled_window.add (textview);
        scrolled_window.set_border_width (5);

        main_window.add (scrolled_window);

        main_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Scritch ();
        return app.run (args);
    }
}
