Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:52803 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3BDP6O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 10:58:14 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130204155813.ZXWP17456.eastrmfepo201.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>; Mon, 4 Feb 2013 10:58:13 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH] Btrfs-progs print more informative error when we fail to open a device
Date: Mon,  4 Feb 2013 10:57:57 -0500
Message-Id: <1359993477-18281-2-git-send-email-gene@czarc.net>
In-Reply-To: <1359993477-18281-1-git-send-email-gene@czarc.net>
References: <1359993477-18281-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

print more informative error when we fail to open a device

If open() fails, we should let the user know why it failed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index d92f317..b560a49 100644
--- a/utils.c
+++ b/utils.c
@@ -1212,7 +1212,8 @@ scan_again:
 
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
-			fprintf(stderr, "failed to read %s\n", fullpath);
+			fprintf(stderr, "failed to open %s: %s\n",
+				fullpath, strerror(errno));
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
-- 
1.8.1

