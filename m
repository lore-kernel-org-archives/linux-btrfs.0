Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52328 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2GaRUR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 13:20:17 -0400
Received: by wibhr14 with SMTP id hr14so3127427wib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 10:20:16 -0700 (PDT)
From: Alexander Karbstein <alexander.karbstein@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Karbstein <alexander.karbstein@gmail.com>
Subject: [PATCH V2] Btrfs-progs: Enabled setting root subvolume with subvolid=0
Date: Tue, 31 Jul 2012 19:11:21 +0200
Message-Id: <1343754681-4454-2-git-send-email-alexander.karbstein@gmail.com>
In-Reply-To: <50173463.5060405@cn.fujitsu.com>
References: <50173463.5060405@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The command btrfs subvolume set-default 0 /path/to/fs changed the
default subvolume to whatever subvolume was currently mounted on
/path/to/fs. This patch changes this behaviour to set the default
subvolume to BTRFS_FS_TREE_OBJECTID in case the user asks for
subvolid=0

Signed-off-by: Alexander Karbstein <alexander.karbstein@gmail.com>
---
 cmds-subvolume.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 3508ce6..8f8c918 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -25,6 +25,7 @@
 #include <limits.h>
 
 #include "kerncompat.h"
+#include "ctree.h"
 #include "ioctl.h"
 
 #include "commands.h"
@@ -464,6 +465,9 @@ static int cmd_subvol_set_default(int argc, char **argv)
 		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
 		return 30;
 	}
+	/* Using the original root fs tree */
+	if (objectid == 0ULL)
+		objectid = BTRFS_FS_TREE_OBJECTID;
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
 	e = errno;
 	close(fd);
-- 
1.7.2.5

