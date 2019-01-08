Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939F9C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 06:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C5E520700
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 06:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfAHGIZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 01:08:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:56840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727408AbfAHGIZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 01:08:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10EC3B120
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 06:08:24 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>
Subject: [For 5.0-rc PATCH] btrfs: Use real device structure to verify dev extent
Date:   Tue,  8 Jan 2019 14:08:18 +0800
Message-Id: <20190108060818.9517-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
Linux v5.0-rc1 will fail fstests/btrfs/163 with the following kernel
message:

  BTRFS error (device dm-6): dev extent devid 1 physical offset 13631488 len 8388608 is beyond device boundary 0
  BTRFS error (device dm-6): failed to verify dev extents against chunks: -117
  BTRFS error (device dm-6): open_ctree failed

[CAUSE]
Commit cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent
mapping check") introduced strict check on dev extents.

We use btrfs_find_device() with dev uuid and fs uuid set to NULL, and
only dependent on @devid to find the real device.

For seed devices, we call clone_fs_devices() in open_seed_devices() to
allow us search seed devices directly.

However clone_fs_devices() just populates devices with devid and dev
uuid, without populating other essential members, like disk_total_bytes.

This makes any device returned by btrfs_find_device(fs_info, devid,
NULL, NULL) is just a dummy, with 0 disk_total_bytes, and any dev
extents on the seed device will not pass the device boundary check.

[FIX]
This patch will try to verify the device returned by btrfs_find_device()
and if it's a dummy then re-search in seed devices.

Reported-by: Filipe Manana <fdmanana@suse.com>
Fixes: cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent mapping check")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2576b1a379c9..3e4f8f88353e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7825,6 +7825,18 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 		ret = -EUCLEAN;
 		goto out;
 	}
+
+	/* It's possible this device is a dummy for seed device */
+	if (dev->disk_total_bytes == 0) {
+		dev = find_device(fs_info->fs_devices->seed, devid, NULL);
+		if (!dev) {
+			btrfs_err(fs_info, "failed to find seed devid %llu",
+				  devid);
+			ret = -EUCLEAN;
+			goto out;
+		}
+	}
+
 	if (physical_offset + physical_len > dev->disk_total_bytes) {
 		btrfs_err(fs_info,
 "dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
-- 
2.20.1

