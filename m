Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490FEC4161B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0719520989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0719520989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbeK0Q2Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:16 -0500
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:36633 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbeK0Q2P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:15 -0500
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2018 11:28:12 EST
Received: from yt-mxoi1.gw.nic.fujitsu.com (unknown [192.168.229.67]) by mgwym01.jp.fujitsu.com with smtp
         id 4226_7b17_bcc0966b_0df7_451c_8176_912e7dded632;
        Tue, 27 Nov 2018 14:20:24 +0900
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id C9E8DAC0115
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:23 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id F41DF584296;
        Tue, 27 Nov 2018 14:20:22 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:22 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>
Subject: [PATCH 3/8] btrfs-progs: sub list: Change the default behavior of "subvolume list" and allow non-privileged user to call it
Date:   Tue, 27 Nov 2018 14:24:44 +0900
Message-ID: <cef2039fd3475d81857ff3f8115edcec648ac354.1543294426.git.misono.tomohiro@jp.fujitsu.com>
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

Change the default behavior of "subvolume list" and allow non-privileged
user to call it as well.

From this commit, by default it only lists subvolumes under the specified
path (incl. the path itself except top-level subvolume. the path needs
to be a subvolume). Also, if kernel supports new ioctls
(BTRFS_IOC_GET_SUBVOL_INFO/BTRFS_IOC_GET_SUBVOL_ROOTREF and
BTRFS_IOC_INO_LOOKUP_USER, which are avilable from 4.18), non-privileged
user can also use "sub list" command (subvolumes which the user does not
have access right will be skiped).

Note that root user can list all the subvolume in the fs with -a option.

