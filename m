Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30610 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756650AbaJaSCk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:02:40 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/11] Btrfs-progs: add ability to replace missing dir item/dir indexes
Date: Fri, 31 Oct 2014 14:01:26 -0400
Message-ID: <1414778489-4049-9-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have everything except the dir item and dir index we can easily replace
them, so add this ability to btrfsck.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 38f8d11..be75dcb 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1772,6 +1772,33 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 			}
 		}
 
+		if (!delete && (!backref->found_dir_index &&
+				!backref->found_dir_item &&
+				backref->found_inode_ref)) {
+			struct btrfs_trans_handle *trans;
+			struct btrfs_key location;
+
+			location.objectid = rec->ino;
+			location.type = BTRFS_INODE_ITEM_KEY;
+			location.offset = 0;
+
+			trans = btrfs_start_transaction(root, 1);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				break;
+			}
+			fprintf(stderr, "adding missing dir index/item pair "
+				"for inode %llu\n",
+				(unsigned long long)rec->ino);
+			ret = btrfs_insert_dir_item(trans, root, backref->name,
+						    backref->namelen,
+						    backref->dir, &location,
+						    imode_to_type(rec->imode),
+						    backref->index);
+			BUG_ON(ret);
+			btrfs_commit_transaction(trans, root);
+			repaired++;
+		}
 	}
 	return ret ? ret : repaired;
 }
-- 
1.8.3.1

