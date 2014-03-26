Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:12778 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756065AbaCZTee (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 15:34:34 -0400
Date: Wed, 26 Mar 2014 21:34:30 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: chunk_recovery: fix mem leak and pthread_cancel
 call
Message-ID: <20140326193429.GA2947@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Free memory if open call fails. Prevent pthread_cancel on threads
which have already finished successfully. If all calls to
pthread_create and pthread_join are successful, we mistakenly call
pthread_cancel because cancel_from and cancel_to are both zero.

Make POSIX.1-2001 happy by supplying a non-NULL second argument to
pthread_setcanceltype.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 chunk-recover.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index a05e644..613d715 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -745,8 +745,9 @@ static int scan_one_device(void *dev_scan_struct)
 	struct recover_control *rc = dev_scan->rc;
 	struct btrfs_device *device = dev_scan->dev;
 	int fd = dev_scan->fd;
+	int oldtype;
 
-	ret = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);
+	ret = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &oldtype);
 	if (ret)
 		return 1;
 
@@ -845,7 +846,8 @@ static int scan_devices(struct recover_control *rc)
 		if (fd < 0) {
 			fprintf(stderr, "Failed to open device %s\n",
 				dev->name);
-			return -1;
+			ret = 1;
+			goto out2;
 		}
 		dev_scans[devidx].rc = rc;
 		dev_scans[devidx].dev = dev;
@@ -856,7 +858,7 @@ static int scan_devices(struct recover_control *rc)
 		if (ret) {
 			cancel_from = 0;
 			cancel_to = devidx - 1;
-			goto out;
+			goto out1;
 		}
 		devidx++;
 	}
@@ -868,15 +870,16 @@ static int scan_devices(struct recover_control *rc)
 			ret = 1;
 			cancel_from = i + 1;
 			cancel_to = devnr - 1;
-			break;
+			goto out1;
 		}
 		i++;
 	}
-out:
-	while (cancel_from <= cancel_to) {
+out1:
+	while (ret && (cancel_from <= cancel_to)) {
 		pthread_cancel(t_scans[cancel_from]);
 		cancel_from++;
 	}
+out2:
 	free(dev_scans);
 	free(t_scans);
 	free(t_rets);
-- 
1.8.5.3

