Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934807AbeBMJte (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:49:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D9l5iZ013345
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:33 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2g3wh2832e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:33 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nW88011836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:32 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nVVs008243
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add a comment to mark the deprecated mount option
Date: Tue, 13 Feb 2018 17:50:47 +0800
Message-Id: <20180213095048.9550-6-anand.jain@oracle.com>
In-Reply-To: <20180213095048.9550-1-anand.jain@oracle.com>
References: <20180213095048.9550-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-o alloc_start and -o subvolrootid are deprecated mount options,
comment them in the tokens list. And leave them as it is. No
functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a299a0ded3a..7771e690460c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -345,7 +345,7 @@ static const match_table_t tokens = {
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_barrier, "barrier"},
 	{Opt_max_inline, "max_inline=%u"},
-	{Opt_alloc_start, "alloc_start=%s"},
+	{Opt_alloc_start, "alloc_start=%s"}, /* deprecated */
 	{Opt_thread_pool, "thread_pool=%u"},
 	{Opt_compress, "compress"},
 	{Opt_compress_type, "compress=%s"},
@@ -371,7 +371,7 @@ static const match_table_t tokens = {
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
 	{Opt_enospc_debug, "enospc_debug"},
 	{Opt_noenospc_debug, "noenospc_debug"},
-	{Opt_subvolrootid, "subvolrootid=%d"},
+	{Opt_subvolrootid, "subvolrootid=%d"}, /* deprecated */
 	{Opt_defrag, "autodefrag"},
 	{Opt_nodefrag, "noautodefrag"},
 	{Opt_inode_cache, "inode_cache"},
-- 
2.7.0

