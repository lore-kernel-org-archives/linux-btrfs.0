Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23546 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782AbbIWS6M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 14:58:12 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t8NIH5Ih028052
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 11:58:11 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1x417p06wv-7
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 11:58:11 -0700
From: Josef Bacik <jbacik@fb.com>
To: <kernel-team@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: end transaction if we abort when creating qgroup root
Date: Wed, 23 Sep 2015 14:56:43 -0400
Message-ID: <1443034603-5542-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We still need to call btrfs_end_transaction if we call btrfs_abort_transaction,
otherwise we hang and make me super grumpy.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fbe7c10..18b5e13 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4028,6 +4028,7 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	if (IS_ERR(uuid_root)) {
 		ret = PTR_ERR(uuid_root);
 		btrfs_abort_transaction(trans, tree_root, ret);
+		btrfs_end_transaction(trans, root);
 		return ret;
 	}
 
-- 
1.8.3.1

