Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20260 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751705AbdB0HLU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 02:11:20 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>, <clm@fb.com>
Subject: [PATCH 7/9] btrfs: qgroup: Fix qgroup reserved space underflow caused by buffered write and quota enable
Date: Mon, 27 Feb 2017 15:10:37 +0800
Message-ID: <20170227071039.8335-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
Under the following case, we can underflow qgroup reserved space.

            Task A                |            Task B
---------------------------------------------------------------
 Quota disabled                   |
 Buffered write                   |
 |- btrfs_check_data_free_space() |
 |  *NO* qgroup space is reserved |
 |  since quota is *DISABLED*     |
 |- All pages are copied to page  |
    cache                         |
                                  | Enable quota
                                  | Quota scan finished
                                  |
                                  | Sync_fs
                                  | |- run_delalloc_range
                                  | |- Write pages
                                  | |- btrfs_finish_ordered_io
                                  |    |- insert_reserved_file_extent
                                  |       |- btrfs_qgroup_release_data()
                                  |          Since no qgroup space is
                                             reserved in Task A, we
                                             underflow qgroup reserved
                                             space
This can be detected by fstest btrfs/104.

[CAUSE]
In insert_reserved_file_extent() we info qgroup to release the @ram_bytes
size of qgroup reserved_space under all case.
And btrfs_qgroup_release_data() will check if qgroup is enabled.

However in above case, the buffered write happens before quota is
enabled, so we don't havee reserved space for that range.

[FIX]
In insert_reserved_file_extent(), we info qgroup to release the acctual
byte number it released.
In above case, since we don't have reserved space, we info qgroup to
release 0 byte, so the problem can be fixed.

And thanks to the @reserved parameter introduced by qgroup rework, and
previous patch to return release bytes, the fix can be as small as less
than 10 lines.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c38391e948d9..aabab731d38e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2045,6 +2045,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_key ins;
+	u64 qg_released;
 	int extent_inserted = 0;
 	int ret;
 
@@ -2100,13 +2101,17 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_alloc_reserved_file_extent(trans, root->root_key.objectid,
-			btrfs_ino(BTRFS_I(inode)), file_pos, ram_bytes, &ins);
+
 	/*
 	 * Release the reserved range from inode dirty range map, as it is
 	 * already moved into delayed_ref_head
 	 */
-	btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
+	ret = btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
+	if (ret < 0)
+		goto out;
+	qg_released = ret;
+	ret = btrfs_alloc_reserved_file_extent(trans, root->root_key.objectid,
+			btrfs_ino(BTRFS_I(inode)), file_pos, qg_released, &ins);
 out:
 	btrfs_free_path(path);
 
-- 
2.11.1



