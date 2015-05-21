Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-01.aalto.fi ([130.233.228.120]:59271 "EHLO
	smtp-out-01.aalto.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbbEUPwb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 11:52:31 -0400
From: jekarlson@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Emil Karlson <jekarlson@gmail.com>
Subject: [PATCH] btrfs-progs: use openat for process_clone in receive
Date: Thu, 21 May 2015 18:42:29 +0300
Message-Id: <1432222949-604-1-git-send-email-jekarlson@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Emil Karlson <jekarlson@gmail.com>

This will fix breakage, when doing chrooted receive with cloned paths
outside main subvolume.
---
 cmds-receive.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index b7cf3f9..b0a312c 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -609,9 +609,9 @@ static int process_clone(const char *path, u64 offset, u64 len,
 		subvol_path = strdup(si->path);
 	}
 
-	full_clone_path = path_cat3(r->root_path, subvol_path, clone_path);
+	full_clone_path = path_cat(subvol_path, clone_path);
 
-	clone_fd = open(full_clone_path, O_RDONLY | O_NOATIME);
+	clone_fd = openat(r->mnt_fd, full_clone_path, O_RDONLY | O_NOATIME);
 	if (clone_fd < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: failed to open %s. %s\n",
-- 
2.3.6

