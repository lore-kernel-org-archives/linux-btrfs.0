Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40849 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3HZSA1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 14:00:27 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so3045883wes.33
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 11:00:26 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [RFC PATCH] Btrfs: WIP, fix broken ctree.c:btrfs_prev_leaf()
Date: Mon, 26 Aug 2013 19:00:19 +0100
Message-Id: <1377540019-30815-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Note: this is a work in progress patch, not yet complete, not meant to
be yet taken.

The btrfs_prev_leaf function often returns the same leaf again and
a return status of 0 (success) - this is wrong for 2 reasons:

1) Shouldn't return 0 when it's the same leaf as before;

2) More importantly, it returns the same leaf in some cases where
   there's actually a previous (to the left) leaf.

Consider the following example of an fs tree captured from a
btrfs-debug-tree output (with item specific data removed for
the sake of readability):

fs tree key (FS_TREE ROOT_ITEM 0)
node 37023744 level 1 items 5 free 116 generation 15 owner 5
fs uuid 35176913-421b-4be9-9c11-6cdf81dd39a9
chunk uuid e13b5f43-8ea1-4867-b6c0-fa4b97caeb43
	key (256 INODE_ITEM 0) block 38113280 (9305) gen 15
	key (257 EXTENT_DATA 2097901568) block 31617024 (7719) gen 14
	key (257 EXTENT_DATA 5093457920) block 34889728 (8518) gen 14
	key (257 EXTENT_DATA 5093797888) block 34881536 (8516) gen 14
	key (257 EXTENT_DATA 5093969920) block 37027840 (9040) gen 15
