Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50145 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaG2BzU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 21:55:20 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so10898070pdj.28
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jul 2014 18:55:20 -0700 (PDT)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH v2] btrfs-progs: add always option to restore's looping prompt
Date: Mon, 28 Jul 2014 18:55:09 -0700
Message-Id: <1406598909-9658-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you are using btrfs restore to try to recover a very large or
fragmented file, you may encounter _lots_ of prompts requiring
you to press 'y' to continue because we are looping a lot.

Add the option to press 'a', to supress these prompts for the rest
of the file.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
---
 cmds-restore.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 3465f84..059194d 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -410,23 +410,31 @@ out:
 	return ret;
 }
 
-static int ask_to_continue(const char *file)
+enum loop_response {
+	LOOP_STOP,
+	LOOP_CONTINUE,
+	LOOP_DONTASK
+};
+
+static enum loop_response ask_to_continue(const char *file)
 {
 	char buf[2];
 	char *ret;
 
 	printf("We seem to be looping a lot on %s, do you want to keep going "
-	       "on ? (y/N): ", file);
+	       "on ? (y/N/a): ", file);
 again:
 	ret = fgets(buf, 2, stdin);
 	if (*ret == '\n' || tolower(*ret) == 'n')
-		return 1;
+		return LOOP_STOP;
+	if (tolower(*ret) == 'a')
+		return LOOP_DONTASK;
 	if (tolower(*ret) != 'y') {
-		printf("Please enter either 'y' or 'n': ");
+		printf("Please enter one of 'y', 'n', or 'a': ");
 		goto again;
 	}
 
-	return 0;
+	return LOOP_CONTINUE;
 }
 
 
@@ -594,11 +602,16 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	}
 
 	while (1) {
-		if (loops++ >= 1024) {
-			ret = ask_to_continue(file);
-			if (ret)
+		if (loops >= 0 && loops++ >= 1024) {
+			enum loop_response resp;
+
+			resp = ask_to_continue(file);
+			if (resp == LOOP_STOP)
 				break;
-			loops = 0;
+			else if (resp == LOOP_CONTINUE)
+				loops = 0;
+			else if (resp == LOOP_DONTASK)
+				loops = -1;
 		}
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			do {
-- 
1.7.10.4

