Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56130 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/16] btrfs-progs: check for fstat failure in cmd_defrag
Date: Wed,  6 Nov 2013 17:15:53 -0600
Message-Id: <1383779755-18228-15-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-Coverity-CID: 1125924
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-filesystem.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b1291d6..2cb067d 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -661,7 +661,13 @@ static int cmd_defrag(int argc, char **argv)
 		if (recursive) {
 			struct stat st;
 
-			fstat(fd, &st);
+			if (fstat(fd, &st)) {
+				fprintf(stderr, "ERROR: failed to stat %s - %s\n",
+						argv[i], strerror(errno));
+				defrag_global_errors++;
+				close_file_or_dir(fd, dirstream);
+				continue;
+			}
 			if (S_ISDIR(st.st_mode)) {
 				ret = nftw(argv[i], defrag_callback, 10,
 						FTW_MOUNT | FTW_PHYS);
-- 
1.7.1

