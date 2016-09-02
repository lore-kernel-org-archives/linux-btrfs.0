Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32590 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752089AbcIBBly (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 21:41:54 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id C6D6A403C872
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Sep 2016 09:41:48 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: mkfs: Warn user for minimal RAID5/6 devices setup
Date: Fri, 2 Sep 2016 09:41:44 +0800
Message-ID: <20160902014145.7817-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For RAID5, 2 devices setup is just RAID1 with more overhead.
For RAID6, 3 devices setup is RAID1 with 3 copies, not what most user
want.

So warn user at mkfs time for such case, and add explain in man pages.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/mkfs.btrfs.asciidoc | 15 +++++++++++----
 utils.c                           | 10 ++++++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 98fe694..846c08f 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -263,18 +263,25 @@ There are the following block group types available:
 .2+^.<h| Profile   3+^.^h| Redundancy           .2+^.<h| Min/max devices
       ^.^h| Copies   ^.^h| Parity     ^.<h| Striping
 | single  | 1            |                |            | 1/any
-| DUP     | 2 / 1 device |                |            | 1/any ^(see note)^
+| DUP     | 2 / 1 device |                |            | 1/any ^(see note1)^
 | RAID0   |              |                | 1 to N     | 2/any
 | RAID1   | 2            |                |            | 2/any
 | RAID10  | 2            |                | 1 to N     | 4/any
-| RAID5   | 1            | 1              | 2 to N - 1 | 2/any
-| RAID6   | 1            | 2              | 3 to N - 2 | 3/any
+| RAID5   | 1            | 1              | 2 to N - 1 | 2/any ^(see note2)^
+| RAID6   | 1            | 2              | 3 to N - 2 | 3/any ^(see note3)^
 |=============================================================
 
-'Note:' DUP may exist on more than 1 device if it starts on a single device and
+'Note1:' DUP may exist on more than 1 device if it starts on a single device and
 another one is added. Since version 4.5.1, *mkfs.btrfs* will let you create DUP
 on multiple devices.
 
+'Note2:' It's not recommended to use 2 devices RAID5. In that case,
+parity stripe will contains the same data of data stripe, making RAID5 degraded
+to RAID1 with more overhead.
+
+'Note3:' It's also not recommended to use 3 devices RAID6, unless one wants to
+get 3 copies RAID1, which btrfs doesn't provide yet.
+
 DUP PROFILES ON A SINGLE DEVICE
 -------------------------------
 
diff --git a/utils.c b/utils.c
index 82f3376..1d6879a 100644
--- a/utils.c
+++ b/utils.c
@@ -3314,6 +3314,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, int ssd)
 {
 	u64 allowed = 0;
+	u64 profile = metadata_profile | data_profile;
 
 	switch (dev_cnt) {
 	default:
@@ -3328,8 +3329,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
 	}
 
-	if (dev_cnt > 1 &&
-	    ((metadata_profile | data_profile) & BTRFS_BLOCK_GROUP_DUP)) {
+	if (dev_cnt > 1 && profile & BTRFS_BLOCK_GROUP_DUP) {
 		warning("DUP is not recommended on filesystem with multiple devices");
 	}
 	if (metadata_profile & ~allowed) {
@@ -3349,6 +3349,12 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 		return 1;
 	}
 
+	if (dev_cnt == 3 && profile & BTRFS_BLOCK_GROUP_RAID6) {
+		warning("RAID6 is not recommended on filesystem with 3 devices only");
+	}
+	if (dev_cnt == 2 && profile & BTRFS_BLOCK_GROUP_RAID5) {
+		warning("RAID5 is not recommended on filesystem with 2 devices only");
+	}
 	warning_on(!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP) && ssd,
 		   "DUP may not actually lead to 2 copies on the device, see manual page");
 
-- 
2.9.3



