Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab2GQJO1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 05:14:27 -0400
From: David Sterba <dsterba@suse.cz>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: mkfs: rename nodiscard option to K
Date: Tue, 17 Jul 2012 11:14:17 +0200
Message-Id: <1342516457-20104-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original patch named the option -T, mkfs.xfs uses -K let's keep it
same.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Based on 8935d8436147f (current master) not yet tagged as 0.20, I hope it's
still time to fix it before it's released. Sorry for not sending the patch
earlier.

 man/mkfs.btrfs.8.in |    2 +-
 mkfs.c              |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index fc2e1d2..ca57044 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -63,7 +63,7 @@ Specify the sectorsize, the minimum block allocation.
 \fB\-r\fR, \fB\-\-rootdir \fIrootdir\fR
 Specify a directory to copy into the newly created fs.
 .TP
-\fB\-T\fR, \fB\-\-nodiscard \fR
+\fB\-K\fR, \fB\-\-nodiscard \fR
 Do not perform whole device TRIM operation by default.
 .TP
 \fB\-V\fR, \fB\-\-version\fR
diff --git a/mkfs.c b/mkfs.c
index dff5eb8..394a622 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -348,7 +348,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
-	fprintf(stderr, "\t -T --nodiscard do not perform whole device TRIM\n");
+	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -410,7 +410,7 @@ static struct option long_options[] = {
 	{ "data", 1, NULL, 'd' },
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
-	{ "nodiscard", 0, NULL, 'T' },
+	{ "nodiscard", 0, NULL, 'K' },
 	{ 0, 0, 0, 0}
 };
 
@@ -1237,7 +1237,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VMT", long_options,
+		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VMK", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1283,7 +1283,7 @@ int main(int ac, char **av)
 				source_dir = optarg;
 				source_dir_set = 1;
 				break;
-			case 'T':
+			case 'K':
 				nodiscard=1;
 				break;
 			default:
-- 
1.7.6.233.gd79bc

