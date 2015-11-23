Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47281 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbbKWM41 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 07:56:27 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 4/5] btrfs-progs: kernel based default features for btrfs-convert
Date: Mon, 23 Nov 2015 20:56:17 +0800
Message-Id: <1448283378-10579-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-convert convert FS with latest default features enabled, and
if the kernel is down-rev and does not support a latest feature then
mount fails, as expected.

This patch disables default features based on the running kernel.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Check if sysfs tells what features are supported

 btrfs-convert.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 73ac584..52ea12a 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2896,7 +2896,15 @@ int main(int argc, char *argv[])
 	int progress = 1;
 	char *file;
 	char fslabel[BTRFS_LABEL_SIZE];
-	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 features;
+
+	if (btrfs_features_allowed_by_sysfs(&features))
+		features = btrfs_features_allowed_by_kernel();
+
+	if (features)
+		features &= BTRFS_MKFS_DEFAULT_FEATURES;
+	else
+		features = BTRFS_MKFS_DEFAULT_FEATURES;
 
 	while(1) {
 		enum { GETOPT_VAL_NO_PROGRESS = 256 };
-- 
2.6.2

