Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C25AC65BA7
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E055520854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:30:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E055520854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbeJEE0L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:26:11 -0400
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45756 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbeJEE0K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 00:26:10 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 3FFE9209D4
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 23:24:44 +0200 (CEST)
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: alloc_chunk: rework chunk/stripe calculations
Date:   Thu,  4 Oct 2018 23:24:43 +0200
Message-Id: <20181004212443.26519-7-hans.van.kranenburg@mendix.com>
X-Mailer: git-send-email 2.19.0.329.g76f2f5c1e3
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Previously, the stripe_size variable was modified too many times in the
__btrfs_alloc_chunk function. The most problematic place was the if
block dealing with a chunk bigger than max_chunk_size, which would throw
away (overwrite) the value of stripe_size, maybe realizing a few lines
later that the previous value was actually better and executing a copy
of former logic to try get it back in the previous state.

Instead of on-the-fly calculating the target chunk size, adjust the
max_stripe_size variable based on the max_chunk_size that was set
before, and use that to simply compare it to stripe_size at some point.
This removes the whole problematic if block.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 fs/btrfs/volumes.c | 46 +++++++++++++++++++++-------------------------
 fs/btrfs/volumes.h |  2 +-
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 453046497ac8..862ee17ee0e5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4596,14 +4596,15 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	struct btrfs_device_info *devices_info = NULL;
 	u64 total_avail;
 	int num_stripes;	/* total number of stripes to allocate */
-	int data_stripes;	/* number of stripes that count for
-				   block group size */
+	int num_data_stripes;	/* number of stripes worth of bytes to
+				   store data including copies */
 	int sub_stripes;	/* sub_stripes info for map */
 	int dev_stripes;	/* stripes per dev */
 	int devs_max;		/* max devs to use */
 	int devs_min;		/* min devs needed */
 	int devs_increment;	/* ndevs has to be a multiple of this */
-	int ncopies;		/* how many copies to data has */
+	int ncopies;		/* how many times actual data is duplicated
+				   inside num_data_stripes */
 	int nparity;		/* number of stripes worth of bytes to
 				   store parity information */
 	int ret;
@@ -4747,6 +4748,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 
 	ndevs = min(ndevs, devs_max);
+	num_stripes = ndevs * dev_stripes;
+	num_data_stripes = num_stripes - nparity;
 
 	/*
 	 * The primary goal is to maximize the number of stripes, so use as
@@ -4756,31 +4759,24 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	 * max_avail is the total size so we have to adjust.
 	 */
 	stripe_size = div_u64(devices_info[ndevs - 1].max_avail, dev_stripes);
-	num_stripes = ndevs * dev_stripes;
-
-	/*
-	 * this will have to be fixed for RAID1 and RAID10 over
-	 * more drives
-	 */
-	data_stripes = (num_stripes - nparity) / ncopies;
 
 	/*
-	 * Use the number of data stripes to figure out how big this chunk
-	 * is really going to be in terms of logical address space,
-	 * and compare that answer with the max chunk size. If it's higher,
-	 * we try to reduce stripe_size.
+	 * Now that we know how many stripes we're going to use, we can adjust
+	 * down max_stripe_size if needed, paying attention to max_chunk_size.
+	 *
+	 * By multiplying chunk size with ncopies, we get the total amount of
+	 * bytes that need to fit into all the non-parity stripes.
+	 *
+	 * A chunk is allowed to end up being a bit bigger than max_chunk_size
+	 * when rounding up the stripe_size to a 16MiB boundary makes it so.
+	 * Unless... it ends up being bigger than the amount of physical free
+	 * space we can use for it.
 	 */
-	if (stripe_size * data_stripes > max_chunk_size) {
-		/* Reduce stripe_size, round it up to a 16MB boundary
-		 * again and then use it, unless it ends up being even
-		 * bigger than the previous value we had already.
-		 */
-		stripe_size = min(round_up(div_u64(max_chunk_size,
-						   data_stripes), SZ_16M),
-				  stripe_size);
-	}
+	max_stripe_size = min(round_up((max_chunk_size * ncopies) /
+				       num_data_stripes, SZ_16M),
+			      max_stripe_size);
 
-	/* align to BTRFS_STRIPE_LEN */
+	stripe_size = min(max_stripe_size, stripe_size);
 	stripe_size = round_down(stripe_size, BTRFS_STRIPE_LEN);
 
 	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
@@ -4804,7 +4800,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	map->type = type;
 	map->sub_stripes = sub_stripes;
 
-	chunk_size = stripe_size * data_stripes;
+	chunk_size = div_u64(stripe_size * num_data_stripes, ncopies);
 
 	trace_btrfs_chunk_alloc(info, map, start, chunk_size);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0fe005b4295a..ee2ec77b1291 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -330,7 +330,7 @@ struct btrfs_raid_attr {
 	int devs_min;		/* min devs needed */
 	int tolerated_failures; /* max tolerated fail devs */
 	int devs_increment;	/* ndevs has to be a multiple of this */
-	int ncopies;		/* how many copies to data has */
+	int ncopies;		/* how many copies the data has */
 	int nparity;		/* number of stripes worth of bytes to
 				   store parity information */
 	int mindev_error;	/* error code if min devs requisite is unmet */
-- 
2.19.0.329.g76f2f5c1e3

