Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9425 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751531AbaGPEHS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 00:07:18 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6G47FKN002179
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 12:07:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs: Call mount_subtree() even 'subvolid=' mount option is given.
Date: Wed, 16 Jul 2014 12:07:10 +0800
Message-ID: <1405483631-23037-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1405483631-23037-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1405483631-23037-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs uses differnet routine to handle 'subvolid=' and 'subvol=' mount
option.
Given 'subvol=' mount option, btrfs will mount btrfs first and then call
mount_subtree() to mount a subtree of btrfs, making vfs handle the path
searching.
This is good since vfs layer know extactly that a subtree mount is done
and findmnt(8) knows which subtree is mounted.

However when using 'subvolid=' mount option, btrfs will do all the
internal subvolume objectid searching and checking, making VFS unaware
about which subtree is mounted, as result, findmnt(8) can't showing any
useful subtree mount info for end users.

This patch will use the root backref to reverse search the subvolume
path for a given subvolid, making findmnt(8) works again.

Reported-by: Stefan G.Weichinger <lists@xunil.at>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/super.c | 231 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 201 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8e16bca..23363a2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -58,6 +58,7 @@
 #include "dev-replace.h"
 #include "free-space-cache.h"
 #include "backref.h"
+#include "locking.h"
 #include "tests/btrfs-tests.h"
 
 #define CREATE_TRACE_POINTS
@@ -1117,28 +1118,81 @@ static inline int is_subvolume_inode(struct inode *inode)
 	return 0;
 }
 
+static int u64_to_strlen(u64 number)
+{
+	int ret = 0;
+
+	/* Zero is the special one, return 1 directly */
+	if (!number)
+		return 1;
+
+	while (number) {
+		ret++;
+		number /= 10;
+	}
+	return ret;
+}
+
+#define CLEAR_SUBVOL		1
+#define CLEAR_SUBVOLID		2
 /*
- * This will strip out the subvol=%s argument for an argument string and add
- * subvolid=0 to make sure we get the actual tree root for path walking to the
- * subvol we want.
+ * This will strip out the subvol=%s or subvolid=%s argument for an argumen
+ * string and add subvolid=0 to make sure we get the actual tree root for path
+ * walking to the subvol we want.
  */
-static char *setup_root_args(char *args)
+static char *setup_root_args(char *args, int flags, u64 subvol_objectid)
 {
-	unsigned len = strlen(args) + 2 + 1;
-	char *src, *dst, *buf;
+	unsigned len;
+	char *src = NULL, *dst, *buf, *comma;
+	char *subvol_string = "subvolid=";
+	int option_len = 0;
+
+	if (!args) {
+		/* Case 1, not args, all default mounting
+		 * just return 'subvolid=<FS_ROOT>' */
+		len = strlen(subvol_string) +
+		      u64_to_strlen(subvol_objectid) + 1;
+		dst = kmalloc(len, GFP_NOFS);
+		if (!dst)
+			return NULL;
+		sprintf(dst, "%s%llu", subvol_string, subvol_objectid);
+		return dst;
+	}
 
-	/*
-	 * We need the same args as before, but with this substitution:
-	 * s!subvol=[^,]+!subvolid=0!
-	 *
-	 * Since the replacement string is up to 2 bytes longer than the
-	 * original, allocate strlen(args) + 2 + 1 bytes.
-	 */
+	switch (flags) {
+	case CLEAR_SUBVOL:
+		src = strstr(args, "subvol=");
+		break;
+	case CLEAR_SUBVOLID:
+		src = strstr(args, "subvolid=");
+		break;
+	}
 
-	src = strstr(args, "subvol=");
-	/* This shouldn't happen, but just in case.. */
-	if (!src)
-		return NULL;
+	if (!src) {
+		/* Case 2, some args, default subvolume mounting
+		 * just append ',subvolid=<FS_ROOT>' */
+
+		/* 1 for ending '\0', 1 for leading ',' */
+		len = strlen(args) + strlen(subvol_string) +
+		      u64_to_strlen(subvol_objectid) + 2;
+		dst = kmalloc(len, GFP_NOFS);
+		if (!dst)
+			return NULL;
+		strcpy(dst, args);
+		sprintf(dst + strlen(args), ",%s%llu", subvol_string,
+			subvol_objectid);
+		return dst;
+	}
+
+	/* Case 3, subvolid=/subvol=  mount
+	 * repalce the 'subvolid/subvol' options to 'subvolid=<FS_ROOT>' */
+	comma = strchr(src, ',');
+	if (comma)
+		option_len = comma - src;
+	else
+		option_len = strlen(src);
+	len = strlen(args) - option_len  + strlen(subvol_string) +
+	      u64_to_strlen(subvol_objectid) + 1;
 
 	buf = dst = kmalloc(len, GFP_NOFS);
 	if (!buf)
@@ -1154,28 +1208,126 @@ static char *setup_root_args(char *args)
 		dst += strlen(args);
 	}
 
-	strcpy(dst, "subvolid=0");
-	dst += strlen("subvolid=0");
+	len = sprintf(dst, "%s%llu", subvol_string, subvol_objectid);
+	dst += len;
 
 	/*
 	 * If there is a "," after the original subvol=... string,
 	 * copy that suffix into our buffer.  Otherwise, we're done.
 	 */
-	src = strchr(src, ',');
-	if (src)
-		strcpy(dst, src);
+	if (comma)
+		strcpy(dst, comma);
 
 	return buf;
 }
 
