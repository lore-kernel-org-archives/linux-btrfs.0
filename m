Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E4AC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6EC208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B6EC208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbeK0Q2i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:38 -0500
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:39421 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbeK0Q2i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:38 -0500
Received: from yt-mxoi2.gw.nic.fujitsu.com (unknown [192.168.229.69]) by mgwym02.jp.fujitsu.com with smtp
         id 0238_95b3_edefa8bc_83bc_42e3_96d7_4a85b7208d69;
        Tue, 27 Nov 2018 14:20:24 +0900
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 87603AC00E3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:24 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id A6F276D656B;
        Tue, 27 Nov 2018 14:20:23 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:23 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>
Subject: [PATCH 6/8] btrfs-progs: sub show: Allow non-privileged user to call "subvolume show"
Date:   Tue, 27 Nov 2018 14:24:47 +0900
Message-ID: <be63681e0f2bd653b20f8f46a00b1eec373ec4af.1543294426.git.misono.tomohiro@jp.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: disable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Allow non-privileged user to call subvolume show if new ioctls
(BTRFS_IOC_GET_SUBVOL_INFO/BTRFS_IOC_GET_SUBVOL_ROOTREF,
BTRFS_IOC_INO_LOOKUP_USER, from kernel 4.18) are available.
Non-privileged user still cannot use -r or -u option.

The behavior for root user is the same as before.

There are some output differences between root and user:
  root ... subvolume path is from top-level subvolume
           list all snapshots in the fs (inc. non-accessible ones)
  user ... subvolume path is absolute path
           list snapshots under the mountpoint
	   (only to which the user has appropriate access right)

[Example]
 $ sudo mkfs.btrfs -f $DEV
 $ sudo mount $DEV /mnt

 $ sudo btrfs subvolume create /mnt/AAA
 $ sudo btrfs subvolume snapshot /mnt/AAA /mnt/snap1
 $ sudo btrfs subvolume snapshot /mnt/AAA /mnt/AAA/snap2

 $ sudo umount /mnt
 $ sudo mount -o subvol=AAA $DEV /mnt

 # root
 $ sudo btrfs subvolume show /mnt
 AAA
      Name:        AAA
      UUID:        15e80697-2ffb-0b4b-8e1e-e0873a7cf944
      ...
      Snapshot(s):
                   AAA/snap2
                   snap1

 # non-privileged user
 $ btrfs subvolume show /mnt
 /mnt
      Name:        AAA
      UUID:        15e80697-2ffb-0b4b-8e1e-e0873a7cf944
      ...
      Snapshot(s):
                   /mnt/snap2

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 Documentation/btrfs-subvolume.asciidoc |  11 ++-
 cmds-subvolume.c                       | 107 ++++++++++++++++++++++---
 2 files changed, 105 insertions(+), 13 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index 428a2faa..ea8e9554 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -182,12 +182,19 @@ The id can be obtained from *btrfs subvolume list*, *btrfs subvolume show* or
 *show* [options] <path>|<mnt>::
 Show information of a given subvolume in the <path>.
 +
+This command had required root privileges. From kernel 4.18,
+non-privileged user can call this unless -r/-u option is not used.
+Note that for root, output path is relative to the top-level subvolume
+while absolute path is shown for non-privileged user.
+Also for root, snapshots filed lists all the snapshots in the fs while
+only snapshots under mount point are shown for non-privileged user.
++
 `Options`
 +
 -r|--rootid::::
-rootid of the subvolume.
+rootid of the subvolume (require root privileges).
 -u|--uuid:::
