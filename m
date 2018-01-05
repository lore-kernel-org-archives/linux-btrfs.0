Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35601 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752940AbeAEUyL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 15:54:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w05KqOso024209
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:11 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2fagex02gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 20:54:11 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w05KsAhw010421
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:10 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w05KsAcA014920
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:10 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 10/10] Btrfs: noinline merge_extent_mapping
Date: Fri,  5 Jan 2018 12:51:17 -0700
Message-Id: <20180105195117.5131-11-bo.li.liu@oracle.com>
In-Reply-To: <20180105195117.5131-1-bo.li.liu@oracle.com>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to debug subtle bugs around merge_extent_mapping(), perf probe
can be used to check the arguments, but sometimes merge_extent_mapping()
got inlined by compiler and couldn't be probed.

This is adding noinline attribute to merge_extent_mapping().

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_map.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index a5a1d17..9e5fdf9 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -480,10 +480,10 @@ static struct extent_map *prev_extent_map(struct extent_map *em)
  * and an extent that you want to insert, deal with overlap and insert
  * the best fitted new extent into the tree.
  */
-static int merge_extent_mapping(struct extent_map_tree *em_tree,
-				struct extent_map *existing,
-				struct extent_map *em,
-				u64 map_start)
+static noinline int merge_extent_mapping(struct extent_map_tree *em_tree,
+					 struct extent_map *existing,
+					 struct extent_map *em,
+					 u64 map_start)
 {
 	struct extent_map *prev;
 	struct extent_map *next;
-- 
2.9.4

