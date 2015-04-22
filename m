Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41650 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754427AbbDVDru (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 23:47:50 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: report failure when resize ioctl fails
Date: Tue, 21 Apr 2015 23:38:47 -0400
Message-Id: <1429673927-3854-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The BTRFS_IOC_RESIZE ioctl returns 0 on success, negative for POSIX
errors, and positive for btrfs-specific errors.

If resize fails with a btrfs-specific error, decode the error and
report it.  If we can't decode the error, report its numeric value so
that the userspace tool is not instantly useless when a new error code
is defined in the kernel.

Exit with non-zero status on any resize error.  This is very important
for scripts that will shrink the underlying storage when btrfs reports
success!
---
 cmds-filesystem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f3fc160..85f0406 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1263,6 +1263,16 @@ static int cmd_resize(int argc, char **argv)
 		fprintf(stderr, "ERROR: unable to resize '%s' - %s\n", 
 			path, strerror(e));
 		return 1;
+	} else if (res > 0) {
+		const char *err_str = btrfs_err_str(res);
+		if (err_str) {
+			fprintf(stderr, "ERROR: btrfs error resizing '%s' - %s\n",
+				path, err_str);
+		} else {
+			fprintf(stderr, "ERROR: btrfs error resizing '%s' - unknown btrfs_err_code %d\n",
+				path, res);
+		}
+		return 1;
 	}
 	return 0;
 }
-- 
1.7.10.4

