Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbaENSNB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 14:13:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 23131ACCB
	for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 18:13:00 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: hide 'FS occupied' from device usage output for now
Date: Wed, 14 May 2014 20:12:57 +0200
Message-Id: <1400091177-14308-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The term has not seen an agreement and we don't want to change it once
it's in non-development branches or even released.

Discussion under the patch:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/34627

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Some variant based on of the terms: occupy, hold, retain, maintain

 cmds-fi-disk_usage.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 5580134ac939..453410f070da 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -906,7 +906,13 @@ void print_device_sizes(int fd, struct device_info *devinfo, int mode)
 	printf("   Device size: %*s%10s\n",
 		(int)(20 - strlen("Device size")), "",
 		pretty_size_mode(devinfo->device_size, mode));
+#if 0
+	/*
+	 * The term has not seen an agreement and we don't want to change it
+	 * once it's in non-development branches or even released.
+	 */
 	printf("   FS occupied: %*s%10s\n",
 		(int)(20 - strlen("FS occupied")), "",
 		pretty_size_mode(devinfo->size, mode));
+#endif
 }
-- 
1.9.0

