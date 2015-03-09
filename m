Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19987 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbCIRK3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:10:29 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 02/26] Btrfs: sysfs: fix, fs_info kobject_unregister has init_completion() twice
Date: Tue, 10 Mar 2015 06:38:20 +0800
Message-Id: <1425940724-7744-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

kobject_unregister is to handle the release of the kobject,
its completion init is being called in btrfs_sysfs_add_one(),
so we don't have to do the same in the open_ctree() again.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8c63419..0cd6550 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2238,7 +2238,6 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->delalloc_root_mutex);
 	seqlock_init(&fs_info->profiles_lock);
 
-	init_completion(&fs_info->kobj_unregister);
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
 	INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
-- 
2.0.0.153.g79dcccc

