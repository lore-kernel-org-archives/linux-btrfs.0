Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40669 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbaCLB26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 21:28:58 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi5so1719511wib.11
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 18:28:57 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/2 v2] Btrfs: less fs tree lock contention when using autodefrag
Date: Wed, 12 Mar 2014 01:28:24 +0000
Message-Id: <1394587704-22578-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1394546175-7370-1-git-send-email-fdmanana@gmail.com>
References: <1394546175-7370-1-git-send-email-fdmanana@gmail.com>
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
After this change:  63.034Mb/sec throughtput, read 83.102Gb, written 27.701Gb

Test machine: quad core intel i5-3570K, 32Gb of RAM, SSD.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Added missing path->keep_locks reset, which made the unlock_up_safe call
    be a noop. And updated commit message test numbers.

 fs/btrfs/ioctl.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e174770..6ab95cc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -935,12 +935,14 @@ static int find_new_extents(struct btrfs_root *root,
 	min_key.type = BTRFS_EXTENT_DATA_KEY;
 	min_key.offset = *off;
 
-	path->keep_locks = 1;
-
 	while (1) {
+		path->keep_locks = 1;
 		ret = btrfs_search_forward(root, &min_key, path, newer_than);
 		if (ret != 0)
 			goto none;
+		path->keep_locks = 0;
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

