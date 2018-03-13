Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39666 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbeCMB42 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 21:56:28 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 1/7] btrfs-progs: convert/ext2: Fix inline extent creation check
Date: Tue, 13 Mar 2018 09:56:10 +0800
Message-Id: <20180313015616.6574-2-wqu@suse.com>
In-Reply-To: <20180313015616.6574-1-wqu@suse.com>
References: <20180313015616.6574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/source-ext2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index b1492c78693d..e13fbe00415a 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -310,7 +310,7 @@ static int ext2_create_file_extents(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto fail;
 	if ((convert_flags & CONVERT_FLAG_INLINE_DATA) && data.first_block == 0
-	    && data.num_blocks > 0
+	    && data.num_blocks > 0 && inode_size < sectorsize
 	    && inode_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
 		u64 num_bytes = data.num_blocks * sectorsize;
 		u64 disk_bytenr = data.disk_block * sectorsize;
-- 
2.16.2

