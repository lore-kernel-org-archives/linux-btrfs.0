Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41328 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILQZl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 12:25:41 -0400
Received: by mail-pf1-f193.google.com with SMTP id h79-v6so859721pfk.8
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 04:21:36 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
Subject: [PATCH 6/6] btrfs-progs: lowmem: optimization and repair for check_inode_extref()
Date: Wed, 12 Sep 2018 19:20:45 +0000
Message-Id: <20180912192046.5861-9-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
References: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

inode_extref is much similar with inode_ref, most codes are reused in
check_inode_extref().
Exception:
There is no need to check root directory, so remove it.
Make check_inode_extref() verify hash value with key offset now.

And lowmem check can detect errors about inode_extref and try to
repair errors.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 119 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 92 insertions(+), 27 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index b6b33786d02b..bec2ee185cc8 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1182,37 +1182,79 @@ out:
  *
  * Return 0 if no error occurred.
  */
-static int check_inode_extref(struct btrfs_root *root,
-			      struct btrfs_key *ref_key,
-			      struct extent_buffer *node, int slot, u64 *refs,
-			      int mode)
+static int check_inode_extref(struct btrfs_root *root, struct btrfs_key *ref_key,
+			      struct btrfs_path *path, char *name_ret,
+			      u32 *namelen_ret, u64 *refs_ret, int mode)
 {
 	struct btrfs_key key;
 	struct btrfs_key location;
 	struct btrfs_inode_extref *extref;
+	struct extent_buffer *node;
 	char namebuf[BTRFS_NAME_LEN] = {0};
 	u32 total;
-	u32 cur = 0;
+	u32 cur;
 	u32 len;
 	u32 name_len;
 	u64 index;
 	u64 parent;
+	int err;
+	int tmp_err;
 	int ret;
-	int err = 0;
+	int slot;
+	u64 refs;
+	bool search_again = false;
 
 	location.objectid = ref_key->objectid;
 	location.type = BTRFS_INODE_ITEM_KEY;
 	location.offset = 0;
+begin:
+	cur = 0;
+	err = 0;
+	refs = *refs_ret;
+	*namelen_ret = 0;
+
+	/* since after repair, path and the dir item may be changed */
+	if (search_again) {
+		search_again = false;
+		btrfs_release_path(path);
+		ret = btrfs_search_slot(NULL, root, ref_key, path, 0, 0);
+		/*
+		 * The item was deleted, let the path point to the last checked
+		 * item.
+		 */
+		if (ret > 0) {
+			if (path->slots[0] == 0) {
+				ret = btrfs_prev_leaf(root, path);
+				/*
+				 * we are checking the inode item, there must
+				 * be some items before, the case shall never
+				 * happen.
+				 */
+				BUG_ON(ret);
+			} else {
+				path->slots[0]--;
+			}
+			goto out;
+		} else if (ret < 0) {
+			err |= ret;
+			goto out;
+		}
+	}
+
+	node = path->nodes[0];
+	slot = path->slots[0];
 
 	extref = btrfs_item_ptr(node, slot, struct btrfs_inode_extref);
 	total = btrfs_item_size_nr(node, slot);
 
-next:
-	/* update inode ref count */
-	(*refs)++;
-	name_len = btrfs_inode_extref_name_len(node, extref);
-	index = btrfs_inode_extref_index(node, extref);
+loop:
+	/* Update inode ref count */
+	refs++;
+	tmp_err = 0;
 	parent = btrfs_inode_extref_parent(node, extref);
+	index = btrfs_inode_extref_index(node, extref);
+	name_len = btrfs_inode_extref_name_len(node, extref);
+
 	if (name_len <= BTRFS_NAME_LEN) {
 		len = name_len;
 	} else {
@@ -1220,37 +1262,60 @@ next:
 		warning("root %llu INODE_EXTREF[%llu %llu] name too long",
 			root->objectid, ref_key->objectid, ref_key->offset);
 	}
+
 	read_extent_buffer(node, namebuf, (unsigned long)(extref + 1), len);
 
-	/* Check root dir ref name */
-	if (index == 0 && strncmp(namebuf, "..", name_len)) {
-		error("root %llu INODE_EXTREF[%llu %llu] ROOT_DIR name shouldn't be %s",
+	/* verify hash value */
+	if (ref_key->offset != btrfs_extref_hash(parent, namebuf, len)) {
+		err |= -EIO;
+		error("root %llu INODE_EXTREF[%llu %llu] name %s namelen %u mode %d mismatch with its hash, wanted %llu have %llu",
 		      root->objectid, ref_key->objectid, ref_key->offset,
-		      namebuf);
-		err |= ROOT_DIR_ERROR;
+		      namebuf, len, mode, ref_key->offset,
+		      btrfs_extref_hash(parent, namebuf, len));
+		goto out;
 	}
 
-	/* find related dir_index */
+	/* copy the first name found to name_ret */
+	if (refs == 1 && name_ret) {
+		memcpy(name_ret, namebuf, len);
+		*namelen_ret = len;
+	}
+
+	/* Find related DIR_INDEX */
 	key.objectid = parent;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = index;
-	ret = find_dir_item(root, &key, &location, namebuf, len, mode);
-	err |= ret;
+	tmp_err |= find_dir_item(root, &key, &location, namebuf, len,
+			    imode_to_type(mode));
 
-	/* find related dir_item */
+	/* Find related dir_item */
 	key.objectid = parent;
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(namebuf, len);
-	ret = find_dir_item(root, &key, &location, namebuf, len, mode);
-	err |= ret;
+	tmp_err |= find_dir_item(root, &key, &location, namebuf, len,
+			    imode_to_type(mode));
+
+	if (tmp_err && repair) {
+		ret = repair_ternary_lowmem(root, parent, ref_key->objectid,
+			    index, namebuf, name_len, imode_to_type(mode),
+			    tmp_err);
+		if (!ret) {
+			search_again = true;
+			goto begin;
+		}
+	}
 
+	print_inode_ref_err(root, ref_key, index, namebuf, name_len,
+			    imode_to_type(mode), tmp_err);
+
+	err |= tmp_err;
 	len = sizeof(*extref) + name_len;
 	extref = (struct btrfs_inode_extref *)((char *)extref + len);
 	cur += len;
-
 	if (cur < total)
-		goto next;
-
+		goto loop;
+out:
+	*refs_ret = refs;
 	return err;
 }
 
@@ -2426,8 +2491,8 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 				warning("root %llu EXTREF[%llu %llu] isn't supported",
 					root->objectid, key.objectid,
 					key.offset);
-			ret = check_inode_extref(root, &key, node, slot, &refs,
-						 mode);
+			ret = check_inode_extref(root, &key, path, namebuf,
+						 &name_len, &refs, mode);
 			err |= ret;
 			break;
 		}
-- 
2.18.0
