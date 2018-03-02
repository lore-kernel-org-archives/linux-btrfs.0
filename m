Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:42631 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932433AbeCBFXH (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Mar 2018 00:23:07 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/5] btrfs: Unify inline extent creation condition for plain and compressed data
Date: Fri,  2 Mar 2018 13:22:53 +0800
Message-Id: <20180302052254.7059-5-wqu@suse.com>
In-Reply-To: <20180302052254.7059-1-wqu@suse.com>
References: <20180302052254.7059-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cow_file_range_inline() used different condition for plain and
compressed data.

For compressed data, it's allowed to have inline extent equal to sectorsize,
while for plain data, it's not allowed to have inline extent equal to
sectorsize.

However we limited BTRFS_MAX_INLINE_DATA_SIZE() to (sectorsize - 1),
and unified the inline extent condition, there is no such difference any
longer, just remove the extra check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fe2991eeb337..1e9f4ff46b25 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -299,8 +299,6 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 
 	if (start > 0 ||
 	    actual_end > fs_info->sectorsize ||
-	    (!compressed_size &&
-	    (actual_end & (fs_info->sectorsize - 1)) == 0) ||
 	    end + 1 < isize ||
 	    inline_len > fs_info->max_inline) {
 		return 1;
-- 
2.16.2

