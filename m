Return-Path: <SRS0=swP/=RU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE821C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 12:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 699ED21019
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 12:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lesimple.fr header.i=@lesimple.fr header.b="eGbVrIC3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfCQMyh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Mar 2019 08:54:37 -0400
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:44502 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726204AbfCQMyh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Mar 2019 08:54:37 -0400
Received: from nas.speed47.net (lfbn-lil-1-519-34.w81-254.abo.wanadoo.fr [81.254.103.34])
        by box.speed47.net (Postfix) with ESMTPSA id 2124D300D;
        Sun, 17 Mar 2019 13:54:34 +0100 (CET)
Authentication-Results: box.speed47.net; dmarc=fail (p=none dis=none) header.from=lesimple.fr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=lesimple.fr; s=mail01;
        t=1552827274; bh=L9jzAiqPSvyzqgikf6n+zHl6cqDrGiDBT16SabxMv5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=eGbVrIC3JnoBoPdTODVKZdNBCH8ZDRk+5KVY6h/vdOq1iI49RUD/AGHp4pjEdGYxJ
         xPr8s7hdj49ipUwDbVzseH9fEmgx6mmhxf6eWjn5WZvQuW2Stfq8i7yBv7sw1Kb0Xh
         YfKs5mFFqb4cY81hPHIaIACrToRWde6qX37zdo/A=
Received: (nullmailer pid 27158 invoked by uid 500);
        Sun, 17 Mar 2019 12:54:34 -0000
From:   stephane_btrfs@lesimple.fr
To:     linux-btrfs@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs@lesimple.fr>
Subject: [PATCH 1/1] btrfs-progs: fi usage: implement raid56
Date:   Sun, 17 Mar 2019 13:51:50 +0100
Message-Id: <20190317125150.26265-2-stephane_btrfs@lesimple.fr>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190317125150.26265-1-stephane_btrfs@lesimple.fr>
References: <20190317125150.26265-1-stephane_btrfs@lesimple.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Stéphane Lesimple <stephane_btrfs@lesimple.fr>

