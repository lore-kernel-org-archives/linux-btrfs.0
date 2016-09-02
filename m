Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55816 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753307AbcIBTZy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 15:25:54 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82JMG8Z007996
        for <linux-btrfs@vger.kernel.org>; Fri, 2 Sep 2016 12:25:53 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0b-00082601.pphosted.com with ESMTP id 256qdu92bt-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:25:53 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: don't leak reloc root nodes on error
Date: Fri, 2 Sep 2016 15:25:43 -0400
Message-ID: <1472844343-19086-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't track the reloc roots in any sort of normal way, so the only way the
root/commit_root nodes get free'd is if the relocation finishes successfully and
the reloc root is deleted.  Fix this by free'ing them in free_reloc_roots.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/relocation.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 7fc6ea7..62dfc2c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2349,6 +2349,10 @@ void free_reloc_roots(struct list_head *list)
 	while (!list_empty(list)) {
 		reloc_root = list_entry(list->next, struct btrfs_root,
 					root_list);
+		free_extent_buffer(reloc_root->node);
+		free_extent_buffer(reloc_root->commit_root);
+		reloc_root->node = NULL;
+		reloc_root->commit_root = NULL;
 		__del_reloc_root(reloc_root);
 	}
 }
-- 
2.7.4