leaf 38113280 items 49 free space 71 generation 15 owner 5
fs uuid 35176913-421b-4be9-9c11-6cdf81dd39a9
chunk uuid e13b5f43-8ea1-4867-b6c0-fa4b97caeb43
	item 0 key (256 INODE_ITEM 0) itemoff 3835 itemsize 160
	item 1 key (256 INODE_REF 256) itemoff 3823 itemsize 12
	item 2 key (256 DIR_ITEM 496027801) itemoff 3787 itemsize 36
	item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
	item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
	item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
	item 6 key (257 EXTENT_DATA 0) itemoff 3522 itemsize 53
	item 7 key (257 EXTENT_DATA 40960000) itemoff 3469 itemsize 53
	item 8 key (257 EXTENT_DATA 806969344) itemoff 3416 itemsize 53
	item 9 key (257 EXTENT_DATA 1572978688) itemoff 3363 itemsize 53
	item 10 key (257 EXTENT_DATA 2053185536) itemoff 3310 itemsize 53
	item 11 key (257 EXTENT_DATA 2093875200) itemoff 3257 itemsize 53
	item 12 key (257 EXTENT_DATA 2097242112) itemoff 3204 itemsize 53
	item 13 key (257 EXTENT_DATA 2097537024) itemoff 3151 itemsize 53
	item 14 key (257 EXTENT_DATA 2097582080) itemoff 3098 itemsize 53
	item 15 key (257 EXTENT_DATA 2097594368) itemoff 3045 itemsize 53
	item 16 key (257 EXTENT_DATA 2097602560) itemoff 2992 itemsize 53
	item 17 key (257 EXTENT_DATA 2097623040) itemoff 2939 itemsize 53
	item 18 key (257 EXTENT_DATA 2097635328) itemoff 2886 itemsize 53
	item 19 key (257 EXTENT_DATA 2097643520) itemoff 2833 itemsize 53
	item 20 key (257 EXTENT_DATA 2097651712) itemoff 2780 itemsize 53
	item 21 key (257 EXTENT_DATA 2097659904) itemoff 2727 itemsize 53
	item 22 key (257 EXTENT_DATA 2097668096) itemoff 2674 itemsize 53
	item 23 key (257 EXTENT_DATA 2097676288) itemoff 2621 itemsize 53
	item 24 key (257 EXTENT_DATA 2097684480) itemoff 2568 itemsize 53
	item 25 key (257 EXTENT_DATA 2097692672) itemoff 2515 itemsize 53
	item 26 key (257 EXTENT_DATA 2097704960) itemoff 2462 itemsize 53
	item 27 key (257 EXTENT_DATA 2097713152) itemoff 2409 itemsize 53
	item 28 key (257 EXTENT_DATA 2097721344) itemoff 2356 itemsize 53
	item 29 key (257 EXTENT_DATA 2097729536) itemoff 2303 itemsize 53
	item 30 key (257 EXTENT_DATA 2097737728) itemoff 2250 itemsize 53
	item 31 key (257 EXTENT_DATA 2097745920) itemoff 2197 itemsize 53
	item 32 key (257 EXTENT_DATA 2097754112) itemoff 2144 itemsize 53
	item 33 key (257 EXTENT_DATA 2097766400) itemoff 2091 itemsize 53
	item 34 key (257 EXTENT_DATA 2097774592) itemoff 2038 itemsize 53
	item 35 key (257 EXTENT_DATA 2097782784) itemoff 1985 itemsize 53
	item 36 key (257 EXTENT_DATA 2097790976) itemoff 1932 itemsize 53
	item 37 key (257 EXTENT_DATA 2097799168) itemoff 1879 itemsize 53
	item 38 key (257 EXTENT_DATA 2097807360) itemoff 1826 itemsize 53
	item 39 key (257 EXTENT_DATA 2097815552) itemoff 1773 itemsize 53
	item 40 key (257 EXTENT_DATA 2097823744) itemoff 1720 itemsize 53
	item 41 key (257 EXTENT_DATA 2097831936) itemoff 1667 itemsize 53
	item 42 key (257 EXTENT_DATA 2097840128) itemoff 1614 itemsize 53
	item 43 key (257 EXTENT_DATA 2097852416) itemoff 1561 itemsize 53
	item 44 key (257 EXTENT_DATA 2097860608) itemoff 1508 itemsize 53
	item 45 key (257 EXTENT_DATA 2097868800) itemoff 1455 itemsize 53
	item 46 key (257 EXTENT_DATA 2097876992) itemoff 1402 itemsize 53
	item 47 key (257 EXTENT_DATA 2097885184) itemoff 1349 itemsize 53
	item 48 key (257 EXTENT_DATA 2097893376) itemoff 1296 itemsize 53
leaf 31617024 items 26 free space 1967 generation 14 owner 5
fs uuid 35176913-421b-4be9-9c11-6cdf81dd39a9
chunk uuid e13b5f43-8ea1-4867-b6c0-fa4b97caeb43
	item 0 key (257 EXTENT_DATA 2097901568) itemoff 3942 itemsize 53
	item 1 key (257 EXTENT_DATA 2097909760) itemoff 3889 itemsize 53
	item 2 key (257 EXTENT_DATA 2097917952) itemoff 3836 itemsize 53
	item 3 key (257 EXTENT_DATA 2862002176) itemoff 3783 itemsize 53
	item 4 key (257 EXTENT_DATA 3626090496) itemoff 3730 itemsize 53
	item 5 key (257 EXTENT_DATA 4065660928) itemoff 3677 itemsize 53
	item 6 key (257 EXTENT_DATA 4077395968) itemoff 3624 itemsize 53
	item 7 key (257 EXTENT_DATA 4077895680) itemoff 3571 itemsize 53
	item 8 key (257 EXTENT_DATA 5054418944) itemoff 3518 itemsize 53
	item 9 key (257 EXTENT_DATA 5092200448) itemoff 3465 itemsize 53
	item 10 key (257 EXTENT_DATA 5093294080) itemoff 3412 itemsize 53
	item 11 key (257 EXTENT_DATA 5093355520) itemoff 3359 itemsize 53
	item 12 key (257 EXTENT_DATA 5093363712) itemoff 3306 itemsize 53
	item 13 key (257 EXTENT_DATA 5093371904) itemoff 3253 itemsize 53
	item 14 key (257 EXTENT_DATA 5093380096) itemoff 3200 itemsize 53
	item 15 key (257 EXTENT_DATA 5093384192) itemoff 3147 itemsize 53
	item 16 key (257 EXTENT_DATA 5093392384) itemoff 3094 itemsize 53
	item 17 key (257 EXTENT_DATA 5093400576) itemoff 3041 itemsize 53
	item 18 key (257 EXTENT_DATA 5093404672) itemoff 2988 itemsize 53
	item 19 key (257 EXTENT_DATA 5093412864) itemoff 2935 itemsize 53
	item 20 key (257 EXTENT_DATA 5093416960) itemoff 2882 itemsize 53
	item 21 key (257 EXTENT_DATA 5093425152) itemoff 2829 itemsize 53
	item 22 key (257 EXTENT_DATA 5093433344) itemoff 2776 itemsize 53
	item 23 key (257 EXTENT_DATA 5093437440) itemoff 2723 itemsize 53
	item 24 key (257 EXTENT_DATA 5093445632) itemoff 2670 itemsize 53
	item 25 key (257 EXTENT_DATA 5093453824) itemoff 2617 itemsize 53
