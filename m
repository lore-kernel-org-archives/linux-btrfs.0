Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53461 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLQUNA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 15:13:00 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so21123430wgh.6
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:12:59 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/8] Return the fsid from make_btrfs()
Date: Wed, 17 Dec 2014 21:14:09 +0100
Message-Id: <1418847252-14184-6-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function make_btrfs() has as argument the fsid of the filesystem.
If this fsid is empty or null make_btrfs() generates a new fsid. However
If the buffer is valid (but the string is empty) the generated fsid is
copied back to the caller.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 mkfs.c  | 7 ++++---
 utils.c | 7 ++++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 042d12e..70c88ea 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1281,7 +1281,7 @@ int main(int ac, char **av)
 	int dev_cnt = 0;
 	int saved_optind;
 	char estr[100];
-	char *fs_uuid = NULL;
+	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
 	u64 features = DEFAULT_MKFS_FEATURES;
 
 	while(1) {
@@ -1356,7 +1356,8 @@ int main(int ac, char **av)
 				source_dir_set = 1;
 				break;
 			case 'U':
-				fs_uuid = optarg;
+				strncpy(fs_uuid,optarg,
+					BTRFS_UUID_UNPARSED_SIZE - 1);
 				break;
 			case 'K':
 				discard = 0;
@@ -1387,7 +1388,7 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	if (fs_uuid) {
+	if (*fs_uuid) {
 		uuid_t dummy_uuid;
 
 		if (uuid_parse(fs_uuid, dummy_uuid) != 0) {
diff --git a/utils.c b/utils.c
index 3f50e4d..c7f1b2f 100644
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

