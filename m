Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482AbaD2QBO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:01:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D433AAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:01:13 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 04/14] btrfs-progs: check if we can't get info from ioctls due to permissions
Date: Tue, 29 Apr 2014 17:58:25 +0200
Message-Id: <3a6b570007c4010771ce046e1cc6cfadde4842de.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The TREE_SEARCH ioctl is root-only, FS_INFO will be available for
non-root users with an updated kernel, let the user know.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 17202de1b6e8..64c85acafd51 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -171,6 +171,12 @@ int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count)
 	while (1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		e = errno;
+		if (ret == -EPERM) {
+			fprintf(stderr,
+				"ERROR: can't read detailed chunk info from ioctl(TREE_SEARCH), run as root\n");
+			return 0;
+		}
+
 		if (ret < 0) {
 			fprintf(stderr,
 				"ERROR: can't perform the search - %s\n",
@@ -461,6 +467,10 @@ int load_device_info(int fd, struct device_info **device_info_ptr,
 	*device_info_ptr = 0;
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
+	if (ret == -EPERM) {
+		fprintf(stderr, "ERROR: can't get filesystem info from ioctl(FS_INFO), run as root\n");
+		return -1;
+	}
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: cannot get filesystem info\n");
 		return -1;
-- 
1.9.0

