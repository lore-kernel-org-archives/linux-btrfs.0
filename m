Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58861 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaJOXOr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 19:14:47 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so2439475wgh.34
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 16:14:46 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/4] btrfs-progs: check sscanf return code
Date: Wed, 15 Oct 2014 16:14:18 -0700
Message-Id: <1413414861-28097-2-git-send-email-zab@zabbo.net>
In-Reply-To: <1413414861-28097-1-git-send-email-zab@zabbo.net>
References: <1413414861-28097-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

coverity warned that the return code from sscanf() assigned to 'i'
wasn't checked before being assigned again.  Check it.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 utils.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index c2f30d4..51e55be 100644
--- a/utils.c
+++ b/utils.c
@@ -1574,7 +1574,11 @@ scan_again:
 
 	strcpy(fullpath,"/dev/");
 	while(fgets(buf, 1023, proc_partitions)) {
-		i = sscanf(buf," %*d %*d %*d %99s", fullpath+5);
+		ret = sscanf(buf," %*d %*d %*d %99s", fullpath+5);
+		if (ret != 1) {
+			fprintf(stderr, "failed to scan device name from /proc/partitions\n");
+			break;
+		}
 
 		/*
 		 * multipath and MD devices may register as a btrfs filesystem
-- 
1.9.3

