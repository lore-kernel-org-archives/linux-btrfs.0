Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24656 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbaJaSCQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:02:16 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/11] Btrfs-progs: create missing root dirid
Date: Fri, 31 Oct 2014 14:01:28 -0400
Message-ID: <1414778489-4049-11-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we just don't have the root dirid stuff go ahead and re-create it, since it
is easily recreated.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index a30db8d..5fbf08f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1987,6 +1987,26 @@ static int check_inode_recs(struct btrfs_root *root,
 			error++;
 		}
 	} else {
+		if (repair) {
+			struct btrfs_trans_handle *trans;
+
+			trans = btrfs_start_transaction(root, 1);
+			if (IS_ERR(trans)) {
+				err = PTR_ERR(trans);
+				return err;
+			}
+
+			fprintf(stderr, "root %llu missing its root dir, "
+				"recreating\n",
+				(unsigned long long)root->objectid);
+
+			ret = btrfs_make_root_dir(trans, root, root_dirid);
+			BUG_ON(ret);
+
+			btrfs_commit_transaction(trans, root);
+			return -EAGAIN;
+		}
+
 		fprintf(stderr, "root %llu root dir %llu not found\n",
 			(unsigned long long)root->root_key.objectid,
 			(unsigned long long)root_dirid);
-- 
1.8.3.1

