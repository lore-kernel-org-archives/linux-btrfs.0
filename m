Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab3ITQw0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 12:52:26 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3D707A51FE
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 18:52:25 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fix loop device mount checks
Date: Fri, 20 Sep 2013 18:52:18 +0200
Message-Id: <1379695938-31244-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When creating a fs on a loop device, mkfs checks whether the same file
is not already mounted, but a backing file of another loop dev does not
exist, mkfs fails. This fixes a bug during openSUSE installation.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 utils.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/utils.c b/utils.c
index 5fa193b..357983d 100644
--- a/utils.c
+++ b/utils.c
@@ -803,11 +803,11 @@ static int is_same_blk_file(const char* a, const char* b)
 	char real_a[PATH_MAX];
 	char real_b[PATH_MAX];
 
-	if(!realpath(a, real_a) ||
-	   !realpath(b, real_b))
-	{
-		return -errno;
-	}
+	if(!realpath(a, real_a))
+		strcpy(real_a, a);
+
+	if (!realpath(b, real_b))
+		strcpy(real_b, b);
 
 	/* Identical path? */
 	if(strcmp(real_a, real_b) == 0)
@@ -848,8 +848,8 @@ static int is_same_loop_file(const char* a, const char* b)
 {
 	char res_a[PATH_MAX];
 	char res_b[PATH_MAX];
-	const char* final_a;
-	const char* final_b;
+	const char* final_a = NULL;
+	const char* final_b = NULL;
 	int ret;
 
 	/* Resolve a if it is a loop device */
@@ -858,10 +858,13 @@ static int is_same_loop_file(const char* a, const char* b)
 			return 0;
 		return ret;
 	} else if (ret) {
-		if ((ret = resolve_loop_device(a, res_a, sizeof(res_a))) < 0)
-			return ret;
-
-		final_a = res_a;
+		ret = resolve_loop_device(a, res_a, sizeof(res_a));
+		if (ret < 0) {
+			if (errno != EPERM)
+				return ret;
+		} else {
+			final_a = res_a;
+		}
 	} else {
 		final_a = a;
 	}
@@ -872,10 +875,13 @@ static int is_same_loop_file(const char* a, const char* b)
 			return 0;
 		return ret;
 	} else if (ret) {
-		if((ret = resolve_loop_device(b, res_b, sizeof(res_b))) < 0)
-			return ret;
-
-		final_b = res_b;
+		ret = resolve_loop_device(b, res_b, sizeof(res_b));
+		if (ret < 0) {
+			if (errno != EPERM)
+				return ret;
+		} else {
+			final_b = res_b;
+		}
 	} else {
 		final_b = b;
 	}
-- 
1.8.3.1

