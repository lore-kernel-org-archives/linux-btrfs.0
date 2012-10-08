Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:57775 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab2JHTIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 15:08:10 -0400
From: Dieter Ries <mail@dieterries.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: Dieter Ries <mail@dieterries.net>
Subject: [PATCH 4/4] btrfs-progs: btrfsck: Remove binary error code output
Date: Mon,  8 Oct 2012 21:07:50 +0200
Message-Id: <1349723270-12773-5-git-send-email-mail@dieterries.net>
In-Reply-To: <1349723270-12773-1-git-send-email-mail@dieterries.net>
References: <1349723270-12773-1-git-send-email-mail@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch changes the output after checking a filesystem. Before, the
default output was "found x bytes used err is 0", where the last integer
corresponds to the return value of check_root_refs(), which is either 1
or 0. Now this value is evaluated, and a message saying if errors were
found or not is printed.

Signed-off-by: Dieter Ries <mail@dieterries.net>
---
 btrfsck.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 83275cd..45ce681 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3613,8 +3613,11 @@ out:
 		       "backup data and re-format the FS. *\n\n");
 		ret = 1;
 	}
-	printf("found %llu bytes used err is %d\n",
-	       (unsigned long long)bytes_used, ret);
+	if (ret)
+		printf("Filesystem is damaged! One or more errors found.\n");
+	else
+		printf("Filesystem is clean! No errors found.\n");
+	printf("%llu bytes used\n",(unsigned long long)bytes_used);
 	printf("total csum bytes: %llu\n",(unsigned long long)total_csum_bytes);
 	printf("total tree bytes: %llu\n",
 	       (unsigned long long)total_btree_bytes);
-- 
1.7.3.GIT

