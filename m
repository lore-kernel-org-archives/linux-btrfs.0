From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 9/9] mkfs.btrfs: fix error text in '-r' mode
Date: Tue, 31 May 2011 00:19:08 +0300
Message-ID: <1306790348-9553-10-git-send-email-slyfox@gentoo.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Smart gcc noticed use of uninitialized warning when compiled
with -O0 flags:

    mkfs.c:1291: error: 'file' may be used uninitialized in this function

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 mkfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 73c898b..ef0407f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1286,13 +1286,13 @@ int main(int ac, char **av)
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
-- 
1.7.3.4

