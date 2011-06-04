From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 9/9] mkfs.btrfs: fix error text in '-r' mode
Date: Sat,  4 Jun 2011 11:19:24 +0300
Message-ID: <1307175564-25355-10-git-send-email-slyfox@gentoo.org>
References: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Smart gcc noticed use of uninitialized warning when compiled
with -O0 flags:

    mkfs.c:1291: error: 'file' may be used uninitialized in this function

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 mkfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index a65fb4d..44a05e8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1272,47 +1272,47 @@ int main(int ac, char **av)
 			fprintf(stderr, "error checking %s mount status\n", file);
 			exit(1);
 		}
 		if (ret == 1) {
 			fprintf(stderr, "%s is mounted\n", file);
 			exit(1);
 		}
 		ac--;
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open %s\n", file);
 			exit(1);
 		}
 		first_fd = fd;
 		first_file = file;
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count, &mixed);
 		if (block_count == 0)
 			block_count = dev_block_count;
 	} else {
 		ac = 0;
+		file = output;
 		fd = open_target(output);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open the %s\n", file);
 			exit(1);
 		}
 
-		file = output;
 		first_fd = fd;
 		first_file = file;
 		block_count = size_sourcedir(source_dir, sectorsize,
 					     &num_of_meta_chunks, &size_of_data);
 		ret = zero_output_file(fd, block_count, sectorsize);
 		if (ret) {
 			fprintf(stderr, "unable to zero the output file\n");
 			exit(1);
 		}
 	}
 	if (mixed) {
 		if (!metadata_profile_opt)
 			metadata_profile = 0;
 		if (!data_profile_opt)
 			data_profile = 0;
 
 		if (metadata_profile != data_profile) {
 			fprintf(stderr, "With mixed block groups data and metadata "
 				"profiles must be the same\n");
 			exit(1);
-- 
1.7.3.4

