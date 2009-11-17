From: Chris Ball <cjb@laptop.org>
Subject: RFC: Btrfs snapshots feature proposal for Fedora 13
Date: Tue, 17 Nov 2009 12:00:49 -0500
Message-ID: <m3lji59jcu.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've written up a draft of an Fedora 13 feature proposal for
filesystem rollback using Btrfs snapshots that are automatically
created by yum:

   https://fedoraproject.org/wiki/Features/SystemRollbackWithBtrfs

It'd be great to get feedback on whether this is a good idea, and how
the UI interaction should work.  We're also discussing it in this
fedora-devel thread:

   http://thread.gmane.org/gmane.linux.redhat.fedora.devel/123695

Some comments I've got already received, from the thread:

* People want the UI to allow independent active snapshots per
  filesystem (i.e. btrfs /home is the live filesystem, and btrfs / is
  an older snapshot).

* Several people think that the ZFS Time Slider patches to nautilus=C2=B9
  look good, and want that for btrfs.  Sounds plausible, but I'm
  more interested in first working on ways to let developers feel
  comfortable upgrading to the development version of Fedora each
  day with the possibility of reverting.

* Instead of inventing a new system-config-blah, this should probably
  be part of Palimpsest=C2=B2.

* Perhaps we should encourage people using the Fedora installer with
  btrfs to create a rootfs separate to their /home, so that they can
  rollback rootfs snapshots without affecting their homedir.

Thanks!

- Chris.

=C2=B9:  http://blogs.sun.com/erwann/entry/zfs_on_the_desktop_zfs
    http://blogs.sun.com/erwann/entry/time_slider_screencast
    http://blogs.sun.com/erwann/entry/new_time_slider_features_in

=C2=B2:  http://library.gnome.org/users/palimpsest/stable/intro.html.en
--=20
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
