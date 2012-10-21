Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:11719 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2JUMXM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Oct 2012 08:23:12 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id D69F0275
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Oct 2012 14:23:09 +0200 (MEST)
From: Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix unaligned accesses
Date: Sun, 21 Oct 2012 14:23:09 +0200
Message-Id: <1350822189-20705-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are some unaligned accesses in progs that cause malfunction or
crashes on ARM.
This patch fixes the ones we stumbled upon.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 btrfs-list.c |   69 +++++++++++++++++++++++++++------------------------------
 volumes.c    |    8 ++++--
 2 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index e5f0f96..cb42fbc 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -720,7 +720,7 @@ static u64 find_root_gen(int fd)
 	int ret;
 	struct btrfs_ioctl_search_args args;
 	struct btrfs_ioctl_search_key *sk = &args.key;
-	struct btrfs_ioctl_search_header *sh;
+	struct btrfs_ioctl_search_header sh;
 	unsigned long off = 0;
 	u64 max_found = 0;
 	int i;
@@ -771,22 +771,21 @@ static u64 find_root_gen(int fd)
 		off = 0;
 		for (i = 0; i < sk->nr_items; i++) {
 			struct btrfs_root_item *item;
-			sh = (struct btrfs_ioctl_search_header *)(args.buf +
-								  off);
 
-			off += sizeof(*sh);
+			memcpy(&sh, args.buf + off, sizeof(sh));
+			off += sizeof(sh);
 			item = (struct btrfs_root_item *)(args.buf + off);
-			off += sh->len;
+			off += sh.len;
 
-			sk->min_objectid = sh->objectid;
-			sk->min_type = sh->type;
-			sk->min_offset = sh->offset;
+			sk->min_objectid = sh.objectid;
+			sk->min_type = sh.type;
+			sk->min_offset = sh.offset;
 
-			if (sh->objectid > ino_args.treeid)
+			if (sh.objectid > ino_args.treeid)
 				break;
 
-			if (sh->objectid == ino_args.treeid &&
-			    sh->type == BTRFS_ROOT_ITEM_KEY) {
+			if (sh.objectid == ino_args.treeid &&
+			    sh.type == BTRFS_ROOT_ITEM_KEY) {
 				max_found = max(max_found,
 						btrfs_root_generation(item));
 			}
@@ -1009,7 +1008,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	int ret;
 	struct btrfs_ioctl_search_args args;
 	struct btrfs_ioctl_search_key *sk = &args.key;
-	struct btrfs_ioctl_search_header *sh;
+	struct btrfs_ioctl_search_header sh;
 	struct btrfs_root_ref *ref;
 	struct btrfs_root_item *ri;
 	unsigned long off = 0;
@@ -1064,23 +1063,22 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 		 * read the root_ref item it contains
 		 */
 		for (i = 0; i < sk->nr_items; i++) {
-			sh = (struct btrfs_ioctl_search_header *)(args.buf +
-								  off);
-			off += sizeof(*sh);
-			if (sh->type == BTRFS_ROOT_BACKREF_KEY) {
+			memcpy(&sh, args.buf + off, sizeof(sh));
+			off += sizeof(sh);
+			if (sh.type == BTRFS_ROOT_BACKREF_KEY) {
 				ref = (struct btrfs_root_ref *)(args.buf + off);
 				name_len = btrfs_stack_root_ref_name_len(ref);
 				name = (char *)(ref + 1);
 				dir_id = btrfs_stack_root_ref_dirid(ref);
 
-				add_root(root_lookup, sh->objectid, sh->offset,
+				add_root(root_lookup, sh.objectid, sh.offset,
 					 0, 0, dir_id, name, name_len, 0, 0, 0,
 					 NULL);
-			} else if (sh->type == BTRFS_ROOT_ITEM_KEY) {
+			} else if (sh.type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
 				flags = btrfs_root_flags(ri);
-				if(sh->len >
+				if(sh.len >
 				   sizeof(struct btrfs_root_item_v0)) {
 					t = ri->otime.sec;
 					ogen = btrfs_root_otransid(ri);
@@ -1091,20 +1089,20 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 					memset(uuid, 0, BTRFS_UUID_SIZE);
 				}
 
-				add_root(root_lookup, sh->objectid, 0,
-					 sh->offset, flags, 0, NULL, 0, ogen,
+				add_root(root_lookup, sh.objectid, 0,
+					 sh.offset, flags, 0, NULL, 0, ogen,
 					 gen, t, uuid);
 			}
 
-			off += sh->len;
+			off += sh.len;
 
 			/*
 			 * record the mins in sk so we can make sure the
 			 * next search doesn't repeat this root
 			 */
-			sk->min_objectid = sh->objectid;
-			sk->min_type = sh->type;
-			sk->min_offset = sh->offset;
+			sk->min_objectid = sh.objectid;
+			sk->min_type = sh.type;
+			sk->min_offset = sh.offset;
 		}
 		sk->nr_items = 4096;
 		sk->min_offset++;
@@ -1556,7 +1554,7 @@ int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 	int ret;
 	struct btrfs_ioctl_search_args args;
 	struct btrfs_ioctl_search_key *sk = &args.key;
-	struct btrfs_ioctl_search_header *sh;
+	struct btrfs_ioctl_search_header sh;
 	struct btrfs_file_extent_item *item;
 	unsigned long off = 0;
 	u64 found_gen;
@@ -1606,35 +1604,34 @@ int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 		 * read the root_ref item it contains
 		 */
 		for (i = 0; i < sk->nr_items; i++) {
-			sh = (struct btrfs_ioctl_search_header *)(args.buf +
-								  off);
-			off += sizeof(*sh);
+			memcpy(&sh, args.buf + off, sizeof(sh));
+			off += sizeof(sh);
 
 			/*
 			 * just in case the item was too big, pass something other
 			 * than garbage
 			 */
-			if (sh->len == 0)
+			if (sh.len == 0)
 				item = &backup;
 			else
 				item = (struct btrfs_file_extent_item *)(args.buf +
 								 off);
 			found_gen = btrfs_stack_file_extent_generation(item);
-			if (sh->type == BTRFS_EXTENT_DATA_KEY &&
+			if (sh.type == BTRFS_EXTENT_DATA_KEY &&
 			    found_gen >= oldest_gen) {
-				print_one_extent(fd, sh, item, found_gen,
+				print_one_extent(fd, &sh, item, found_gen,
 						 &cache_dirid, &cache_dir_name,
 						 &cache_ino, &cache_full_name);
 			}
-			off += sh->len;
+			off += sh.len;
 
 			/*
 			 * record the mins in sk so we can make sure the
 			 * next search doesn't repeat this root
 			 */
-			sk->min_objectid = sh->objectid;
-			sk->min_offset = sh->offset;
-			sk->min_type = sh->type;
+			sk->min_objectid = sh.objectid;
+			sk->min_offset = sh.offset;
+			sk->min_type = sh.type;
 		}
 		sk->nr_items = 4096;
 		if (sk->min_offset < (u64)-1)
diff --git a/volumes.c b/volumes.c
index 8dca5e1..581c298 100644
--- a/volumes.c
+++ b/volumes.c
@@ -652,6 +652,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int index;
 	int stripe_len = 64 * 1024;
 	struct btrfs_key key;
+	u64 offset;
 
 	if (list_empty(dev_list)) {
 		return -ENOSPC;
@@ -757,12 +758,13 @@ again:
 		}
 		return -ENOSPC;
 	}
-	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
 	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-			      &key.offset);
+			      &offset);
 	if (ret)
 		return ret;
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	key.offset = offset;
 
 	chunk = kmalloc(btrfs_chunk_item_size(num_stripes), GFP_NOFS);
 	if (!chunk)
-- 
1.7.3.4

