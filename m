Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932219AbdERDjd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 22/32] btrfs-progs: Refactor sectorsize users in file.c
Date: Thu, 18 May 2017 11:38:47 +0800
Message-ID: <20170518033857.15002-23-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/file.c b/file.c
index bf31ccef..028bfba8 100644
--- a/file.c
+++ b/file.c
@@ -193,10 +193,10 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 	int read = 0;
 	int ret;
 
-	if (!IS_ALIGNED(start, root->sectorsize) ||
-	    !IS_ALIGNED(len, root->sectorsize)) {
+	if (!IS_ALIGNED(start, root->fs_info->sectorsize) ||
+	    !IS_ALIGNED(len, root->fs_info->sectorsize)) {
 		warning("@start and @len must be aligned to %u for function %s",
-			root->sectorsize, __func__);
+			root->fs_info->sectorsize, __func__);
 		return -EINVAL;
 	}
 
@@ -260,7 +260,7 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 				goto next;
 			read_extent_buffer(leaf, dest,
 				btrfs_file_extent_inline_start(fi), extent_len);
-			read += round_up(extent_len, root->sectorsize);
+			read += round_up(extent_len, root->fs_info->sectorsize);
 			break;
 		}
 
@@ -319,7 +319,7 @@ next:
 		ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
 				    struct btrfs_inode_item);
 		isize = round_up(btrfs_inode_size(path.nodes[0], ii),
-				 root->sectorsize);
+				 root->fs_info->sectorsize);
 		read = min_t(u64, isize - start, len);
 	}
 out:
-- 
2.13.0



