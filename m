From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 7/9] mkfs.btrfs: free buffers allocated by pretty_sizes
Date: Tue, 31 May 2011 00:19:06 +0300
Message-ID: <1306790348-9553-8-git-send-email-slyfox@gentoo.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
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
@@ -1176,6 +1176,7 @@ int main(int ac, char **av)
 	char *output = "output.img";
 	u64 num_of_meta_chunks = 0;
 	u64 size_of_data = 0;
+	char * pretty_buf;
 
 	while(1) {
 		int c;
@@ -1395,7 +1396,8 @@ raid_groups:
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_sizes(btrfs_super_total_bytes(&root->fs_info->super_copy)));
+	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(&root->fs_info->super_copy)));
+	free (pretty_buf);
 
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	btrfs_commit_transaction(trans, root);
-- 
1.7.3.4

