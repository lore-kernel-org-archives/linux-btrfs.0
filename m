Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23191 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756222AbcE0RBd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 13:01:33 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4RGwlbk031057
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 10:01:32 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 2369pg4yex-2
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 10:01:32 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: always use trans->block_rsv for orphans
Date: Fri, 27 May 2016 13:01:08 -0400
Message-ID: <1464368468-3256-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the case all the time anyway except for relocation which could be doing
a reloc root for a non ref counted root, in which case we'd end up with some
random block rsv rather than the one we have our reservation in.  If there isn't
enough space in the block rsv we are trying to steal from we'll BUG() because we
expect there to be space for the orphan to make its reservation.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 43bc9f5..528b9a8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5679,7 +5679,13 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 				  struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_block_rsv *src_rsv = get_block_rsv(trans, root);
+	/*
+	 * We always use trans->block_rsv here as we will have reserved space
+	 * for our orphan when starting the transaction, using get_block_rsv()
+	 * here will sometimes make us choose the wrong block rsv as we could be
+	 * doing a reloc inode for a non refcounted root.
+	 */
+	struct btrfs_block_rsv *src_rsv = trans->block_rsv;
 	struct btrfs_block_rsv *dst_rsv = root->orphan_block_rsv;
 
 	/*
-- 
1.8.3.1