[Example]
 $ mkfs.btrfs -f $DEV
 $ mount $DEV /mnt

 $ btrfs subvolume create /mnt/AAA
 $ btrfs subvolume create /mnt/AAA/BBB
 $ mkdir /mnt/AAA/BBB/dir
 $ btrfs subvolume create /mnt/AAA/BBB/dir/CCC
 $ btrfs subvolume create /mnt/ZZZ

 $ umount /mnt
 $ mount -o subvol=AAA $DEV /mnt

 $ btrfs subvolume list /mnt
 ID 256 gen 11 top level 5 path .
 ID 257 gen 8 top level 256 path BBB
 ID 258 gen 8 top level 257 path BBB/dir/CCC

 $ btrfs subvolume list /mnt/BBB
 ID 257 gen 8 top level 256 path .
 ID 258 gen 8 top level 257 path dir/CCC

 ** output of progs <= 4.19
 $ mount -o subvol=AAA $DEV /mnt
 $ btrfs subvolume list /mnt
 ID 256 gen 11 top level 5 path AAA
 ID 257 gen 8 top level 256 path BBB
 ID 258 gen 8 top level 257 path BBB/dir/CCC
 ID 259 gen 11 top level 256 path ZZZ

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 Documentation/btrfs-subvolume.asciidoc |   8 +-
 cmds-subvolume.c                       | 144 +++++++++++++++++++------
 2 files changed, 119 insertions(+), 33 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index f3eb4e26..99fff977 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -95,6 +95,12 @@ The output format is similar to *subvolume list* command.
 
 *list* [options] [-G [\+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>::
 List the subvolumes present in the filesystem <path>.
+By default, this only lists the subvolumes under <path>,
+including <path> itself (except top-level subvolume).
++
+This command had required root privileges. From kernel 4.18,
+non privileged user can call this too. Also from kernel 4.18,
+It is possible to specify non-subvolume directory as <path>.
 +
 For every subvolume the following information is shown by default:
 +
@@ -102,7 +108,7 @@ ID <ID> gen <generation> top level <ID> path <path>
 +
 where ID is subvolume's id, gen is an internal counter which is updated
 every transaction, top level is the same as parent subvolume's id, and
-path is the relative path of the subvolume to the top level subvolume.
+path is the relative path of the subvolume to the specified path.
 The subvolume's ID may be used by the subvolume set-default command,
 or at mount time via the subvolid= option.
 +
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 40cc2687..ef613662 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1128,9 +1128,37 @@ out:
 	return subvols;
 }
 
+static int add_subvol(struct subvol_list **subvols,
+		      struct listed_subvol *subvol,
+		      size_t *capacity)
+{
+	if ((*subvols)->num >= *capacity) {
+		struct subvol_list *new_subvols;
+		size_t new_capacity = max_t(size_t, 1, *capacity * 2);
+
+		new_subvols = realloc(*subvols,
+				      sizeof(*new_subvols) +
+				      new_capacity *
+				      sizeof(new_subvols->subvols[0]));
+		if (!new_subvols) {
+			error("out of memory");
+			return -1;
+		}
+
+		*subvols = new_subvols;
+		*capacity = new_capacity;
+	}
+
+	(*subvols)->subvols[(*subvols)->num] = *subvol;
+	(*subvols)->num++;
+
+	return 0;
+}
+
 static void get_subvols_info(struct subvol_list **subvols,
 			     struct btrfs_list_filter_set_v2 *filter_set,
 			     int fd,
+			     int tree_id,
 			     size_t *capacity)
 {
 	struct btrfs_util_subvolume_iterator *iter;
@@ -1138,7 +1166,7 @@ static void get_subvols_info(struct subvol_list **subvols,
 	int ret = -1;
 
 	err = btrfs_util_create_subvolume_iterator_fd(fd,
-						      BTRFS_FS_TREE_OBJECTID, 0,
+						      tree_id, 0,
 						      &iter);
 	if (err) {
 		iter = NULL;
@@ -1146,6 +1174,52 @@ static void get_subvols_info(struct subvol_list **subvols,
 		goto out;
 	}
 
+	/*
+	 * Subvolume iterator does not include the information of the
+	 * specified path/fd. So, add it first.
+	 */
+	if (!tree_id) {
+		uint64_t id;
+		struct listed_subvol subvol;
+
+		err = btrfs_util_is_subvolume_fd(fd);
+		if (err != BTRFS_UTIL_OK) {
+			if (err == BTRFS_UTIL_ERROR_NOT_SUBVOLUME) {
+				ret = 0;
+				goto skip;
+			} else {
+				ret = -1;
+				goto out;
+			}
+		}
+		err = btrfs_util_subvolume_id_fd(fd, &id);
+		if (err) {
+			ret = -1;
+			goto out;
+		}
+		if (id == BTRFS_FS_TREE_OBJECTID) {
+			/* Skip top level subvolume */
+			ret = 0;
+			goto skip;
+		}
+
+		err = btrfs_util_subvolume_info_fd(fd, 0, &subvol.info);
+		if (err) {
+			ret = -1;
+			goto out;
+		}
+
+		subvol.path = strdup(".");
+		if (!filters_match(&subvol, filter_set)) {
+			free(subvol.path);
+		} else {
+			ret = add_subvol(subvols, &subvol, capacity);
+			if (ret)
+				goto out;
+		}
+	}
+
+skip:
 	for (;;) {
 		struct listed_subvol subvol;
 
@@ -1156,33 +1230,17 @@ static void get_subvols_info(struct subvol_list **subvols,
 			break;
 		} else if (err) {
 			error_btrfs_util(err);
+			ret = -1;
 			goto out;
 		}
 
 		if (!filters_match(&subvol, filter_set)) {
 			free(subvol.path);
-			continue;
-		}
-
-		if ((*subvols)->num >= *capacity) {
-			struct subvol_list *new_subvols;
-			size_t new_capacity = max_t(size_t, 1, *capacity * 2);
-
-			new_subvols = realloc(*subvols,
-					      sizeof(*new_subvols) +
-					      new_capacity *
-					      sizeof(new_subvols->subvols[0]));
-			if (!new_subvols) {
-				error("out of memory");
+		} else {
+			ret = add_subvol(subvols, &subvol, capacity);
+			if (ret)
 				goto out;
-			}
-
-			*subvols = new_subvols;
-			*capacity = new_capacity;
 		}
-
-		(*subvols)->subvols[(*subvols)->num] = subvol;
-		(*subvols)->num++;
 	}
 
 	ret = 0;
@@ -1196,6 +1254,8 @@ out:
 }
 
 static struct subvol_list *btrfs_list_subvols(int fd,
+					      int is_list_all,
+					      const char *path,
 					      struct btrfs_list_filter_set_v2 *filter_set)
 {
 	struct subvol_list *subvols;
@@ -1208,7 +1268,11 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 	}
 	subvols->num = 0;
 
-	get_subvols_info(&subvols, filter_set, fd, &capacity);
+	if (is_list_all)
+		get_subvols_info(&subvols, filter_set, fd,
+				BTRFS_FS_TREE_OBJECTID, &capacity);
+	else
+		get_subvols_info(&subvols, filter_set, fd, 0, &capacity);
 
 	return subvols;
 }
@@ -1217,20 +1281,16 @@ static int btrfs_list_subvols_print_v2(int fd,
 				    struct btrfs_list_filter_set_v2 *filter_set,
 				    struct btrfs_list_comparer_set_v2 *comp_set,
 				    enum btrfs_list_layout layout,
-				    int full_path, const char *raw_prefix)
+				    int is_list_all,
+				    const char *path,
+				    const char *raw_prefix)
 {
 	struct subvol_list *subvols;
 
-	/*
-	 * full_path hasn't done anything since 4f5ebb3ef553 ("Btrfs-progs: fix
-	 * to make list specified directory's subvolumes work"). See
-	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html
-	 */
-
 	if (filter_set->only_deleted)
 		subvols = btrfs_list_deleted_subvols(fd, filter_set);
 	else
-		subvols = btrfs_list_subvols(fd, filter_set);
+		subvols = btrfs_list_subvols(fd, is_list_all, path, filter_set);
 	if (!subvols)
 		return -1;
 
@@ -1326,6 +1386,14 @@ static int btrfs_list_parse_filter_string_v2(char *opt_arg,
 	return 0;
 }
 
+static bool is_root(void)
+{
+	uid_t uid;
+
+	uid = geteuid();
+	return (uid == 0);
+}
+
 /*
  * Naming of options:
  * - uppercase for filters and sort options
@@ -1334,12 +1402,18 @@ static int btrfs_list_parse_filter_string_v2(char *opt_arg,
 static const char * const cmd_subvol_list_usage[] = {
 	"btrfs subvolume list [options] <path>",
 	"List subvolumes and snapshots in the filesystem.",
+	"By default, this only lists the subvolumes under <path>,",
+	"including <path> itself (except top-level subvolume).",
+	"",
+	"This command had required root privileges. From kernel 4.18,",
+	"non privileged user can call this too. Also from kernel 4.18,",
+	"It is possible to specify non-subvolume directory as <path>.",
 	"",
 	"Path filtering:",
 	"-o           print only subvolumes below specified path",
 	"-a           print all the subvolumes in the filesystem and",
 	"             distinguish absolute and relative path with respect",
-	"             to the given <path>",
+	"             to the given <path> (require root privileges)",
 	"",
 	"Field selection:",
 	"-p           print parent ID",
@@ -1485,6 +1559,12 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
+	if (is_list_all && !is_root()) {
+		ret = -1;
+		error("only root can use -a option");
+		goto out;
+	}
+
 	subvol = argv[optind];
 	fd = btrfs_open_dir(subvol, &dirstream, 1);
 	if (fd < 0) {
@@ -1517,7 +1597,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	btrfs_list_setup_print_column_v2(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print_v2(fd, filter_set, comparer_set,
-			layout, !is_list_all && !is_only_in_path, NULL);
+			layout, is_list_all, subvol, NULL);
 
 out:
 	close_file_or_dir(fd, dirstream);
-- 
2.19.1


