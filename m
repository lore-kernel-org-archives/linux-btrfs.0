Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m199-177.yeah.net ([123.58.177.199]:42850 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab2JWJMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 05:12:12 -0400
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com [209.85.215.46])
	by m199-177.yeah.net (HMail) with ESMTPA id 0D2DB10041F
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 17:12:09 +0800 (CST)
Received: by mail-la0-f46.google.com with SMTP id h6so2184039lag.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 02:12:07 -0700 (PDT)
MIME-Version: 1.0
From: Rock Lee <zimilo@code-trick.com>
Date: Tue, 23 Oct 2012 17:11:27 +0800
Message-ID: <CAMRmmpLkp58en6mikZ9MAYwoA_kkrZx+UNTifjXSw3=hELLZZw@mail.gmail.com>
Subject: [PATCH] [btrfs-progs] Modify parse_size to remove the strdup/free
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the function atoi(l) series stop at the first non numeric chars,

So there's no need to strdup the original s and modify s[len-1] = '\0'

Signed-off-by: Rock Lee <zimilo@code-trick.com>
---
 mkfs.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 47f0c9c..663d73c 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -61,8 +61,6 @@ static u64 parse_size(char *s)
 	u64 mult = 1;
 	u64 ret;

-	s = strdup(s);
-
 	if (len && !isdigit(s[len - 1])) {
 		c = tolower(s[len - 1]);
 		switch (c) {
@@ -78,10 +76,9 @@ static u64 parse_size(char *s)
 			fprintf(stderr, "Unknown size descriptor %c\n", c);
 			exit(1);
 		}
-		s[len - 1] = '\0';
 	}
+
 	ret = atol(s) * mult;
-	free(s);
 	return ret;
 }

-- 
1.7.7.6
