Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755275AbdLUXpm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 18:45:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBLNfprl082990
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2f0prs01b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNje36010775
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:41 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjeun008961
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/10] Btrfs: add WARN_ONCE to detect unexpected error from merge_extent_mapping
Date: Thu, 21 Dec 2017 15:42:54 -0700
Message-Id: <20171221224256.18196-9-bo.li.liu@oracle.com>
In-Reply-To: <20171221224256.18196-1-bo.li.liu@oracle.com>
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a subtle case, so in order to understand the problem, it'd be good to
know the content of existing and em when any error occurs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_map.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index d386cfb..a8b7e24 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -550,17 +550,23 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
 			*em_in = existing;
 			ret = 0;
 		} else {
+			u64 orig_start = em->start;
+			u64 orig_len = em->len;
+
 			/*
 			 * The existing extent map is the one nearest to
 			 * the [start, start + len) range which overlaps
 			 */
 			ret = merge_extent_mapping(em_tree, existing,
 						   em, start, len);
-			free_extent_map(existing);
 			if (ret) {
 				free_extent_map(em);
 				*em_in = NULL;
+				WARN_ONCE(ret, KERN_INFO "Unexpected error %d: merge existing(start %llu len %llu) with em(start %llu len %llu)\n",
+					  ret, existing->start, existing->len,
+					  orig_start, orig_len);
 			}
+			free_extent_map(existing);
 		}
 	}
 
-- 
2.9.4

