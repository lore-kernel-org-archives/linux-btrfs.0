From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH 1/4] fix segfaults from bnc#710486
Date: Thu, 12 Jan 2012 16:17:44 +0100
Message-ID: <1326381467-19848-2-git-send-email-danny.kukawka@bisect.de>
References: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
List-ID: <linux-btrfs.vger.kernel.org>

Fixed segfaults from bnc#710486 due to unchecked usage of return
value from open_ctree().
---
 btrfs-image.c        |    5 +++++
 btrfs-select-super.c |    4 +++-
 btrfslabel.c         |    8 ++++++++
 btrfstune.c          |    5 +++++
 dir-test.c           |   11 +++++++++++
 find-root.c          |    5 ++++-
 mkfs.c               |    6 ++++++
 quick-test.c         |   20 ++++++++++++++++++++
 random-test.c        |    8 ++++++++
 9 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index f2bbcc8..7dc131d 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -491,6 +491,11 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	int ret;
 
 	root = open_ctree(input, 0, 0);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		exit(1);
+	}
+
 	BUG_ON(root->nodesize != root->leafsize);
 
 	ret = metadump_init(&metadump, root, out, num_threads,
diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 51eb9c9..0c4f5c0 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -84,8 +84,10 @@ int main(int ac, char **av)
 
 	root = open_ctree(av[optind], bytenr, 1);
 
-	if (root == NULL)
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
 		return 1;
+	}
 
 	/* make the super writing code think we've read the first super */
 	root->fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
diff --git a/btrfslabel.c b/btrfslabel.c
index c9f4684..2e5d539 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -55,6 +55,10 @@ static void change_label_unmounted(char *dev, char *nLabel)
         * and as read-write.
         */
        root = open_ctree(dev, 0, 1);
+       if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		return;
+       }
 
        trans = btrfs_start_transaction(root, 1);
        strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
@@ -72,6 +76,10 @@ static void get_label_unmounted(char *dev)
         * and as read-only.
         */
        root = open_ctree(dev, 0, 0);
+       if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		return;
+       }
 
        fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
 
diff --git a/btrfstune.c b/btrfstune.c
index 47830c5..6950f74 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -108,6 +108,11 @@ int main(int argc, char *argv[])
 
 	root = open_ctree(device, 0, 1);
 
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		return 1;
+	}
+
 	if (seeding_flag) {
 		ret = update_seeding_flag(root, seeding_value);
 		if (!ret)
diff --git a/dir-test.c b/dir-test.c
index 3ae9c68..c7644d6 100644
--- a/dir-test.c
+++ b/dir-test.c
@@ -436,6 +436,12 @@ int main(int ac, char **av)
 	radix_tree_init();
 
 	root = open_ctree(av[ac-1], &super, 0);
+
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		return 1;
+	}
+
 	trans = btrfs_start_transaction(root, 1);
 
 	dir_oid = btrfs_super_root_dir(&super);
@@ -479,6 +485,11 @@ int main(int ac, char **av)
 				btrfs_header_nritems(&root->node->node.header));
 			close_ctree(root, &super);
 			root = open_ctree("dbfile", &super, 0);
+
+			if (!root) {
+				fprintf(stderr, "Open ctree failed\n");
+				return 1;
+			}
 		}
 		while(count--) {
 			ret = ops[op](trans, root, &radix);
diff --git a/find-root.c b/find-root.c
index c0f38b8..83f1592 100644
--- a/find-root.c
+++ b/find-root.c
@@ -448,8 +448,11 @@ int main(int argc, char **argv)
 
 	root = open_ctree_broken(dev_fd, argv[optind]);
 	close(dev_fd);
-	if (!root)
+
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
+	}
 
 	csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
 	ret = find_root(root);
diff --git a/mkfs.c b/mkfs.c
index e3ced19..4b4930a 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1329,6 +1329,12 @@ int main(int ac, char **av)
 		exit(1);
 	}
 	root = open_ctree(file, 0, O_RDWR);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		close (fd);
+		exit(1);
+	}
+
 	root->fs_info->alloc_start = alloc_start;
 
 	ret = make_root_dir(root, mixed);
diff --git a/quick-test.c b/quick-test.c
index fa6fd83..05d73fd 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -52,6 +52,10 @@ int main(int ac, char **av) {
 	radix_tree_init();
 
 	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		exit(1);
+	}
 	trans = btrfs_start_transaction(root, 1);
 	srand(55);
 	btrfs_set_key_type(&ins, BTRFS_STRING_ITEM_KEY);
@@ -75,6 +79,10 @@ int main(int ac, char **av) {
 	close_ctree(root);
 	exit(1);
 	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		exit(1);
+	}
 	printf("starting search\n");
 	srand(55);
 	for (i = 0; i < run_size; i++) {
@@ -94,6 +102,10 @@ int main(int ac, char **av) {
 	close_ctree(root);
 
 	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		exit(1);
+	}
 	printf("node %p level %d total ptrs %d free spc %lu\n", root->node,
 	        btrfs_header_level(root->node),
 		btrfs_header_nritems(root->node),
@@ -122,6 +134,10 @@ int main(int ac, char **av) {
 	close_ctree(root);
 
 	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		exit(1);
+	}
 	trans = btrfs_start_transaction(root, 1);
 	srand(128);
 	for (i = 0; i < run_size; i++) {
@@ -138,6 +154,10 @@ int main(int ac, char **av) {
 	close_ctree(root);
 
 	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		exit(1);
+	}
 	srand(128);
 	printf("starting search2\n");
 	for (i = 0; i < run_size; i++) {
diff --git a/random-test.c b/random-test.c
index 0003236..3a07e6d 100644
--- a/random-test.c
+++ b/random-test.c
@@ -356,6 +356,10 @@ int main(int ac, char **av)
 	struct btrfs_trans_handle *trans;
 	radix_tree_init();
 	root = open_ctree("dbfile", &super);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		exit(1);
+	}
 	fill_radix(root, &radix);
 
 	signal(SIGTERM, sigstopper);
@@ -398,6 +402,10 @@ int main(int ac, char **av)
 				btrfs_header_nritems(&root->node->node.header));
 			close_ctree(root, &super);
 			root = open_ctree("dbfile", &super);
+			if (!root) {
+				fprintf(stderr, "Open ctree failed\n");
+				goto out;
+			}
 		}
 		while(count--) {
 			ret = ops[op](trans, root, &radix);
-- 
1.7.8

