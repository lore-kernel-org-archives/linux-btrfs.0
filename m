Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56119 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab3KFXP5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/16] btrfs-progs: fix error returns in get_df()
Date: Wed,  6 Nov 2013 17:15:41 -0600
Message-Id: <1383779755-18228-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_df returns -ERRNO, or maybe (+)errno, or even 0 in
the case where we inexplicably got 0 total_spaces from
the BTRFS_IOC_SPACE_INFO.

Consistently return a negative error number, and return
-ENOENT rather than 0 for total_spaces == 0, so that the
caller will know that **sargs_ret hasn't been set up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-filesystem.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 0bfd710..e6642ef 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -106,11 +106,12 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 		fprintf(stderr, "ERROR: couldn't get space info - %s\n",
 			strerror(e));
 		free(sargs);
-		return ret;
+		return -e;
 	}
+	/* This really should never happen */
 	if (!sargs->total_spaces) {
 		free(sargs);
-		return 0;
+		return -ENOENT;
 	}
 	count = sargs->total_spaces;
 	free(sargs);
@@ -128,7 +129,7 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 		fprintf(stderr, "ERROR: get space info count %llu - %s\n",
 				count, strerror(e));
 		free(sargs);
-		return ret;
+		return -e;
 	}
 	*sargs_ret = sargs;
 	return 0;
-- 
1.7.1

