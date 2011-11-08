Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45783 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755180Ab1K1Teh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:34:37 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWUGe020779
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:31 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWQAK012378
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:27 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWQRH020319
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:26 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWPeX020318
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:25 -0200
Message-Id: <fc45a1eacef1587562f853747b331092af361391.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Tue, 8 Nov 2011 12:33:11 -0200
Subject: [PATCH 01/20] Btrfs: enable removal of second disk with raid1
 metadata
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enable removal of a second disk even if that requires conversion of
metadata from raid1 to dup, but not when data would lose replication.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/volumes.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c37433d..7b348c2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1290,12 +1290,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		goto out;
 	}
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
+	if ((root->fs_info->avail_data_alloc_bits & BTRFS_BLOCK_GROUP_RAID1) &&
 	    root->fs_info->fs_devices->num_devices <= 2) {
 		printk(KERN_ERR "btrfs: unable to go below two "
 		       "devices on raid1\n");
 		ret = -EINVAL;
 		goto out;
+	} else if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
+		   root->fs_info->fs_devices->num_devices <= 2) {
+		printk(KERN_ERR "btrfs: going below two devices "
+		       "will switch metadata from raid1 to dup\n");
 	}
 
 	if (strcmp(device_path, "missing") == 0) {
-- 
1.7.4.4

