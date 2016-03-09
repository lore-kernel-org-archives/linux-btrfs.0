Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:43815 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934369AbcCIXFL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 18:05:11 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 831F4AC075D
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 08:05:04 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: Remove unnecessary variable devstart from
 cmd_device_scan()
Message-ID: <56E0AC1B.3020405@jp.fujitsu.com>
Date: Thu, 10 Mar 2016 08:04:59 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's unnecessary since it's always 1.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to devel (commit b2bdd0da8969).
---
 cmds-device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index cb470af..78d6535 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -246,7 +246,6 @@ static const char * const cmd_device_scan_usage[] = {
 static int cmd_device_scan(int argc, char **argv)
 {
 	int i;
-	int devstart = 1;
 	int all = 0;
 	int ret = 0;

@@ -282,7 +281,7 @@ static int cmd_device_scan(int argc, char **argv)
 		goto out;
 	}

-	for( i = devstart ; i < argc ; i++ ){
+	for (i = 1; i < argc; i++) {
 		char *path;

 		if (is_block_device(argv[i]) != 1) {
-- 
2.7.0

