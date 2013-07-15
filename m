Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43392 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3GOF0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:09 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 03/11] btrfs-progs: update device scan usage
Date: Mon, 15 Jul 2013 13:30:49 +0800
Message-Id: <1373866257-10519-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

the btrfs device scan usage didnt publish --all-devices
option so add it

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 9e7328b..c94fcd5 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -178,7 +178,7 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [<device>...]",
+	"btrfs device scan [<--all-devices>|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
 	NULL
 };
-- 
1.7.7.6

