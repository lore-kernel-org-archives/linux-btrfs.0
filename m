From: Chris Mason <chris.mason@oracle.com>
Subject: please review recent fixes for file write and fiemap
Date: Tue, 08 Mar 2011 12:58:40 -0500
Message-ID: <1299606753-sup-5310@think>
Content-Type: text/plain; charset=UTF-8
To: "Linux Btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Everyone,

The master branch of the btrfs-unstable tree has three shiny new
commits, which fix some important bugs in file_write and fiemap.

These are not yet pushed to Linus but the plan is to send them out
before the final .38 release.

The commits fix errors in the copy_from_user handling where short
returns or zero returns would make btrfs_file_write do the wrong thing.
This included looping forever, or pretending pages were up to date when
they really were not.

There is also another fiemap fix. Our fiemap was returning overlapping
extents, which made recent versions of cp copy too many bytes into the
destination file.

The top commit is this one (just in case kernel.org hasn't caught up
yet)

commit ea8efc74bd0402b4d5f663d007b4e25fa29ea778
Author: Chris Mason <chris.mason@oracle.com>
Date:   Tue Mar 8 11:54:40 2011 -0500

    Btrfs: make sure not to return overlapping extents to fiemap

Please read them, and try to break them ;)

-chris
