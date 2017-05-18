Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932160AbdERDjV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 13/32] btrfs-progs: Refactor nodesize user in btrfstune.c
Date: Thu, 18 May 2017 11:38:38 +0800
Message-ID: <20170518033857.15002-14-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfstune.c b/btrfstune.c
index 257bac44..0a6ad9ca 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -149,7 +149,7 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
 			goto next;
 
 		bytenr = key.objectid;
-		eb = read_tree_block(root, bytenr, root->nodesize, 0);
+		eb = read_tree_block(root, bytenr, root->fs_info->nodesize, 0);
 		if (IS_ERR(eb)) {
 			error("failed to read tree block: %llu", bytenr);
 			ret = PTR_ERR(eb);
-- 
2.13.0



