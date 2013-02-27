Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37909 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab3B0CcO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 21:32:14 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 2FA1B3EE0BB
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 11:32:13 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 18AAF45DE55
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 11:32:13 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 0188E45DE58
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 11:32:13 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id E5261E0800E
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 11:32:12 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9F4DAE08004
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 11:32:12 +0900 (JST)
Message-Id: <201302270231.AA00022@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 27 Feb 2013 11:31:54 +0900
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix segmentation fault of "btrfs check"
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Segmentation fault occurred in the following command.

 # btrfs check /dev/sdc7
 No valid Btrfs found on /dev/sdc7
 Segmentation fault (core dumped)

Fix it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 cmds-check.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index d63e945..5d2e9ed 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3610,12 +3610,12 @@ int cmd_check(int argc, char **argv)
 	}
 
 	info = open_ctree_fs_info(argv[optind], bytenr, rw, 1);
-	uuid_unparse(info->super_copy.fsid, uuidbuf);
-	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
-
 	if (info == NULL)
 		return 1;
 
+	uuid_unparse(info->super_copy.fsid, uuidbuf);
+	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
+
 	if (!extent_buffer_uptodate(info->tree_root->node) ||
 	    !extent_buffer_uptodate(info->dev_root->node) ||
 	    !extent_buffer_uptodate(info->extent_root->node) ||