leaf 34889728 items 51 free space 17 generation 14 owner 5
fs uuid 35176913-421b-4be9-9c11-6cdf81dd39a9
chunk uuid e13b5f43-8ea1-4867-b6c0-fa4b97caeb43
	item 0 key (257 EXTENT_DATA 5093457920) itemoff 3942 itemsize 53
	item 1 key (257 EXTENT_DATA 5093466112) itemoff 3889 itemsize 53
	item 2 key (257 EXTENT_DATA 5093470208) itemoff 3836 itemsize 53
	item 3 key (257 EXTENT_DATA 5093478400) itemoff 3783 itemsize 53
	item 4 key (257 EXTENT_DATA 5093482496) itemoff 3730 itemsize 53
	item 5 key (257 EXTENT_DATA 5093490688) itemoff 3677 itemsize 53
	item 6 key (257 EXTENT_DATA 5093494784) itemoff 3624 itemsize 53
	item 7 key (257 EXTENT_DATA 5093502976) itemoff 3571 itemsize 53
	item 8 key (257 EXTENT_DATA 5093511168) itemoff 3518 itemsize 53
	item 9 key (257 EXTENT_DATA 5093515264) itemoff 3465 itemsize 53
	item 10 key (257 EXTENT_DATA 5093523456) itemoff 3412 itemsize 53
	item 11 key (257 EXTENT_DATA 5093527552) itemoff 3359 itemsize 53
	item 12 key (257 EXTENT_DATA 5093539840) itemoff 3306 itemsize 53
	item 13 key (257 EXTENT_DATA 5093543936) itemoff 3253 itemsize 53
	item 14 key (257 EXTENT_DATA 5093552128) itemoff 3200 itemsize 53
	item 15 key (257 EXTENT_DATA 5093560320) itemoff 3147 itemsize 53
	item 16 key (257 EXTENT_DATA 5093564416) itemoff 3094 itemsize 53
	item 17 key (257 EXTENT_DATA 5093572608) itemoff 3041 itemsize 53
	item 18 key (257 EXTENT_DATA 5093580800) itemoff 2988 itemsize 53
	item 19 key (257 EXTENT_DATA 5093584896) itemoff 2935 itemsize 53
	item 20 key (257 EXTENT_DATA 5093593088) itemoff 2882 itemsize 53
	item 21 key (257 EXTENT_DATA 5093597184) itemoff 2829 itemsize 53
	item 22 key (257 EXTENT_DATA 5093605376) itemoff 2776 itemsize 53
	item 23 key (257 EXTENT_DATA 5093613568) itemoff 2723 itemsize 53
	item 24 key (257 EXTENT_DATA 5093617664) itemoff 2670 itemsize 53
	item 25 key (257 EXTENT_DATA 5093625856) itemoff 2617 itemsize 53
	item 26 key (257 EXTENT_DATA 5093629952) itemoff 2564 itemsize 53
	item 27 key (257 EXTENT_DATA 5093638144) itemoff 2511 itemsize 53
	item 28 key (257 EXTENT_DATA 5093642240) itemoff 2458 itemsize 53
	item 29 key (257 EXTENT_DATA 5093650432) itemoff 2405 itemsize 53
	item 30 key (257 EXTENT_DATA 5093654528) itemoff 2352 itemsize 53
	item 31 key (257 EXTENT_DATA 5093662720) itemoff 2299 itemsize 53
	item 32 key (257 EXTENT_DATA 5093670912) itemoff 2246 itemsize 53
	item 33 key (257 EXTENT_DATA 5093675008) itemoff 2193 itemsize 53
	item 34 key (257 EXTENT_DATA 5093683200) itemoff 2140 itemsize 53
	item 35 key (257 EXTENT_DATA 5093691392) itemoff 2087 itemsize 53
	item 36 key (257 EXTENT_DATA 5093695488) itemoff 2034 itemsize 53
	item 37 key (257 EXTENT_DATA 5093703680) itemoff 1981 itemsize 53
	item 38 key (257 EXTENT_DATA 5093711872) itemoff 1928 itemsize 53
	item 39 key (257 EXTENT_DATA 5093715968) itemoff 1875 itemsize 53
	item 40 key (257 EXTENT_DATA 5093724160) itemoff 1822 itemsize 53
	item 41 key (257 EXTENT_DATA 5093728256) itemoff 1769 itemsize 53
	item 42 key (257 EXTENT_DATA 5093736448) itemoff 1716 itemsize 53
	item 43 key (257 EXTENT_DATA 5093740544) itemoff 1663 itemsize 53
	item 44 key (257 EXTENT_DATA 5093748736) itemoff 1610 itemsize 53
	item 45 key (257 EXTENT_DATA 5093756928) itemoff 1557 itemsize 53
	item 46 key (257 EXTENT_DATA 5093761024) itemoff 1504 itemsize 53
	item 47 key (257 EXTENT_DATA 5093769216) itemoff 1451 itemsize 53
	item 48 key (257 EXTENT_DATA 5093777408) itemoff 1398 itemsize 53
	item 49 key (257 EXTENT_DATA 5093781504) itemoff 1345 itemsize 53
	item 50 key (257 EXTENT_DATA 5093789696) itemoff 1292 itemsize 53
