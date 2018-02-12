Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752616AbeBLPUN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:20:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFHOSP029705
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:20:12 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2g3d6cr7yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:20:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFKB7t022629
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:20:11 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFKAkW008704
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:20:11 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: print-tree: fix INODE_ITEM sequence and flags
Date: Mon, 12 Feb 2018 23:21:26 +0800
Message-Id: <20180212152126.17984-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dump-tree prints wrong sequence number and the flags numbers,
as we misplaced the printf args. This patch fixes it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 print-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index d3fa862139ef..cdc39c971ec9 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -919,8 +919,8 @@ static void print_inode_item(struct extent_buffer *eb,
 	       btrfs_inode_uid(eb, ii),
 	       btrfs_inode_gid(eb, ii),
 	       (unsigned long long)btrfs_inode_rdev(eb,ii),
-	       (unsigned long long)btrfs_inode_flags(eb,ii),
 	       (unsigned long long)btrfs_inode_sequence(eb, ii),
+	       (unsigned long long)btrfs_inode_flags(eb,ii),
 	       flags_str);
 	print_timespec(eb, btrfs_inode_atime(ii), "\t\tatime ", "\n");
 	print_timespec(eb, btrfs_inode_ctime(ii), "\t\tctime ", "\n");
-- 
2.15.0

