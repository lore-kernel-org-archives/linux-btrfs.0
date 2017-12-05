Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33316 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751840AbdLEIjy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:39:54 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 827C0ACAE
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 08:39:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/7] btrfs-progs: Factor out common print_device_info
Date: Tue,  5 Dec 2017 10:39:44 +0200
Message-Id: <1512463189-24724-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-1-git-send-email-nborisov@suse.com>
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function has been copied twice in chunk-recover and super-recover. Factor
it out into utils.c/h and use it. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 chunk-recover.c | 18 ------------------
 super-recover.c | 13 -------------
 utils.c         | 18 ++++++++++++++++++
 utils.h         |  3 +++
 4 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 4a6d7141ae80..705bcf52379d 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -451,24 +451,6 @@ static void print_device_extent_tree(struct device_extent_tree *tree)
 	printf("\n");
 }
 
-static void print_device_info(struct btrfs_device *device, char *prefix)
-{
-	if (prefix)
-		printf("%s", prefix);
-	printf("Device: id = %llu, name = %s\n",
-	       device->devid, device->name);
-}
-
-static void print_all_devices(struct list_head *devices)
-{
-	struct btrfs_device *dev;
-
-	printf("All Devices:\n");
-	list_for_each_entry(dev, devices, dev_list)
-		print_device_info(dev, "\t");
-	printf("\n");
-}
-
 static void print_scan_result(struct recover_control *rc)
 {
 	if (!rc->verbose)
diff --git a/super-recover.c b/super-recover.c
index 6b80416f976a..6a13d81b0b29 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -186,19 +186,6 @@ static struct super_block_record *recover_get_good_super(
 	return record;
 }
 
-static void print_all_devices(struct list_head *devices)
-{
-	struct btrfs_device *dev;
-
-	printf("All Devices:\n");
-	list_for_each_entry(dev, devices, dev_list) {
-		printf("\t");
-		printf("Device: id = %llu, name = %s\n",
-			dev->devid, dev->name);
-	}
-	printf("\n");
-}
-
 static void print_super_info(struct super_block_record *record)
 {
 	printf("\t\tdevice name = %s\n", record->device_name);
diff --git a/utils.c b/utils.c
index 524f463d3140..6c0d9fc1bebf 100644
--- a/utils.c
+++ b/utils.c
@@ -2701,3 +2701,21 @@ unsigned long total_memory(void)
         }
         return si.totalram * si.mem_unit;       /* bytes */
 }
+
+void print_device_info(struct btrfs_device *device, char *prefix)
+{
+	if (prefix)
+		printf("%s", prefix);
+	printf("Device: id = %llu, name = %s\n",
+	       device->devid, device->name);
+}
+
+void print_all_devices(struct list_head *devices)
+{
+	struct btrfs_device *dev;
+
+	printf("All Devices:\n");
+	list_for_each_entry(dev, devices, dev_list)
+		print_device_info(dev, "\t");
+	printf("\n");
+}
diff --git a/utils.h b/utils.h
index a82d46f6d7cc..e31ed34426c4 100644
--- a/utils.h
+++ b/utils.h
@@ -171,6 +171,9 @@ int prefixcmp(const char *str, const char *prefix);
 
 unsigned long total_memory(void);
 
+
+void print_device_info(struct btrfs_device *device, char *prefix);
+void print_all_devices(struct list_head *devices);
 /*
  * Global program state, configurable by command line and available to
  * functions without extra context passing.
-- 
2.7.4

