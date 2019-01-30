Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC40C282D4
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 07:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BD502087F
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 07:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfA3HkK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:40:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:44170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfA3HkK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 02:40:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2EB9AB017
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 07:40:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 2/2] btrfs: Introduce free dev extent hint to speed up chunk allocation
Date:   Wed, 30 Jan 2019 15:40:00 +0800
Message-Id: <20190130074000.16638-3-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130074000.16638-1-wqu@suse.com>
References: <20190130074000.16638-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[PROBLEM]
When allocating a 4G file, falloc() call is slower and slower if the fs
is more and more filled.

This is going to be super obvious when doing some crazy test.
E.g. fallocating a 1PiB file TiB by TiB.
The first 16T only takes 10 seconds to finish while the last 16TiB can
take over 15min to finish.

[CAUSE]
When allocating new dev extents for a chunk, btrfs doesn't have any free
dev extent cache, thus it can only search device tree to find free slot.

However it always search from device offset 0, and if there are a lot of
dev extents already allocated, such search will be super time consuming.

The following is function execution time for __btrfs_alloc_chunk()
and find_free_dev_extent_start(), one is allocating 4G on an empty fs,
the other one is allocating 4G on a 4T used fs.
      empty fs   |   4T used fs    |    function
-----------------------------------------------------------------------
 4)              | 7)              |  __btrfs_alloc_chunk [btrfs]() {
 4)   4.839 us   | 7) ! 152.496 us |    find_free_dev_extent_start [btrfs]()
 4) + 64.692 us  | 7) ! 185.488 us |  }
 4)              | 7)              |  __btrfs_alloc_chunk [btrfs]() {
 4) + 12.844 us  | 7) ! 132.889 us |    find_free_dev_extent_start [btrfs]()
 4) ! 131.877 us | 7) ! 152.115 us |  }
 4)              | 7)              |  __btrfs_alloc_chunk [btrfs]() {
 4)   2.375 us   | 7) ! 127.689 us |    find_free_dev_extent_start [btrfs]()
 4) + 16.992 us  | 7) ! 146.595 us |  }
 4)              | 7)              |  __btrfs_alloc_chunk [btrfs]() {
 4)   2.144 us   | 7) ! 126.657 us |    find_free_dev_extent_start [btrfs]()
 4) + 16.280 us  | 7) ! 144.521 us |  }

It's pretty ovbious that find_free_free_dev_extent_start() takes over
20x more time for 4TB used fs, causing chunk allocation much slower.

[ENHANCEMENT]
This patch will introduce btrfs_device::hint_free_dev_extent member to
give some hint for chunk allocator to find free dev extents.

The hint itself is pretty simple, only tells where the first free slot
could possibly be.

It is not 100% correct, unlike free space cache, but since
find_free_dev_extent_start() is already robust enough to handle
search_hint, so there is not need to introduce a complex and fancy free
dev extent cache.

With this patch, allocating 4G on a 4T filled fs will be way more
faster:

      v5.0-rc1   |   patched      |    function
---------------------------------------------------------------------
 7)              | 7)             |  __btrfs_alloc_chunk [btrfs]() {
 7) ! 152.496 us | 7)   7.885 us  |    find_free_dev_extent_start [btrfs]();
 7) ! 185.488 us | 7) + 36.649 us |  }
 7)              | 7)             |  __btrfs_alloc_chunk [btrfs]() {
 7) ! 132.889 us | 7)   2.454 us  |    find_free_dev_extent_start [btrfs]();
 7) ! 152.115 us | 7) + 24.145 us |  }
 7)              | 7)             |  __btrfs_alloc_chunk [btrfs]() {
 7) ! 127.689 us | 7)   2.245 us  |    find_free_dev_extent_start [btrfs]();
 7) ! 146.595 us | 7) + 19.376 us |  }
 7)              | 7)             |  __btrfs_alloc_chunk [btrfs]() {
 7) ! 126.657 us | 7)   2.174 us  |    find_free_dev_extent_start [btrfs]();
 7) ! 144.521 us | 7) + 16.321 us |  }

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 23 +++++++++++++++---
 fs/btrfs/volumes.h | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8e932d7d2fe6..cc15bf70dc72 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -411,6 +411,7 @@ static struct btrfs_device *__alloc_device(void)
 	btrfs_device_data_ordered_init(dev);
 	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
