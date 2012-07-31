Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56014 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2GaAyp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 20:54:45 -0400
Received: by weyx8 with SMTP id x8so3987052wey.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 17:54:44 -0700 (PDT)
From: Alexander Karbstein <alexander.karbstein@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Karbstein <alexander.karbstein@gmail.com>
Subject: [PATCH] Btrfs-progs: Enabled setting root subvolume with subvolid=0
Date: Tue, 31 Jul 2012 00:53:25 +0000
Message-Id: <1343696005-23703-1-git-send-email-alexander.karbstein@gmail.com>
In-Reply-To: <CA+=FuiWE4QVFrbTY_dQyABABJyvD=xtpEFKe4Ob9pqeZQ9NysA@mail.gmail.com>
References: <CA+=FuiWE4QVFrbTY_dQyABABJyvD=xtpEFKe4Ob9pqeZQ9NysA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The command btrfs subvolume set-default 0 /path/to/fs changed the
default subvolume to whatever subvolume was currently mounted on
/path/to/fs. This patch changes this behaviour to set the default
subvolume to BTRFS_FS_TREE_OBJECTID in case the user asks for
subvolid=0

Signed-off-by: Alexander Karbstein <alexander.karbstein@gmail.com>
---
 btrfs_cmds.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index f2b6355..699d9b0 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -964,6 +964,11 @@ int do_set_default_subvol(int nargs, char **argv)
 		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
 		return 30;
 	}
+	
+	/* Using the original root fs tree */
+	if (objectid == 0ULL) {
+		objectid = BTRFS_FS_TREE_OBJECTID;
+	}
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
 	e = errno;
 	close(fd);
-- 
1.7.2.5

