Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51686 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbbJEPFg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 11:05:36 -0400
Received: from pps.filterd (m0001255 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t95F4pIH019254
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:05:35 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1xbtqs06h6-6
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 08:05:35 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: fix qgroup sanity tests
Date: Mon, 5 Oct 2015 11:03:08 -0400
Message-ID: <1444057388-10949-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With my changes to allow us to find old roots when resolving indirect refs I
introduced a regression to the sanity tests.  Since we don't really care to go
down into the fs roots we just need to have the old behavior of returning ENOENT
for dummy roots for the sanity tests.  In the future if we want to get fancy we
can populate the test fs trees with the references as well.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/backref.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 5de66e9..905d697 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -339,6 +339,13 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state))) {
+		srcu_read_unlock(&fs_info->subvol_srcu, index);
+		ret = -ENOENT;
+		goto out;
+	}
+#endif
 	if (path->search_commit_root)
 		root_level = btrfs_header_level(root->commit_root);
 	else if (time_seq == (u64)-1)
-- 
1.8.3.1

