Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52507 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2JWRvl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 13:51:41 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1252036eaa.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 10:51:40 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/5] parse_size(): replace atoll() with strtoull()
Date: Tue, 23 Oct 2012 19:51:52 +0200
Message-Id: <1351014715-5727-3-git-send-email-kreijack@inwind.com>
In-Reply-To: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
References: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Replace the function atoll with strtoull()
---
 utils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 705be7b..732c782 100644
--- a/utils.c
+++ b/utils.c
@@ -1243,6 +1243,6 @@ u64 parse_size(char *s)
 		}
 		s[len - 1] = '\0';
 	}
-	return atoll(s) * mult;
+	return strtoull(s, NULL, 0) * mult;
 }
 
-- 
1.7.10.4

