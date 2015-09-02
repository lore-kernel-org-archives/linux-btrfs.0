Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17084 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752058AbbIBJlj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 05:41:39 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t829fPVv023639
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Sep 2015 17:41:25 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: stat info for btrfs rescue chunk-recover
Date: Wed, 2 Sep 2015 17:39:55 +0800
Message-ID: <9edcb6f091b14a9dc54677261e09ca72b9048262.1441186744.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441186744.git.zhaolei@cn.fujitsu.com>
References: <cover.1441186744.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

chunk-recover need to use many many time in scan_devices(),
and no output in screen:
 # btrfs rescue chunk-recover /dev/sda6
 (no output here, but need long time)

To notice user that "the command is not hang", this patch add
dynamic updated stat information in above period:
 # btrfs rescue chunk-recover /dev/sda6
 Scanning: DONE in dev[0], 19998441472 in dev[1], DONE in dev[2]
 (until)
 Scanning: DONE in dev0, DONE in dev1, DONE in dev2
 Check chunks successfully with no orphans
 Recover the chunk tree successfully.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 chunk-recover.c | 72 ++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 18 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 66a4ce6..7698ee0 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -76,6 +76,7 @@ struct device_scan {
 	struct recover_control *rc;
 	struct btrfs_device *dev;
 	int fd;
+	u64 bytenr;
 };
 
 static struct extent_record *btrfs_new_extent_record(struct extent_buffer *eb)
@@ -766,6 +767,8 @@ static int scan_one_device(void *dev_scan_struct)
 
 	bytenr = 0;
 	while (1) {
+		dev_scan->bytenr = bytenr;
+
 		if (is_super_block_address(bytenr))
 			bytenr += rc->sectorsize;
 
@@ -832,9 +835,8 @@ static int scan_devices(struct recover_control *rc)
 	int *t_rets;
 	int devnr = 0;
 	int devidx = 0;
-	int cancel_from = 0;
-	int cancel_to = 0;
 	int i;
+	int all_done;
 
 	list_for_each_entry(dev, &rc->fs_devices->devices, dev_list)
 		devnr++;
@@ -860,30 +862,64 @@ static int scan_devices(struct recover_control *rc)
 		dev_scans[devidx].rc = rc;
 		dev_scans[devidx].dev = dev;
 		dev_scans[devidx].fd = fd;
-		ret = pthread_create(&t_scans[devidx], NULL,
-				     (void *)scan_one_device,
-				     (void *)&dev_scans[devidx]);
-		if (ret) {
-			cancel_from = 0;
-			cancel_to = devidx - 1;
-			goto out1;
-		}
+		dev_scans[devidx].bytenr = -1;
 		devidx++;
 	}
 
 	for (i = 0; i < devidx; i++) {
-		ret = pthread_join(t_scans[i], (void **)&t_rets[i]);
-		if (ret || t_rets[i]) {
-			ret = 1;
-			cancel_from = i + 1;
-			cancel_to = devnr - 1;
+		ret = pthread_create(&t_scans[i], NULL,
+				     (void *)scan_one_device,
+				     (void *)&dev_scans[i]);
+		if (ret)
 			goto out1;
+
+		dev_scans[i].bytenr = 0;
+	}
+
+	while (1) {
+		all_done = 1;
+		for (i = 0; i < devidx; i++) {
+			if (dev_scans[i].bytenr == -1)
+				continue;
+			ret = pthread_tryjoin_np(t_scans[i],
+						 (void **)&t_rets[i]);
+			if (ret == EBUSY) {
+				all_done = 0;
+				continue;
+			}
+			if (ret || t_rets[i]) {
+				ret = 1;
+				goto out1;
+			}
+			dev_scans[i].bytenr = -1;
+		}
+
+		printf("\rScanning: ");
+		for (i = 0; i < devidx; i++) {
+			if (dev_scans[i].bytenr == -1)
+				printf("%sDONE in dev%d",
+				       i ? ", " : "", i);
+			else
+				printf("%s%llu in dev%d",
+				       i ? ", " : "", dev_scans[i].bytenr, i);
 		}
+		/* clear chars if exist in tail */
+		printf("                ");
+		printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
+		fflush(stdout);
+
+		if (all_done) {
+			printf("\n");
+			break;
+		}
+
+		sleep(1);
 	}
 out1:
-	while (ret && (cancel_from <= cancel_to)) {
-		pthread_cancel(t_scans[cancel_from]);
-		cancel_from++;
+	for (i = 0; i < devidx; i++) {
+		if (dev_scans[i].bytenr == -1)
+			continue;
+		pthread_cancel(t_scans[i]);
 	}
 out2:
 	free(dev_scans);
-- 
1.8.5.1

