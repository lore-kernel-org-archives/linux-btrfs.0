Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5883 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab3L0NKl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Dec 2013 08:10:41 -0500
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: t-itoh@jp.fujitsu.com
Subject: [PATCH 2/2] Btrfs: fix the wrong nocow range check
Date: Fri, 27 Dec 2013 21:11:50 +0800
Message-Id: <1388149910-31499-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1388149910-31499-1-git-send-email-miaox@cn.fujitsu.com>
References: <1388149910-31499-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following warning message was outputed when running the 274th case
of xfstests with nodatacow option:
 BUG: Bad page state in process kswapd0  pfn:1c66f
 page:ffffea0000636848 count:0 mapcount:0 mapping:(null) index:0x78000
 page flags: 0x1000000000100a(error|uptodate|private_2)

It is because the check of nocow range was wrong, we should compare the
start and end position of the extent with the write position to verify
if the write position was in the extent, but the current code just used
the start postion to do the check, so we got the wrong extent and told
the caller that it was a nocow write. And then when we write back the
dirty pages, we found we should cow the extent, but at that time, there
was no space in the fs, we had to the error flag for the page. When
someone reclaimed that page, the above warning outputed. Fix it.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1a7744..f2c6f91 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6386,6 +6386,7 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	int slot;
 	int found_type;
 	bool nocow = (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW);
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -6429,6 +6430,10 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	if (!nocow && found_type == BTRFS_FILE_EXTENT_REG)
 		goto out;
 
+	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
+	if (extent_end <= offset)
+		goto out;
+
 	disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	if (disk_bytenr == 0)
 		goto out;
@@ -6446,8 +6451,6 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 		*ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
 	}
 
-	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
-
 	if (btrfs_extent_readonly(root, disk_bytenr))
 		goto out;
 	btrfs_release_path(path);
-- 
1.8.1.4

