Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40673 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2GDNiz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:38:55 -0400
Received: by bkwj10 with SMTP id j10so2632673bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:38:54 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 3/7] Btrfs: make iref_to_path non static
Date: Wed,  4 Jul 2012 15:38:24 +0200
Message-Id: <1341409108-13567-4-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make iref_to_path non static (needed in send) and rename
it to btrfs_iref_to_path

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/backref.c |   10 +++++-----
 fs/btrfs/backref.h |    4 ++++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7301cdb..f642d28 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1122,10 +1122,10 @@ static int inode_ref_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
  * required for the path to fit into the buffer. in that case, the returned
  * value will be smaller than dest. callers must check this!
  */
-static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
-				struct btrfs_inode_ref *iref,
-				struct extent_buffer *eb_in, u64 parent,
-				char *dest, u32 size)
+char *btrfs_iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
+			 struct btrfs_inode_ref *iref,
+			 struct extent_buffer *eb_in, u64 parent,
+			 char *dest, u32 size)
 {
 	u32 len;
 	int slot;
@@ -1540,7 +1540,7 @@ static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
 					ipath->fspath->bytes_left - s_ptr : 0;
 
 	fspath_min = (char *)ipath->fspath->val + (i + 1) * s_ptr;
-	fspath = iref_to_path(ipath->fs_root, ipath->btrfs_path, iref, eb,
+	fspath = btrfs_iref_to_path(ipath->fs_root, ipath->btrfs_path, iref, eb,
 				inum, fspath_min, bytes_left);
 	if (IS_ERR(fspath))
 		return PTR_ERR(fspath);
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index c18d8ac..1a76579 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -21,6 +21,7 @@
 
 #include "ioctl.h"
 #include "ulist.h"
+#include "extent_io.h"
 
 #define BTRFS_BACKREF_SEARCH_COMMIT_ROOT ((struct btrfs_trans_handle *)0)
 
@@ -60,6 +61,9 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
 				u64 delayed_ref_seq, u64 time_seq,
 				struct ulist **roots);
+char *btrfs_iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
+			 struct btrfs_inode_ref *iref, struct extent_buffer *eb,
+			 u64 parent, char *dest, u32 size);
 
 struct btrfs_data_container *init_data_container(u32 total_bytes);
 struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
-- 
1.7.10

