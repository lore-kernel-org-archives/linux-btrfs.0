Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35694 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab3IEG53 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 02:57:29 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id CEA153EE0B6
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:57:28 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id BFDF445DEB5
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:57:28 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id AB3F345DEB2
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:57:28 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 9E9BF1DB803F
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:57:28 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4DA371DB8038
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:57:28 +0900 (JST)
Message-ID: <52282B4F.9040508@jp.fujitsu.com>
Date: Thu, 05 Sep 2013 15:57:19 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: chris.mason@fusionio.com
Subject: [PATCH v2 3/3] btrfs-progs: calculate available blocks on device
 properly
References: <522829F5.5050405@jp.fujitsu.com>
In-Reply-To: <522829F5.5050405@jp.fujitsu.com>
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
 2) (According to the comment in source code, to avoid overwriting
    superblock,) btrfs_alloc_chunk starts taking chunks at an offset
    of 1MB. It means that the layout of a disk will be like:
     [[1MB at beginning for sb][allocated chunks]* ... free space ... ]
    and you can see that the available free space for allocation is:
        avail = device->total_bytes - device->used_bytes - 1MB.
 3) Therefore there is only free space 1MB less than requested. damn.

>From further investigations I also found that this issue is easily
reproduced by using -A, --alloc-start option:

  # truncate --size=1G testfile
  # ./mkfs.btrfs -A900M -f testfile
   :
  mkfs.btrfs: volumes.c:852: btrfs_alloc_chunk: Assertion `!(ret)' failed.
  Aborted (core dumped)

In this case there is only 100MB for allocation but btrfs_alloc_chunk
was going to allocate more than the 100MB.

The root cause of both of above troubles is a same simple bug:
btrfs_chunk_alloc does not calculate available bytes properly even
though it researches how many devices have enough room to have a
chunk to be allocated.

So this patch introduces new function btrfs_device_avail_bytes()
which returns available bytes for allocation in specified device.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 ctree.h   |    8 +++++
 volumes.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 106 insertions(+), 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index 0b0d701..90be7ab 100644
--- a/ctree.h
+++ b/ctree.h
@@ -811,6 +811,14 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+/*
+ * We don't want to overwrite 1M at the beginning of device, even though
+ * there is our 1st superblock at 64k. Some possible reasons:
+ *  - the first 64k blank is useful for some boot loader/manager
+ *  - the first 1M could be scratched by buggy partitioner or somesuch
+ */
+#define BTRFS_BLOCK_RESERVED_1M_FOR_SUPER	((u64)1024 * 1024)
+
 /* tag for the radix tree of block groups in ram */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
diff --git a/volumes.c b/volumes.c
index 0ff2283..e8d7f25 100644
--- a/volumes.c
+++ b/volumes.c
@@ -268,7 +268,7 @@ static int find_free_dev_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_dev_extent *dev_extent = NULL;
 	u64 hole_size = 0;
 	u64 last_byte = 0;
-	u64 search_start = 0;
+	u64 search_start = root->fs_info->alloc_start;
 	u64 search_end = device->total_bytes;
 	int ret;
 	int slot = 0;
@@ -283,10 +283,12 @@ static int find_free_dev_extent(struct btrfs_trans_handle *trans,
 	/* we don't want to overwrite the superblock on the drive,
 	 * so we make sure to start at an offset of at least 1MB
 	 */
-	search_start = max((u64)1024 * 1024, search_start);
+	search_start = max(BTRFS_BLOCK_RESERVED_1M_FOR_SUPER, search_start);
 
-	if (root->fs_info->alloc_start + num_bytes <= device->total_bytes)
-		search_start = max(root->fs_info->alloc_start, search_start);
+	if (search_start >= search_end) {
+		ret = -ENOSPC;
+		goto error;
+	}
 
 	key.objectid = device->devid;
 	key.offset = search_start;
@@ -660,6 +662,94 @@ static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
 	return 64 * 1024;
 }
 
+/*
+ * btrfs_device_avail_bytes - count bytes available for alloc_chunk
+ *
+ * It is not equal to "device->total_bytes - device->bytes_used".
+ * We do not allocate any chunk in 1M at beginning of device, and not
+ * allowed to allocate any chunk before alloc_start if it is specified.
+ * So search holes from max(1M, alloc_start) to device->total_bytes.
+ */
+static int btrfs_device_avail_bytes(struct btrfs_trans_handle *trans,
+				    struct btrfs_device *device,
+				    u64 *avail_bytes)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *root = device->dev_root;
+	struct btrfs_key key;
+	struct btrfs_dev_extent *dev_extent = NULL;
+	struct extent_buffer *l;
+	u64 search_start = root->fs_info->alloc_start;
+	u64 search_end = device->total_bytes;
+	u64 extent_end = 0;
+	u64 free_bytes = 0;
+	int ret;
+	int slot = 0;
+
+	search_start = max(BTRFS_BLOCK_RESERVED_1M_FOR_SUPER, search_start);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = device->devid;
+	key.offset = root->fs_info->alloc_start;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+
+	path->reada = 2;
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto error;
+	ret = btrfs_previous_item(root, path, 0, key.type);
+	if (ret < 0)
+		goto error;
+
+	while (1) {
+		l = path->nodes[0];
+		slot = path->slots[0];
+		if (slot >= btrfs_header_nritems(l)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret == 0)
+				continue;
+			if (ret < 0)
+				goto error;
+			break;
+		}
+		btrfs_item_key_to_cpu(l, &key, slot);
+
+		if (key.objectid < device->devid)
+			goto next;
+		if (key.objectid > device->devid)
+			break;
+		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
+			goto next;
+		if (key.offset > search_end)
+			break;
+		if (key.offset > search_start)
+			free_bytes += key.offset - search_start;
+
+		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
+		extent_end = key.offset + btrfs_dev_extent_length(l,
+								  dev_extent);
+		if (extent_end > search_start)
+			search_start = extent_end;
+		if (search_start > search_end)
+			break;
+next:
+		path->slots[0]++;
+		cond_resched();
+	}
+
+	if (search_start < search_end)
+		free_bytes += search_end - search_start;
+
+	*avail_bytes = free_bytes;
+	ret = 0;
+error:
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 *start,
 		      u64 *num_bytes, u64 type)
@@ -678,7 +768,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	u64 calc_size = 8 * 1024 * 1024;
 	u64 min_free;
 	u64 max_chunk_size = 4 * calc_size;
-	u64 avail;
+	u64 avail = 0;
 	u64 max_avail = 0;
 	u64 percent_max;
 	int num_stripes = 1;
@@ -782,7 +872,9 @@ again:
 	/* build a private list of devices we will allocate from */
 	while(index < num_stripes) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		avail = device->total_bytes - device->bytes_used;
+		ret = btrfs_device_avail_bytes(trans, device, &avail);
+		if (ret)
+			return ret;
 		cur = cur->next;
 		if (avail >= min_free) {
 			list_move_tail(&device->dev_list, &private_devs);
-- 
1.7.1


