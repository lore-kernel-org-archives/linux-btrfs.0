Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22817 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbbKWM42 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 07:56:28 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 5/5] btrfs-progs: add warning when we fail to read sysfs or version
Date: Mon, 23 Nov 2015 20:56:18 +0800
Message-Id: <1448283378-10579-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-convert.c | 10 +++++++++-
 mkfs.c          |  8 +++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 52ea12a..b0a998b 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2898,14 +2898,22 @@ int main(int argc, char *argv[])
 	char fslabel[BTRFS_LABEL_SIZE];
 	u64 features;
 
-	if (btrfs_features_allowed_by_sysfs(&features))
+	if (btrfs_features_allowed_by_sysfs(&features)) {
+		fprintf(stderr,
+		"Warning: Failed/Unsupported to obtain feature list from sysfs\n");
+
 		features = btrfs_features_allowed_by_kernel();
+		if (!features)
+			fprintf(stderr,
+		"Warning: Failed/Unsupported to get running kernel version\n");
+	}
 
 	if (features)
 		features &= BTRFS_MKFS_DEFAULT_FEATURES;
 	else
 		features = BTRFS_MKFS_DEFAULT_FEATURES;
 
+
 	while(1) {
 		enum { GETOPT_VAL_NO_PROGRESS = 256 };
 		static const struct option long_options[] = {
diff --git a/mkfs.c b/mkfs.c
index 4f46ad9..6cb998b 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1367,8 +1367,14 @@ int main(int ac, char **av)
 	 * fails then default to the progs default, which is set as per
 	 * BTRFS_MKFS_DEFAULT_FEATURES
 	 */
-	if (btrfs_features_allowed_by_sysfs(&features))
+	if (btrfs_features_allowed_by_sysfs(&features)) {
+		fprintf(stderr,
+		"Warning: Failed/Unsupported to obtain feature list from sysfs\n");
 		features = btrfs_features_allowed_by_kernel();
+		if (!features)
+			fprintf(stderr,
+		"Warning: Failed/Unsupported to get running kernel version\n");
+	}
 
 	if (features)
 		features &= BTRFS_MKFS_DEFAULT_FEATURES;
-- 
2.6.2

