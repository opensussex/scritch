public class Scritch : Gtk.Application {

    public Scritch () {
        Object (
            application_id: "com.github.opensussex.scritch",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var main_window = new Gtk.ApplicationWindow (this);
        main_window.default_height = 300;
        main_window.default_width = 300;
        main_window.title = "Scritch";
        main_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Scritch ();
        return app.run (args);
    }
}