leaf 34881536 items 26 free space 1967 generation 14 owner 5
fs uuid 35176913-421b-4be9-9c11-6cdf81dd39a9
chunk uuid e13b5f43-8ea1-4867-b6c0-fa4b97caeb43
	item 0 key (257 EXTENT_DATA 5093797888) itemoff 3942 itemsize 53
	item 1 key (257 EXTENT_DATA 5093801984) itemoff 3889 itemsize 53
	item 2 key (257 EXTENT_DATA 5093810176) itemoff 3836 itemsize 53
	item 3 key (257 EXTENT_DATA 5093814272) itemoff 3783 itemsize 53
	item 4 key (257 EXTENT_DATA 5093822464) itemoff 3730 itemsize 53
	item 5 key (257 EXTENT_DATA 5093830656) itemoff 3677 itemsize 53
	item 6 key (257 EXTENT_DATA 5093834752) itemoff 3624 itemsize 53
	item 7 key (257 EXTENT_DATA 5093842944) itemoff 3571 itemsize 53
	item 8 key (257 EXTENT_DATA 5093851136) itemoff 3518 itemsize 53
	item 9 key (257 EXTENT_DATA 5093855232) itemoff 3465 itemsize 53
	item 10 key (257 EXTENT_DATA 5093863424) itemoff 3412 itemsize 53
	item 11 key (257 EXTENT_DATA 5093871616) itemoff 3359 itemsize 53
	item 12 key (257 EXTENT_DATA 5093875712) itemoff 3306 itemsize 53
	item 13 key (257 EXTENT_DATA 5093883904) itemoff 3253 itemsize 53
	item 14 key (257 EXTENT_DATA 5093892096) itemoff 3200 itemsize 53
	item 15 key (257 EXTENT_DATA 5093896192) itemoff 3147 itemsize 53
	item 16 key (257 EXTENT_DATA 5093904384) itemoff 3094 itemsize 53
	item 17 key (257 EXTENT_DATA 5093912576) itemoff 3041 itemsize 53
	item 18 key (257 EXTENT_DATA 5093916672) itemoff 2988 itemsize 53
	item 19 key (257 EXTENT_DATA 5093924864) itemoff 2935 itemsize 53
	item 20 key (257 EXTENT_DATA 5093933056) itemoff 2882 itemsize 53
	item 21 key (257 EXTENT_DATA 5093937152) itemoff 2829 itemsize 53
	item 22 key (257 EXTENT_DATA 5093945344) itemoff 2776 itemsize 53
	item 23 key (257 EXTENT_DATA 5093949440) itemoff 2723 itemsize 53
	item 24 key (257 EXTENT_DATA 5093957632) itemoff 2670 itemsize 53
	item 25 key (257 EXTENT_DATA 5093961728) itemoff 2617 itemsize 53