Implement RAID5 and RAID6 support in `filesystem usage'.

Before:
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
>      Device allocated:     0.00B
>      Device unallocated:   2.04GiB
>      Used:                 0.00B
>      Free (estimated):     0.00B      (min: 8.00EiB)
>      Data ratio:           0.00
>      Metadata ratio:       0.00

After:
>      Device allocated:     1.83GiB
>      Device unallocated:   211.50MiB
>      Used:                 1.83GiB
>      Free (estimated):     128.44MiB  (min: 128.44MiB)
>      Data ratio:           1.65
>      Metadata ratio:       1.20

Note that this might need some fine-tuning for mixed mode.

We may also overestimate the free space incorrectly in
some complex disk configurations, i.e. when some of the
unallocated space is in fact unallocatable because the
redundancy profile requisites can't be matched with how
the remaining unallocated space is distributed over the
devices. This is not specific to raid56 and also happens
with other raid profiles, it'll need to be taken care of
separately.

Signed-off-by: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
---
 cmds-fi-usage.c | 96 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 36 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 9a23e176..baa1ff89 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -280,28 +280,6 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, const char *path)
 	return sargs;
 }
 
-/*
- * This function computes the space occupied by a *single* RAID5/RAID6 chunk.
- * The computation is performed on the basis of the number of stripes
- * which compose the chunk, which could be different from the number of devices
- * if a disk is added later.
- */
-static void get_raid56_used(struct chunk_info *chunks, int chunkcount,
-		u64 *raid5_used, u64 *raid6_used)
-{
-	struct chunk_info *info_ptr = chunks;
-	*raid5_used = 0;
-	*raid6_used = 0;
-
-	while (chunkcount-- > 0) {
-		if (info_ptr->type & BTRFS_BLOCK_GROUP_RAID5)
-			(*raid5_used) += info_ptr->size / (info_ptr->num_stripes - 1);
-		if (info_ptr->type & BTRFS_BLOCK_GROUP_RAID6)
-			(*raid6_used) += info_ptr->size / (info_ptr->num_stripes - 2);
-		info_ptr++;
-	}
-}
-
 #define	MIN_UNALOCATED_THRESH	SZ_16M
 static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		int chunkcount, struct device_info *devinfo, int devcount,
@@ -331,13 +309,15 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	double data_ratio;
 	double metadata_ratio;
 	/* logical */
-	u64 raid5_used = 0;
-	u64 raid6_used = 0;
+	u64 r_data_raid56_chunks = 0;
+	u64 l_data_raid56_chunks = 0;
+	u64 r_metadata_raid56_chunks = 0;
+	u64 l_metadata_raid56_chunks = 0;
 	u64 l_global_reserve = 0;
 	u64 l_global_reserve_used = 0;
 	u64 free_estimated = 0;
 	u64 free_min = 0;
-	int max_data_ratio = 1;
+	double max_data_ratio = 1;
 	int mixed = 0;
 
 	sargs = load_space_info(fd, path);
@@ -359,24 +339,29 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		ret = 1;
 		goto exit;
 	}
-	get_raid56_used(chunkinfo, chunkcount, &raid5_used, &raid6_used);
 
 	for (i = 0; i < sargs->total_spaces; i++) {
 		int ratio;
 		u64 flags = sargs->spaces[i].flags;
 
+		if ((flags & (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA))
+		    == (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
+			mixed = 1;
+		}
+
 		/*
 		 * The raid5/raid6 ratio depends by the stripes number
-		 * used by every chunk. It is computed separately
+		 * used by every chunk. It is computed separately,
+		 * after we're done with this loop, so skip those.
 		 */
 		if (flags & BTRFS_BLOCK_GROUP_RAID0)
 			ratio = 1;
 		else if (flags & BTRFS_BLOCK_GROUP_RAID1)
 			ratio = 2;
 		else if (flags & BTRFS_BLOCK_GROUP_RAID5)
-			ratio = 0;
+			continue;
 		else if (flags & BTRFS_BLOCK_GROUP_RAID6)
-			ratio = 0;
+			continue;
 		else if (flags & BTRFS_BLOCK_GROUP_DUP)
 			ratio = 2;
 		else if (flags & BTRFS_BLOCK_GROUP_RAID10)
@@ -384,9 +369,6 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		else
 			ratio = 1;
 
-		if (!ratio)
-			warning("RAID56 detected, not implemented");
-
 		if (ratio > max_data_ratio)
 			max_data_ratio = ratio;
 
@@ -394,10 +376,6 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 			l_global_reserve = sargs->spaces[i].total_bytes;
 			l_global_reserve_used = sargs->spaces[i].used_bytes;
 		}
-		if ((flags & (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA))
-		    == (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
-			mixed = 1;
-		}
 		if (flags & BTRFS_BLOCK_GROUP_DATA) {
 			r_data_used += sargs->spaces[i].used_bytes * ratio;
 			r_data_chunks += sargs->spaces[i].total_bytes * ratio;
@@ -414,6 +392,52 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		}
 	}
 
+	/*
+	 * Here we compute the space occupied by every RAID5/RAID6 chunks.
+	 * The computation is performed on the basis of the number of stripes
+	 * which compose each chunk, which could be different from the number of devices
+	 * if a disk is added later, or if the disks are of different sizes..
+	 */
+	struct chunk_info *info_ptr;
+	for (info_ptr = chunkinfo, i = chunkcount; i > 0; i--, info_ptr++) {
+		int flags = info_ptr->type;
+		int nparity;
+
+		if (flags & BTRFS_BLOCK_GROUP_RAID5) {
+			nparity = 1;
+		}
+		else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
+			nparity = 2;
+		}
+		else {
+			// We're only interested in raid56 here
+			continue;
+		}
+
+		if (flags & BTRFS_BLOCK_GROUP_DATA) {
+			r_data_raid56_chunks += info_ptr->size / (info_ptr->num_stripes - nparity);
+			l_data_raid56_chunks += info_ptr->size / info_ptr->num_stripes;
+		}
+		if (flags & BTRFS_BLOCK_GROUP_METADATA) {
+			r_metadata_raid56_chunks += info_ptr->size / (info_ptr->num_stripes - nparity);
+			l_metadata_raid56_chunks += info_ptr->size / info_ptr->num_stripes;
+		}
+	}
+
+	if (l_data_raid56_chunks > 0) {
+		double ratio = (double)r_data_raid56_chunks / l_data_raid56_chunks;
+		r_data_used += r_data_raid56_chunks;
+		r_data_chunks += r_data_raid56_chunks;
+		l_data_chunks += l_data_raid56_chunks;
+		if (ratio > max_data_ratio)
+			max_data_ratio = ratio;
+	}
+	if (l_metadata_raid56_chunks > 0) {
+		r_metadata_used += r_metadata_raid56_chunks;
+		r_metadata_chunks += r_metadata_raid56_chunks;
+		l_metadata_chunks += l_metadata_raid56_chunks;
+	}
+
 	r_total_chunks = r_data_chunks + r_system_chunks;
 	r_total_used = r_data_used + r_system_used;
 	if (!mixed) {
-- 
2.17.1

