Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53157 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaCKN43 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 09:56:29 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so10026727wgg.18
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 06:56:28 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/2] Btrfs: less fs tree lock contention when using autodefrag
Date: Tue, 11 Mar 2014 13:56:14 +0000
Message-Id: <1394546175-7370-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When finding new extents during an autodefrag, don't do so many fs tree
lookups to find an extent with a size smaller then the target treshold.
Instead, after each fs tree forward search immediately unlock upper
levels and process the entire leaf while holding a read lock on the leaf,
since our leaf processing is very fast.
This reduces lock contention, allowing for higher concurrency when other
tasks want to write/update items related to other inodes in the fs tree,
as we're not holding read locks on upper tree levels while processing the
leaf and we do less tree searches.

Test:

    sysbench --test=fileio --file-num=512 --file-total-size=16G \
       --file-test-mode=rndrw --num-threads=32 --file-block-size=32768 \
       --file-rw-ratio=3 --file-io-mode=sync --max-time=1800 \
       --max-requests=10000000000 [prepare|run]

(fileystem mounted with -o autodefrag, averages of 5 runs)

Before this change: 58.852Mb/sec throughtput, read 77.589Gb, written 25.863Gb
After this change:  62.683Mb/sec throughtput, read 82.111Gb, written 27.37Gb

Test machine: quad core intel i5-3570K, 32Gb of RAM, SSD.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e174770..5239470 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -941,6 +941,8 @@ static int find_new_extents(struct btrfs_root *root,
 		ret = btrfs_search_forward(root, &min_key, path, newer_than);
 		if (ret != 0)
 			goto none;
+		btrfs_unlock_up_safe(path, 1);
+process_slot:
 		if (min_key.objectid != ino)
 			goto none;
 		if (min_key.type != BTRFS_EXTENT_DATA_KEY)
@@ -959,6 +961,12 @@ static int find_new_extents(struct btrfs_root *root,
 			return 0;
 		}
 
+		path->slots[0]++;
+		if (path->slots[0] < btrfs_header_nritems(leaf)) {
+			btrfs_item_key_to_cpu(leaf, &min_key, path->slots[0]);
+			goto process_slot;
+		}
+
 		if (min_key.offset == (u64)-1)
 			goto none;
 
-- 
1.7.9.5

