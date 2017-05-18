Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932161AbdERDjY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 27/32] btrfs-progs: Refactor sectorsize users in convert/source-ext2.c
Date: Thu, 18 May 2017 11:38:52 +0800
Message-ID: <20170518033857.15002-28-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/source-ext2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index 1b0576b1..d12681b5 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -289,7 +289,7 @@ static int ext2_create_file_extents(struct btrfs_trans_handle *trans,
 	char *buffer = NULL;
 	errcode_t err;
 	u32 last_block;
-	u32 sectorsize = root->sectorsize;
+	u32 sectorsize = root->fs_info->sectorsize;
 	u64 inode_size = btrfs_stack_inode_size(btrfs_inode);
 	struct blk_iterate_data data;
 
-- 
2.13.0



