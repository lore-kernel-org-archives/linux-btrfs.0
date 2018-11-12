Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D81C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 11:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 785C7223DD
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 11:58:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 785C7223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=synesis.ru
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbeKLVvp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 16:51:45 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39948 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbeKLVvp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 16:51:45 -0500
Received: by mail-lj1-f193.google.com with SMTP id t22-v6so7344333lji.7
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 03:58:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZuGD9nZYxOpwSJpV5qy7fur2OP4Zii4QnIqPflAzeUg=;
        b=Zo2Fvc2kd0VmUmHe/MIMDnnU49gCJjgC+nN/88qGQdqDDgOGzJhwulRl/wznt6zqYL
         A3Ba2GIU2p6Tan+srjbU6PUQUi/vKsiOWFjzyR2WKbCD5gblUR9ZcM0+1AghFD4iqaq7
         M+R4oz/Vea9vgxJnM+q+CFYinofm9/P26h76PNMWTuIdurWIVtis5BWbpCfwA9Za9qU5
         G5IhNJwMsDdHpBgc/vEvucBBO92boqt8+MKRavmvOobC2Ssh4iYsskgk4LdBnAWH5k+k
         GdZCZBEvXPw7ihLswdWdHUifp6gRj6HQ+MhmpwCJ2dtksRptNF7kZLrm1EFGHCnMtJsO
         hzVQ==
X-Gm-Message-State: AGRZ1gIaXpxVcuzYWH2oTgbeU2dJ5njYFuHeLCgrWd6clrC5wdpc3zCu
        TIPeHk66qzx0r4g6pDahGTO7AiRm
X-Google-Smtp-Source: AJdET5dfQlY6212ZgCafAXTOc8f2y1uiyjqInoaKdQol7+DV/BQQUQsGZ5gi75XVRnaNZio8AjQHJA==
X-Received: by 2002:a2e:145a:: with SMTP id 26-v6mr495458lju.116.1542023926174;
        Mon, 12 Nov 2018 03:58:46 -0800 (PST)
Received: from TitovetsT.synesis.local ([86.57.155.118])
        by smtp.gmail.com with ESMTPSA id j76-v6sm3110043ljb.12.2018.11.12.03.58.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 03:58:45 -0800 (PST)
From:   Timofey Titovets <timofey.titovets@synesis.ru>
To:     linux-btrfs@vger.kernel.org
Cc:     nborisov@suse.com, Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH V7] Btrfs: enhance raid1/10 balance heuristic
Date:   Mon, 12 Nov 2018 14:58:39 +0300
Message-Id: <20181112115839.13969-1-timofey.titovets@synesis.ru>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Timofey Titovets <nefelim4ag@gmail.com>

Currently btrfs raid1/10 balancer bаlance requests to mirrors,
based on pid % num of mirrors.

Make logic understood:
 - if one of underline devices are non rotational
 - Queue length to underline devices

By default try use pid % num_mirrors guessing, but:
 - If one of mirrors are non rotational, repick optimal to it
 - If underline mirror have less queue length then optimal,
   repick to that mirror

For avoid round-robin request balancing,
lets round down queue length:
 - By 8 for rotational devs
 - By 2 for all non rotational devs

Some bench results from mail list
(Dmitrii Tcvetkov <demfloro@demfloro.ru>):
Benchmark summary (arithmetic mean of 3 runs):
         Mainline     Patch
------------------------------------
RAID1  | 18.9 MiB/s | 26.5 MiB/s
RAID10 | 30.7 MiB/s | 30.7 MiB/s
------------------------------------------------------------------------
mainline, fio got lucky to read from first HDD (quite slow HDD):
Jobs: 1 (f=1): [r(1)][100.0%][r=8456KiB/s,w=0KiB/s][r=264,w=0 IOPS]
  read: IOPS=265, BW=8508KiB/s (8712kB/s)(499MiB/60070msec)
  lat (msec): min=2, max=825, avg=60.17, stdev=65.06
------------------------------------------------------------------------
mainline, fio got lucky to read from second HDD (much more modern):
Jobs: 1 (f=1): [r(1)][8.7%][r=11.9MiB/s,w=0KiB/s][r=380,w=0 IOPS]
  read: IOPS=378, BW=11.8MiB/s (12.4MB/s)(710MiB/60051msec)
  lat (usec): min=416, max=644286, avg=42312.74, stdev=48518.56
------------------------------------------------------------------------
mainline, fio got lucky to read from an SSD:
Jobs: 1 (f=1): [r(1)][100.0%][r=436MiB/s,w=0KiB/s][r=13.9k,w=0 IOPS]
  read: IOPS=13.9k, BW=433MiB/s (454MB/s)(25.4GiB/60002msec)
  lat (usec): min=343, max=16319, avg=1152.52, stdev=245.36
------------------------------------------------------------------------
With the patch, 2 HDDs:
Jobs: 1 (f=1): [r(1)][100.0%][r=17.5MiB/s,w=0KiB/s][r=560,w=0 IOPS]
  read: IOPS=560, BW=17.5MiB/s (18.4MB/s)(1053MiB/60052msec)
  lat (usec): min=435, max=341037, avg=28511.64, stdev=30000.14
