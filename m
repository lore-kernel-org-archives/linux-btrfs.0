From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 7/9] mkfs.btrfs: free buffers allocated by pretty_sizes
Date: Sat,  4 Jun 2011 11:19:22 +0300
Message-ID: <1307175564-25355-8-git-send-email-slyfox@gentoo.org>
References: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

found by valgrind:
==2559== 16 bytes in 1 blocks are definitely lost in loss record 3 of 19
==2559==    at 0x4C2720E: malloc (vg_replace_malloc.c:236)
==2559==    by 0x412F7E: pretty_sizes (utils.c:1054)
==2559==    by 0x4179E9: main (mkfs.c:1395)

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 mkfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 32f25f5..c8b19c1 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1159,40 +1159,41 @@ int main(int ac, char **av)
 	u64 data_profile = BTRFS_BLOCK_GROUP_RAID0;
 	u32 leafsize = getpagesize();
 	u32 sectorsize = 4096;
 	u32 nodesize = leafsize;
 	u32 stripesize = 4096;
 	int zero_end = 1;
 	int option_index = 0;
 	int fd;
 	int first_fd;
 	int ret;
 	int i;
 	int mixed = 0;
 	int data_profile_opt = 0;
 	int metadata_profile_opt = 0;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
 	char *output = "output.img";
 	u64 num_of_meta_chunks = 0;
 	u64 size_of_data = 0;
+	char * pretty_buf;
 
 	while(1) {
 		int c;
 		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VM", long_options,
 				&option_index);
 		if (c < 0)
 			break;
 		switch(c) {
 			case 'A':
 				alloc_start = parse_size(optarg);
 				break;
 			case 'd':
 				data_profile = parse_profile(optarg);
 				data_profile_opt = 1;
 				break;
 			case 'l':
 				leafsize = parse_size(optarg);
 				break;
 			case 'L':
 				label = parse_label(optarg);
@@ -1378,41 +1379,42 @@ raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 metadata_profile, mixed);
 		BUG_ON(ret);
 	}
 
 	ret = create_data_reloc_tree(trans, root);
 	BUG_ON(ret);
 
 	if (mixed) {
 		struct btrfs_super_block *super = &root->fs_info->super_copy;
 		u64 flags = btrfs_super_incompat_flags(super);
 
 		flags |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
 		btrfs_set_super_incompat_flags(super, flags);
 	}
 
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_sizes(btrfs_super_total_bytes(&root->fs_info->super_copy)));
+	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(&root->fs_info->super_copy)));
+	free (pretty_buf);
 
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	btrfs_commit_transaction(trans, root);
 
 	if (source_dir_set) {
 		trans = btrfs_start_transaction(root, 1);
 		ret = create_chunks(trans, root,
 				    num_of_meta_chunks, size_of_data);
 		BUG_ON(ret);
 		btrfs_commit_transaction(trans, root);
 
 		ret = make_image(source_dir, root, fd);
 		BUG_ON(ret);
 	}
 
 	ret = close_ctree(root);
 	BUG_ON(ret);
 
 	free(label);
 	return 0;
-- 
1.7.3.4

