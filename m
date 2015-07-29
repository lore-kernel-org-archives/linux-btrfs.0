Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5460 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520AbbG2CaX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 22:30:23 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <jamespharvey20@gmail.com>
Subject: [PATCH] btrfs-progs: Add missing exit for parse_profile function
Date: Wed, 29 Jul 2015 10:28:17 +0800
Message-ID: <1438136897-11590-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In parse_profile() function, in error handling route, it output error
message but forgot to exit(1), causing even profile is not valid, it
will just fallback to single.

Reported-by: James Harvey <jamespharvey20@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 mkfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mkfs.c b/mkfs.c
index 9073f87..7d635dc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -356,6 +356,7 @@ static u64 parse_profile(char *s)
 		return 0;
 	} else {
 		fprintf(stderr, "Unknown profile %s\n", s);
+		exit(1);
 	}
 	/* not reached */
 	return 0;
-- 
2.4.6