-UUID of the subvolume.
+UUID of the subvolume (require root privileges).
 
 +
 If no option is specified, subvolume information of <path> is shown,
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index cd2e4425..ab1f14a2 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1886,8 +1886,12 @@ static int cmd_subvol_find_new(int argc, char **argv)
 static const char * const cmd_subvol_show_usage[] = {
 	"btrfs subvolume show [options] <subvol-path>|<mnt>",
 	"Show more information about the subvolume",
-	"-r|--rootid   rootid of the subvolume",
-	"-u|--uuid     uuid of the subvolume",
+	"",
+	"This command had required root privileges. From kernel 4.18,",
+	"non-privileged user can call this unless -r/-u option is not used.",
+	"",
+	"-r|--rootid   rootid of the subvolume (require root privileges)",
+	"-u|--uuid     uuid of the subvolume   (require root privileges)",
 	"",
 	"If no option is specified, <subvol-path> will be shown, otherwise",
 	"the rootid or uuid are resolved relative to the <mnt> path.",
@@ -1900,8 +1904,10 @@ static int cmd_subvol_show(int argc, char **argv)
 	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
 	char *fullpath = NULL;
 	int fd = -1;
+	int fd_mnt = -1;
 	int ret = 1;
 	DIR *dirstream1 = NULL;
+	DIR *dirstream_mnt = NULL;
 	int by_rootid = 0;
 	int by_uuid = 0;
 	u64 rootid_arg = 0;
@@ -1909,7 +1915,10 @@ static int cmd_subvol_show(int argc, char **argv)
 	struct btrfs_util_subvolume_iterator *iter;
 	struct btrfs_util_subvolume_info subvol;
 	char *subvol_path = NULL;
+	char *subvol_name = NULL;
+	char *mount_point = NULL;
 	enum btrfs_util_error err;
+	bool root;
 
 	optind = 0;
 	while (1) {
@@ -1947,6 +1956,12 @@ static int cmd_subvol_show(int argc, char **argv)
 		usage(cmd_subvol_show_usage);
 	}
 
+	root = is_root();
+	if (!root && (by_rootid || by_uuid)) {
+		error("only root can use -r or -u options");
+		return -1;
+	}
+
 	fullpath = realpath(argv[optind], NULL);
 	if (!fullpath) {
 		error("cannot find real path for '%s': %m", argv[optind]);
@@ -2001,19 +2016,53 @@ static int cmd_subvol_show(int argc, char **argv)
 			goto out;
 		}
 
-		err = btrfs_util_subvolume_path_fd(fd, subvol.id, &subvol_path);
-		if (err) {
-			error_btrfs_util(err);
-			goto out;
+		if (root) {
+			/* Construct path relative to top-level subvolume */
+			err = btrfs_util_subvolume_path_fd(fd, subvol.id,
+								&subvol_path);
+			if (err) {
+				error_btrfs_util(err);
+				goto out;
+			}
+			subvol_name = strdup(basename(subvol_path));
+		} else {
+			/* Show absolute path */
+			subvol_path = strdup(fullpath);
+
+			ret = find_mount_root(fullpath, &mount_point);
+			if (ret < 0) {
+				error("cannot get mount point");
+				goto out;
+			}
+			fd_mnt = open_file_or_dir(mount_point, &dirstream_mnt);
+			if (fd_mnt < 0) {
+				error("cannot open mount point");
+				goto out;
+			}
+			/* Get real name if the path is mount point */
+			if (strlen(fullpath) == strlen(mount_point)) {
+				struct btrfs_ioctl_get_subvol_info_args arg;
+
+				ret = ioctl(fd_mnt, BTRFS_IOC_GET_SUBVOL_INFO,
+							&arg);
+				if (ret < 0) {
+					error("cannot get subvolume info");
+					goto out;
+				}
+				subvol_name = strdup(arg.name);
+			} else {
+				subvol_name = strdup(basename(subvol_path));
+			}
 		}
 
 	}
 
 	/* print the info */
-	printf("%s\n", subvol.id == BTRFS_FS_TREE_OBJECTID ? "/" : subvol_path);
+	printf("%s\n", (subvol.id == BTRFS_FS_TREE_OBJECTID && root) ?
+			"/" : subvol_path);
 	printf("\tName: \t\t\t%s\n",
 	       (subvol.id == BTRFS_FS_TREE_OBJECTID ? "<FS_TREE>" :
-		basename(subvol_path)));
+					subvol_name));
 
 	if (uuid_is_null(subvol.uuid))
 		strcpy(uuidparse, "-");
@@ -2056,9 +2105,18 @@ static int cmd_subvol_show(int argc, char **argv)
 	/* print the snapshots of the given subvol if any*/
 	printf("\tSnapshot(s):\n");
 
-	err = btrfs_util_create_subvolume_iterator_fd(fd,
-						      BTRFS_FS_TREE_OBJECTID, 0,
-						      &iter);
+	/*
+	 * For root, show all snapshots in the filesystem.
+	 * For non-privileged user, show all snapshots under mount point.
+	 */
+	if (root)
+		err = btrfs_util_create_subvolume_iterator_fd(fd,
+					      BTRFS_FS_TREE_OBJECTID, 0,
+					      &iter);
+	else
+		err = btrfs_util_create_subvolume_iterator_fd(fd_mnt,
+					      0, 0,
+					      &iter);
 
 	for (;;) {
 		struct btrfs_util_subvolume_info subvol2;
@@ -2070,9 +2128,33 @@ static int cmd_subvol_show(int argc, char **argv)
 		} else if (err) {
 			error_btrfs_util(err);
 			btrfs_util_destroy_subvolume_iterator(iter);
+			ret = -1;
 			goto out;
 		}
 
+		if (!root) {
+			/* Make path absolute */
+			char *temp = malloc(strlen(mount_point) +
+						   strlen(path) + 2);
+
+			if (!temp) {
+				error("out of memory");
+				ret = -1;
+				goto out;
+			}
+
+			strcpy(temp, mount_point);
+			if (strlen(mount_point) == 1) {
+				strcpy(temp + 1, path);
+			} else {
+				temp[strlen(mount_point)] = '/';
+				strcpy(temp + strlen(mount_point) + 1, path);
+			}
+
+			free(path);
+			path = temp;
+		}
+
 		if (uuid_compare(subvol2.parent_uuid, subvol.uuid) == 0)
 			printf("\t\t\t\t%s\n", path);
 
@@ -2083,8 +2165,11 @@ static int cmd_subvol_show(int argc, char **argv)
 	ret = 0;
 out:
 	free(subvol_path);
+	free(subvol_name);
 	close_file_or_dir(fd, dirstream1);
+	close_file_or_dir(fd_mnt, dirstream_mnt);
 	free(fullpath);
+	free(mount_point);
 	return !!ret;
 }
 
-- 
2.19.1


