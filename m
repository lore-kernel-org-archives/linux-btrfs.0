Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57570 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbeC3Hfo (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 03:35:44 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: convert: Fix offset-by-one error in read_data_extent()
Date: Fri, 30 Mar 2018 15:35:27 +0800
Message-Id: <20180330073528.20650-3-wqu@suse.com>
In-Reply-To: <20180330073528.20650-1-wqu@suse.com>
References: <20180330073528.20650-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For read_data_extent() in convert/main.c it's using mirror number in a
incorrect way, which will not get correct copy for RAID1:
------
	for (cur_mirror = 0; cur_mirror < num_copies; cur_mirror++) {
------

In such case, for RAID1 @cur_mirror will only be 0 and 1.

However for 0 and 1 case, btrfs_map_block() will only return the first
copy.
To reach the 2nd copy, it correct @cur_mirror range should be 1 and 2.

So with this offset-by-one error, btrfs-image will never be able to read
out data extent if the first stripe of the chunk is the missing one.

Fix it by starting @cur_mirror from 1 and to @num_copies (including).

Fixes: 2d46558b30f5 ("btrfs-progs: Use existing facility to replace read_data_extent function")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/image/main.c b/image/main.c
index 5f155c23dce6..351c5a256938 100644
--- a/image/main.c
+++ b/image/main.c
@@ -571,7 +571,7 @@ static int read_data_extent(struct metadump_struct *md,
 	num_copies = btrfs_num_copies(root->fs_info, logical, bytes_left);
 
 	/* Try our best to read data, just like read_tree_block() */
-	for (cur_mirror = 0; cur_mirror < num_copies; cur_mirror++) {
+	for (cur_mirror = 1; cur_mirror <= num_copies; cur_mirror++) {
 		while (bytes_left) {
 			read_len = bytes_left;
 			ret = read_extent_data(fs_info,
-- 
2.16.3

