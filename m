Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42036 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752443AbeEPCtH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 22:49:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G2kj6t107974
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:06 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2hx29wathw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:06 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4G2n611006661
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:06 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4G2n64S003614
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:06 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: balance: add kernel log for end or paused
Date: Wed, 16 May 2018 10:51:28 +0800
Message-Id: <20180516025128.9899-4-anand.jain@oracle.com>
In-Reply-To: <20180516025128.9899-1-anand.jain@oracle.com>
References: <20180516025128.9899-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a kernel log when the balance ends, either for cancel or completed
or if it is paused.
---
v1->v2: Moved from 2/3 to 3/3

 fs/btrfs/volumes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ce68c4f42f94..a4e243a29f5c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4053,6 +4053,13 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
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

