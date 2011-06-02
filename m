From: "Fajar A. Nugraha" <list@fajar.net>
Subject: [PATCH] make "btrfs filesystem label" command actually work
Date: Thu, 2 Jun 2011 09:54:27 +0700
Message-ID: <BANLkTikGo52=CHtwYN2Eh9wv=RTH5+sANg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This simple patch makes "btrfs filesystem label" command actually work.

On tmp branch, commit d1dc6a9, "btrfs filesystem label" functionality
was introduced. However the commit lacks one component that lets
"btrfs" accept "filesystem label" command.
Test case:

#===================================================

# truncate -s 1G /tmp/dev.img

# losetup -f
/dev/loop0

# losetup /dev/loop0 /tmp/dev.img

# mkfs.btrfs -L old /dev/loop0

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label old on /dev/loop0
	nodesize 4096 leafsize 4096 sectorsize 4096 size 1.00GB
Btrfs Btrfs v0.19

# btrfs fi la /dev/loop0
old

# btrfs fi la /dev/loop0 new

# btrfs fi la /dev/loop0
new

# mount /dev/disk/by-label/new /mnt/tmp

# btrfs fi la /dev/loop0
FATAL: the filesystem has to be unmounted

# umount /dev/loop0

# btrfs fi la /dev/loop0
new

#===================================================

Not sure if you need if you need a signoff for something as trivial as
this, but here it is just in case.

Signed-off-by: Fajar A. Nugraha <list@fajar.net>
---
 btrfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 4cd4210..84c2337 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -95,6 +95,12 @@ static struct Command commands[] = {
          "filesystem balance", "<path>\n"
                "Balance the chunks across the device."
        },
+       { do_change_label, -1,
+         "filesystem label", "<device> [<newlabel>]\n"
+               "With one argument, get the label of filesystem on <device>.\n"
+               "If <newlabel> is passed, set the filesystem label to
<newlabel>.\n"
+               "The filesystem must be unmounted.\n"
+       },
        { do_scan, 999,
          "device scan", "[<device>...]\n"
                "Scan all device for or the passed device for a btrfs\n"
---

-- 
Fajar
