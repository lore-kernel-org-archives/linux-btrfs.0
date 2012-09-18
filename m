Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27076 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab2IRKzJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 06:55:09 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8IAt84t016496
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 18:55:08 +0800
Message-ID: <5058530B.9070302@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 18:55:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 3/7] Btrfs-progs: fix wrong usage of btrfs subvolume list
 command
References: <50584E6D.8000602@cn.fujitsu.com>
In-Reply-To: <50584E6D.8000602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

Since the uuid output function has been implemented, we should update
the usage to tell the users.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v3 -> v4:
- no change.

Changelog v1 -> v3:
- new patch
---
 cmds-subvolume.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ffc5d95..cd4b5a7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -258,10 +258,11 @@ static int cmd_subvol_delete(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-ps] <path>",
+	"btrfs subvolume list [-pu] [-s 0|1] <path>",
 	"List subvolumes (and snapshots)",
 	"",
 	"-p           print parent ID",
+	"-u           print the uuid of subvolumes (and snapshots)",
 	"-s value     list snapshots with generation in ascending/descending order",
 	"             (1: ascending, 0: descending)",
 	NULL
-- 
1.7.6.5

