Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63066 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754536AbaGCCMI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 22:12:08 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s632C4wA013408
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 10:12:04 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: add mount status check for btrfs-image
Date: Thu, 3 Jul 2014 10:06:34 +0800
Message-ID: <1404353196-10914-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs-image tool should not be run on a mounted filesystem.
The undergoing fs operations may change what you have imaged a while ago,
this makes the image meanmingless.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 985aa26..9719d1c 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2570,10 +2570,20 @@ int main(int argc, char *argv[])
 			num_threads = 1;
 	}
 
-	if (create)
+	if (create) {
+		ret = check_mounted(source);
+		if (ret < 0) {
+			fprintf(stderr, "Could not check mount status: %s\n",
+			strerror(-ret));
+			exit(1);
+		} else if (ret) {
+			fprintf(stderr, "The device is busy\n");
+			exit(1);
+		}
+
 		ret = create_metadump(source, out, num_threads,
 				      compress_level, sanitize, walk_trees);
-	else
+	} else
 		ret = restore_metadump(source, out, old_restore, 1,
 				       multi_devices);
 	if (ret) {
-- 
1.8.1.4

