Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:29636 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966927AbdI0CC4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 22:02:56 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 46F23AC00B9
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:02:51 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 7AB15584283
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:02:50 +0900 (JST)
Subject: [PATCH v2 4/5] btrfs-progs: change seen_fsid to hold fd and DIR*
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
Message-ID: <56bb58ff-e9d5-045b-7eb4-4e4583fa4866@jp.fujitsu.com>
Date: Wed, 27 Sep 2017 11:02:47 +0900
MIME-Version: 1.0
In-Reply-To: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change seen_fsid to hold fd and DIR* in order to keep access to each fs.
This will be used for 'subvol delete --commit-after'.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 cmds-filesystem.c | 4 ++--
 utils.c           | 6 +++++-
 utils.h           | 5 ++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index c7dae40..4bbff43 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -277,7 +277,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices,
 	u64 devs_found = 0;
 	u64 total;
 
-	if (add_seen_fsid(fs_devices->fsid, seen_fsid_hash))
+	if (add_seen_fsid(fs_devices->fsid, seen_fsid_hash, -1, NULL))
 		return;
 
 	uuid_unparse(fs_devices->fsid, uuidbuf);
@@ -324,7 +324,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
 	int ret;
 
-	ret = add_seen_fsid(fs_info->fsid, seen_fsid_hash);
+	ret = add_seen_fsid(fs_info->fsid, seen_fsid_hash, -1, NULL);
 	if (ret == -EEXIST)
 		return 0;
 	else if (ret)
diff --git a/utils.c b/utils.c
index f91d41e..bdfbfe0 100644
--- a/utils.c
+++ b/utils.c
@@ -1804,7 +1804,8 @@ int is_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[])
 	return 0;
 }
 
-int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[])
+int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[],
+		int fd, DIR *dirstream)
 {
 	u8 hash = fsid[0];
 	int slot = hash % SEEN_FSID_HASH_SIZE;
@@ -1832,6 +1833,8 @@ insert:
 
 	alloc->next = NULL;
 	memcpy(alloc->fsid, fsid, BTRFS_FSID_SIZE);
+	alloc->fd = fd;
+	alloc->dirstream = dirstream;
 
 	if (seen)
 		seen->next = alloc;
@@ -1851,6 +1854,7 @@ void free_seen_fsid(struct seen_fsid *seen_fsid_hash[])
 		seen = seen_fsid_hash[slot];
 		while (seen) {
 			next = seen->next;
+			close_file_or_dir(seen->fd, seen->dirstream);
 			free(seen);
 			seen = next;
 		}
diff --git a/utils.h b/utils.h
index da34e6c..bac7688 100644
--- a/utils.h
+++ b/utils.h
@@ -107,9 +107,12 @@ int get_fsid(const char *path, u8 *fsid, int silent);
 struct seen_fsid {
 	u8 fsid[BTRFS_FSID_SIZE];
 	struct seen_fsid *next;
+	DIR *dirstream;
+	int fd;
 };
 int is_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[]);
-int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[]);
+int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[],
+		int fd, DIR *dirstream);
 void free_seen_fsid(struct seen_fsid *seen_fsid_hash[]);
 
 int get_label(const char *btrfs_dev, char *label);
-- 
2.9.5

