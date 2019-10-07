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

        var style = """
            textview text {
                background-color: #131c16;
                color: #3ce85c;
            }
        """;

        var css_provider = new Gtk.CssProvider();
        
        try {
            css_provider.load_from_data(style, -1);
        } catch (GLib.Error e) {
            warning ("Failed to parse css style : %s", e.message);
        }

        Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

        buffer = new Gtk.TextBuffer (null);
        buffer.set_text (initial_buffer_content);
        var textview = new Gtk.TextView.with_buffer (buffer);
        textview.left_margin  = 5;
        textview.right_margin  = 5;
        textview.top_margin  = 5;
        textview.bottom_margin  = 5;

        buffer.changed.connect (on_buffer_changed);
        GLib.Timeout.add_seconds_full(GLib.Priority.DEFAULT, 5, save_buffer);

        textview.set_wrap_mode (Gtk.WrapMode.WORD);

        var scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scrolled_window.add (textview);

        main_window.add (scrolled_window);

        main_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Scritch ();
        return app.run (args);
    }
}
