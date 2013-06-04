Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36811 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3FDU6n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 16:58:43 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 75E087C0428
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Jun 2013 14:58:42 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id Vkx8GaQsanr5qxoB (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 04 Jun 2013 14:58:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix incorrect root backref errors in fsck
Date: Tue, 4 Jun 2013 16:58:39 -0400
Message-ID: <1370379519-9334-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported that fsck was complaining about unresolved refs for some
snapshots.  You can reproduce this by doing

mkfs.btrfs /dev/sdb
mount /dev/sdb /mnt
btrfs subvol snap /mnt/ /mnt/a
btrfs subvol snap /mnt/ /mnt/b
btrfs subvol del /mnt/a
umount /mnt
btrfsck /dev/sdb

and you'd get this

unresolved ref root 258 dir 256 index 2 namelen 1 name a error 600

because snapshot b has a dir item that points to a.  Except we encode in our
root ref the dirid of the ref holder, and if it doesn't match we just give it
back a empty directory since we can't hardlink directories.  This makes the
check in btrfsck bogus, when we delete a we remove the ref key for it so any
lookups into /mnt/b/a will just give a blank directory as it's supposed to.  Fix
this by only saying the backref is reachable if there is both a DIR_ITEM and a
REF_KEY for the given root.  With this patch I no longer see errors when running
this reproducer.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index bbef89a..4083298 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1507,14 +1507,16 @@ static int add_root_backref(struct cache_tree *root_cache,
 	}
 
 	if (item_type == BTRFS_DIR_ITEM_KEY) {
+		if (backref->found_forward_ref)
+			rec->found_ref++;
 		backref->found_dir_item = 1;
-		backref->reachable = 1;
-		rec->found_ref++;
 	} else if (item_type == BTRFS_DIR_INDEX_KEY) {
 		backref->found_dir_index = 1;
 	} else if (item_type == BTRFS_ROOT_REF_KEY) {
 		if (backref->found_forward_ref)
 			backref->errors |= REF_ERR_DUP_ROOT_REF;
+		else if (backref->found_dir_item)
+			rec->found_ref++;
 		backref->found_forward_ref = 1;
 	} else if (item_type == BTRFS_ROOT_BACKREF_KEY) {
 		if (backref->found_back_ref)
@@ -1524,6 +1526,8 @@ static int add_root_backref(struct cache_tree *root_cache,
 		BUG_ON(1);
 	}
 
+	if (backref->found_forward_ref && backref->found_dir_item)
+		backref->reachable = 1;
 	return 0;
 }
 
-- 
1.7.7.6

