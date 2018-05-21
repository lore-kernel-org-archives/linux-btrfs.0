Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48568 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbeEUGfY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 02:35:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4L6VUsY007251
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:24 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2j2bw82vj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:24 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4L6ZNG3017384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:23 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4L6ZNSN029102
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/3] btrfs: balance: add kernel log for end or paused
Date: Mon, 21 May 2018 14:37:45 +0800
Message-Id: <20180521063745.29343-4-anand.jain@oracle.com>
In-Reply-To: <20180521063745.29343-1-anand.jain@oracle.com>
References: <20180521063745.29343-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a kernel log when the balance ends, either for cancel or completed
or if it is paused.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: nothing.
v1->v2: Moved from 2/3 to 3/3

 fs/btrfs/volumes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d2e6b81f7874..baf42650ead6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4061,6 +4061,13 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	ret = __btrfs_balance(fs_info);
 
 	mutex_lock(&fs_info->balance_mutex);
+	if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req))
+		btrfs_info(fs_info, "balance: paused");
+	else if (ret == -ECANCELED && atomic_read(&fs_info->balance_cancel_req))
+		btrfs_info(fs_info, "balance: canceled");
+	else
+		btrfs_info(fs_info, "balance: ended with status: %d", ret);
+
 	clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
 
 	if (bargs) {
-- 
2.7.0

