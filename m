Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46643 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbaBGS6E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 13:58:04 -0500
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s17Im4BP022093
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Feb 2014 10:58:03 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1hw3m4rbfv-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 10:58:03 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't loop forever if we can't run because of the tree mod log
Date: Fri, 7 Feb 2014 13:57:59 -0500
Message-ID: <1391799479-14886-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a 100% cpu hang with my new delayed ref code.  Turns out I
forgot to increase the count check when we can't run a delayed ref because of
the tree mod log.  If we can't run any delayed refs during this there is no
point in continuing to look, and we need to break out.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9c9ecc9..32312e0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2385,6 +2385,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			spin_unlock(&delayed_refs->lock);
 			locked_ref = NULL;
 			cond_resched();
+			count++;
 			continue;
 		}
 
-- 
1.8.3.1

