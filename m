Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:57972 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbcCNADY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 20:03:24 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 2117FAC0137
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 09:03:20 +0900 (JST)
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH 1/4] btrfs-progs: Avoid interpreting options after "--" when
 getting unit mode
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <56E5FF9A.4020609@jp.fujitsu.com>
Date: Mon, 14 Mar 2016 09:02:34 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* actual result

  ======================================
  # ./btrfs device usage -- -m /btrfs

  /dev/sdf1, ID: 1
     Device size:          95367.41MiB
     Data,single:          2056.00MiB
     Metadata,DUP:         2048.00MiB
     System,DUP:             16.00MiB
     Unallocated:          91247.41MiB
  ======================================

* expected result

  ======================================
  # ./btrfs device usage -- -m /btrfs

  ERROR: can't access '-m': No such file or directory
  ======================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to devel branch (commit: 31266d0ef811).
---
 utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils.c b/utils.c
index d7ceaa8..77f0f68 100644
--- a/utils.c
+++ b/utils.c
@@ -3024,6 +3024,9 @@ unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode)
 	int arg_end;

 	for (arg_i = 0; arg_i < *argc; arg_i++) {
+		if (!strcmp(argv[arg_i], "--"))
+			break;
+
 		if (!strcmp(argv[arg_i], "--raw")) {
 			unit_mode = UNITS_RAW;
 			argv[arg_i] = NULL;
-- 
2.7.0
