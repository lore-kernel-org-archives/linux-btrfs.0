Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1C2C64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BB3F20854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BB3F20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbeJEE0J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:26:09 -0400
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45757 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbeJEE0I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 00:26:08 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2018 00:26:08 EDT
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 32DFA2051E
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 23:24:44 +0200 (CEST)
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: introduce nparity raid_attr
Date:   Thu,  4 Oct 2018 23:24:42 +0200
Message-Id: <20181004212443.26519-6-hans.van.kranenburg@mendix.com>
X-Mailer: git-send-email 2.19.0.329.g76f2f5c1e3
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Instead of hardcoding exceptions for RAID5 and RAID6 in the code, use an
nparity field in raid_attr.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 fs/btrfs/volumes.c | 18 +++++++++++-------
 fs/btrfs/volumes.h |  2 ++
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d82b3d735ebe..453046497ac8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -37,6 +37,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.tolerated_failures = 1,
 		.devs_increment	= 2,
 		.ncopies	= 2,
+		.nparity        = 0,
 		.raid_name	= "raid10",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID10,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
@@ -49,6 +50,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.tolerated_failures = 1,
 		.devs_increment	= 2,
 		.ncopies	= 2,
+		.nparity        = 0,
 		.raid_name	= "raid1",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID1,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
@@ -61,6 +63,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.tolerated_failures = 0,
 		.devs_increment	= 1,
 		.ncopies	= 2,
+		.nparity        = 0,
 		.raid_name	= "dup",
 		.bg_flag	= BTRFS_BLOCK_GROUP_DUP,
 		.mindev_error	= 0,
@@ -73,6 +76,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.tolerated_failures = 0,
 		.devs_increment	= 1,
 		.ncopies	= 1,
+		.nparity        = 0,
 		.raid_name	= "raid0",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID0,
 		.mindev_error	= 0,
@@ -85,6 +89,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.tolerated_failures = 0,
 		.devs_increment	= 1,
 		.ncopies	= 1,
+		.nparity        = 0,
 		.raid_name	= "single",
 		.bg_flag	= 0,
 		.mindev_error	= 0,
@@ -97,6 +102,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.tolerated_failures = 1,
 		.devs_increment	= 1,
 		.ncopies	= 1,
+		.nparity        = 2,
 		.raid_name	= "raid5",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID5,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
@@ -109,6 +115,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.tolerated_failures = 2,
 		.devs_increment	= 1,
 		.ncopies	= 1,
+		.nparity        = 2,
 		.raid_name	= "raid6",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID6,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
@@ -4597,6 +4604,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int devs_min;		/* min devs needed */
 	int devs_increment;	/* ndevs has to be a multiple of this */
 	int ncopies;		/* how many copies to data has */
+	int nparity;		/* number of stripes worth of bytes to
+				   store parity information */
 	int ret;
 	u64 max_stripe_size;
 	u64 max_chunk_size;
@@ -4623,6 +4632,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	devs_min = btrfs_raid_array[index].devs_min;
 	devs_increment = btrfs_raid_array[index].devs_increment;
 	ncopies = btrfs_raid_array[index].ncopies;
+	nparity = btrfs_raid_array[index].nparity;
 
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_stripe_size = SZ_1G;
@@ -4752,13 +4762,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	 * this will have to be fixed for RAID1 and RAID10 over
 	 * more drives
 	 */
-	data_stripes = num_stripes / ncopies;
-
-	if (type & BTRFS_BLOCK_GROUP_RAID5)
-		data_stripes = num_stripes - 1;
-
-	if (type & BTRFS_BLOCK_GROUP_RAID6)
-		data_stripes = num_stripes - 2;
+	data_stripes = (num_stripes - nparity) / ncopies;
 
 	/*
 	 * Use the number of data stripes to figure out how big this chunk
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 23e9285d88de..0fe005b4295a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -331,6 +331,8 @@ struct btrfs_raid_attr {
 	int tolerated_failures; /* max tolerated fail devs */
 	int devs_increment;	/* ndevs has to be a multiple of this */
 	int ncopies;		/* how many copies to data has */
+	int nparity;		/* number of stripes worth of bytes to
+				   store parity information */
 	int mindev_error;	/* error code if min devs requisite is unmet */
 	const char raid_name[8]; /* name of the raid */
 	u64 bg_flag;		/* block group flag of the raid */
-- 
2.19.0.329.g76f2f5c1e3