leaf 37027840 items 34 free space 1343 generation 15 owner 5
fs uuid 35176913-421b-4be9-9c11-6cdf81dd39a9
chunk uuid e13b5f43-8ea1-4867-b6c0-fa4b97caeb43
	item 0 key (257 EXTENT_DATA 5093969920) itemoff 3942 itemsize 53
	item 1 key (257 EXTENT_DATA 5093978112) itemoff 3889 itemsize 53
	item 2 key (257 EXTENT_DATA 5093982208) itemoff 3836 itemsize 53
	item 3 key (257 EXTENT_DATA 5093990400) itemoff 3783 itemsize 53
	item 4 key (257 EXTENT_DATA 5093994496) itemoff 3730 itemsize 53
	item 5 key (257 EXTENT_DATA 5094002688) itemoff 3677 itemsize 53
	item 6 key (257 EXTENT_DATA 5094006784) itemoff 3624 itemsize 53
	item 7 key (257 EXTENT_DATA 5094014976) itemoff 3571 itemsize 53
	item 8 key (257 EXTENT_DATA 5094023168) itemoff 3518 itemsize 53
	item 9 key (257 EXTENT_DATA 5094027264) itemoff 3465 itemsize 53
	item 10 key (257 EXTENT_DATA 5094035456) itemoff 3412 itemsize 53
	item 11 key (257 EXTENT_DATA 5094039552) itemoff 3359 itemsize 53
	item 12 key (257 EXTENT_DATA 5094047744) itemoff 3306 itemsize 53
	item 13 key (257 EXTENT_DATA 5094055936) itemoff 3253 itemsize 53
	item 14 key (257 EXTENT_DATA 5094064128) itemoff 3200 itemsize 53
	item 15 key (257 EXTENT_DATA 5094072320) itemoff 3147 itemsize 53
	item 16 key (257 EXTENT_DATA 5094076416) itemoff 3094 itemsize 53
	item 17 key (257 EXTENT_DATA 5094084608) itemoff 3041 itemsize 53
	item 18 key (257 EXTENT_DATA 5094088704) itemoff 2988 itemsize 53
	item 19 key (257 EXTENT_DATA 5094096896) itemoff 2935 itemsize 53
	item 20 key (257 EXTENT_DATA 5094100992) itemoff 2882 itemsize 53
	item 21 key (257 EXTENT_DATA 5094109184) itemoff 2829 itemsize 53
	item 22 key (257 EXTENT_DATA 5094117376) itemoff 2776 itemsize 53
	item 23 key (257 EXTENT_DATA 5094121472) itemoff 2723 itemsize 53
	item 24 key (257 EXTENT_DATA 5094129664) itemoff 2670 itemsize 53
	item 25 key (257 EXTENT_DATA 5094137856) itemoff 2617 itemsize 53
	item 26 key (257 EXTENT_DATA 5094141952) itemoff 2564 itemsize 53
	item 27 key (257 EXTENT_DATA 5094150144) itemoff 2511 itemsize 53
	item 28 key (257 EXTENT_DATA 5094154240) itemoff 2458 itemsize 53
	item 29 key (257 EXTENT_DATA 5094158336) itemoff 2405 itemsize 53
	item 30 key (257 EXTENT_DATA 5876654080) itemoff 2352 itemsize 53
	item 31 key (257 EXTENT_DATA 6659149824) itemoff 2299 itemsize 53
	item 32 key (257 EXTENT_DATA 7001882624) itemoff 2246 itemsize 53
	item 33 key (257 EXTENT_DATA 7008460800) itemoff 2193 itemsize 53

