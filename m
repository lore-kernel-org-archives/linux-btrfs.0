Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:26222 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbcCKA0X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 19:26:23 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B2887AC01FB
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 09:26:17 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: Fix device scan to interpret its argument
 properly
Message-ID: <56E210A5.8030100@jp.fujitsu.com>
Date: Fri, 11 Mar 2016 09:26:13 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the following bug.

  ================================
  # btrfs device scan -- /dev/sdb
  ERROR: not a block device: --
  ================================

It should work as follow.

  ================================
  # ./btrfs device scan -- /dev/sdb
  Scanning for Btrfs filesystems in '/dev/sdb'
  ================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to devel (commit: 5d038a7ed212)
---
 cmds-device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-device.c b/cmds-device.c
index 94ffdc5..e500638 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -246,7 +246,7 @@ static const char * const cmd_device_scan_usage[] = {
 static int cmd_device_scan(int argc, char **argv)
 {
 	int i;
-	int devstart = 1;
+	int devstart;
 	int all = 0;
 	int ret = 0;

@@ -269,6 +269,7 @@ static int cmd_device_scan(int argc, char **argv)
 			usage(cmd_device_scan_usage);
 		}
 	}
+	devstart = optind;

 	if (all && check_argc_max(argc - optind, 1))
 		usage(cmd_device_scan_usage);
-- 
2.5.0
