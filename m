From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] btrfsck: Exit and print error message when not able to open device
Date: Fri, 16 Jan 2009 22:27:57 -0200
Message-ID: <1232152077-3862-1-git-send-email-cascardo@holoscopio.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If btrfsck is not able to open a device, it segfaults. This fixes it and
prints an error message too.
---
 btrfsck.c |    3 +++
 disk-io.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 4a41e6d..cde0e68 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2075,6 +2075,9 @@ int main(int ac, char **av)
 	radix_tree_init();
 	root = open_ctree(av[1], 0, 0);
 
+	if (root == NULL)
+		return 1;
+
 	ret = check_extents(root);
 	if (ret)
 		goto out;
diff --git a/disk-io.c b/disk-io.c
index c15cf53..e49c220 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -530,6 +530,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 
 	fp = open(filename, flags, 0600);
 	if (fp < 0) {
+		fprintf (stderr, "Coult not open %s\n", filename);
 		return NULL;
 	}
 	root = open_ctree_fd(fp, filename, sb_bytenr, writes);
-- 
1.6.0.6

