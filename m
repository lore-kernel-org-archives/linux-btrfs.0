Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55158 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbeAEJXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 04:23:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w059MBjl044556
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 09:23:32 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2fa5m38897-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 09:23:32 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w059NVYO014607
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 09:23:31 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w059NVSB031053
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 09:23:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add missing BTRFS_SUPER_FLAG define
Date: Fri,  5 Jan 2018 17:24:22 +0800
Message-Id: <20180105092422.9794-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs uses additional two super flag bits. So just define
that so that we know its been used.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
The btrfs-progs commits (very old) introduced them,

 commit 7cc792872a133cabc3467e6ccaf5a2c8ea9e5218
    btrfs-progs: Add CHANGING_FSID super flag

 commit 797a937e5dd8db0092add633a80f3cd698e182df
    Btrfs-progs: Introduce metadump_v2

Appears that we need bit of support from the kernel side like
failing to mount if CHANGING_FSID is set. And device mounted
with metadump_v2 flag is kind of broken on the kernel side
as of now, this patch does not fix those.

 include/uapi/linux/btrfs_tree.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 6d6e5da51527..aff1356c2bb8 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -456,6 +456,8 @@ struct btrfs_free_space_header {
 
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
+#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
+#define BTRFS_SUPER_FLAG_CHANGING_FSID	(1ULL << 35)
 
 
 /*
-- 
2.15.0

