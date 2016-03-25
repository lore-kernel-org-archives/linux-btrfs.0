Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:56996 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbcCYB4E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 21:56:04 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9787DAC0292
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:55:55 +0900 (JST)
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: mkfs: fix an error when using DUP on multidev fs
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1458834973-3199-1-git-send-email-dsterba@suse.com>
Message-ID: <56F49A96.70808@jp.fujitsu.com>
Date: Fri, 25 Mar 2016 10:55:34 +0900
MIME-Version: 1.0
In-Reply-To: <1458834973-3199-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To accept DUP on multidev fs, in addition to the following
commit, we need to mark DUP as an allowed data/metadata
profile.

commit 42f1279bf8e9 ("btrfs-progs: mkfs: allow DUP on multidev fs, only warn")

* actual result

  =============================================
  # ./mkfs.btrfs -f -m DUP -d DUP /dev/sdb1 /dev/sdb2
  btrfs-progs v4.5-24-ga35b7e6
  See http://btrfs.wiki.kernel.org for more information.

  WARNING: DUP is not recommended on filesystem with multiple devices
  ERROR: unable to create FS with metadata profile DUP (have 2 devices but 1 devices are required)
  =============================================

* expected result

  =============================================
  # ./mkfs.btrfs -f -m dup -d dup /dev/sdb1 /dev/sdb2
  WARNING: DUP is not recommended on filesystem with multiple devices
  btrfs-progs v4.5-25-g1a10a3c
  See http://btrfs.wiki.kernel.org for more information.

  Label:              (null)
  UUID:               010d72ff-c87c-4516-8916-5e635719d110
  Node size:          16384
  Sector size:        4096
  Filesystem size:    28.87GiB
  Block group profiles:
    Data:             DUP               1.01GiB
    Metadata:         DUP               1.01GiB
    System:           DUP              12.00MiB
  SSD detected:       no
  Incompat features:  extref, skinny-metadata
  Number of devices:  2
  Devices:
     ID        SIZE  PATH
      1   953.00MiB  /dev/sdb1
      2    27.94GiB  /dev/sdb2

  ==================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to devel branch (commit: a35b7e6ee122)
---
 utils.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/utils.c b/utils.c
index 75ce6ea..7e45702 100644
--- a/utils.c
+++ b/utils.c
@@ -2455,7 +2455,6 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	case 2:
 		allowed |= BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
 			BTRFS_BLOCK_GROUP_RAID5;
-		break;
 	case 1:
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
 	}
-- 
2.5.0