Using the current btrfs_prev_leaf implementation, to lookup for the key
(257 BTRFS_EXTENT_DATA_KEY 5093457920), which is the left most item of
the third leaf, and then calling btrfs_leaf_prev against the path produced
by btrfs_search_slot, returns the same leaf with a success return value (0):

	struct btrfs_path *path;
	struct btrfs_key key;
	struct btrfs_disk_key disk_key;
	struct extent_buffer *leaf;
	int ret, slot;

	path = btrfs_alloc_path();
	key.objectid = 257;
	key.type = BTRFS_EXTENT_DATA_KEY;
	key.offset = 5093457920;
	ret = btrfs_search_slot(NULL, fs_info->fs_root, &key, path, 0, 0);
	BUG_ON(ret != 0);

	leaf = path->nodes[0];
	slot = path->slots[0];
	btrfs_item_key(leaf, &disk_key, slot);
	printf("\tslot: %d, parent slot: %d, key: ", slot, path->slots[1]);
	btrfs_print_key(&disk_key);
	printf("\n");

	ret = btrfs_prev_leaf(info->fs_root, path);
	leaf = path->nodes[0];
	slot = path->slots[0];
	btrfs_item_key(leaf, &disk_key, slot);
	printf("\tprev leaf ret: %d, prev leaf key: ", ret);
	btrfs_print_key(&disk_key);
	printf("\n");

The output sent to stdout from the above code when using the current implementation
of btrfs_prev_leaf is:

	slot: 0, parent slot: 2, key: key (257 EXTENT_DATA 5093457920)
	prev leaf ret: 0, prev leaf key: key (257 EXTENT_DATA 5093457920)

Using the new version of btrfs_prev_leaf, introduced by this change and which is
based on the version found in btrfs-progs, produces correct results, i.e. it returns
the previous leaf with the correct slot set (right most item of the previous leaf).
The output sent to stdout with the fixed btrfs_prev_leaf is:

	slot: 0, parent slot: 2, key: key (257 EXTENT_DATA 5093457920)
	prev leaf ret: 0, prev leaf key: key (257 EXTENT_DATA 5093453824)

The above fs tree was produced with the following code:

$ mkfs.btrfs -f /dev/sdb3
$ mount /dev/sdb3 /mnt/btrfs
$ dd if=/dev/zero of=/mnt/btrfs/foobar bs=4096 count=10000000
$ umount /mnt/btrfs
$ btrfs-debug-tree /dev/sdb3

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c |  113 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 82 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5fa521b..df68600 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -42,6 +42,7 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb);
 static int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
+static void read_lock_node(struct extent_buffer *b, struct btrfs_path *path);
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
@@ -2646,16 +2647,8 @@ cow_done:
 								  BTRFS_WRITE_LOCK);
 					}
 					p->locks[level] = BTRFS_WRITE_LOCK;