------------------------------------------------------------------------
With the patch, HDD(old one)+SSD:
Jobs: 1 (f=1): [r(1)][100.0%][r=371MiB/s,w=0KiB/s][r=11.9k,w=0 IOPS]
  read: IOPS=11.6k, BW=361MiB/s (379MB/s)(21.2GiB/60084msec)
  lat  (usec): min=363, max=346752, avg=1381.73, stdev=6948.32

Changes:
  v1 -> v2:
    - Use helper part_in_flight() from genhd.c
      to get queue length
    - Move guess code to guess_optimal()
    - Change balancer logic, try use pid % mirror by default
      Make balancing on spinning rust if one of underline devices
      are overloaded
  v2 -> v3:
    - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
  v3 -> v4:
    - Rebased on latest misc-next
  v4 -> v5:
    - Rebased on latest misc-next
  v5 -> v6:
    - Fix spelling
    - Include bench results
  v6 -> v7:
    - Fixes based on Nikolay Borisov review:
      * Assume num == 2
      * Remove "for" loop based on that assumption, where possible
      * No functional changes

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
---
 block/genhd.c      |   1 +
 fs/btrfs/volumes.c | 100 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index be5bab20b2ab..939f0c6a2d79 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -81,6 +81,7 @@ void part_in_flight(struct request_queue *q, struct hd_struct *part,
 				atomic_read(&part->in_flight[1]);
 	}
 }
+EXPORT_SYMBOL_GPL(part_in_flight);
 
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 		       unsigned int inflight[2])
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4405e430da6..a6632cc2bfab 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -13,6 +13,7 @@
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
 #include <linux/uuid.h>
+#include <linux/genhd.h>
 #include <linux/list_sort.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -5159,6 +5160,102 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	return ret;
 }
 
+/**
+ * bdev_get_queue_len - return rounded down in flight queue length of bdev
+ *
+ * @bdev: target bdev
+ * @round_down: round factor big for hdd and small for ssd, like 8 and 2
+ */
+static int bdev_get_queue_len(struct block_device *bdev, int round_down)
+{
+	int sum;
+	struct hd_struct *bd_part = bdev->bd_part;
+	struct request_queue *rq = bdev_get_queue(bdev);
+	uint32_t inflight[2] = {0, 0};
+
+	part_in_flight(rq, bd_part, inflight);
+
+	sum = max_t(uint32_t, inflight[0], inflight[1]);
+
+	/*
+	 * Try prevent switch for every sneeze
+	 * By roundup output num by some value
+	 */
+	return ALIGN_DOWN(sum, round_down);
+}
+
+/**
+ * guess_optimal - return guessed optimal mirror
+ *
+ * Optimal expected to be pid % num_stripes
+ *
+ * That's generaly ok for spread load
+ * Add some balancer based on queue length to device
+ *
+ * Basic ideas:
+ *  - Sequential read generate low amount of request
+ *    so if load of drives are equal, use pid % num_stripes balancing
+ *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
+ *    and repick if other dev have "significant" less queue length
+ *  - Repick optimal if queue length of other mirror are less
+ */
+static int guess_optimal(struct map_lookup *map, int num, int optimal)
+{
+	int i;
+	int round_down = 8;
+	/* Init for missing bdevs */
+	int qlen[2] = { INT_MAX, INT_MAX };
+	bool is_nonrot[2] = { false, false };
+	bool all_bdev_nonrot = true;
+	bool all_bdev_rotate = true;
+	struct block_device *bdev;
+
+	ASSERT(num == 2);
+
+	/* Check accessible bdevs */
+	for (i = 0; i < 2; i++) {
+		bdev = map->stripes[i].dev->bdev;
+		if (bdev) {
+			qlen[i] = 0;
+			is_nonrot[i] = blk_queue_nonrot(bdev_get_queue(bdev));
+			if (is_nonrot[i])
+				all_bdev_rotate = false;
+			else
+				all_bdev_nonrot = false;
+		}
+	}
+
+	/*
+	 * Don't bother with computation
+	 * if only one of two bdevs are accessible
+	 */
+	if (qlen[0] == INT_MAX)
+		return 1;
+	if (qlen[1] == INT_MAX)
+		return 0;
+
+	if (all_bdev_nonrot)
+		round_down = 2;
+
+	for (i = 0; i < 2; i++) {
+		bdev = map->stripes[i].dev->bdev;
+		qlen[i] = bdev_get_queue_len(bdev, round_down);
+	}
+
+	/* For mixed case, pick non rotational dev as optimal */
+	if (all_bdev_rotate == all_bdev_nonrot) {
+		if (is_nonrot[0])
+			optimal = 0;
+		else
+			optimal = 1;
+	}
+
+	if (qlen[optimal] > qlen[(optimal + 1) % 2])
+		optimal = i;
+
+	return optimal;
+}
+
 static int find_live_mirror(struct btrfs_fs_info *fs_info,
 			    struct map_lookup *map, int first,
 			    int dev_replace_is_ongoing)
@@ -5177,7 +5274,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	else
 		num_stripes = map->num_stripes;
 
-	preferred_mirror = first + current->pid % num_stripes;
+	preferred_mirror = first + guess_optimal(map, num_stripes,
+						 current->pid % num_stripes);
 
 	if (dev_replace_is_ongoing &&
 	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
-- 
2.19.1
