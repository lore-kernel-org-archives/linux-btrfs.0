Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56671 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2JVURX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 16:17:23 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1245989bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 13:17:23 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/5] parse_size(): check for invalid suffix
Date: Mon, 22 Oct 2012 22:17:46 +0200
Message-Id: <1350937068-10080-4-git-send-email-kreijack@inwind.com>
In-Reply-To: <1350937068-10080-1-git-send-email-kreijack@inwind.com>
References: <1350937068-10080-1-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Check that the suffix for the parse_size() input is of only
one character.
---
 utils.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/utils.c b/utils.c
index 732c782..de75309 100644
--- a/utils.c
+++ b/utils.c
@@ -1226,6 +1226,11 @@ u64 parse_size(char *s)
 	char c;
 	u64 mult = 1;
 
+	if( len <= 0 ){
+		fprintf(stderr, "ERROR: size value is empty\n");
+		exit(50);
+	}
+
 	if (!isdigit(s[len - 1])) {
 		c = tolower(s[len - 1]);
 		switch (c) {
@@ -1242,6 +1247,13 @@ u64 parse_size(char *s)
 			exit(1);
 		}
 		s[len - 1] = '\0';
+		len--;
+	}
+	if( len > 0 && !isdigit(s[len - 1])) {
+		fprintf(stderr, "ERROR: Illegal size value contains "
+			"non-digit character %c in wrong position\n",
+			s[len-1]);
+		exit(51);
 	}
 	return strtoull(s, NULL, 0) * mult;
 }
-- 
1.7.10.4

