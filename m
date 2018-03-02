Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:59311 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163333AbeCBCKE (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 1 Mar 2018 21:10:04 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3] btrfs: Unify inline extent creation condition for plain and compressed data
Date: Fri,  2 Mar 2018 10:09:47 +0800
Message-Id: <20180302020948.24816-2-wqu@suse.com>
In-Reply-To: <20180302020948.24816-1-wqu@suse.com>
References: <20180302020948.24816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cow_file_range_inline() used different condition for plain and
compressed data.

For compressed data, it's allowed to have inline extent equal to sectorsize,
while for plain data, it's not allowed to have inline extent equal to
sectorsize.

But since we limit BTRFS_MAX_INLINE_DATA_SIZE() to (sectorsize - 1),
there is no such difference any long, just remove the extra check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0f7041e10c67..8c5e69bdbfb5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -299,8 +299,6 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 
 	if (start > 0 ||
 	    actual_end > fs_info->sectorsize ||
-	    (!compressed_size &&
-	    (actual_end & (fs_info->sectorsize - 1)) == 0) ||
 	    end + 1 < isize ||
 	    data_len > fs_info->max_inline) {
 		return 1;
-- 
2.16.2

