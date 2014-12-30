Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaL3O5w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 09:57:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 26D4FABFC
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 14:57:51 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/5] btrfs-progs: fix minor leak of dev_info in btrfs_scan_kernel
Date: Tue, 30 Dec 2014 15:57:50 +0100
Message-Id: <f8a24717b11fa5501ade5c76077584f771b005c1.1419951036.git.dsterba@suse.cz>
In-Reply-To: <cover.1419951036.git.dsterba@suse.cz>
References: <cover.1419951036.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-coverity-id: 1127098
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-filesystem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1c1d34ae8ca2..a3cf114fb6ac 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -516,8 +516,10 @@ static int btrfs_scan_kernel(void *search)
 			continue;
 		ret = get_fs_info(mnt->mnt_dir, &fs_info_arg,
 				&dev_info_arg);
-		if (ret)
+		if (ret) {
+			kfree(dev_info_arg);
 			goto out;
+		}
 
 		if (get_label_mounted(mnt->mnt_dir, label)) {
 			kfree(dev_info_arg);
-- 
2.1.3

