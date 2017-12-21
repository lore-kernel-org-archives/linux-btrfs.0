Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755184AbdLUXpl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 18:45:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBLNg61J083252
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2f0prs01b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjea9010769
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjeCQ008955
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/10] Btrfs: fix incorrect block_len in merge_extent_mapping
Date: Thu, 21 Dec 2017 15:42:52 -0700
Message-Id: <20171221224256.18196-7-bo.li.liu@oracle.com>
In-Reply-To: <20171221224256.18196-1-bo.li.liu@oracle.com>
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

%block_len could be checked on deciding if two em are mergable.

merge_extent_mapping() has only added the front pad if the front part
of em gets truncated, but it's possible that the end part gets
truncated.

For both compressed extent and inline extent, em->block_len is not
adjusted accordingly, while for regular extent, em->block_len always
equals to em->len, hence this sets em->block_len with em->len.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 51665de..6653b08 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -511,7 +511,7 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
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

