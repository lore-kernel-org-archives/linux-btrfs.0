Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37692 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3CZTXf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 15:23:35 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 305B49A0370
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 13:23:35 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id iCsxZ2ifzuFxSJIM (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 13:23:34 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: hold the ordered operations mutex when waiting on ordered extents
Date: Tue, 26 Mar 2013 15:30:59 -0400
Message-ID: <1364326259-8199-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to hold the ordered_operations mutex while waiting on ordered extents
since we splice and run the ordered extents list.  We need to make sure anybody
else who wants to wait on ordered extents does actually wait for them to be
completed.  This will keep us from bailing out of flushing in case somebody is
already waiting on ordered extents to complete.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ordered-data.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index dc08d77..005c45d 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -557,6 +557,7 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 	INIT_LIST_HEAD(&splice);
 	INIT_LIST_HEAD(&works);
 
+	mutex_lock(&root->fs_info->ordered_operations_mutex);
 	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_splice_init(&root->fs_info->ordered_extents, &splice);
 	while (!list_empty(&splice)) {
@@ -600,6 +601,7 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 
 		cond_resched();
 	}
+	mutex_unlock(&root->fs_info->ordered_operations_mutex);
 }
 
 /*
-- 
1.7.7.6

