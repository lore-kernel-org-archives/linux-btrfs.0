Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36349 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971630AbeEXVln (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 17:41:43 -0400
Received: by mail-pl0-f66.google.com with SMTP id v24-v6so1831975plo.3
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2018 14:41:42 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH v4 2/6] vfs: update swap_{,de}activate documentation
Date: Thu, 24 May 2018 14:41:26 -0700
Message-Id: <4578bf3c7543f6f9a95b14a0523f2066f58ad43d.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The documentation for these functions is wrong in several ways:

- swap_activate() is called with the inode locked
- swap_activate() takes a swap_info_struct * and a sector_t *
- swap_activate() can also return a positive number of extents it added
  itself
- swap_deactivate() does not return anything

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Documentation/filesystems/Locking | 17 +++++++----------
 Documentation/filesystems/vfs.txt | 12 ++++++++----
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 75d2d57e2c44..7f009e98fa3c 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -211,8 +211,9 @@ prototypes:
 	int (*launder_page)(struct page *);
 	int (*is_partially_uptodate)(struct page *, unsigned long, unsigned long);
 	int (*error_remove_page)(struct address_space *, struct page *);
-	int (*swap_activate)(struct file *);
-	int (*swap_deactivate)(struct file *);
+	int (*swap_activate)(struct swap_info_struct *, struct file *,
+			     sector_t *);
+	void (*swap_deactivate)(struct file *);
 
 locking rules:
 	All except set_page_dirty and freepage may block
@@ -236,8 +237,8 @@ putback_page:		yes
 launder_page:		yes
 is_partially_uptodate:	yes
 error_remove_page:	yes
-swap_activate:		no
-swap_deactivate:	no
+swap_activate:					yes
+swap_deactivate:				no
 
 	->write_begin(), ->write_end() and ->readpage() may be called from
 the request handler (/dev/loop).
@@ -334,14 +335,10 @@ cleaned, or an error value if not. Note that in order to prevent the page
 getting mapped back in and redirtied, it needs to be kept locked
 across the entire operation.
 
-	->swap_activate will be called with a non-zero argument on
-files backing (non block device backed) swapfiles. A return value
-of zero indicates success, in which case this file can be used for
-backing swapspace. The swapspace operations will be proxied to the
-address space operations.
+	->swap_activate is called from sys_swapon() with the inode locked.
 
 	->swap_deactivate() will be called in the sys_swapoff()
-path after ->swap_activate() returned success.
+path after ->swap_activate() returned success. The inode is not locked.
 
 ----------------------- file_lock_operations ------------------------------
 prototypes:
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 5fd325df59e2..0149109d94d1 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -650,8 +650,9 @@ struct address_space_operations {
 					unsigned long);
 	void (*is_dirty_writeback) (struct page *, bool *, bool *);
 	int (*error_remove_page) (struct mapping *mapping, struct page *page);
-	int (*swap_activate)(struct file *);
-	int (*swap_deactivate)(struct file *);
+	int (*swap_activate)(struct swap_info_struct *, struct file *,
+			     sector_t *);
+	void (*swap_deactivate)(struct file *);
 };
 
   writepage: called by the VM to write a dirty page to backing store.
@@ -828,8 +829,11 @@ struct address_space_operations {
 
   swap_activate: Called when swapon is used on a file to allocate
 	space if necessary and pin the block lookup information in
-	memory. A return value of zero indicates success,
-	in which case this file can be used to back swapspace.
+	memory. If this returns zero, the swap system will call the address
+	space operations ->readpage() and ->direct_IO(). Alternatively, this
+	may call add_swap_extent() and return the number of extents added, in
+	which case the swap system will use the provided blocks directly
+	instead of going through the filesystem.
 
   swap_deactivate: Called during swapoff on files where swap_activate
 	was successful.
-- 
2.17.0

