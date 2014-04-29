Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbaD2QCG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:06 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 40D1BAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:02:06 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 05/14] btrfs-progs: zero out structures before calling ioctl
Date: Tue, 29 Apr 2014 18:01:18 +0200
Message-Id: <9d1cde36aa9edf28f5dd431a9f6899ca7b309269.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 64c85acafd51..067c60078710 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -248,7 +248,7 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 	struct btrfs_ioctl_space_args *sargs = 0, *sargs_orig = 0;
 	int e, ret, count;
 
-	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
+	sargs_orig = sargs = calloc(1, sizeof(struct btrfs_ioctl_space_args));
 	if (!sargs) {
 		fprintf(stderr, "ERROR: not enough memory\n");
 		return NULL;
@@ -476,15 +476,15 @@ int load_device_info(int fd, struct device_info **device_info_ptr,
 		return -1;
 	}
 
-	info = malloc(sizeof(struct device_info) * fi_args.num_devices);
+	info = calloc(fi_args.num_devices, sizeof(struct device_info));
 	if (!info) {
 		fprintf(stderr, "ERROR: not enough memory\n");
 		return -1;
 	}
 
 	for (i = 0, ndevs = 0 ; i <= fi_args.max_id ; i++) {
-
 		BUG_ON(ndevs >= fi_args.num_devices);
+		memset(&dev_info, 0, sizeof(dev_info));
 		ret = get_device_info(fd, i, &dev_info);
 
 		if (ret == -ENODEV)
-- 
1.9.0

