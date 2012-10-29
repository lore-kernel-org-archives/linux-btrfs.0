Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37204 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759689Ab2J2Rwq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 13:52:46 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1806130eaa.19
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 10:52:45 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 3/4] parse_size(): add new suffixes
Date: Mon, 29 Oct 2012 18:53:19 +0100
Message-Id: <1351533200-5703-4-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351533200-5703-1-git-send-email-kreijack@inwind.it>
References: <1351533200-5703-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new suffixes in parse_size() function. New suffixes are: T as
terabyte, P as petabyte, E as exabyte. Note these units are
multiply of 2 .

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 utils.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/utils.c b/utils.c
index aa2e574..b487be6 100644
--- a/utils.c
+++ b/utils.c
@@ -1236,6 +1236,12 @@ u64 parse_size(char *s)
 	if (s[i]) {
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

