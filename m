Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22801 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbbKWM40 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 07:56:26 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/5] btrfs-progs: kernel based default features for mkfs
Date: Mon, 23 Nov 2015 20:56:16 +0800
Message-Id: <1448283378-10579-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mkfs from latest btrfs-progs will enable latest default features,
and if the kernel is down-rev and does not support a latest default
feature then mount fails, as expected.

This patch disables default features based on the running kernel.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Check if sysfs tells what features are supported

 mkfs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index a5802f7..4f46ad9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1357,10 +1357,24 @@ int main(int ac, char **av)
 	int dev_cnt = 0;
 	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
-	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 features;
 	struct mkfs_allocation allocation = { 0 };
 	struct btrfs_mkfs_config mkfs_cfg;
 
+	/*
+	 * If kernel could tell supported features by sysfs then use it,
+	 * if not, then set it by static kernel version, if the this also
+	 * fails then default to the progs default, which is set as per
+	 * BTRFS_MKFS_DEFAULT_FEATURES
+	 */
+	if (btrfs_features_allowed_by_sysfs(&features))
+		features = btrfs_features_allowed_by_kernel();
+
+	if (features)
+		features &= BTRFS_MKFS_DEFAULT_FEATURES;
+	else
+		features = BTRFS_MKFS_DEFAULT_FEATURES;
+
 	while(1) {
 		int c;
 		static const struct option long_options[] = {
-- 
2.6.2

