Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38514 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3LQLIe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 06:08:34 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBHB8XSk011128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 11:08:34 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBHB8Xs5015921
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 11:08:33 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBHB8WYr025950
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 11:08:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] btrfs-progs: use stripe_len define here
Date: Tue, 17 Dec 2013 19:16:46 +0800
Message-Id: <1387279007-10388-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1387279007-10388-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1387279007-10388-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v3: volume.c needs BTRFS_STRIPE_LEN as well
 v2: commit update

 btrfs-convert.c |    2 +-
 btrfs-image.c   |    2 +-
 volumes.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
diff --git a/volumes.c b/volumes.c
index c38da6c..7a9c955 100644
--- a/volumes.c
+++ b/volumes.c
@@ -773,7 +773,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int looped = 0;
 	int ret;
 	int index;
-	int stripe_len = 64 * 1024;
+	int stripe_len = BTRFS_STRIPE_LEN;
 	struct btrfs_key key;
 	u64 offset;
 
-- 
1.7.1

