Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56125 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/16] btrfs-progs: btrfs_scan_kernel(): fd==0 is not an error
Date: Wed,  6 Nov 2013 17:15:48 -0600
Message-Id: <1383779755-18228-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error return from open is -1, so test that, not 0,
for success/failure.

Resolves-Coverity-CID: 1125931
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-filesystem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index e6642ef..df9d1ff 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -362,13 +362,13 @@ static int btrfs_scan_kernel(void *search)
 		}
 
 		fd = open(mnt->mnt_dir, O_RDONLY);
-		if (fd > 0 && !get_df(fd, &space_info_arg)) {
+		if ((fd != -1) && !get_df(fd, &space_info_arg)) {
 			get_label_mounted(mnt->mnt_dir, label);
 			print_one_fs(&fs_info_arg, dev_info_arg,
 					space_info_arg, label, mnt->mnt_dir);
 			free(space_info_arg);
 		}
-		if (fd > 0)
+		if (fd != -1)
 			close(fd);
 		free(dev_info_arg);
 	}
-- 
1.7.1

