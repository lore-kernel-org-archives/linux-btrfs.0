Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:53428 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752361Ab3BYVzP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/17] btrfs-progs: Remove write-only var fdres in cmd_dev_stats()
Date: Mon, 25 Feb 2013 16:54:36 -0600
Message-Id: <1361832890-40921-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fdres is initialized to -1, then later tested, but never
set.  Just remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-device.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 198ad68..58df6da 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -295,7 +295,6 @@ static int cmd_dev_stats(int argc, char **argv)
 	int fdmnt;
 	int i;
 	char c;
-	int fdres = -1;
 	int err = 0;
 	__u64 flags = 0;
 
@@ -390,8 +389,6 @@ static int cmd_dev_stats(int argc, char **argv)
 out:
 	free(di_args);
 	close(fdmnt);
-	if (fdres > -1)
-		close(fdres);
 
 	return err;
 }
-- 
1.7.1

