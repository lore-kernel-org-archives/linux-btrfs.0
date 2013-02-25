Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:9818 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759572Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 12/17] btrfs-progs: free allocated di_args in cmd_start_replace
Date: Mon, 25 Feb 2013 16:54:45 -0600
Message-Id: <1361832890-40921-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We only freed this allocation in error paths, and leaked
a bit when it went out of scope normally.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-replace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 9397396..4cc32df 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -228,6 +228,7 @@ static int cmd_start_replace(int argc, char **argv)
 		for (i = 0; i < fi_args.num_devices; i++)
 			if (start_args.start.srcdevid == di_args[i].devid)
 				break;
+		free(di_args);
 		if (i == fi_args.num_devices) {
 			fprintf(stderr, "Error: '%s' is not a valid devid for filesystem '%s'\n",
 				srcdev, path);
-- 
1.7.1

