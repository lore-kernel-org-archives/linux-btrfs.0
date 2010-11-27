From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [next-rc] Compile Error fs/btrfs/diskio.c
Date: Sat, 27 Nov 2010 16:53:23 -0600
Message-ID: <AANLkTi=GVdSTacEVPRqQJu0Fktm8H4aDYfF5wuDDnrH4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been getting a compile error when building the 'next-rc' branch
of btrfs-unstable.

  CC      fs/btrfs/disk-io.o
fs/btrfs/disk-io.c: In function =91btree_migratepage=92:
fs/btrfs/disk-io.c:716: error: called object =910u=92 is not a function
make[2]: *** [fs/btrfs/disk-io.o] Error 1
make[1]: *** [fs/btrfs] Error 2
make: *** [fs] Error 2

Line 716 of fs/btrfs/disk-io.c is:

        return migrate_page(mapping, newpage, page);

This is related to the "Btrfs: add migrate page for metadata inode"
patch (the first patch in the set of patches added to the next-rc
branch).

When I configure my kernel with CONFIG_MEMORY_HOTPLUG=3Dn, this
automatically unconfigures CONFIG_MIGRATION.

In include/linux/migrate.h, when CONFIG_MIGRATION is not set,
migrate_page is defined as NULL:

/* Possible settings for the migrate_page() method in address_operation=
s */
#define migrate_page NULL

So in this case, migrate_page is defined as NULL instead of as a
function (hence, the "called object is not a function" error).

I've confirmed that setting CONFIG_MEMORY_HOTPLUG=3Dy and
CONFIG_MIGRATION=3Dy is a workaround to clear the error.

As a possible fix, I've wrapped a "#ifdef CONFIG_MIGRATION" statement
around part of the patch, and it seems to be working OK for me.  Let
me know if you want this patch submitted as a git patch, although it
might make more sense to fix the original patch since it's still early
in 'next-rc' review period.

$ diff -Nau fs/btrfs/disk-io.c /usr/src/linux/fs/btrfs/disk-io.c
--- fs/btrfs/disk-io.c	2010-11-27 15:59:22.896666675 -0600
+++ /usr/src/linux/fs/btrfs/disk-io.c	2010-11-27 16:08:15.643333349 -06=
00
@@ -696,6 +696,7 @@
 				   __btree_submit_bio_done);
 }

+#ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
 			struct page *newpage, struct page *page)
 {
@@ -715,6 +716,9 @@

 	return migrate_page(mapping, newpage, page);
 }
+#else
+#define btree_migratepage NULL
+#endif

 static int btree_writepage(struct page *page, struct writeback_control=
 *wbc)
 {
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
