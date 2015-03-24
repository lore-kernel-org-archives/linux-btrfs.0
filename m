Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbbCXSQ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 14:16:58 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 06012AC77
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2015 18:16:57 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: convert, add long options for all short options
Date: Tue, 24 Mar 2015 19:16:56 +0100
Message-Id: <1427221016-28178-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-convert.txt | 21 +++++++++++----------
 btrfs-convert.c                 | 27 ++++++++++++++++++---------
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index 89b2fbd978e2..8b3f05b40ace 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -17,23 +17,24 @@ named 'ext2_saved' as file image.
 
 OPTIONS
 -------
--d::
-Disable data checksum.
--i::
+-d|--no-datasum::
+Disable data checksum calculations and set NODATASUM file flag. This can speed
+up the conversion.
+-i|--no-xattr::
 Ignore xattrs and ACLs.
--n::
-Disable packing of small files.
--N <SIZE>::
+-n|--no-inline::
+Disable inlining of small files to metadata blocks.
+-N|--nodesize <SIZE>::
 Set filesystem nodesize, the tree block size in which btrfs stores data.
 The default value is 16KB (16384) or the page size, whichever is bigger.
 Must be a multiple of the sectorsize, but not larger than 65536.
--r::
+-r|--rollback::
 Roll back to ext2fs.
--l <LABEL>::
+-l|--label <LABEL>::
 set filesystem label during conversion.
--L::
+-L|--copy-label::
 use label from the converted filesystem.
--p::
+-p|--progress::
 Show progress of conversion, on by default.
 --no-progress::
 Disable detailed progress and show only the main phases of conversion.
diff --git a/btrfs-convert.c b/btrfs-convert.c
index ff8a959f6fa1..4dc33b3c03a4 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2800,15 +2800,16 @@ fail:
 static void print_usage(void)
 {
 	printf("usage: btrfs-convert [options] device\n");
-	printf("\t-d             disable data checksum\n");
-	printf("\t-i             ignore xattrs and ACLs\n");
-	printf("\t-n             disable packing of small files\n");
-	printf("\t-N SIZE        set filesystem nodesize\n");
-	printf("\t-r             roll back to ext2fs\n");
-	printf("\t-l LABEL       set filesystem label\n");
-	printf("\t-L             use label from converted fs\n");
-	printf("\t-p             show converting progress (default)\n");
-	printf("\t--no-progress  show only overview, not the detailed progress\n");
+	printf("options:\n");
+	printf("\t-d|--no-datasum        disable data checksum, sets NODATASUM\n");
+	printf("\t-i|--no-xattr          ignore xattrs and ACLs\n");
+	printf("\t-n|--no-inline         disable inlining of small files to metadata\n");
+	printf("\t-N|--nodesize SIZE     set filesystem metadata nodesize\n");
+	printf("\t-r|--rollback          roll back to ext2fs\n");
+	printf("\t-l|--label LABEL       set filesystem label\n");
+	printf("\t-L|--copy-label        use label from converted filesystem\n");
+	printf("\t-p|--progress          show converting progress (default)\n");
+	printf("\t--no-progress          show only overview, not the detailed progress\n");
 }
 
 int main(int argc, char *argv[])
@@ -2832,6 +2833,14 @@ int main(int argc, char *argv[])
 		static const struct option long_options[] = {
 			{ "no-progress", no_argument, NULL,
 				GETOPT_VAL_NO_PROGRESS },
+			{ "no-datasum", no_argument, NULL, 'd' },
+			{ "no-inline", no_argument, NULL, 'n' },
+			{ "no-xattr", no_argument, NULL, 'i' },
+			{ "rollback", no_argument, NULL, 'r' },
+			{ "progress", no_argument, NULL, 'p' },
+			{ "label", required_argument, NULL, 'l' },
+			{ "copy-label", no_argument, NULL, 'L' },
+			{ "nodesize", required_argument, NULL, 'N' },
 			{ NULL, 0, NULL, 0 }
 		};
 		int c = getopt_long(argc, argv, "dinN:rl:Lp", long_options,
-- 
2.1.3

