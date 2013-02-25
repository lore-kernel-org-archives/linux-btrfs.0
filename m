Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:37174 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759571Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/17] btrfs-progs: provide positive errno to strerror in cmd_restore
Date: Mon, 25 Feb 2013 16:54:44 -0600
Message-Id: <1361832890-40921-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

check_mounted returns a negative errno, so it needs to be flipped
again before passing to strerror.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-restore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 12b2188..9385042 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -836,7 +836,7 @@ int cmd_restore(int argc, char **argv)
 
 	if ((ret = check_mounted(argv[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n",
-			strerror(ret));
+			strerror(-ret));
 		return ret;
 	} else if (ret) {
 		fprintf(stderr, "%s is currently mounted.  Aborting.\n", argv[optind]);
-- 
1.7.1

