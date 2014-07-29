Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46898 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaG2ADk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 20:03:40 -0400
Received: by mail-pd0-f182.google.com with SMTP id fp1so10755127pdb.13
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jul 2014 17:03:39 -0700 (PDT)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] btrfs-progs: add always option to restore's looping prompt
Date: Mon, 28 Jul 2014 17:03:31 -0700
Message-Id: <1406592211-7726-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you are using btrfs restore to try to recover a very large or
fragmented file, you may encounter _lots_ of prompts requiring
you to press 'y' to continue because we are looping a lot.

Add the option to press 'a', to supress these prompts for the rest
of the file.
---
 cmds-restore.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 96b97e1..ae95d5a 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -410,17 +410,19 @@ static int ask_to_continue(const char *file)
 	char *ret;
 
 	printf("We seem to be looping a lot on %s, do you want to keep going "
-	       "on ? (y/N): ", file);
+	       "on ? (y/N/a): ", file);
 again:
 	ret = fgets(buf, 2, stdin);
 	if (*ret == '\n' || tolower(*ret) == 'n')
-		return 1;
+		return 0;
+	if (tolower(*ret) == 'a')
+		return 2;
 	if (tolower(*ret) != 'y') {
 		printf("Please enter either 'y' or 'n': ");
 		goto again;
 	}
 
-	return 0;
+	return 1;
 }
 
 
@@ -588,11 +590,14 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	}
 
 	while (1) {
-		if (loops++ >= 1024) {
+		if (loops >= 0 && loops++ >= 1024) {
 			ret = ask_to_continue(file);
-			if (ret)
+			if (ret == 0)
 				break;
-			loops = 0;
+			else if (ret == 1)
+				loops = 0;
+			else if (ret == 2)
+				loops = -1;
 		}
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			do {
-- 
1.9.1

