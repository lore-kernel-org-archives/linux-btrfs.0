Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36062 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032907AbeBNRLi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 12:11:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1EH9YXn050960
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 17:11:38 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2g4pxg8wnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 17:11:37 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1EHBahS023809
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 17:11:37 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1EHBaNs000941
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 17:11:36 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix bare unsigned declarations
Date: Thu, 15 Feb 2018 01:13:00 +0800
Message-Id: <20180214171300.5809-1-anand.jain@oracle.com>
In-Reply-To: <20180213165849.GZ3003@twin.jikos.cz>
References: <20180213165849.GZ3003@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have btrfs_fs_info::data_chunk_allocations and
btrfs_fs_info::metadata_ratio declared as unsigned which would
be unsinged int and kernel style prefers unsigned int over bare
unsigned. So this patch changes them to u32.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Update change log.

 fs/btrfs/ctree.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8620eea57d6a..32d7b55061d3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -994,8 +994,8 @@ struct btrfs_fs_info {
 	struct btrfs_balance_control *balance_ctl;
 	wait_queue_head_t balance_wait_q;
 
-	unsigned data_chunk_allocations;
-	unsigned metadata_ratio;
+	u32 data_chunk_allocations;
+	u32 metadata_ratio;
 
 	void *bdev_holder;
 
-- 
2.15.0

