Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38770 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753502AbeAOE1g (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Sun, 14 Jan 2018 23:27:36 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] btrfs-progs: fsck: Continue check even if we find space cache problem
Date: Mon, 15 Jan 2018 12:27:22 +0800
Message-Id: <20180115042722.25435-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Space cache itself is not a fatal part of btrfs (especially for v1 space
cache), and if we find something wrong it can be caused by other more
serious problem.

So continue to check more important trees even we found something wrong
in free space cache.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 7fc30da83ea1..6083ac0dd032 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -15000,7 +15000,10 @@ int cmd_check(int argc, char **argv)
 			error("errors found in free space tree");
 		else
 			error("errors found in free space cache");
-		goto out;
+		/*
+		 * Space cache problem is not fatal, and normally indicates more
+		 * serious problem, so continue check to expose the cause.
+		 */
 	}
 
 	/*
-- 
2.15.1

