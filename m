Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59414 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752445AbeAZIa4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:56 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 09DEA49F19B0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:51 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 11/15] btrfs-progs: check: modify indoe_rec and backref after repair
Date: Fri, 26 Jan 2018 16:35:15 +0800
Message-ID: <20180126083519.28373-12-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

repair_inode_backrefs() forgets to modify backrefs and inode records
after repair them.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index d8d9a3227c06..b23a4493b12b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3192,6 +3192,7 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 				ret = create_inode_item(root, rec, 1);
 				if (ret)
 					break;
+				rec->found_inode_item = 1;
 				repaired++;
 			}
 		}
@@ -3268,6 +3269,8 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 						    backref->index);
 			BUG_ON(ret);
 			btrfs_commit_transaction(trans, root);
+			backref->found_dir_index = 1;
+			backref->found_dir_item = 1;
 			repaired++;
 		}
 
@@ -3279,6 +3282,7 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 			ret = create_inode_item(root, rec, 0);
 			if (ret)
 				break;
+			rec->found_inode_item = 1;
 			repaired++;
 		}
 
-- 
2.16.1