-				} else {
-					err = btrfs_try_tree_read_lock(b);
-					if (!err) {
-						btrfs_set_path_blocking(p);
-						btrfs_tree_read_lock(b);
-						btrfs_clear_path_blocking(p, b,
-								  BTRFS_READ_LOCK);
-					}
-					p->locks[level] = BTRFS_READ_LOCK;
-				}
+				} else
+					read_lock_node(b, p);
 				p->nodes[level] = b;
 			}
 		} else {
@@ -4776,30 +4769,74 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
  */
 static int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 {
-	struct btrfs_key key;
-	struct btrfs_disk_key found_key;
-	int ret;
+	int slot;
+	int level = 1;
+	int ret = 1;
+	struct extent_buffer *c;
+	struct extent_buffer *next = NULL, *next2 = NULL;
+	int *locks;
 
-	btrfs_item_key_to_cpu(path->nodes[0], &key, 0);
+	locks = kzalloc(sizeof(int) * BTRFS_MAX_LEVEL, GFP_NOFS);
+	if (!locks)
+		return -ENOMEM;
+	locks[0] = path->locks[0];
 
-	if (key.offset > 0)
-		key.offset--;
-	else if (key.type > 0)
-		key.type--;
-	else if (key.objectid > 0)
-		key.objectid--;
-	else
-		return 1;
+	while (level < BTRFS_MAX_LEVEL) {
+		if (!path->nodes[level])
+			goto out;
 
-	btrfs_release_path(path);
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		return ret;
-	btrfs_item_key(path->nodes[0], &found_key, 0);
-	ret = comp_keys(&found_key, &key);
-	if (ret < 0)
-		return 0;
-	return 1;
+		slot = path->slots[level];
+		c = path->nodes[level];
+		locks[level] = path->locks[level];
+		if (slot == 0) {
+			level++;
+			if (level == BTRFS_MAX_LEVEL)
+				goto out;
+			continue;
+		}
+		slot--;
+		/*
+		 * TODO: need to lock 'c' ?
+		 * Perhaps need to lock it, then check if
+		 * extent_buffer_uptodate(c) returns true. If yes, all is ok?
+		 * If it's not, then repeat the tree search for the key at the
+		 * original path->nodes[0] (item at the original path->slots[0]).
+		 * Is this safe? Can it cause infinite retries?
+		 */
+		next = read_node_slot(root, c, slot);
+		if (!path->skip_locking)
+			read_lock_node(next, path);
+		break;
+	}
+	path->slots[level] = slot;
+	while (1) {
+		level--;
+		c = path->nodes[level];
+		if (locks[level])
+			btrfs_tree_unlock_rw(c, locks[level]);
+		free_extent_buffer(c);
+		slot = btrfs_header_nritems(next) - 1;
+		if (slot < 0)
+			goto out;
+		path->nodes[level] = next;
+		path->slots[level] = slot;
+		if (level == 0) {
+			ret = 0;
+			goto out;
+		}
+		next2 = read_node_slot(root, next, slot);
+		if (!path->skip_locking)
+			read_lock_node(next2, path);
+		if (locks[level + 1]) {
+			btrfs_tree_unlock_rw(next, locks[level + 1]);
+			locks[level + 1] = 0;
+		}
+		next = next2;
+	}
+
+out:
+	kfree(locks);
+	return ret;
 }
 
 /*
@@ -5636,3 +5673,17 @@ int btrfs_previous_item(struct btrfs_root *root,
 	}
 	return 1;
 }
+
+static void read_lock_node(struct extent_buffer *b, struct btrfs_path *path)
+{
+	int success;
+	int level = btrfs_header_level(b);
+
+	success = btrfs_try_tree_read_lock(b);
+	if (!success) {
+		btrfs_set_path_blocking(path);
+		btrfs_tree_read_lock(b);
+		btrfs_clear_path_blocking(path, b, BTRFS_READ_LOCK);
+	}
+	path->locks[level] = BTRFS_READ_LOCK;
+}
-- 
1.7.9.5

