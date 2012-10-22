Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64974 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2JVURW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 16:17:22 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1245985bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 13:17:21 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/5] parse_size(): replace atoll() with strtoull()
Date: Mon, 22 Oct 2012 22:17:45 +0200
Message-Id: <1350937068-10080-3-git-send-email-kreijack@inwind.com>
In-Reply-To: <1350937068-10080-1-git-send-email-kreijack@inwind.com>
References: <1350937068-10080-1-git-send-email-kreijack@inwind.com>
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

