Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:52857 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759366Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/17] btrfs-progs: more scrub cancel error handling
Date: Mon, 25 Feb 2013 16:54:41 -0600
Message-Id: <1361832890-40921-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we request scrub cancel on an unmounted or
non-btrfs device, we still get a "scrub canceled"
success message:

# btrfs scrub cancel /dev/loop1
scrub cancelled
# blkid /dev/loop1
/dev/loop1: UUID="7f586941-1d5e-4ba7-9caa-b35934849957" TYPE="xfs"

Fix this so that if check_mounted_where returns 0
we don't report success.

While we're at it, use perror to report the reason for an open
failure, if we get one.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-scrub.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 353d9cb..da4120f 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1451,7 +1451,7 @@ static int cmd_scrub_cancel(int argc, char **argv)
 again:
 	fdmnt = open_file_or_dir(path);
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: scrub cancel failed\n");
+		perror("ERROR: scrub cancel failed:");
 		return 1;
 	}
 
@@ -1462,11 +1462,18 @@ again:
 		/* path is not a btrfs mount point.  See if it's a device. */
 		ret = check_mounted_where(fdmnt, path, mp, sizeof(mp),
 					  &fs_devices_mnt);
-		if (ret) {
-			/* It is a device; try again with the mountpoint. */
+		if (ret > 0) {
+			/* It's a mounted btrfs device; retry w/ mountpoint. */
 			close(fdmnt);
 			path = mp;
 			goto again;
+		} else {
+			/* It's not a mounted btrfs device either */
+			fprintf(stderr,
+				"ERROR: %s is not a mounted btrfs device\n",
+				path);
+			ret = 1;
+			err = EINVAL;
 		}
 	}
 
@@ -1474,7 +1481,7 @@ again:
 
 	if (ret) {
 		fprintf(stderr, "ERROR: scrub cancel failed on %s: %s\n", path,
-			err == ENOTCONN ? "not running" : strerror(errno));
+			err == ENOTCONN ? "not running" : strerror(err));
 		return 1;
 	}
 
-- 
1.7.1

