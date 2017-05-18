Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932198AbdERDjZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:25 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 19/32] btrfs-progs: Refactor sectorsize users in mkfs/main.c
Date: Thu, 18 May 2017 11:38:44 +0800
Message-ID: <20170518033857.15002-20-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 mkfs/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 61f746b3..24a51cb4 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -451,7 +451,7 @@ static int fill_inode_item(struct btrfs_trans_handle *trans,
 			   struct btrfs_inode_item *dst, struct stat *src)
 {
 	u64 blocks = 0;
-	u64 sectorsize = root->sectorsize;
+	u64 sectorsize = root->fs_info->sectorsize;
 
 	/*
 	 * btrfs_inode_item has some reserved fields
@@ -652,7 +652,7 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 	u64 bytes_read = 0;
 	struct btrfs_key key;
 	int blocks;
-	u32 sectorsize = root->sectorsize;
+	u32 sectorsize = root->fs_info->sectorsize;
 	u64 first_block = 0;
 	u64 file_pos = 0;
 	u64 cur_bytes;
-- 
2.13.0



