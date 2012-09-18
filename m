Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab2IRK7r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 06:59:47 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8IAxjro016676
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 18:59:45 +0800
Message-ID: <50585420.6060407@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 18:59:44 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 4/7] Btrfs-progs: fix wrong way to check if the root item
 contains otime and uuid
References: <50584E6D.8000602@cn.fujitsu.com>
In-Reply-To: <50584E6D.8000602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

Now we check if the root item contains otime and uuid or not by comparing
->generation_v2 and ->generation of the btrfs_root_item structure, it is
wrong because it is possbile that ->generation may equal to the first
variant of the next item. We fix this problem by check the size of btrfs_root_item,
if it is larger than the original one, the new btrfs_root_item contains otime
and uuid. we needn't worry the case that the new filesystem is mounted on the
old kernel. because the otime and uuid are not changed on the old kernel, we can
get the correct result even on the kernel.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v3 -> v4:
- change the check method of btrfs_root_item, if the size of btrfs_root_item
  is larger than the original one, the new btrfs_root_item contains otime and
  uuid.

Changelog v1 -> v3:
- new patch
---
 btrfs-list.c |    9 ++++++---
 ctree.h      |   15 +++++++++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index ef621f0..ed28021 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -737,7 +737,8 @@ again:
 			} else if (get_gen && sh->type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
-				if(ri->generation == ri->generation_v2) {
+				if(sh->len >
+				   sizeof(struct btrfs_root_item_v0)) {
 					t = ri->otime.sec;
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
 				} else {
@@ -844,9 +845,11 @@ static int __list_snapshot_search(int fd, struct root_lookup *root_lookup)
 			off += sizeof(*sh);
 			if (sh->type == BTRFS_ROOT_ITEM_KEY && sh->offset) {
 				item = (struct btrfs_root_item *)(args.buf + off);
-				if(item->generation == item->generation_v2) {
+				if(sh->len >
+				   sizeof(struct btrfs_root_item_v0)) {
 					t = item->otime.sec;
-					memcpy(uuid, item->uuid, BTRFS_UUID_SIZE);
+					memcpy(uuid, item->uuid,
+					       BTRFS_UUID_SIZE);
 				} else {
 					t = 0;
 					memset(uuid, 0, BTRFS_UUID_SIZE);
diff --git a/ctree.h b/ctree.h
index 7f55229..c55d033 100644
--- a/ctree.h
+++ b/ctree.h
@@ -637,6 +637,21 @@ struct btrfs_dir_item {
 	u8 type;
 } __attribute__ ((__packed__));
 
+struct btrfs_root_item_v0 {
+	struct btrfs_inode_item inode;
+	__le64 generation;
+	__le64 root_dirid;
+	__le64 bytenr;
+	__le64 byte_limit;
+	__le64 bytes_used;
+	__le64 last_snapshot;
+	__le64 flags;
+	__le32 refs;
+	struct btrfs_disk_key drop_progress;
+	u8 drop_level;
+	u8 level;
+} __attribute__ ((__packed__));
+
 struct btrfs_root_item {
 	struct btrfs_inode_item inode;
 	__le64 generation;
-- 
1.7.6.5

