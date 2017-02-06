Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11354 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751093AbdBFFrs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 00:47:48 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH v2 06/12] btrfs-progs: lowmem check: Fix silent error if first inode item missing
Date: Mon, 6 Feb 2017 13:47:29 +0800
Message-ID: <20170206054735.5227-7-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
References: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If first inode item is missing, lowmem check will detect it but not
output any error message.

Add error message for it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index cf5a08ce..7d273623 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5001,6 +5001,8 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 	if (ret > 0) {
 		ret = 0;
 		err |= INODE_ITEM_MISSING;
+		error("first inode item of root %llu is missing",
+		      root->objectid);
 	}
 
 	err |= check_inode_item(root, &path, ext_ref);
-- 
2.11.0



