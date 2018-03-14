Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50115 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932590AbeCNBFu (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 13 Mar 2018 21:05:50 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: inspect-dump-tree: add '-f|--follow' options to print all children tree blocks for '-b'
Date: Wed, 14 Mar 2018 09:05:38 +0800
Message-Id: <20180314010538.29292-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When debuging with "btrfs inspect dump-tree", it's not that handy if we
want to iterate all child tree blocks starting from a specified block.

-b can only print a single block, while without -b "btrfs inspect dump-tree"
will need extra tree roots fulfilled to continue, which is not possible
for some damaged filesystem.

Add a new option '-f|--follow' to iterate a sub-tree starting from block
specified by '-b|--block', so we would have less limitation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-inspect-internal.asciidoc |  2 ++
 cmds-inspect-dump-tree.c                      | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index e072a943f825..04cf81b93b8a 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -87,6 +87,8 @@ the respective tree root block offset
 print only the uuid tree information, empty output if the tree does not exist
 -b <block_num>::::
 print info of the specified block only
+-f|--follow::::
+use with '-b', print all children tree blocks of '<block_num>'
 -t <tree_id>::::
 print only the tree with the specified ID, where the ID can be numerical or
 common name in a flexible human readable form
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index df44bb635c9c..5eb9ca34b99a 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -198,6 +198,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
 	"-u|--uuid              print only the uuid tree",
 	"-b|--block <block_num> print info from the specified block only",
 	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
+	"-f|--follow            use with '-b', to show all children tree blocks of <block_num>",
 	NULL
 };
 
@@ -223,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	u64 block_only = 0;
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
+	bool follow = false;
 
 	while (1) {
 		int c;
@@ -234,10 +236,11 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			{ "uuid", no_argument, NULL, 'u'},
 			{ "block", required_argument, NULL, 'b'},
 			{ "tree", required_argument, NULL, 't'},
+			{ "follow", no_argument, NULL, 'f'},
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "deb:rRut:", long_options, NULL);
+		c = getopt_long(argc, argv, "deb:rRut:f", long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
@@ -286,6 +289,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			}
 			break;
 			}
+		case 'f':
+			follow = true;
+			break;
 		default:
 			usage(cmd_inspect_dump_tree_usage);
 		}
@@ -324,7 +330,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 				(unsigned long long)block_only);
 			goto close_root;
 		}
-		btrfs_print_tree(root, leaf, 0);
+		btrfs_print_tree(root, leaf, follow);
 		free_extent_buffer(leaf);
 		goto close_root;
 	}
-- 
2.16.2

