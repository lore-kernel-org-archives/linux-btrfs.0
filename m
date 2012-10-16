Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37948 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2JPMEk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 08:04:40 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so5846278pad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 05:04:40 -0700 (PDT)
Message-ID: <507D4D4F.10807@gmail.com>
Date: Tue, 16 Oct 2012 20:04:31 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: check non-digit character in the size value
 for mkfs options
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we run mkfs.btrfs, we can specify the size value for leafsize, etc.
Current the limit is 65536, and the lower limit is 4096. Also, the size
should be 4096 aligned. When we specify such value, parse_size just check
the tailing non-digit character, but doesn't check other characters.

For example, run "mkfs.btrfs -l 40960b btrfs.img" will get nodesize 40960,
leafsize 40960 and sectorsize 4096, which is expected. But if we typo
4096bb, "mkfs.btrfs -l 4096bb btrfs.img", the result is nodesize 4096,
leafsize 4096 and sectorsize 4096, which maybe not what we want and what
we really want to type is 40960b.

Add check in parse_size to deal with the non-tailing non-digit characters.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mkfs.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2cc6051..11e64d2 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -60,6 +60,7 @@ static u64 parse_size(char *s)
 	char c;
 	u64 mult = 1;
 	u64 ret;
+	int i;

 	s = strdup(s);

@@ -80,6 +81,16 @@ static u64 parse_size(char *s)
 		}
 		s[len - 1] = '\0';
 	}
+
+	len = strlen(s);
+	for (i = 0; i < len; i++) {
+		if (!isdigit(s[i])) {
+			fprintf(stderr, "Illegal size value contains "
+				"non-digit character %c\n", s[i]);
+			exit(1);
+		}
+	}
+
 	ret = atol(s) * mult;
 	free(s);
 	return ret;
-- 
1.7.5.4
