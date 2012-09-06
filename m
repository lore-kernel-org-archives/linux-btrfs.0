Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab2IFKuO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:50:14 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86AoD6G019807
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:50:13 +0800
Message-ID: <50487FD8.1000804@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:50:00 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3 4/7] Btrfs-progs: fix wrong way to check if the root item
 contains otime and uuid
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487F6E.6060001@cn.fujitsu.com>

Now we check if the root item contains otime and uuid or not by comparing
->generation_v2 and ->generation of the btrfs_root_item structure, it is
wrong because it is possbile that ->generation may equal to the first
variant of the next item. We fix this problem by comparing the size of
btrfs_root_item because the size is different between the old and new ones.
we needn't worry the case that the new filesystem is mounted on the old kernel.
because the otime and uuid are not changed on the old kernel, we can get the
correct result even on the kernel.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v3:
- new patch
---
 btrfs-list.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index ef621f0..2101695 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -737,7 +737,7 @@ again:
 			} else if (get_gen && sh->type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
-				if(ri->generation == ri->generation_v2) {
+				if(sh->len == sizeof(struct btrfs_root_item)) {
 					t = ri->otime.sec;
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
 				} else {
@@ -844,7 +844,7 @@ static int __list_snapshot_search(int fd, struct root_lookup *root_lookup)
 			off += sizeof(*sh);
 			if (sh->type == BTRFS_ROOT_ITEM_KEY && sh->offset) {
 				item = (struct btrfs_root_item *)(args.buf + off);
-				if(item->generation == item->generation_v2) {
+				if(sh->len == sizeof(struct btrfs_root_item)) {
 					t = item->otime.sec;
 					memcpy(uuid, item->uuid, BTRFS_UUID_SIZE);
 				} else {
-- 
1.7.6.5
