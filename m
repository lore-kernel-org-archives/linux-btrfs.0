Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44915 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbeHIUb5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:31:57 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 04/17] btrfs: limit super block locations in HMZONED mode
Date: Fri, 10 Aug 2018 03:04:37 +0900
Message-Id: <20180809180450.5091-5-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When in HMZONED mode, make sure that device super blocks are located in
randomly writable zones of zoned block devices. That is, do not write super
blocks in sequential write required zones of host-managed zoned block
devices as update would not be possible.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/disk-io.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 14f284382ba7..6a014632ca1e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3435,6 +3435,13 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	return latest;
 }
 
+static int check_super_location(struct btrfs_device *device, u64 pos)
+{
+	/* any address is good on a regular (zone_size == 0) device */
+	/* non-SEQUENTIAL WRITE REQUIRED zones are capable on a zoned device */
+	return device->zone_size == 0 || !btrfs_dev_is_sequential(device, pos);
+}
+
 /*
  * Write superblock @sb to the @device. Do not wait for completion, all the
  * buffer heads we write are pinned.
@@ -3464,6 +3471,8 @@ static int write_dev_supers(struct btrfs_device *device,
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
 		    device->commit_total_bytes)
 			break;
+		if (!check_super_location(device, bytenr))
+			continue;
 
 		btrfs_set_super_bytenr(sb, bytenr);
 
-- 
2.18.0

