Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34229 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3LPMZv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 07:25:51 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBGCPo1P014819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 12:25:51 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBGCPnNC028621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 12:25:50 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBGCPnag028611
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 12:25:49 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs_progs: use stripe_len define here
Date: Mon, 16 Dec 2013 20:33:58 +0800
Message-Id: <1387197239-29893-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1387197239-29893-1-git-send-email-anand.jain@oracle.com>
References: <1387197239-29893-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-convert.c | 2 +-
 btrfs-image.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 65fe707..df20c15 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1715,7 +1715,7 @@ static int prepare_system_chunk_sb(struct btrfs_super_block *super)
 
 	btrfs_set_stack_chunk_length(chunk, btrfs_super_total_bytes(super));
 	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_stack_chunk_stripe_len(chunk, 64 * 1024);
+	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
 	btrfs_set_stack_chunk_type(chunk, BTRFS_BLOCK_GROUP_SYSTEM);
 	btrfs_set_stack_chunk_io_align(chunk, sectorsize);
 	btrfs_set_stack_chunk_io_width(chunk, sectorsize);
diff --git a/btrfs-image.c b/btrfs-image.c
index 7bcfc06..1b2831a 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1350,7 +1350,7 @@ static void update_super_old(u8 *buffer)
 
 	btrfs_set_stack_chunk_length(chunk, (u64)-1);
 	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_stack_chunk_stripe_len(chunk, 64 * 1024);
+	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
 	btrfs_set_stack_chunk_type(chunk, BTRFS_BLOCK_GROUP_SYSTEM);
 	btrfs_set_stack_chunk_io_align(chunk, sectorsize);
 	btrfs_set_stack_chunk_io_width(chunk, sectorsize);
-- 
1.8.1.164.g2d0029e