+	dev->hint_free_dev_extent = (u64)-1;
 
 	return dev;
 }
@@ -1741,9 +1742,9 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *len)
 {
-	/* FIXME use last free of some kind */
-	return find_free_dev_extent_start(trans->transaction, device,
-					  num_bytes, 0, start, len);
+	return find_free_dev_extent_start(trans->transaction, device, num_bytes,
+					  device->hint_free_dev_extent, start,
+					  len);
 }
 
 static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
@@ -1799,6 +1800,7 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 				      "Failed to remove dev extent item");
 	} else {
 		set_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags);
+		btrfs_device_hint_add_free(device, key.offset, *dev_extent_len);
 	}
 out:
 	btrfs_free_path(path);
@@ -1841,6 +1843,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
 
 	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
+	btrfs_device_hint_del_free(device, key.offset, num_bytes);
 	btrfs_mark_buffer_dirty(leaf);
 out:
 	btrfs_free_path(path);
@@ -7913,6 +7916,14 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 		devid = key.objectid;
 		physical_offset = key.offset;
 
+		/*
+		 * previous device verification is done, update its free dev
+		 * extent hint
+		 */
+		if (device && devid != device->devid)
+			btrfs_device_hint_add_free(device, prev_dev_ext_end,
+				device->disk_total_bytes - prev_dev_ext_end);
+
 		if (!device || devid != device->devid) {
 			device = btrfs_find_device(fs_info, devid, NULL, NULL);
 			if (!device) {
@@ -7940,6 +7951,10 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 					    physical_offset, physical_len);
 		if (ret < 0)
 			goto out;
+
+		btrfs_device_hint_add_free(device, prev_dev_ext_end,
+				physical_offset - prev_dev_ext_end);
+
 		prev_devid = devid;
 		prev_dev_ext_end = physical_offset + physical_len;
 
@@ -7951,6 +7966,8 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 			break;
 		}
 	}
+	btrfs_device_hint_add_free(device, prev_dev_ext_end,
+			device->disk_total_bytes - prev_dev_ext_end);
 
 	/* Ensure all chunks have corresponding dev extents */
 	ret = verify_chunk_dev_extent_mapping(fs_info);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ed806649a473..00f7ef72466f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -108,6 +108,14 @@ struct btrfs_device {
 
 	/* bytes used on the current transaction */
 	u64 commit_bytes_used;
+
+	/*
+	 * hint about where the first possible free dev extent is.
+	 *
+	 * u64(-1) means no hint.
+	 */
+	u64 hint_free_dev_extent;
+
 	/*
 	 * used to manage the device which is resized
 	 *
@@ -569,4 +577,54 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 int btrfs_bg_type_to_factor(u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 
+static inline void btrfs_device_hint_add_free(struct btrfs_device *dev,
+					      u64 start, u64 len)
+{
+	if (dev->disk_total_bytes == 0 || start + len > dev->disk_total_bytes)
+		return;
+	if (len < SZ_16M)
+		return;
+	if (start > dev->hint_free_dev_extent)
+		return;
+	dev->hint_free_dev_extent = start;
+}
+
+static inline void btrfs_device_hint_del_free(struct btrfs_device *dev,
+					      u64 start, u64 len)
+{
+	u64 free_hint = dev->hint_free_dev_extent;
+
+	if (dev->disk_total_bytes == 0 || start + len > dev->disk_total_bytes)
+		return;
+	/*
+	 * |<- to be removed ->|
+	 * 			| free hint
+	 * Not affecting free hint
+	 */
+	if (start + len <= free_hint)
+		return;
+	/*
+	 * |<- to be removed ->|
+	 * 		| free hint
+	 * Or
+	 * 	|<- to be removed ->|
+	 * | free hint
+	 * |<-->| Less than 16M
+	 *
+	 * Move the hint to the range end
+	 */
+	if ((start <= free_hint && start + len > free_hint) ||
+	    (start > free_hint && free_hint - start < SZ_16M)) {
+		dev->hint_free_dev_extent = start + len;
+		return;
+	}
+
+	/*
+	 * 			|<- to be removed ->|
+	 * | free hint
+	 *
+	 * We still have larger than 16M free space, no need to update
+	 * free hint
+	 */
+}
 #endif
-- 
2.20.1

