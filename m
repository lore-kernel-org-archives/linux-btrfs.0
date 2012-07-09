Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47878 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2GIR34 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 13:29:56 -0400
Received: by lbbgm6 with SMTP id gm6so20477019lbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2012 10:29:54 -0700 (PDT)
From: Pierre Carrier <pierre@spotify.com>
To: linux-btrfs@vger.kernel.org
Cc: Pierre Carrier <pierre@spotify.com>
Subject: [PATCH 1/2] utils.c: fix sizes in B & malloc in pretty_sizes
Date: Mon,  9 Jul 2012 17:29:34 +0000
Message-Id: <1341854974-14502-1-git-send-email-pierre@spotify.com>
In-Reply-To: <1341853347-11788-2-git-send-email-pierre@spotify.com>
References: <1341853347-11788-2-git-send-email-pierre@spotify.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before, sizes below 1KB are still displayed in KB,
but without a unit.

Signed-off-by: Pierre Carrier <pierre@spotify.com>

diff --git a/utils.c b/utils.c
index aade9e2..937e763 100644
--- a/utils.c
+++ b/utils.c
@@ -1108,13 +1108,20 @@ char *pretty_sizes(u64 size)
 		size /= 1024;
 		num_divs++;
 	}
-	if (num_divs == 0)
+	if (num_divs <= 1) {
 		num_divs = 1;
+		fraction = (float)fract_size;
+	} else
+		fraction = (float)fract_size / 1024;
+
 	if (num_divs > ARRAY_SIZE(size_strs))
 		return NULL;
 
-	fraction = (float)fract_size / 1024;
+
 	pretty = malloc(pretty_len);
+	if (!pretty)
+		return NULL;
+
 	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs-1]);
 	return pretty;
 }
-- 
1.7.11.1

