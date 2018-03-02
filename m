Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:53787 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753321AbeCBFXG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Mar 2018 00:23:06 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/5] btrfs: Always limit inline extent size by uncompressed size
Date: Fri,  2 Mar 2018 13:22:51 +0800
Message-Id: <20180302052254.7059-3-wqu@suse.com>
In-Reply-To: <20180302052254.7059-1-wqu@suse.com>
References: <20180302052254.7059-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Normally when specifying max_inline, we should normally limit it by
uncompressed extent size, as it's the only thing user can control.
(Control the algorithm and compressed data is almost impossible)

Since btrfs is providing *TRANSPARENT* compression, max_inline should
behave the same for both plain and compress data.

So this patch will use @inline_len instead of @data_len in
cow_file_range_inline() so user will know their max_inline mount option
works exactly the same for both plain and compressed data extent.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e1a7f3cb5be9..48472509239b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -303,7 +303,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	    (!compressed_size &&
 	    (actual_end & (fs_info->sectorsize - 1)) == 0) ||
 	    end + 1 < isize ||
-	    data_len > fs_info->max_inline) {
+	    inline_len > fs_info->max_inline) {
 		return 1;
 	}
 
-- 
2.16.2

