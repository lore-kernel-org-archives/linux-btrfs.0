Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11089 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754719AbbCBRvZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 12:51:25 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t22HnKni020744
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Mar 2015 09:51:24 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1svuenr9ur-17
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 02 Mar 2015 09:51:24 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove extra run_delayed_refs in update_cowonly_root
Date: Mon, 2 Mar 2015 12:51:02 -0500
Message-ID: <1425318662-1334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This got added with my dirty_bgs patch, it's not needed.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/transaction.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a7a413f..3d017d6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1058,9 +1058,6 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 		if (ret)
 			return ret;
-		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-		if (ret)
-			return ret;
 	}
 
 	return 0;
-- 
1.8.3.1

