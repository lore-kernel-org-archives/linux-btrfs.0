Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57173 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbaJJU5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:44 -0400
Received: from pps.filterd (m0044008 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKuGjv009731
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:44 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1pxnkg85gx-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:43 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/12] Btrfs-progs: deal with mismatch index between dir index and inode ref
Date: Fri, 10 Oct 2014 16:57:15 -0400
Message-ID: <1412974637-31334-11-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes we have a dir index and an inode ref that don't agree on the index.
In this case just assume that the inode ref is the ultimate authority on the
subject and delete the dir index.  This means we have to not reset index if we
find a mismatched inode ref to make sure we delete the right dir index.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ca890cc..80fa244 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -608,9 +608,10 @@ static int add_inode_backref(struct cache_tree *inode_cache,
 			backref->errors |= REF_ERR_DUP_INODE_REF;
 		if (backref->found_dir_index && backref->index != index)
 			backref->errors |= REF_ERR_INDEX_UNMATCH;
+		else
+			backref->index = index;
 
 		backref->ref_type = itemtype;
-		backref->index = index;
 		backref->found_inode_ref = 1;
 	} else {
 		BUG_ON(1);
@@ -1654,8 +1655,10 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 		if (rec->ino == root_dirid && backref->index == 0)
 			continue;
 
-		if (delete && backref->found_dir_index &&
-		    !backref->found_inode_ref) {
+		if (delete &&
+		    ((backref->found_dir_index && !backref->found_inode_ref) ||
+		     (backref->found_dir_index && backref->found_inode_ref &&
+		      backref->errors & REF_ERR_INDEX_UNMATCH))) {
 			ret = delete_dir_index(root, inode_cache, rec, backref);
 			if (ret)
 				break;
-- 
1.8.3.1

