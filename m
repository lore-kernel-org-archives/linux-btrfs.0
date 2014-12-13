Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56521 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966591AbaLMMEc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 07:04:32 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so11095913wgh.36
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 04:04:30 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] BUG: use metadata_profile instead of data_profile
Date: Sat, 13 Dec 2014 13:05:51 +0100
Message-Id: <1418472351-5113-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418472351-5113-1-git-send-email-kreijack@inwind.it>
References: <1418472351-5113-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function test_num_disk_vs_raid() show an error message if
the raid profile is incompatible with the number of devices.

Unfortunately when the error is related to data profile,
the message print the metadata profile.

This patch correct the bug.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index fc69e9b..e1b56ac 100644
--- a/utils.c
+++ b/utils.c
@@ -2116,7 +2116,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	if (data_profile & ~allowed) {
 		snprintf(estr, sz, "unable to create FS with data "
 			"profile %llu (have %llu devices)\n",
-			metadata_profile, dev_cnt);
+			data_profile, dev_cnt);
 		return 1;
 	}
 
-- 
2.1.3

