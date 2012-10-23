Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52507 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab2JWRvn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 13:51:43 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1252036eaa.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 10:51:43 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/5] parse_size(): add new suffixes
Date: Tue, 23 Oct 2012 19:51:54 +0200
Message-Id: <1351014715-5727-5-git-send-email-kreijack@inwind.com>
In-Reply-To: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
References: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Add new suffixes in parse_size() function. New suffixes are: T as
terabyte, P as petabyte, E as exabyte. Note these units are
multiply of 2 .
---
 utils.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/utils.c b/utils.c
index e61cdea..4b16fc9 100644
--- a/utils.c
+++ b/utils.c
@@ -1236,6 +1236,12 @@ u64 parse_size(char *s)
 	if ( s[i] ) {
 		c = tolower(s[i]);
 		switch (c) {
+		case 'e':
+			mult *= 1024;
+		case 'p':
+			mult *= 1024;
+		case 't':
+			mult *= 1024;
 		case 'g':
 			mult *= 1024;
 		case 'm':
-- 
1.7.10.4

