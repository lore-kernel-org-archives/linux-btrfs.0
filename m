Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62627 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754643AbaCNUhN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 16:37:13 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s2EKXfZX012534
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 13:37:12 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1jm46y18h2-4
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 13:37:12 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: abort the transaction when we don't find our extent ref
Date: Fri, 14 Mar 2014 16:36:53 -0400
Message-ID: <1394829413-1620-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure why we weren't aborting here in the first place, it is obviously a
bad time from the fact that we print the leaf and yell loudly about it.  Fix
this up, otherwise we panic because our path could be pointing into oblivion.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 696f0b6..0015b02 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5744,6 +5744,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
 			bytenr, parent, root_objectid, owner_objectid,
 			owner_offset);
+		btrfs_abort_transaction(trans, extent_root, ret);
+		goto out;
 	} else {
 		btrfs_abort_transaction(trans, extent_root, ret);
 		goto out;
-- 
1.8.3.1

