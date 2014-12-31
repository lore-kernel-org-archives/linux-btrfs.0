Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26879 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbaLaSab (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 13:30:31 -0500
Date: Wed, 31 Dec 2014 13:30:13 -0500
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: Roman Mamedov <rm@romanrm.net>, Marc MERLIN <marc@merlins.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't delay inode ref updates during log replay
Message-ID: <20141231183013.GA3637@ret.masoncoding.com>
References: <20141228192614.GO17254@merlins.org>
 <20141229010047.7f9b6d43@natsu>
 <54A1FAB2.2050805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <54A1FAB2.2050805@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 1d52c78afbb (Btrfs: try not to ENOSPC on log replay) added a
check to skip delayed inode updates during log replay because it
confuses the enospc code.  But the delayed processing will end up
skipping delayed refs from log replay because the inode itself wasn't
put through the delayed code.

This can end up triggering a warning at commit time:

WARNING: CPU: 2 PID: 778 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empty+0x32/0x34()

Which is repeated for each commit because we never process the delayed ref.

The fix used here is to change btrfs_delayed_delete_inode_ref to return
an error if we're current in log replay.  The caller will do the ref
deletion immediately and everything will work properly.

This bug can cause lost files, whick fsck will find.  --repair on
btrfs-progs 3.18 will fix them

Signed-off-by: Chris Mason <clm@fb.com>
cc: stable@vger.kernel.org # v3.18 and any stable series that picked 1d52c78afbbf80b58299e076a159617d6b42fe3c

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 054577b..de4e70f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1857,6 +1857,14 @@ int btrfs_delayed_delete_inode_ref(struct inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
 
+	/*
+	 * we don't do delayed inode updates during log recovery because it
+	 * leads to enospc problems.  This means we also can't do
+	 * delayed inode refs
+	 */
+	if (BTRFS_I(inode)->root->fs_info->log_root_recovering)
+		return -EAGAIN;
+
 	delayed_node = btrfs_get_or_create_delayed_node(inode);
 	if (IS_ERR(delayed_node))
 		return PTR_ERR(delayed_node);
