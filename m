Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42112 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbeICOeI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 10:34:08 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@versity.com>
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Mon,  3 Sep 2018 12:14:25 +0200
Message-Id: <20180903101426.14968-1-kilobyte@angband.pl>
MIME-Version: 1.0
Subject: [PATCH 1/2] btrfs-progs: fix kernel version parsing on some versions past 3.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The code fails if the third section is missing (like "4.18") or is followed
by anything but "." or "-".  This happens for example if we're not exactly
at a tag and CONFIG_LOCALVERSION_AUTO=n (which results in "4.18.5+").

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fsfeatures.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fsfeatures.c b/fsfeatures.c
index 7d85d60f..66111bf4 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -216,11 +216,8 @@ u32 get_running_kernel_version(void)
 		return (u32)-1;
 	version |= atoi(tmp) << 8;
 	tmp = strtok_r(NULL, ".", &saveptr);
-	if (tmp) {
-		if (!string_is_numerical(tmp))
-			return (u32)-1;
+	if (tmp && string_is_numerical(tmp))
 		version |= atoi(tmp);
-	}
 
 	return version;
 }
-- 
2.19.0.rc1
