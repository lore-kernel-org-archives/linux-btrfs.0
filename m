Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-grille.xs4.mendix.net ([82.94.188.30]:37219 "EHLO
        smtp-grille.xs4.mendix.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753825AbdKXUd3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 15:33:29 -0500
Received: from dorothy.pg10b.knorrie.org (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-grille.xs4.mendix.net (Postfix) with ESMTPSA id DDEC1746
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 21:26:08 +0100 (CET)
Received: from dorothy.pg10b.knorrie.org (localhost [IPv6:::1])
        by dorothy.pg10b.knorrie.org (Postfix) with ESMTP id 7AF6F50BBEF
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 21:26:08 +0100 (CET)
From: Hans van Kranenburg <hans@knorrie.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: dump_tree: remove superfluous _TREE
Date: Fri, 24 Nov 2017 21:26:08 +0100
Message-Id: <20171124202608.11152-1-hans@knorrie.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-# btrfs inspect-internal dump-tree -t fs /dev/block/device
ERROR: unrecognized tree id: fs

Without this fix I can't dump-tree fs, but I can dump-tree fs_tree and
also fs_tree_tree, which is a bit silly.
---
 cmds-inspect-dump-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 4e72c08a..df44bb63 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -143,7 +143,7 @@ static u64 treeid_from_string(const char *str, const char **end)
 		{ "CHUNK", BTRFS_CHUNK_TREE_OBJECTID },
 		{ "DEVICE", BTRFS_DEV_TREE_OBJECTID },
 		{ "DEV", BTRFS_DEV_TREE_OBJECTID },
-		{ "FS_TREE", BTRFS_FS_TREE_OBJECTID },
+		{ "FS", BTRFS_FS_TREE_OBJECTID },
 		{ "CSUM", BTRFS_CSUM_TREE_OBJECTID },
 		{ "CHECKSUM", BTRFS_CSUM_TREE_OBJECTID },
 		{ "QUOTA", BTRFS_QUOTA_TREE_OBJECTID },
-- 
2.11.0

