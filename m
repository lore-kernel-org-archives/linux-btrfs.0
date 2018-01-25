Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47066 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbeAYTIq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 14:08:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0PJ7PwD060984
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2fqkb3ghev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8i1b015789
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:44 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8iCH007069
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix deadlock in run_delalloc_nocow
Date: Thu, 25 Jan 2018 11:02:50 -0700
Message-Id: <20180125180256.10844-3-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@cur_offset is not set back to what it should be (@cow_start) if
btrfs_next_leaf() returns something wrong, and the range [cow_start,
cur_offset) remains locked forever.

cc: <stable@vger.kernel.org>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ac1a1ac..281a250 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1332,8 +1332,11 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		leaf = path->nodes[0];
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root, path);
-			if (ret < 0)
+			if (ret < 0) {
+				if (cow_start != (u64)-1)
+					cur_offset = cow_start;
 				goto error;
+			}
 			if (ret > 0)
 				break;
 			leaf = path->nodes[0];
-- 
2.9.4

