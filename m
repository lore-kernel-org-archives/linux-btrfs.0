Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932122AbdERDjO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:14 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 17/32] btrfs-progs: Refactor nodesize users in qgroup-verify.c
Date: Thu, 18 May 2017 11:38:42 +0800
Message-ID: <20170518033857.15002-18-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 qgroup-verify.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index 23d34699..2f4b1c66 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -736,7 +736,7 @@ static int travel_tree(struct btrfs_fs_info *info, struct btrfs_root *root,
 	nr = btrfs_header_nritems(eb);
 	for (i = 0; i < nr; i++) {
 		new_bytenr = btrfs_node_blockptr(eb, i);
-		new_num_bytes = root->nodesize;
+		new_num_bytes = info->nodesize;
 
 		ret = travel_tree(info, root, new_bytenr, new_num_bytes,
 				  ref_parent);
@@ -1185,7 +1185,7 @@ static int scan_extents(struct btrfs_fs_info *info,
 				bytenr = key.objectid;
 				num_bytes = key.offset;
 				if (key.type == BTRFS_METADATA_ITEM_KEY) {
-					num_bytes = info->extent_root->nodesize;
+					num_bytes = info->nodesize;
 					meta = 1;
 				}
 
-- 
2.13.0



