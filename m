Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaBCSYE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:24:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 42315AC6E
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:24:03 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/6] btrfs: send: lower memory requirements in common case
Date: Mon,  3 Feb 2014 19:23:59 +0100
Message-Id: <c745104d71dca776e5369fc42314ad8b8ae2edcb.1391447200.git.dsterba@suse.cz>
In-Reply-To: <cover.1391447200.git.dsterba@suse.cz>
References: <cover.1391447200.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fs_path structure uses an inline buffer and falls back to a chain of
allocations, but vmalloc is not necessary because PATH_MAX fits into
PAGE_SIZE.

The size of fs_path has been reduced to 256 bytes from PAGE_SIZE,
usually 4k. Experimental measurements show that most paths on a single
filesystem do not exceed 200 bytes, and these get stored into the inline
buffer directly, which is now 230 bytes. Longer paths are kmalloced when
needed.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |  103 ++++++++++++++++++-------------------------------------
 1 files changed, 34 insertions(+), 69 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index cb12c2ec37dc..4e3a3d413417 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -57,7 +57,12 @@ struct fs_path {
 			unsigned short reversed:1;
 			char inline_buf[];
 		};
-		char pad[PAGE_SIZE];
+		/*
+		 * Average path length does not exceed 200 bytes, we'll have
+		 * better packing in the slab and higher chance to satisfy
+		 * a allocation later during send.
+		 */
+		char pad[256];
 	};
 };
 #define FS_PATH_INLINE_SIZE \
@@ -262,12 +267,8 @@ static void fs_path_free(struct fs_path *p)
 {
 	if (!p)
 		return;
-	if (p->buf != p->inline_buf) {
-		if (is_vmalloc_addr(p->buf))
-			vfree(p->buf);
-		else
-			kfree(p->buf);
-	}
+	if (p->buf != p->inline_buf)
+		kfree(p->buf);
 	kfree(p);
 }
 
@@ -287,40 +288,28 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	if (p->buf_len >= len)
 		return 0;
 
-	path_len = p->end - p->start;
-	old_buf_len = p->buf_len;
-	len = PAGE_ALIGN(len);
-
+	/*
+	 * First time the inline_buf does not suffice
+	 */
 	if (p->buf == p->inline_buf) {
-		tmp_buf = kmalloc(len, GFP_NOFS | __GFP_NOWARN);
-		if (!tmp_buf) {
-			tmp_buf = vmalloc(len);
-			if (!tmp_buf)
-				return -ENOMEM;
-		}
-		memcpy(tmp_buf, p->buf, p->buf_len);
-		p->buf = tmp_buf;
-		p->buf_len = len;
+		p->buf = kmalloc(len, GFP_NOFS);
+		if (!p->buf)
+			return -ENOMEM;
+		/*
+		 * The real size of the buffer is bigger, this will let the
+		 * fast path happen most of the time
+		 */
+		p->buf_len = ksize(p->buf);
 	} else {
-		if (is_vmalloc_addr(p->buf)) {
-			tmp_buf = vmalloc(len);
-			if (!tmp_buf)
-				return -ENOMEM;
-			memcpy(tmp_buf, p->buf, p->buf_len);
-			vfree(p->buf);
-		} else {
-			tmp_buf = krealloc(p->buf, len, GFP_NOFS);
-			if (!tmp_buf) {
-				tmp_buf = vmalloc(len);
-				if (!tmp_buf)
-					return -ENOMEM;
-				memcpy(tmp_buf, p->buf, p->buf_len);
-				kfree(p->buf);
-			}
-		}
-		p->buf = tmp_buf;
-		p->buf_len = len;
+		p->buf = krealloc(p->buf, len, GFP_NOFS);
+		if (!p->buf)
+			return -ENOMEM;
+		p->buf_len = ksize(p->buf);
 	}
+
+	path_len = p->end - p->start;
+	old_buf_len = p->buf_len;
+
 	if (p->reversed) {
 		tmp_buf = p->buf + old_buf_len - path_len - 1;
 		p->end = p->buf + p->buf_len - 1;
@@ -911,9 +900,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 	struct btrfs_dir_item *di;
 	struct btrfs_key di_key;
 	char *buf = NULL;
-	char *buf2 = NULL;
-	int buf_len;
-	int buf_virtual = 0;
+	const int buf_len = PATH_MAX;
 	u32 name_len;
 	u32 data_len;
 	u32 cur;
@@ -923,7 +910,6 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 	int num;
 	u8 type;
 
-	buf_len = PAGE_SIZE;
 	buf = kmalloc(buf_len, GFP_NOFS);
 	if (!buf) {
 		ret = -ENOMEM;
@@ -945,30 +931,12 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 		type = btrfs_dir_type(eb, di);
 		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
 
+		/*
+		 * Path too long
+		 */
 		if (name_len + data_len > buf_len) {
-			buf_len = PAGE_ALIGN(name_len + data_len);
-			if (buf_virtual) {
-				buf2 = vmalloc(buf_len);
-				if (!buf2) {
-					ret = -ENOMEM;
-					goto out;
-				}
-				vfree(buf);
-			} else {
-				buf2 = krealloc(buf, buf_len, GFP_NOFS);
-				if (!buf2) {
-					buf2 = vmalloc(buf_len);
-					if (!buf2) {
-						ret = -ENOMEM;
-						goto out;
-					}
-					kfree(buf);
-					buf_virtual = 1;
-				}
-			}
-
-			buf = buf2;
-			buf2 = NULL;
+			ret = -ENAMETOOLONG;
+			goto out;
 		}
 
 		read_extent_buffer(eb, buf, (unsigned long)(di + 1),
@@ -991,10 +959,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 	}
 
 out:
-	if (buf_virtual)
-		vfree(buf);
-	else
-		kfree(buf);
+	kfree(buf);
 	return ret;
 }
 
-- 
1.7.9

