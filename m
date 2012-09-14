Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42078 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab2INJAE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 05:00:04 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8E9029W000910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 09:00:03 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8E902es028820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 09:00:02 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8E901gE025525
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 04:00:01 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Btrfs: cleanup fs_info->hashers
Date: Fri, 14 Sep 2012 16:58:06 +0800
Message-Id: <1347613087-3489-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info->hashers is now an obsolete one.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h   |    1 -
 fs/btrfs/disk-io.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d195b5..ab7cd13 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1240,7 +1240,6 @@ struct btrfs_fs_info {
 	struct mutex reloc_mutex;
 
 	struct list_head trans_list;
-	struct list_head hashers;
 	struct list_head dead_roots;
 	struct list_head caching_block_groups;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 22e98e0..fe39362 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1994,7 +1994,6 @@ int open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
 	INIT_LIST_HEAD(&fs_info->delayed_iputs);
-	INIT_LIST_HEAD(&fs_info->hashers);
 	INIT_LIST_HEAD(&fs_info->delalloc_inodes);
 	INIT_LIST_HEAD(&fs_info->ordered_operations);
 	INIT_LIST_HEAD(&fs_info->caching_block_groups);
-- 
1.7.7.6

