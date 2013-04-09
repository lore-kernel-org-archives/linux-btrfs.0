Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:17967 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507Ab3DIRKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:10:06 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUc for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/17] Btrfs-progs: don't allocate one byte too much each time
Date: Tue,  9 Apr 2013 19:08:41 +0200
Message-Id: <0848a8ec32586b47bd7ea403677c2aeccb5feedc.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

str1 + '/' + str2 + '\0' requires a buffer with the size
strlen(str1) + strlen(str2) + 2 bytes.

str1 + '/' + str2 + '/' + str3 + '\0' requires a buffer with the size
strlen(str1) + strlen(str2) + strlen(str3) + 3 bytes.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 send-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/send-utils.c b/send-utils.c
index b2d544c..aff62ad 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -352,7 +352,7 @@ char *path_cat(const char *p1, const char *p2)
 {
 	int p1_len = strlen(p1);
 	int p2_len = strlen(p2);
-	char *new = malloc(p1_len + p2_len + 3);
+	char *new = malloc(p1_len + p2_len + 2);
 
 	if (p1_len && p1[p1_len - 1] == '/')
 		p1_len--;
@@ -368,7 +368,7 @@ char *path_cat3(const char *p1, const char *p2, const char *p3)
 	int p1_len = strlen(p1);
 	int p2_len = strlen(p2);
 	int p3_len = strlen(p3);
-	char *new = malloc(p1_len + p2_len + p3_len + 4);
+	char *new = malloc(p1_len + p2_len + p3_len + 3);
 
 	if (p1_len && p1[p1_len - 1] == '/')
 		p1_len--;
-- 
1.8.2.1

