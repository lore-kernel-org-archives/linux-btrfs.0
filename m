Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935371AbeEYEnd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 00:43:33 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F2DAFAC42
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 04:43:31 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 3/3] btrfs: Do super block verification before writing it to disk
Date: Fri, 25 May 2018 12:43:25 +0800
Message-Id: <20180525044325.3365-4-wqu@suse.com>
In-Reply-To: <20180525044325.3365-1-wqu@suse.com>
References: <20180525044325.3365-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are already 2 reports about strangely corrupted super blocks,
where csum still matches but extra garbage gets slipped into super block.

The corruption would looks like:
------
superblock: bytenr=65536, device=/dev/sdc1
---------------------------------------------------------
csum_type               41700 (INVALID)
csum                    0x3b252d3a [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
...
incompat_flags          0x5b22400000000169
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          BIG_METADATA |
                          EXTENDED_IREF |
                          SKINNY_METADATA |
                          unknown flag: 0x5b22400000000000 )
...
------
Or
------
superblock: bytenr=65536, device=/dev/mapper/x
---------------------------------------------------------
csum_type              35355 (INVALID)
csum_size              32
csum                   0xf0dbeddd [match]
bytenr                 65536
flags                  0x1
                       ( WRITTEN )
magic                  _BHRfS_M [match]
...
incompat_flags         0x176d200000000169
                       ( MIXED_BACKREF |
                         COMPRESS_LZO |
                         BIG_METADATA |
                         EXTENDED_IREF |
                         SKINNY_METADATA |
                         unknown flag: 0x176d200000000000 )
------

Obviously, csum_type and incompat_flags get some garbage, but its csum
still matches, which means kernel calculates the csum based on corrupted
super block memory.
And after manually fixing these values, the filesystem is completely
healthy without any problem exposed by btrfs check.

Although the cause is still unknown, at least detect it and prevent further
corruption.

Reported-by: Ken Swenson <flat@imo.uto.moe>
Reported-by: Ben Parsons <9parsonsb@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b981ecc4b6f9..d6c0cee627d9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2610,6 +2610,41 @@ static int btrfs_validate_mount_super(struct btrfs_fs_info *fs_info)
 	return __validate_super(fs_info, fs_info->super_copy, 0);
 }
 
+/*
+ * Check the validation of super block at write time.
+ * Some checks like bytenr check will be skipped as their values will be
+ * overwritten soon.
+ * Extra checks like csum type and incompact flags will be executed here.
+ */
+static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
+				      struct btrfs_super_block *sb)
+{
+	int ret;
+
+	ret = __validate_super(fs_info, sb, -1);
+	if (ret < 0)
+		goto out;
+	if (btrfs_super_csum_type(sb) != BTRFS_CSUM_TYPE_CRC32) {
+		ret = -EUCLEAN;
+		btrfs_err(fs_info, "invalid csum type, has %u want %u",
+			  btrfs_super_csum_type(sb), BTRFS_CSUM_TYPE_CRC32);
+		goto out;
+	}
+	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
+		ret = -EUCLEAN;
+		btrfs_err(fs_info,
+		"invalid incompact flags, has 0x%llu valid mask 0x%llu",
+			  btrfs_super_incompat_flags(sb),
+			  BTRFS_FEATURE_INCOMPAT_SUPP);
+		goto out;
+	}
+out:
+	if (ret < 0)
+		btrfs_err(fs_info,
+		"super block corruption detected before writing it to disk");
+	return ret;
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -3770,6 +3805,14 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
 
+		ret = btrfs_validate_write_super(fs_info, sb);
+		if (ret < 0) {
+			mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+			btrfs_handle_fs_error(fs_info, -EUCLEAN,
+				"unexpected superblock corruption detected");
+			return -EUCLEAN;
+		}
+
 		ret = write_dev_supers(dev, sb, max_mirrors);
 		if (ret)
 			total_errors++;
-- 
2.17.0

