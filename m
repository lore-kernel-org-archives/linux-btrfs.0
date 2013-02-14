Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760806Ab3BNS3w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 13:29:52 -0500
Date: Thu, 14 Feb 2013 10:29:50 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: btrfs-progs: Fix pointer math in __ino_to_path_fd
Message-ID: <20130214182950.GB31017@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are casting an array of u64 values into a char ** array so
when we dereference this array (as a char **) on a 32 bit system
we're then re-casting that back to a 32 bit value. This causes
problems when we try to print those strings.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 cmds-inspect.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 25b83d2..371bd34 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -61,12 +61,15 @@ static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 			fspath->elem_cnt, fspath->elem_missed);
 
 	for (i = 0; i < fspath->elem_cnt; ++i) {
-		char **str = (char **)fspath->val;
-		str[i] += (unsigned long)fspath->val;
+		u64 ptr;
+		char *str;
+		ptr = (u64)(unsigned long)fspath->val;
+		ptr += fspath->val[i];
+		str = (char *)(unsigned long)ptr;
 		if (prepend)
-			printf("%s/%s\n", prepend, str[i]);
+			printf("%s/%s\n", prepend, str);
 		else
-			printf("%s\n", str[i]);
+			printf("%s\n", str);
 	}
 
 out:
-- 
1.7.10.4

