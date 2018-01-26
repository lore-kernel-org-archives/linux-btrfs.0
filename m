Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752436AbeAZIa6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:58 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 9959549F19B1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:51 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 12/15] btrfs-progs: check: increase counter error in check_inode_recs()
Date: Fri, 26 Jan 2018 16:35:16 +0800
Message-ID: <20180126083519.28373-13-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Counter @error decides return values of check_inode_recs().

Previously, @error won't be incremented even repair_inode_recs() failed.
It causes 'btrfs check --repair' prints some error information but
returns 0.

So, if root dir is missing and repair is disabled, @error should be
incremented.
And after repair_inode_recs(), increase @error if any errors in inodes
and backrefs.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index b23a4493b12b..a83f0a92f48b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4137,6 +4137,7 @@ static int check_inode_recs(struct btrfs_root *root,
 			return -EAGAIN;
 		}
 
+		error++;
 		fprintf(stderr, "root %llu root dir %llu not found\n",
 			(unsigned long long)root->root_key.objectid,
 			(unsigned long long)root_dirid);
@@ -4176,10 +4177,9 @@ static int check_inode_recs(struct btrfs_root *root,
 				free_inode_rec(rec);
 				continue;
 			}
-			ret = 0;
 		}
 
-		if (!(repair && ret == 0))
+		if (rec->errors)
 			error++;
 		print_inode_error(root, rec);
 		list_for_each_entry(backref, &rec->backrefs, list) {
@@ -4189,6 +4189,8 @@ static int check_inode_recs(struct btrfs_root *root,
 				backref->errors |= REF_ERR_NO_DIR_INDEX;
 			if (!backref->found_inode_ref)
 				backref->errors |= REF_ERR_NO_INODE_REF;
+			if (backref->errors)
+				error++;
 			fprintf(stderr, "\tunresolved ref dir %llu index %llu"
 				" namelen %u name %s filetype %d errors %x",
 				(unsigned long long)backref->dir,
-- 
2.16.1



