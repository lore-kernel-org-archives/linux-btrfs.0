Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27376 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070Ab3FTMFm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 08:05:42 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5KBxO0Z026393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 11:59:24 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5eCW013900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:41 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5eUG028139
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:40 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] Btrfs-progs: fix misuse of skinny metadata in btrfs-image
Date: Thu, 20 Jun 2013 20:05:27 +0800
Message-Id: <1371729930-22497-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As for skinny metadata, key.offset stores levels rather than extent length.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-image.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
1.7.7

