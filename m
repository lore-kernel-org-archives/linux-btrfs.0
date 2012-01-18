From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs progs: fix compiler cast warnings
Date: Wed, 18 Jan 2012 11:00:03 +0100
Message-ID: <1326880803-15464-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <COL113-W26B06C5519CFEB29075D36B0800@phx.gbl>
Cc: kylegates@hotmail.com
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <COL113-W26B06C5519CFEB29075D36B0800@phx.gbl>
List-ID: <linux-btrfs.vger.kernel.org>

With -m32, we need two casts to get from a pointer to u64. This fixes:
- btrfs_cmds.c:1138: error: cast from pointer to integer of different size
- btrfs_cmds.c:1242: error: cast from pointer to integer of different size

With -m64, sizeof gives unsigned long, so we need a cast as well to fix:
- extent-tree.c:1071: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'long unsigned int'

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 btrfs_cmds.c  |    4 ++--
 extent-tree.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index b59e9cb..d6ae5f0 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1135,7 +1135,7 @@ static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 
 	ipa.inum = inum;
 	ipa.size = 4096;
-	ipa.fspath = (u64)fspath;
+	ipa.fspath = (u64)(long int)fspath;
 
 	ret = ioctl(fd, BTRFS_IOC_INO_PATHS, &ipa);
 	if (ret) {
@@ -1239,7 +1239,7 @@ int do_logical_to_ino(int nargs, char **argv)
 
 	loi.logical = atoll(argv[optind]);
 	loi.size = 4096;
-	loi.inodes = (u64)inodes;
+	loi.inodes = (u64)(long int)inodes;
 
 	fd = open_file_or_dir(argv[optind+1]);
 	if (fd < 0) {
diff --git a/extent-tree.c b/extent-tree.c
index 5bed3c2..8cabcc5 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1067,8 +1067,8 @@ static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	}
 #endif
 	if (item_size < sizeof(*ei)) {
-		printf("Size is %u, needs to be %u, slot %d\n", item_size,
-		       sizeof(*ei), path->slots[0]);
+		printf("Size is %u, needs to be %lu, slot %d\n", item_size,
+		       (unsigned long)sizeof(*ei), path->slots[0]);
 		btrfs_print_leaf(root, leaf);
 		return -EINVAL;
 	}
-- 
1.7.3.4