-static struct dentry *mount_subvol(const char *subvol_name, int flags,
-				   const char *device_name, char *data)
+static char *str_append_head(char *dest, char *src)
+{
+	memmove(dest + strlen(src), dest, strlen(dest) + 1);
+	memcpy(dest, src, strlen(src));
+	return dest;
+}
+
+/* Find the path for given subvol_objectid.
+ * Caller needs to readlock the root tree and kzalloc PATH_MAX for
+ * subvol_name and namebuf */
+static char *find_subvol_by_id(struct btrfs_root *root, u64 subvol_objectid)
+{
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_root_ref *ref;
+	struct btrfs_path *path;
+	char *namebuf = NULL;
+	char *new_buf = NULL;
+	char *subvol_ret = NULL;
+	int ret = 0;
+	u16 namelen = 0;
+
+	path = btrfs_alloc_path();
+	/* Alloc 1 byte for later strlen() calls */
+	subvol_ret = kzalloc(1, GFP_NOFS);
+	if (!path || !subvol_ret) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = subvol_objectid;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
+	key.offset = 0;
+	/* We don't need to lock the tree_root,
+	 * if when we do the backref walking, some one deleted/moved
+	 * the subvol, we just return -ENOENT or let mount_subtree
+	 * return -ENOENT and no disaster will happen.
+	 * User should not modify subvolume when trying to mount it */
+	while (key.objectid != BTRFS_FS_TREE_OBJECTID) {
+		ret = btrfs_search_slot_for_read(root, &key, path, 1, 1);
+		if (ret < 0)
+			goto out;
+		if (ret) {
+			ret = -ENOENT;
+			goto out;
+		}
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				      path->slots[0]);
+		if (found_key.objectid != key.objectid ||
+		    found_key.type != BTRFS_ROOT_BACKREF_KEY) {
+			ret = -ENOENT;
+			goto out;
+		}
+		key.objectid = found_key.offset;
+		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				     struct btrfs_root_ref);
+		namelen = btrfs_root_ref_name_len(path->nodes[0], ref);
+		/* One for ending '\0' One for '/' */
+		new_buf = krealloc(namebuf, namelen + 2, GFP_NOFS);
+		if (!new_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		namebuf = new_buf;
+		read_extent_buffer(path->nodes[0], namebuf,
+				   (unsigned long)(ref + 1), namelen);
+		btrfs_release_path(path);
+		*(namebuf + namelen) = '/';
+		*(namebuf + namelen + 1) = '\0';
+
+		new_buf = krealloc(subvol_ret, strlen(subvol_ret) + namelen + 2,
+				   GFP_NOFS);
+		if (!new_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		subvol_ret = new_buf;
+		str_append_head(subvol_ret, namebuf);
+	}
+out:
+	kfree(namebuf);
+	btrfs_free_path(path);
+	if (ret < 0) {
+		kfree(subvol_ret);
+		return ERR_PTR(ret);
+	} else
+		return subvol_ret;
+
+}
+
+static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
+				   int flags, const char *device_name,
+				   char *data)
 {
 	struct dentry *root;
 	struct vfsmount *mnt;
+	struct btrfs_root *tree_root = NULL;
 	char *newargs;
+	char *subvol_ret = NULL;
+	int ret = 0;
 
-	newargs = setup_root_args(data);
+	if (subvol_name)
+		newargs = setup_root_args(data, CLEAR_SUBVOL,
+					  BTRFS_FS_TREE_OBJECTID);
+	else
+		newargs = setup_root_args(data, CLEAR_SUBVOLID,
+					  BTRFS_FS_TREE_OBJECTID);
 	if (!newargs)
 		return ERR_PTR(-ENOMEM);
 	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name,
@@ -1207,19 +1359,36 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 
 	if (IS_ERR(mnt))
 		return ERR_CAST(mnt);
-
+	tree_root = btrfs_sb(mnt->mnt_sb)->tree_root;
+
+	if (!subvol_name) {
+		subvol_ret = find_subvol_by_id(tree_root, subvol_objectid);
+		if (IS_ERR(subvol_ret)) {
+			ret = PTR_ERR(subvol_ret);
+			subvol_ret = NULL;
+			mntput(mnt);
+			goto out;
+		}
+		subvol_name = subvol_ret;
+	}
 	root = mount_subtree(mnt, subvol_name);
 
 	if (!IS_ERR(root) && !is_subvolume_inode(root->d_inode)) {
 		struct super_block *s = root->d_sb;
 		dput(root);
-		root = ERR_PTR(-EINVAL);
+		ret = -EINVAL;
 		deactivate_locked_super(s);
 		printk(KERN_ERR "BTRFS: '%s' is not a valid subvolume\n",
 				subvol_name);
 	}
 
-	return root;
+out:
+	kfree(subvol_ret);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	else
+		return root;
+
 }
 
 /*
@@ -1252,8 +1421,10 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		return ERR_PTR(error);
 	}
 
-	if (subvol_name) {
-		root = mount_subvol(subvol_name, flags, device_name, data);
+	if (subvol_name || (subvol_objectid != 0 &&
+			    subvol_objectid != BTRFS_FS_TREE_OBJECTID)) {
+		root = mount_subvol(subvol_name, subvol_objectid, flags,
+				    device_name, data);
 		kfree(subvol_name);
 		return root;
 	}
-- 
2.0.1

