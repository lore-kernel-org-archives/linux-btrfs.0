Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaL3O5m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 09:57:42 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7D216ABFC
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 14:57:41 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/5] btrfs-progs: fi show, don't leak canonical path
Date: Tue, 30 Dec 2014 15:57:40 +0100
Message-Id: <8499af348407909801cf87c6e1e7426c930ae567.1419951036.git.dsterba@suse.cz>
In-Reply-To: <cover.1419951036.git.dsterba@suse.cz>
References: <cover.1419951036.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-coverity-id: 1260252
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-filesystem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 80875fffddfe..1c1d34ae8ca2 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -471,7 +471,6 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 		char *canonical_path;
 
 		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
-		canonical_path = canonicalize_path((char *)tmp_dev_info->path);
 
 		/* Add check for missing devices even mounted */
 		fd = open((char *)tmp_dev_info->path, O_RDONLY);
@@ -480,6 +479,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 			continue;
 		}
 		close(fd);
+		canonical_path = canonicalize_path((char *)tmp_dev_info->path);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 			tmp_dev_info->devid,
 			pretty_size(tmp_dev_info->total_bytes),
-- 
2.1.3

