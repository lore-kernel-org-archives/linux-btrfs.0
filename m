Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:41849 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933320AbaLJVFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:43 -0500
Received: from mail-in-15-z2.arcor-online.net (mail-in-15-z2.arcor-online.net [151.189.8.32])
	by mx.arcor.de (Postfix) with ESMTP id 8C4DCD8511
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:42 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 13/18] btrfs restore: improve user-asking logic for files with many extents
Date: Wed, 10 Dec 2014 21:51:43 +0100
Message-Id: <1418244708-7087-14-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

The logic to ask after 1024 extents is broken. It unnecessarily
confuses users if big files are being restored, making them think
somthing is going wrong.

Change it to two cases: 1) no or little progress restoring,
2) writing beyond the file size.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 80081b8..8ae3337 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -661,7 +661,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 #define MAYBE_NL (verbose && (next_pos >> display_shift) ? "\n" : "")
 	const u64 display_shift = 16;
 	struct stat st;
-
+	int dont_ask = 0;
 	path = btrfs_alloc_path();
 	if (!path) {
 		fprintf(stderr, "Ran out of memory\n");
@@ -697,9 +697,21 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	}
 
 	while (1) {
-		if (loops >= 0 && loops++ >= 1024) {
+		int problem = 0;
+		if (st.st_size == _INVALID_SIZE && next_pos > st.st_size) {
+			fprintf(stderr, "%swriting at offset %llu beyond size "
+				"of file (%llu)\n",
+				MAYBE_NL, next_pos, st.st_size);
+			problem = 1;
+		}
+		if ((++loops % 1024) == 0 && (next_pos / loops < 4096)) {
+			fprintf(stderr, "%smany loops (%d) and little progress "
+				"(%llu bytes)\n", 
+				MAYBE_NL, loops, next_pos);
+			problem = 1;
+		}
+		if (problem && !dont_ask && loops++) {
 			enum loop_response resp;
-
 			resp = ask_to_continue(file);
 			if (resp == LOOP_STOP)
 				break;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
