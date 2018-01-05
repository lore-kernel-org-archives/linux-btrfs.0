Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35592 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752921AbeAEUyL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 15:54:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w05KqjDZ024671
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:10 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2fagex02ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 20:54:10 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w05Ks8rw004946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:09 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w05Ks8XZ027703
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:08 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 01/10] Btrfs: fix incorrect block_len in merge_extent_mapping
Date: Fri,  5 Jan 2018 12:51:08 -0700
Message-Id: <20180105195117.5131-2-bo.li.liu@oracle.com>
In-Reply-To: <20180105195117.5131-1-bo.li.liu@oracle.com>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

%block_len could be checked on deciding if two em are mergeable.

merge_extent_mapping() has only added the front pad if the front part
of em gets truncated, but it's possible that the end part gets
truncated.

For both compressed extent and inline extent, em->block_len is not
adjusted accordingly, and for regular extent, em->block_len always
equals to em->len, hence this sets em->block_len with em->len.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e1a7f3c..2784bb3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6860,7 +6860,7 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
 	if (em->block_start < EXTENT_MAP_LAST_BYTE &&
 	    !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
 		em->block_start += start_diff;
-		em->block_len -= start_diff;
+		em->block_len = em->len;
 	}
 	return add_extent_mapping(em_tree, em, 0);
 }
-- 
2.9.4

