Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbcEQOcN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 10:32:13 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 75D15ACAE
	for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 14:32:07 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: device usage: report slack space
Date: Tue, 17 May 2016 16:31:40 +0200
Message-Id: <1463495500-14983-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The total filesystem space on a given device might be smaller than the
device size. We should report that space as well. The original idea was
to report the 'occupied' size but the term was not all clear, so the
logic was reversed to report the slack space.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-fi-usage.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 23820066ce26..b26ece1d2ece 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -1024,13 +1024,8 @@ void print_device_sizes(int fd, struct device_info *devinfo, unsigned unit_mode)
 	printf("   Device size: %*s%10s\n",
 		(int)(20 - strlen("Device size")), "",
 		pretty_size_mode(devinfo->device_size, unit_mode));
-#if 0
-	/*
-	 * The term has not seen an agreement and we don't want to change it
-	 * once it's in non-development branches or even released.
-	 */
-	printf("   FS occupied: %*s%10s\n",
-		(int)(20 - strlen("FS occupied")), "",
-		pretty_size_mode(devinfo->size, unit_mode));
-#endif
+	printf("   Device slack: %*s%10s\n",
+		(int)(20 - strlen("Device slack")), "",
+		pretty_size_mode(devinfo->device_size - devinfo->size,
+			unit_mode));
 }
-- 
2.7.1

