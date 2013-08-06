Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36997 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab3HFVHO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Aug 2013 17:07:14 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 113F87C06A0
	for <linux-btrfs@vger.kernel.org>; Tue,  6 Aug 2013 15:07:14 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id AMMZqUA6ssSMlPO2 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 06 Aug 2013 15:07:13 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check our parent dir when doing a compare send V2
Date: Tue, 6 Aug 2013 17:07:11 -0400
Message-ID: <1375823231-8806-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When doing a send with a parent subvol we will check to see if the file we are
acting on is being overwritten and move it if we think it may be needed further
down the line during the send.  We check this by checking its directory and
making sure it existed in the parent and making sure the file existed in the
parent.  The problem with this check is that if we create a directory and a file
in that directory, and then snapshot, and then remove and re-create that same
directory and file with different inode numbers and then try to snapshot and
send with the original parent we will try and save the original file inside of
that directory.  This is a problem because during the receive we move the
directory out of the way because it is a completely new inode, which makes us
unable to find the old file inside of the directory when we try to move that out
of the way for the overwrite.  We fix this by checking the parent directory of
the inode we think we are overwriting.  If the parent directory generation in
the send root != the parent directory generation in the parent root then we know
it is a completely new directory and we need not bother with moving the file out
of the way because it would have been completely destroyed.  This fixes bz
60673.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: remove the debugging stuff

 fs/btrfs/send.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d3f3b43..0efc2e2 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1668,6 +1668,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 			      u64 *who_ino, u64 *who_gen)
 {
 	int ret = 0;
+	u64 gen;
 	u64 other_inode = 0;
 	u8 other_type = 0;
 
@@ -1678,6 +1679,24 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	if (ret <= 0)
 		goto out;
 
+	/*
+	 * If we have a parent root we need to verify that the parent dir was
+	 * not delted and then re-created, if it was then we have no overwrite
+	 * and we can just unlink this entry.
+	 */
+	if (sctx->parent_root) {
+		ret = get_inode_info(sctx->parent_root, dir, NULL, &gen, NULL,
+				     NULL, NULL, NULL);
+		if (ret < 0 && ret != -ENOENT)
+			goto out;
+		if (ret) {
+			ret = 0;
+			goto out;
+		}
+		if (gen != dir_gen)
+			goto out;
+	}
+
 	ret = lookup_dir_item_inode(sctx->parent_root, dir, name, name_len,
 			&other_inode, &other_type);
 	if (ret < 0 && ret != -ENOENT)
-- 
1.7.7.6

