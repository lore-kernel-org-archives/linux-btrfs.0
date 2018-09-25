Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B5AC43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 18:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 317BB20833
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 18:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ceYz+35p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 317BB20833
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbeIZAro (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 20:47:44 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:44556 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbeIZAro (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 20:47:44 -0400
Received: by mail-wr1-f44.google.com with SMTP id v16-v6so24396594wro.11
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 11:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xd44zrlvyWNngZvKg3iJ/e7euHYwFTYSB4mzsLDzpDU=;
        b=ceYz+35pbA1fZAdXa5Qh2wACHHihZJkRw5lOW62JV9V5zBkLhSpMl6zJwU/TDxZXSU
         BT5+8ExTE4Yt0Oyj6TfZsxCMqch3u6QNAUn9Gdodwws0/DDs5iOF3j7tbHrHBPxlFPO5
         iF+QBK377GjTq5HXDe+pHPvr40SMznGE1u8CrEF5TtGX+cAq3/62vX9nD+VM/5FH73Aa
         0vYhZuSVdtYB9m/EPdfp8o8r76LwwA48UrNDCfN9y9y0ZV07tXy7JmyhZHdqXxCKzk0I
         Daz/5wwM/rk3ObET8R3RX1Gq0cCj7HWmW8x6zS1s2wjcA8zaJog0ltCtBd3YmfquLZj4
         lFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xd44zrlvyWNngZvKg3iJ/e7euHYwFTYSB4mzsLDzpDU=;
        b=jc/g+6orRbZnnHWipukvz3nliX7DGrMn+jc0UGI2LQxxGt9EiuKz/za8edBe7lWSXt
         nzzM0tUNitoAyiRfpIraWQ7NHW04MSSJ3I2rMXElrQFMtUkiHhwdAnjGo/x5HVfgeRao
         u184yA78NT1EuPa8qFpCWzww8pyeas89YTsI9kSL6HcEqQjKDgKk9V5f6hjCXRhdMeBT
         +6cVZAFfHaLt2z0p9fuZiSk35FJWB3FnOkuz4DL5suEGwA/NdSHfdxvxsVIzPGTaXTp5
         bE4iB93ypUTVfz3S6mjuKXVo4txiy0vP/LQHfpLlmaFLAUWaBBCBVO/jbH05OtJLyMm5
         syJg==
X-Gm-Message-State: ABuFfogX5bZuatjTDmDqpBWJrdem87b/Y09tQUyM2RlskMLZ87fm1Lpj
        YBOrFrVrZ6hTHbCdL1WVG3DUyorl
X-Google-Smtp-Source: ACcGV635Eoxst+cyL0N3C4taLXsqE40uDqogyZPIiSAvXlCRKCDHWMml/SKdKMN8zoWM6RyvUCoq1g==
X-Received: by 2002:adf:ade3:: with SMTP id w90-v6mr2262773wrc.73.1537900731270;
        Tue, 25 Sep 2018 11:38:51 -0700 (PDT)
Received: from localhost.localdomain (mm-118-64-122-178.brest.dynamic.pppoe.byfly.by. [178.122.64.118])
        by smtp.gmail.com with ESMTPSA id d2-v6sm3166938wrm.71.2018.09.25.11.38.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Sep 2018 11:38:50 -0700 (PDT)
From:   Timofey Titovets <nefelim4ag@gmail.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH V6] Btrfs: enhance raid1/10 balance heuristic
Date:   Tue, 25 Sep 2018 21:38:41 +0300
Message-Id: <20180925183841.26936-1-nefelim4ag@gmail.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

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

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
---
 block/genhd.c      |   1 +
 fs/btrfs/volumes.c | 111 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9656f9e9f99e..5ea5acc88d3c 100644
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
index c95af358b71f..fa7dd6ac087f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -16,6 +16,7 @@
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
 #include <linux/uuid.h>
+#include <linux/genhd.h>
 #include <linux/list_sort.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -5201,6 +5202,111 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
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
+	int qlen[num];
+	bool is_nonrot[num];
+	bool all_bdev_nonrot = true;
+	bool all_bdev_rotate = true;
+	struct block_device *bdev;
+
+	if (num == 1)
+		return optimal;
+
+	/* Check accessible bdevs */
+	for (i = 0; i < num; i++) {
+		/* Init for missing bdevs */
+		is_nonrot[i] = false;
+		qlen[i] = INT_MAX;
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
+	if (num == 2 && qlen[0] != qlen[1]) {
+		if (qlen[0] < qlen[1])
+			return 0;
+		else
+			return 1;
+	}
+
+	if (all_bdev_nonrot)
+		round_down = 2;
+
+	for (i = 0; i < num; i++) {
+		if (qlen[i])
+			continue;
+		bdev = map->stripes[i].dev->bdev;
+		qlen[i] = bdev_get_queue_len(bdev, round_down);
+	}
+
+	/* For mixed case, pick non rotational dev as optimal */
+	if (all_bdev_rotate == all_bdev_nonrot) {
+		for (i = 0; i < num; i++) {
+			if (is_nonrot[i])
+				optimal = i;
+		}
+	}
+
+	for (i = 0; i < num; i++) {
+		if (qlen[optimal] > qlen[i])
+			optimal = i;
+	}
+
+	return optimal;
+}
+
 static int find_live_mirror(struct btrfs_fs_info *fs_info,
 			    struct map_lookup *map, int first,
 			    int dev_replace_is_ongoing)
@@ -5219,7 +5325,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	else
 		num_stripes = map->num_stripes;
 
-	preferred_mirror = first + current->pid % num_stripes;
+	preferred_mirror = first + guess_optimal(map, num_stripes,
+						 current->pid % num_stripes);
 
 	if (dev_replace_is_ongoing &&
 	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
-- 
2.17.0
