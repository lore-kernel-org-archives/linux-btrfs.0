Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47911 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3HWGam (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 02:30:42 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 2618D3EE1DD
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:30:41 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 154DB45DE55
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:30:41 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id E8A5645DE58
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:30:40 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id D82ADE08002
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:30:40 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 8053F1DB804B
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:30:40 +0900 (JST)
Message-ID: <52170188.7000704@jp.fujitsu.com>
Date: Fri, 23 Aug 2013 15:30:32 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: chris.mason@fusionio.com
Subject: [PATCH 1/2] btrfs-progs: treat reserved 1MB for superblock properly
References: <52170114.7060604@jp.fujitsu.com>
In-Reply-To: <52170114.7060604@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found that mkfs.btrfs aborts when assigned multi volumes contain
a small volume:

  # parted /dev/sdf p
  Model: LSI MegaRAID SAS RMB (scsi)
  Disk /dev/sdf: 72.8GB
  Sector size (logical/physical): 512B/512B
  Partition Table: msdos

  Number  Start   End     Size    Type     File system  Flags
   1      32.3kB  72.4GB  72.4GB  primary
   2      72.4GB  72.8GB  461MB   primary

  # ./mkfs.btrfs -f /dev/sdf1 /dev/sdf2
  :
  SMALL VOLUME: forcing mixed metadata/data groups
  adding device /dev/sdf2 id 2
  mkfs.btrfs: volumes.c:852: btrfs_alloc_chunk: Assertion `!(ret)' failed.
  Aborted (core dumped)

This failure of btrfs_alloc_chunk was caused by following steps:
 1) since there is only small space in the small device, mkfs was
    going to allocate a chunk from free space as much as available.
    So mkfs called btrfs_alloc_chunk with
        size = device->total_bytes - device->used_bytes.
 2) To avoid overwriting superblock, btrfs_alloc_chunk starts taking
    chunks at an offset of 1MB. It means that the layout of a disk
    will be like:
     [[1MB at begging for sb][allocated chunks]* ... free space ... ]
    and you can see that the available free space for allocation is:
        avail = device->total_bytes - device->used_bytes - 1MB.
 3) Therefore there is only free space 1MB less than requested. damn.

So this fix let mkfs know how much spaces are really there.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 ctree.h   |    3 +++
 volumes.c |    7 ++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/ctree.h b/ctree.h
index 0b0d701..791bd14 100644
--- a/ctree.h
+++ b/ctree.h
@@ -811,6 +811,9 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+/* we have reserved 1M for superblock at the begging of device */
+#define BTRFS_BLOCK_RESERVED_1M_FOR_SUPER	((u64)1024 * 1024)
+
 /* tag for the radix tree of block groups in ram */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
diff --git a/volumes.c b/volumes.c
index 0ff2283..bf6b2e1 100644
--- a/volumes.c
+++ b/volumes.c
@@ -283,7 +283,7 @@ static int find_free_dev_extent(struct btrfs_trans_handle *trans,
 	/* we don't want to overwrite the superblock on the drive,
 	 * so we make sure to start at an offset of at least 1MB
 	 */
-	search_start = max((u64)1024 * 1024, search_start);
+	search_start = max(BTRFS_BLOCK_RESERVED_1M_FOR_SUPER, search_start);
 
 	if (root->fs_info->alloc_start + num_bytes <= device->total_bytes)
 		search_start = max(root->fs_info->alloc_start, search_start);
@@ -783,6 +783,11 @@ again:
 	while(index < num_stripes) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
 		avail = device->total_bytes - device->bytes_used;
+		/* we have reserved 1M for superblock at the head of device */
+		if (avail > BTRFS_BLOCK_RESERVED_1M_FOR_SUPER)
+			avail -= BTRFS_BLOCK_RESERVED_1M_FOR_SUPER;
+		else
+			avail = 0;
 		cur = cur->next;
 		if (avail >= min_free) {
 			list_move_tail(&device->dev_list, &private_devs);
-- 
1.7.1


