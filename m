Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48833 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbbEBQDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 May 2015 12:03:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YoZtB-0004yb-Rr
	for linux-btrfs@vger.kernel.org; Sat, 02 May 2015 18:03:37 +0200
Received: from host-78-149-209-236.as13285.net ([78.149.209.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 May 2015 18:03:37 +0200
Received: from samtygier by host-78-149-209-236.as13285.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 May 2015 18:03:37 +0200
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: [PATCH] btrfs-progs: check metadata redundancy
Date: Sat, 02 May 2015 17:03:31 +0100
Message-ID: <mi2sgj$urs$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently BTRFS allows you to make bad choices of data and 
metadata levels. For example -d raid1 -m raid0 means you can
only use half your total disk space, but will loose everything
if 1 disk fails. This patch prevents you creating the situation
another will be need to prevent rebalancing in to it. 

When making a filesystem check that metadata mode is at least
as redundant as the data mode. For example don't allow:
	-d raid1 -m raid0

Signed-off-by: Sam Tygier <samtygier@yahoo.co.uk>
---
 utils.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/utils.c b/utils.c
index b175b01..1136a78 100644
--- a/utils.c
+++ b/utils.c
@@ -2391,6 +2391,24 @@ static int group_profile_devs_min(u64 flag)
 	}
 }
 
+static int group_profile_max_safe_loss(u64 flag)
+{
+	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case 0: /* single */
+	case BTRFS_BLOCK_GROUP_DUP:
+	case BTRFS_BLOCK_GROUP_RAID0:
+		return 0;
+	case BTRFS_BLOCK_GROUP_RAID1:
+	case BTRFS_BLOCK_GROUP_RAID5:
+	case BTRFS_BLOCK_GROUP_RAID10:
+		return 1;
+	case BTRFS_BLOCK_GROUP_RAID6:
+		return 2;
+	default:
+		return -1;
+	}
+}
+
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr)
 {
@@ -2439,6 +2457,13 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 			"dup for data is allowed only in mixed mode");
 		return 1;
 	}
+
+	if (group_profile_max_safe_loss(metadata_profile) <
+		group_profile_max_safe_loss(data_profile)){
+		snprintf(estr, sz,
+			"metatdata has lower redundancy than data");
+		return 1;
+	}
 	return 0;
 }
 
-- 2.1.4


