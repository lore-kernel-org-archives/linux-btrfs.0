Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dragon.cz ([213.168.176.4]:49730 "EHLO smtp.dragon.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbbAIVdc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 16:33:32 -0500
Received: from i3.doma (fw501.dragon.cz [213.168.176.131])
	by smtp.dragon.cz (8.13.8/8.13.8) with ESMTP id t09LRLGY019168
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Jan 2015 22:27:22 +0100
From: Martin Volf <martin.volf.42@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Remove redundant short description from cmd_snapshot_usage
Date: Fri,  9 Jan 2015 22:27:21 +0100
Message-Id: <1420838841-20944-1-git-send-email-martin.volf.42@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmd_snapshot_usage in cmds-subvolume.c contains the short description
twice. Remove the first one.

Signed-off-by: Martin Volf <martin.volf.42@gmail.com>
---

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 15d4b97..9618cae 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -565,7 +565,6 @@ out:
 }
 
 static const char * const cmd_snapshot_usage[] = {
-	"btrfs subvolume snapshot [-r] <source> <dest>|[<dest>/]<name>",
 	"btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
 	"Create a snapshot of the subvolume",
 	"Create a writable/readonly snapshot of the subvolume <source> with",
