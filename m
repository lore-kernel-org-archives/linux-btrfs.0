Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:43994 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758699Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/17] btrfs-progs: fix open error test in cmd_start_replace
Date: Mon, 25 Feb 2013 16:54:39 -0600
Message-Id: <1361832890-40921-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

open() returns a negative fd on failure, not 0.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-replace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index d14c9b5..9397396 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -235,7 +235,7 @@ static int cmd_start_replace(int argc, char **argv)
 		}
 	} else {
 		fdsrcdev = open(srcdev, O_RDWR);
-		if (!fdsrcdev) {
+		if (fdsrcdev < 0) {
 			fprintf(stderr, "Error: Unable to open device '%s'\n",
 				srcdev);
 			goto leave_with_error;
-- 
1.7.1

