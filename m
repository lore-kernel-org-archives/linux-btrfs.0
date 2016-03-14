Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:38525 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298AbcCNA2H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 20:28:07 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E649AAC00FD
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 09:27:58 +0900 (JST)
Subject: [PATCH 4/4] btrfs-progs: "device ready" accepts just one device
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56E5FF9A.4020609@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56E6056A.4020307@jp.fujitsu.com>
Date: Mon, 14 Mar 2016 09:27:22 +0900
MIME-Version: 1.0
In-Reply-To: <56E5FF9A.4020609@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* actual result

  =======================================
  # ./btrfs device ready /dev/sdb foo
  #
  =======================================

* expecting result

  =======================================
  # ./btrfs device ready /dev/sdb foo
  btrfs device ready: too many arguments
  usage: btrfs device ready <device>

      Check device to see if it has all of its devices in cache for mounting

  #
  =======================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 cmds-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-device.c b/cmds-device.c
index 33da2ce..23656c3 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -326,7 +326,7 @@ static int cmd_device_ready(int argc, char **argv)

 	clean_args_no_options(argc, argv, cmd_device_ready_usage);

-	if (check_argc_min(argc - optind, 1))
+	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_device_ready_usage);

 	fd = open("/dev/btrfs-control", O_RDWR);
-- 
2.7.0
