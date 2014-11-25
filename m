Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaKYSwC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 13:52:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2B2C3ADC5
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 18:52:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fix spacing in error messages
Date: Tue, 25 Nov 2014 19:52:00 +0100
Message-Id: <1416941520-896-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-list.c | 4 ++--
 qgroup.c     | 2 +-
 send-utils.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index b6b84935109d..50edcf493869 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1711,7 +1711,7 @@ int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		e = errno;
 		if (ret < 0) {
-			fprintf(stderr, "ERROR: can't perform the search- %s\n",
+			fprintf(stderr, "ERROR: can't perform the search - %s\n",
 				strerror(e));
 			break;
 		}
@@ -1911,7 +1911,7 @@ int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
 	if (ret < 0) {
 		fprintf(stderr,
-			"ERROR: can't perform the search -%s\n",
+			"ERROR: can't perform the search - %s\n",
 			strerror(errno));
 		return ret;
 	}
diff --git a/qgroup.c b/qgroup.c
index 368b26284544..1a4866cb7345 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1160,7 +1160,7 @@ u64 btrfs_get_path_rootid(int fd)
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
 	if (ret < 0) {
 		fprintf(stderr,
-			"ERROR: can't perform the search -%s\n",
+			"ERROR: can't perform the search - %s\n",
 			strerror(errno));
 		return ret;
 	}
diff --git a/send-utils.c b/send-utils.c
index 71b6ec1528e5..cbaf2e90acb4 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -556,7 +556,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 	ret = is_uuid_tree_supported(mnt_fd);
 	if (ret < 0) {
 		fprintf(stderr,
-			"ERROR: check if we support uuid tree fails- %s\n",
+			"ERROR: check if we support uuid tree fails - %s\n",
 			strerror(errno));
 		return ret;
 	} else if (ret) {
@@ -579,7 +579,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 		ret = ioctl(mnt_fd, BTRFS_IOC_TREE_SEARCH, &args);
 		e = errno;
 		if (ret < 0) {
-			fprintf(stderr, "ERROR: can't perform the search- %s\n",
+			fprintf(stderr, "ERROR: can't perform the search - %s\n",
 				strerror(e));
 			return ret;
 		}
-- 
2.1.3

