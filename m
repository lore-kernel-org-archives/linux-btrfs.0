Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40910 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbbKYMIp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:08:45 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Subject: [PATCH 1/7] btrfs-progs: show the version for -O list-all
Date: Wed, 25 Nov 2015 20:08:14 +0800
Message-Id: <1448453300-8449-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shows min kernel version in the -O list-all output

eg: (version is show with in ())
btrfs-convert -O list-all
Filesystem features available:
extref          - increased hardlink limit per file to 65536 (0x40, 3.7, default)
skinny-metadata - reduced-size metadata extent refs (0x100, 3.10, default)
no-holes        - no explicit hole extents for files (0x200, 3.14)

mkfs.btrfs -O list-all
Filesystem features available:
mixed-bg        - mixed data and metadata block groups (0x4, 2.7.37)
extref          - increased hardlink limit per file to 65536 (0x40, 3.7, default)
raid56          - raid56 extended format (0x80, 3.9)
skinny-metadata - reduced-size metadata extent refs (0x100, 3.10, default)
no-holes        - no explicit hole extents for files (0x200, 3.14)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 2710ed7..0163915 100644
--- a/utils.c
+++ b/utils.c
@@ -657,10 +657,11 @@ void btrfs_list_all_fs_features(u64 mask_disallowed)
 			continue;
 		if (mkfs_features[i].flag & BTRFS_MKFS_DEFAULT_FEATURES)
 			is_default = ", default";
-		fprintf(stderr, "%-20s- %s (0x%llx%s)\n",
+		fprintf(stderr, "%-20s- %s (0x%llx, %s%s)\n",
 				mkfs_features[i].name,
 				mkfs_features[i].desc,
 				mkfs_features[i].flag,
+				mkfs_features[i].min_ker_ver,
 				is_default);
 	}
 }
-- 
2.6.2

