Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:57421 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752361Ab3BYVzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 16/17] btrfs-progs: fix fd leak in cmd_subvol_set_default
Date: Mon, 25 Feb 2013 16:54:49 -0600
Message-Id: <1361832890-40921-17-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rearrange cmd_subvol_set_default() slightly so we
don't have to close the fd on an error return.

While we're at it, fix whitespace & remove magic
return values.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-subvolume.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 0dfaefe..461eed9 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -712,24 +712,25 @@ static int cmd_subvol_set_default(int argc, char **argv)
 	subvolid = argv[1];
 	path = argv[2];
 
+	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
+	if (errno == ERANGE) {
+		fprintf(stderr, "ERROR: invalid tree id (%s)\n", subvolid);
+		return 1;
+	}
+
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
-	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
-	if (errno == ERANGE) {
-		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
-		return 30;
-	}
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
 	e = errno;
 	close(fd);
-	if( ret < 0 ){
+	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to set a new default subvolume - %s\n",
 			strerror(e));
-		return 30;
+		return 1;
 	}
 	return 0;
 }
-- 
1.7.1

