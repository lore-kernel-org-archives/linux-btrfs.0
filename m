Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbaGBUen (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 16:34:43 -0400
Date: Wed, 2 Jul 2014 13:34:41 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: show extent state for a subvolume
Message-ID: <20140702203441.GY5484@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The qgroup verification code can trivially be extended to provide
extended information on the extents which a subvolume root
references. Along with qgroup-verify, I have found this tool to be
invaluable when tracking down extent references.

The patch adds a switch to the check subcommand '--subvol-extents'
which takes as args a single subvolume id. When run with the switch,
we'll print out each extent that the subvolume references. The extent
printout gives standard extent info you would expect along with
information on which other roots reference it.

Sample output follows - this is a few lines from a run on a subvolume
I've been testing qgroup changes on:

Print extent state for subvolume 281 on /dev/vdb2
UUID: 8203ca66-9858-4e3f-b447-5bbaacf79c02
Offset		Len	Root Refs	Roots
12582912	20480	12	257 279 280 281 282 283 284 285 286 287 288 289
12603392	8192	12	257 279 280 281 282 283 284 285 286 287 288 289
12611584	12288	12	257 279 280 281 282 283 284 285 286 287 288 289
 <snip a bunch of extents to show some variety>
124583936	16384	4	281 282 283 280
125075456	16384	4	280 281 282 283
126255104	16384	11	257 280 281 282 283 284 285 286 287 288 289
4763508736	4096	3	279 280 281

In case it wasn't clear, this applies on top of my qgroup verify patch:
"btrfs-progs: add quota group verify code"

A branch with all this can be found on github:

https://github.com/markfasheh/btrfs-progs-patches/tree/qgroup-verify

Please apply,

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 cmds-check.c    | 12 +++++++++
 qgroup-verify.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 qgroup-verify.h |  2 ++
 3 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5401ad9..18d4341 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6428,6 +6428,7 @@ static struct option long_options[] = {
 	{ "init-csum-tree", 0, NULL, 0 },
 	{ "init-extent-tree", 0, NULL, 0 },
 	{ "backup", 0, NULL, 0 },
+	{ "subvol-extents", 1, NULL, 'E' },
 	{ "qgroup-report", 0, NULL, 'Q' },
 	{ NULL, 0, NULL, 0}
 };
@@ -6442,6 +6443,7 @@ const char * const cmd_check_usage[] = {
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
 	"--qgroup-report             print a report on qgroup consistency",
+	"--subvol-extents            print subvolume extents and sharing state",
 	NULL
 };
 
@@ -6451,6 +6453,7 @@ int cmd_check(int argc, char **argv)
 	struct btrfs_root *root;
 	struct btrfs_fs_info *info;
 	u64 bytenr = 0;
+	u64 subvolid = 0;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
 	u64 num;
@@ -6486,6 +6489,9 @@ int cmd_check(int argc, char **argv)
 			case 'Q':
 				qgroup_report = 1;
 				break;
+			case 'E':
+				subvolid = arg_strtou64(optarg);
+				break;
 			case '?':
 			case 'h':
 				usage(cmd_check_usage);
@@ -6541,6 +6547,12 @@ int cmd_check(int argc, char **argv)
 			print_qgroup_report(1);
 		goto close_out;
 	}
+	if (subvolid) {
+		printf("Print extent state for subvolume %llu on %s\nUUID: %s\n",
+		       subvolid, argv[optind], uuidbuf);
+		ret = print_extent_state(info, subvolid);
+		goto close_out;
+	}
 	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
 
 	if (!extent_buffer_uptodate(info->tree_root->node) ||
diff --git a/qgroup-verify.c b/qgroup-verify.c
index f7692f9..81a1651 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -296,6 +296,8 @@ static void find_parent_roots(struct ulist *roots, u64 parent)
 	} while (node && ref->bytenr == parent);
 }
 
+static void print_subvol_info(u64 subvolid, u64 bytenr, u64 num_bytes,
+			      struct ulist *roots);
 /*
  * Account each ref. Walk the refs, for each set of refs in a
  * given bytenr:
@@ -308,7 +310,7 @@ static void find_parent_roots(struct ulist *roots, u64 parent)
  * - Walk ref_roots ulist, adding extent bytes to each qgroup count that
  *    cooresponds to a found root.
  */
-static void account_all_refs(void)
+static void account_all_refs(int do_qgroups, u64 search_subvol)
 {
 	int exclusive;
 	struct ref *ref;
@@ -358,11 +360,15 @@ static void account_all_refs(void)
 		else
 			exclusive = 0;
 
+		if (search_subvol)
+			print_subvol_info(search_subvol, bytenr, num_bytes,
+					  roots);
+
 		ULIST_ITER_INIT(&uiter);
 		while ((unode = ulist_next(roots, &uiter))) {
 			BUG_ON(unode->val == 0ULL);
 			/* We only want to account fs trees */
-			if (is_fstree(unode->val))
+			if (is_fstree(unode->val) && do_qgroups)
 				add_bytes(unode->val, num_bytes, exclusive);
 		}
 	}
@@ -1072,7 +1078,7 @@ int qgroup_verify_all(struct btrfs_fs_info *info)
 		goto out;
 	}
 
-	account_all_refs();
+	account_all_refs(1, 0);
 
 out:
 	/*
@@ -1083,3 +1089,72 @@ out:
 	free_ref_tree(&by_bytenr);
 	return ret;
 }
+
+static void __print_subvol_info(u64 bytenr, u64 num_bytes, struct ulist *roots)
+{
+	int n = roots->nnodes;
+	struct ulist_iterator uiter;
+	struct ulist_node *unode;
+
+	printf("%llu\t%llu\t%d\t", bytenr, num_bytes, n);
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(roots, &uiter))) {
+		printf("%llu ", unode->val);
+	}
+	printf("\n");
+}
+
+static void print_subvol_info(u64 subvolid, u64 bytenr, u64 num_bytes,
+			      struct ulist *roots)
+{
+	struct ulist_iterator uiter;
+	struct ulist_node *unode;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(roots, &uiter))) {
+		BUG_ON(unode->val == 0ULL);
+		if (unode->val == subvolid) {
+			__print_subvol_info(bytenr, num_bytes, roots);
+			return;
+		}
+	}
+
+
+}
+
+int print_extent_state(struct btrfs_fs_info *info, u64 subvol)
+{
+	int ret;
+
+	tree_blocks = ulist_alloc(0);
+	if (!tree_blocks) {
+		fprintf(stderr,
+			"ERROR: Out of memory while allocating ulist.\n");
+		return ENOMEM;
+	}
+
+	/*
+	 * Put all extent refs into our rbtree
+	 */
+	ret = scan_extents(info, 0, ~0ULL);
+	if (ret) {
+		fprintf(stderr, "ERROR: while scanning extent tree: %d\n", ret);
+		goto out;
+	}
+
+	ret = map_implied_refs(info);
+	if (ret) {
+		fprintf(stderr, "ERROR: while mapping refs: %d\n", ret);
+		goto out;
+	}
+
+	printf("Offset\t\tLen\tRoot Refs\tRoots\n");
+	account_all_refs(0, subvol);
+
+out:
+	free_tree_blocks();
+	free_ref_tree(&by_bytenr);
+	return ret;
+}
+
diff --git a/qgroup-verify.h b/qgroup-verify.h
index a222c17..9201407 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -22,4 +22,6 @@
 int qgroup_verify_all(struct btrfs_fs_info *info);
 void print_qgroup_report(int all);
 
+int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
+
 #endif	/* _BTRFS_QGROUP_VERIFY_H */
-- 
1.8.4.5

