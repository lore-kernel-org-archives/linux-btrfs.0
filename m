Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:40435 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3ASO4j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 09:56:39 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130119145638.JUHB17456.eastrmfepo201.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 19 Jan 2013 09:56:38 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 3/4] Fedora 18 - fix-labels.patch
Date: Sat, 19 Jan 2013 09:56:24 -0500
Message-Id: <1358607385-21163-4-git-send-email-gene@czarc.net>
In-Reply-To: <1358607385-21163-1-git-send-email-gene@czarc.net>
References: <1358607385-21163-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

