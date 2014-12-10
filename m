Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:52074 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933319AbaLJVFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:43 -0500
Received: from mail-in-11-z2.arcor-online.net (mail-in-11-z2.arcor-online.net [151.189.8.28])
	by mx.arcor.de (Postfix) with ESMTP id 137C72D65F5
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:42 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 11/18] btrfs restore: print progress marks for big files
Date: Wed, 10 Dec 2014 21:51:41 +0100
Message-Id: <1418244708-7087-12-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

print a '+' for every 64k restored. This gives people more confidence
in long-running restore processes.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 cmds-restore.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index f1c63ed..004c82e 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -658,6 +658,8 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	int loops = 0;
 	u64 bytes_written, next_pos = 0ULL;
 	u64 total_written = 0ULL;
+#define MAYBE_NL (verbose && (next_pos >> display_shift) ? "\n" : "")
+	const u64 display_shift = 16;
 	struct stat st;
 
 	path = btrfs_alloc_path();
@@ -751,6 +753,10 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 			printf("Weird extent type %d\n", extent_type);
 		}
 		total_written += bytes_written;
+		if (verbose && 
+		    ((next_pos +  bytes_written) >> display_shift) > 
+		    (next_pos >> display_shift))
+			fprintf(stderr, "+");
 		next_pos = found_key.offset + bytes_written;
 		if (ret) {
 			fprintf(stderr, "ERROR after writing %llu bytes\n",
@@ -764,6 +770,8 @@ next:
 
 set_size:
 	btrfs_free_path(path);
+
+	printf(MAYBE_NL);
 	if (get_xattrs) {
 		ret = set_file_xattrs(root, key->objectid, fd, file);
 		if (ret)
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
