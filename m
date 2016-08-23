Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59397 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755385AbcHWKnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 73FA7AD4D
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/13] btrfs-progs: mkfs: do not scan partially initialized devices
Date: Tue, 23 Aug 2016 12:25:08 +0200
Message-Id: <1471947917-5324-5-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We call scan ioctl on the devices too early, when most of the filesystem
structures are not yet created. Move the registration to the end, after
the filesystem gets closed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 mkfs.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 1f209b54ff79..0b081dd44457 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1748,9 +1748,6 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	if (is_block_device(file) == 1)
-		btrfs_register_one_device(file);
-
 	if (dev_cnt == 0)
 		goto raid_groups;
 
@@ -1796,9 +1793,6 @@ int main(int argc, char **argv)
 			printf("adding device %s id %llu\n", file,
 				(unsigned long long)device->devid);
 		}
-
-		if (is_block_device(file) == 1)
-			btrfs_register_one_device(file);
 	}
 
 raid_groups:
@@ -1867,6 +1861,15 @@ int main(int argc, char **argv)
 out:
 	ret = close_ctree(root);
 	BUG_ON(ret);
+
+	optind = saved_optind;
+	dev_cnt = argc - optind;
+	while (dev_cnt-- > 0) {
+		file = argv[optind++];
+		if (is_block_device(file) == 1)
+			btrfs_register_one_device(file);
+	}
+
 	btrfs_close_all_devices();
 	free(label);
 	return 0;
-- 
2.7.1

