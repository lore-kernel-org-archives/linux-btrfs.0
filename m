Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:41353 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161962AbeBOTFz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:55 -0500
Received: by mail-pl0-f65.google.com with SMTP id k8so346917pli.8
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:55 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 25/27] btrfs-progs: add recursive snapshot/delete using libbtrfsutil
Date: Thu, 15 Feb 2018 11:05:10 -0800
Message-Id: <0c443530936babb4c061c71817aa324da168e116.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

And update the documentation.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Documentation/btrfs-subvolume.asciidoc | 14 ++++++++++++--
 cmds-subvolume.c                       | 25 +++++++++++++++++++++----
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index a8c4af4b..7a2ec8d2 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -81,6 +81,12 @@ wait for transaction commit at the end of the operation
 +
 -C|--commit-each::::
 wait for transaction commit after deleting each subvolume
++
+-R|--recursive::::
+delete subvolumes beneath each subvolume recursively
++
+-v|--verbose::::
+output more verbosely
 
 *find-new* <subvolume> <last_gen>::
 List the recently modified files in a subvolume, after <last_gen> ID.
@@ -157,7 +163,7 @@ The id can be obtained from *btrfs subvolume list*, *btrfs subvolume show* or
 *show* <path>::
 Show information of a given subvolume in the <path>.
 
-*snapshot* [-r] <source> <dest>|[<dest>/]<name>::
+*snapshot* [-r|-R] <source> <dest>|[<dest>/]<name>::
 Create a snapshot of the subvolume <source> with the
 name <name> in the <dest> directory.
 +
@@ -167,7 +173,11 @@ If <source> is not a subvolume, btrfs returns an error.
 `Options`
 +
 -r::::
-Make the new snapshot read only.
+make the new snapshot read-only
++
+-R::::
+recursively snapshot subvolumes beneath the source; this option cannot be
+combined with -r
 
 *sync* <path> [subvolid...]::
 Wait until given subvolume(s) are completely removed from the filesystem after
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 43875c96..101ba4ca 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -187,6 +187,7 @@ static const char * const cmd_subvol_delete_usage[] = {
 	"",
 	"-c|--commit-after      wait for transaction commit at the end of the operation",
 	"-C|--commit-each       wait for transaction commit after deleting each subvolume",
+	"-R|--recursive         delete subvolumes beneath each subvolume recursively",
 	"-v|--verbose           verbose output of operations",
 	NULL
 };
@@ -203,6 +204,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 	DIR	*dirstream = NULL;
 	int verbose = 0;
 	int commit_mode = 0;
+	int flags = 0;
 	u8 fsid[BTRFS_FSID_SIZE];
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = { NULL, };
@@ -214,11 +216,12 @@ static int cmd_subvol_delete(int argc, char **argv)
 		static const struct option long_options[] = {
 			{"commit-after", no_argument, NULL, 'c'},
 			{"commit-each", no_argument, NULL, 'C'},
+			{"recursive", no_argument, NULL, 'R'},
 			{"verbose", no_argument, NULL, 'v'},
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "cCv", long_options, NULL);
+		c = getopt_long(argc, argv, "cCRv", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -229,6 +232,9 @@ static int cmd_subvol_delete(int argc, char **argv)
 		case 'C':
 			commit_mode = COMMIT_EACH;
 			break;
+		case 'R':
+			flags |= BTRFS_UTIL_DELETE_SUBVOLUME_RECURSIVE;
+			break;
 		case 'v':
 			verbose++;
 			break;
@@ -280,7 +286,7 @@ again:
 		commit_mode == COMMIT_EACH || (commit_mode == COMMIT_AFTER && cnt + 1 == argc)
 		? "commit" : "no-commit", dname, vname);
 
-	err = btrfs_util_delete_subvolume_fd(fd, vname, 0);
+	err = btrfs_util_delete_subvolume_fd(fd, vname, flags);
 	if (err) {
 		error_btrfs_util(err);
 		ret = 1;
@@ -569,13 +575,15 @@ out:
 }
 
 static const char * const cmd_subvol_snapshot_usage[] = {
-	"btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
+	"btrfs subvolume snapshot [-r|-R] [-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
 	"Create a snapshot of the subvolume",
 	"Create a writable/readonly snapshot of the subvolume <source> with",
 	"the name <name> in the <dest> directory.  If only <dest> is given,",
 	"the subvolume will be named the basename of <source>.",
 	"",
 	"-r             create a readonly snapshot",
+	"-R             recursively snapshot subvolumes beneath the source; this",
+	"               option cannot be combined with -r",
 	"-i <qgroupid>  add the newly created snapshot to a qgroup. This",
 	"               option can be given multiple times.",
 	NULL
@@ -589,7 +597,7 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 	int retval = 1;
 
 	while (1) {
-		int c = getopt(argc, argv, "i:r");
+		int c = getopt(argc, argv, "i:rR");
 		if (c < 0)
 			break;
 
@@ -601,11 +609,20 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 		case 'r':
 			flags |= BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY;
 			break;
+		case 'R':
+			flags |= BTRFS_UTIL_CREATE_SNAPSHOT_RECURSIVE;
+			break;
 		default:
 			usage(cmd_subvol_snapshot_usage);
 		}
 	}
 
+	if ((flags & BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY) &&
+	    (flags & BTRFS_UTIL_CREATE_SNAPSHOT_RECURSIVE)) {
+		error("-r and -R cannot be combined");
+		return 1;
+	}
+
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_subvol_snapshot_usage);
 
-- 
2.16.1

