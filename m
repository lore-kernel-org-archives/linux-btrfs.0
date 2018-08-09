Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40697 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbeHIUhZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:25 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 06/12] btrfs-progs: avoid writing super block to sequential zones
Date: Fri, 10 Aug 2018 03:10:59 +0900
Message-Id: <20180809181105.12856-6-naota@elisp.net>
In-Reply-To: <20180809181105.12856-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809181105.12856-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is not possible to write a super block copy in sequential write required
zones as this prevents in-place updates required for super blocks.  This
patch limits super block possible locations to zones accepting random
writes. In particular, the zone containing the first block of the device or
partition being formatted must accept random writes.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 26e4f6e9..127d8cf4 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1523,6 +1523,7 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 			    struct btrfs_super_block *sb,
 			    struct btrfs_device *device)
 {
+	struct btrfs_zone_info *zinfo = &device->zinfo;
 	u64 bytenr;
 	u32 crc;
 	int i, ret;
@@ -1534,6 +1535,11 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
 		btrfs_csum_final(crc, &sb->csum[0]);
 
+		if (!zone_is_random_write(zinfo, fs_info->super_bytenr)) {
+			ret = -EIO;
+			goto write_err;
+		}
+
 		/*
 		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
 		 * zero filled, we can use it directly
@@ -1550,6 +1556,8 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->total_bytes)
 			break;
+		if (!zone_is_random_write(zinfo, bytenr))
+			continue;
 
 		btrfs_set_super_bytenr(sb, bytenr);
 
-- 
2.18.0

