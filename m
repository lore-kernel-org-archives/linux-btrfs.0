Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51441 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaLOUCp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 15:02:45 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so15708406wgh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 12:02:44 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/7] Return the fsid from make_btrfs()
Date: Mon, 15 Dec 2014 21:02:58 +0100
Message-Id: <1418673780-22000-6-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function make_btrfs() has as argument the fsid of the filesystem.
If this fsid is empty or null make_btrfs() generates a new fsid. However
If the buffer is valid (but the string is empty) the generated fsid is
copied back to the caller.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 utils.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 3f50e4d..15127db 100644
--- a/utils.c
+++ b/utils.c
@@ -203,7 +203,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	memset(&super, 0, sizeof(super));
 
 	num_bytes = (num_bytes / sectorsize) * sectorsize;
-	if (fs_uuid) {
+	if (fs_uuid && *fs_uuid) {
 		if (uuid_parse(fs_uuid, super.fsid) != 0) {
 			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
 			ret = -EINVAL;
@@ -216,6 +216,11 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 		}
 	} else {
 		uuid_generate(super.fsid);
+		/* 
+		 * if the fs_uuid is a valid pointer, return the generated uuid
+		 */
+		if (fs_uuid)
+			uuid_unparse(super.fsid, fs_uuid);
 	}
 	uuid_generate(super.dev_item.uuid);
 	uuid_generate(chunk_tree_uuid);
-- 
2.1.3

