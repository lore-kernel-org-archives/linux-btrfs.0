Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:43963 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcFXIZ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 04:25:29 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 645F1AC01FA
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 17:25:22 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: fi show: print error message if no valid Btrfs
 is specified
Message-ID: <a22eda17-c639-9b2b-fa08-d4f0b032d4c9@jp.fujitsu.com>
Date: Fri, 24 Jun 2016 17:24:47 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* Before this patch

 ===============================
 # ./btrfs fi show foo      # "foo" doesn't mean any valid Btrfs
 #                          # no error message
 # echo $?
 1
 ===============================

* After this patch

 ===============================
 # ./btrfs fi show foo
 ERROR: foo is not a valid Btrfs
 #
 # echo $?
 1
 ===============================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 cmds-filesystem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 88867a3..90f3c49 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -898,9 +898,10 @@ devs_only:
 	list_for_each_entry(fs_devices, &all_uuids, list)
 		print_one_uuid(fs_devices, unit_mode);

-	if (search && !found)
+	if (search && !found) {
+		error("%s is not a valid Btrfs", search);
 		ret = 1;
-
+	}
 	while (!list_empty(&all_uuids)) {
 		fs_devices = list_entry(all_uuids.next,
 					struct btrfs_fs_devices, list);
-- 
2.5.5
