Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49456 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933987AbeBMJte (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:49:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D9l5aS013703
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:34 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2g3wh2832k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:34 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nX48022859
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:33 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nX7M009922
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:33 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix bare unsigned declarations
Date: Tue, 13 Feb 2018 17:50:48 +0800
Message-Id: <20180213095048.9550-7-anand.jain@oracle.com>
In-Reply-To: <20180213095048.9550-1-anand.jain@oracle.com>
References: <20180213095048.9550-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel style prefers "unsigned int <foo>" over "unsigned <foo>"
and "signed int <foo>" over "signed <foo>".

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80d1d4d12f9d..c6de1a5281ca 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -993,8 +993,8 @@ struct btrfs_fs_info {
 	struct btrfs_balance_control *balance_ctl;
 	wait_queue_head_t balance_wait_q;
 
-	unsigned data_chunk_allocations;
-	unsigned metadata_ratio;
+	u32 data_chunk_allocations;
+	u32 metadata_ratio;
 
 	void *bdev_holder;
 
-- 
2.7.0

