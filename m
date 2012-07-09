Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41149 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2GIRCv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 13:02:51 -0400
Received: by bkwj10 with SMTP id j10so6229401bkw.19
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2012 10:02:50 -0700 (PDT)
From: Pierre Carrier <pierre@spotify.com>
To: linux-btrfs@vger.kernel.org
Cc: Pierre Carrier <pierre@spotify.com>
Subject: [PATCH 2/2] utils.c: offer to limit divisions in pretty_sizes
Date: Mon,  9 Jul 2012 17:02:27 +0000
Message-Id: <1341853347-11788-3-git-send-email-pierre@spotify.com>
In-Reply-To: <1341853347-11788-1-git-send-email-pierre@spotify.com>
References: <1341853347-11788-1-git-send-email-pierre@spotify.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dirty hack to allow inspection of sizes in lower units.

Useful to know the minimum size a partition shoud be resized to
after a 'btrfs filesystem resize'.

Label: 'home'  uuid: 10453c4c-1c5b-4df5-b4a5-43a7f377430a
        Total devices 1 FS bytes used 42.80GB
        devid    1 size 62.16GB used 62.16GB path /dev/sda5

Label: 'home'  uuid: 10453c4c-1c5b-4df5-b4a5-43a7f377430a
        Total devices 1 FS bytes used 44884524.00KB
        devid    1 size 65182236.00KB used 65182208.00KB path /dev/sda5

Signed-off-by: Pierre Carrier <pierre@spotify.com>

diff --git a/utils.c b/utils.c
index dde0513..e660799 100644
--- a/utils.c
+++ b/utils.c
@@ -1096,13 +1096,18 @@ static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
 char *pretty_sizes(u64 size)
 {
 	int num_divs = 0;
+	int max_divs = INT_MAX;
         int pretty_len = 16;
 	u64 last_size = size;
 	u64 fract_size = size;
 	float fraction;
 	char *pretty;
+	char *max_divs_s;
 
-	while(size > 0) {
+	if (max_divs_s = getenv("MAX_DIVS"))
+		max_divs = atoi(max_divs_s);
+
+	while(size > 0 && num_divs < max_divs) {
 		fract_size = last_size;
 		last_size = size;
 		size /= 1024;
-- 
1.7.11.1

