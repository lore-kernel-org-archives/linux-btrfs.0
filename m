Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FNDU5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 23:20:57 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5E3KueS026705
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 03:20:57 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5E3KuN4009754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 03:20:56 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5E3KuZY020078
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 03:20:56 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix misuse of skinny metadata in btrfs-image
Date: Fri, 14 Jun 2013 11:20:47 +0800
Message-Id: <1371180047-23253-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As for skinny metadata, key.offset stores levels rather than extent length.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-image.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 739ae35..e5ff795 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -798,9 +798,9 @@ static int copy_from_extent_tree(struct metadump_struct *metadump,
 
 		bytenr = key.objectid;
 		if (key.type == BTRFS_METADATA_ITEM_KEY)
-			num_bytes = key.offset;
-		else
 			num_bytes = extent_root->leafsize;
+		else
+			num_bytes = key.offset;
 
 		if (btrfs_item_size_nr(leaf, path->slots[0]) > sizeof(*ei)) {
 			ei = btrfs_item_ptr(leaf, path->slots[0],
-- 
1.8.1.4

