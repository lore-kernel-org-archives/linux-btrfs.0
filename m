Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51283 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbbBAIDA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 03:03:00 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 02/12] Btrfs: sysfs: fix, fs_info kobject_unregister has init_completion() twice
Date: Sun,  1 Feb 2015 16:01:32 +0800
Message-Id: <1422777702-12584-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
 <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kobject_unregister is to handle the release of the kobject,
its completion init is being called in btrfs_sysfs_add_one(),
so we don't have to do the same in the open_ctree() again.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 612d46e..2e076b2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2247,7 +2247,6 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->delalloc_root_mutex);
 	seqlock_init(&fs_info->profiles_lock);
 
-	init_completion(&fs_info->kobj_unregister);
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
 	INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
-- 
1.9.1

