Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:54300 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3ASSGd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 13:06:33 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130119180632.TELZ17456.eastrmfepo201.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 19 Jan 2013 13:06:32 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 3/6] Fedora 18 - fix-labels.patch
Date: Sat, 19 Jan 2013 13:06:18 -0500
Message-Id: <1358618781-26629-4-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-1-git-send-email-gene@czarc.net>
References: <1358618781-26629-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 mkfs.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index d123d5f..8c291c9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -352,7 +352,6 @@ static u64 parse_profile(char *s)
 
 static char *parse_label(char *input)
 {
-	int i;
 	int len = strlen(input);
 
 	if (len >= BTRFS_LABEL_SIZE) {
@@ -360,12 +359,6 @@ static char *parse_label(char *input)
 			BTRFS_LABEL_SIZE - 1);
 		exit(1);
 	}
-	for (i = 0; i < len; i++) {
-		if (input[i] == '/' || input[i] == '\\') {
-			fprintf(stderr, "invalid label %s\n", input);
-			exit(1);
-		}
-	}
 	return strdup(input);
 }
 
-- 
1.8.1

