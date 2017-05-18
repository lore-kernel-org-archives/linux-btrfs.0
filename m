Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932197AbdERDjZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:25 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 24/32] btrfs-progs: Refactor sectorsize users in free-space-tree.c
Date: Thu, 18 May 2017 11:38:49 +0800
Message-ID: <20170518033857.15002-25-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 free-space-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/free-space-tree.c b/free-space-tree.c
index f3a51263..69a4eca8 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -205,7 +205,7 @@ static int load_free_space_bitmaps(struct btrfs_fs_info *fs_info,
 		offset = key.objectid;
 		while (offset < key.objectid + key.offset) {
 			bit = free_space_test_bit(block_group, path, offset,
-						  root->sectorsize);
+						  fs_info->sectorsize);
 			if (prev_bit == 0 && bit == 1) {
 				extent_start = offset;
 			} else if (prev_bit == 1 && bit == 0) {
@@ -213,7 +213,7 @@ static int load_free_space_bitmaps(struct btrfs_fs_info *fs_info,
 				extent_count++;
 			}
 			prev_bit = bit;
-			offset += root->sectorsize;
+			offset += fs_info->sectorsize;
 		}
 	}
 
-- 
2.13.0



