Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40403 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758398Ab2IEJVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 05:21:25 -0400
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <wuzhy@linux.vnet.ibm.com>;
	Wed, 5 Sep 2012 05:21:24 -0400
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 1/2] btrfs-progs: Close file descriptor on exit
Date: Wed,  5 Sep 2012 17:21:06 +0800
Message-Id: <1346836867-1060-2-git-send-email-wuzhy@linux.vnet.ibm.com>
In-Reply-To: <1346836867-1060-1-git-send-email-wuzhy@linux.vnet.ibm.com>
References: <1346836867-1060-1-git-send-email-wuzhy@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  Need to close fd on exit.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 cmds-filesystem.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b1457de..e62c4fd 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -77,18 +77,23 @@ static int cmd_df(int argc, char **argv)
 	if (ret) {
 		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
 			path, strerror(e));
+		close(fd);
 		free(sargs);
 		return ret;
 	}
-	if (!sargs->total_spaces)
+	if (!sargs->total_spaces) {
+		close(fd);
 		return 0;
+	}
 
 	count = sargs->total_spaces;
 
 	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
 			(count * sizeof(struct btrfs_ioctl_space_info)));
-	if (!sargs)
+	if (!sargs) {
+		close(fd);
 		return -ENOMEM;
+	}
 
 	sargs->space_slots = count;
 	sargs->total_spaces = 0;
@@ -148,6 +153,7 @@ static int cmd_df(int argc, char **argv)
 		printf("%s: total=%s, used=%s\n", description, total_bytes,
 		       used_bytes);
 	}
+	close(fd);
 	free(sargs);
 
 	return 0;
-- 
1.7.6.5

