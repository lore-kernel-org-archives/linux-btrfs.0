Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40969 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaAIMnS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 07:43:18 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex@bpmit.com
Subject: [PATCH] Btrfs-progs: fix to make list specified directory's subvolumes work
Date: Thu, 9 Jan 2014 20:42:12 +0800
Message-Id: <1389271332-12897-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sda8
 # mount /dev/sda8 /mnt
 # mkdir /mnt/subvolumes
 # btrfs sub create /mnt/subvolumes/subv1
 # btrfs sub create /mnt/subvolumes/subv1/subv1.1
 # btrfs sub list -o /mnt/subvolumes/subv1   <----we did not list anything

The problem is that we don't set @top_id right, fix it.

Reported-by: Alex <alex@bpmit.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-list.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index fa69910..9effb27 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -578,23 +578,18 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 			full_path = strdup(found->path);
 			len = add_len;
 		}
+		if (!ri->top_id)
+			ri->top_id = found->ref_tree;
 
 		next = found->ref_tree;
-
-		if (next == top_id) {
-			ri->top_id = top_id;
+		if (next == top_id)
 			break;
-		}
-
 		/*
 		* if the ref_tree = BTRFS_FS_TREE_OBJECTID,
 		* we are at the top
 		*/
-		if (next == BTRFS_FS_TREE_OBJECTID) {
-			ri->top_id = next;
+		if (next == BTRFS_FS_TREE_OBJECTID)
 			break;
-		}
-
 		/*
 		* if the ref_tree wasn't in our tree of roots, the
 		* subvolume was deleted.
-- 
1.8.3.1

