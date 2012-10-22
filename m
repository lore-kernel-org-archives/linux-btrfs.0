Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64974 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2JVURZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 16:17:25 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1245985bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 13:17:24 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/5] parse_size(): add new suffixes
Date: Mon, 22 Oct 2012 22:17:47 +0200
Message-Id: <1350937068-10080-5-git-send-email-kreijack@inwind.com>
In-Reply-To: <1350937068-10080-1-git-send-email-kreijack@inwind.com>
References: <1350937068-10080-1-git-send-email-kreijack@inwind.com>
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
index de75309..a5fabdc 100644
--- a/utils.c
+++ b/utils.c
@@ -1234,6 +1234,12 @@ u64 parse_size(char *s)
 	if (!isdigit(s[len - 1])) {
 		c = tolower(s[len - 1]);
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

