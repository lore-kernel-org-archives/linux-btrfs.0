Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:10454 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759154Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/17] btrfs-progs: fix close of error fd in scrub cancel
Date: Mon, 25 Feb 2013 16:54:40 -0600
Message-Id: <1361832890-40921-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we retry opening the mountpoint and fail, we'll call
close on a filehandle w/ value -1.  Rearrange so the
retry uses the same open and same error handling.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-scrub.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index b984e96..353d9cb 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1448,13 +1448,13 @@ static int cmd_scrub_cancel(int argc, char **argv)
 
 	path = argv[1];
 
+again:
 	fdmnt = open_file_or_dir(path);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: scrub cancel failed\n");
-		return 12;
+		return 1;
 	}
 
-again:
 	ret = ioctl(fdmnt, BTRFS_IOC_SCRUB_CANCEL, NULL);
 	err = errno;
 
@@ -1463,13 +1463,10 @@ again:
 		ret = check_mounted_where(fdmnt, path, mp, sizeof(mp),
 					  &fs_devices_mnt);
 		if (ret) {
-			/* It is a device; open the mountpoint. */
+			/* It is a device; try again with the mountpoint. */
 			close(fdmnt);
-			fdmnt = open_file_or_dir(mp);
-			if (fdmnt >= 0) {
-				path = mp;
-				goto again;
-			}
+			path = mp;
+			goto again;
 		}
 	}
 
-- 
1.7.1

