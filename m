Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:55706 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaFXHcd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 03:32:33 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail2.fujitsu.co.jp (Postfix) with ESMTP id E85D93EE0C8
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 16:32:31 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 076C1AC015A
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 16:32:31 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id B4EB91DB8048
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 16:32:30 +0900 (JST)
Message-ID: <53A9290D.6090202@jp.fujitsu.com>
Date: Tue, 24 Jun 2014 16:30:21 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
CC: Adam Buchbinder <abuchbinder@google.com>, <dave@jikos.cz>
Subject: [PATCH] Avoid double-free of fs_devices->list.
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found the following patch is insufficient.

===============================================================================
commit 6e6b32ddf58db54f714d0f263c2589f4859e8b5e
Author: Adam Buchbinder <abuchbinder@google.com>
Date:   Fri Jun 13 16:43:56 2014 -0700

    btrfs-progs: Fix a use-after-free in the volumes code.
===============================================================================

"btrfs filesystem show <dev>" with this patch causes segmentation fault
if "<dev>" is a not-mounted Btrfs filesystem.

===============================================================================
# ./btrfs filesystem show /dev/sdd1
Label: none  uuid: <cut here>
        Total devices 1 FS bytes used 112.00KiB
        devid    1 size 59.12GiB used 2.04GiB path /dev/sdd1
                                                                                                                             
Segmentation fault (core dumped)
===============================================================================

It's due to double-free of fs_devices->list as follows.

===============================================================================
cmd_show
  -> list_del(&fs_devices->list)     # 1st one.
  -> btrfs_close_devices(fs_devices)
    -> list_del(&fs_devices->list)   # <- 2nd one introduced at 6e6b32dd.
                                          Double-free happens here.
===============================================================================

First list_del() can safely be removed because fs_devices->list will be
deleted by second one, soon.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Adam Buchbinder <abuchbinder@google.com>  

---
 cmds-filesystem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b1ba508..14cb6e0 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -716,7 +716,6 @@ devs_only:
 	while (!list_empty(all_uuids)) {
 		fs_devices = list_entry(all_uuids->next,
 					struct btrfs_fs_devices, list);
-		list_del(&fs_devices->list);
 		btrfs_close_devices(fs_devices);
 	}
 out:
-- 
1.9.3

