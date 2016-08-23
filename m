Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756916AbcHWKnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3EAA7AD9D
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 12/13] btrfs-progs: mkfs: help and usage now to to stdout
Date: Tue, 23 Aug 2016 12:25:16 +0200
Message-Id: <1471947917-5324-13-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 mkfs.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index f063323903dc..ef0b099a58d7 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -344,31 +344,31 @@ static int create_data_reloc_tree(struct btrfs_trans_handle *trans,
 
 static void print_usage(int ret)
 {
-	fprintf(stderr, "usage: mkfs.btrfs [options] dev [ dev ... ]\n");
-	fprintf(stderr, "options:\n");
-	fprintf(stderr, "\t-A|--alloc-start START  the offset to start the FS\n");
-	fprintf(stderr, "\t-b|--byte-count SIZE    total number of bytes in the FS\n");
-	fprintf(stderr, "\t-d|--data PROFILE       data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
-	fprintf(stderr, "\t-f|--force              force overwrite of existing filesystem\n");
-	fprintf(stderr, "\t-l|--leafsize SIZE      deprecated, alias for nodesize\n");
-	fprintf(stderr, "\t-L|--label LABEL        set a label\n");
-	fprintf(stderr, "\t-m|--metadata PROFILE   metadata profile, values like data profile\n");
-	fprintf(stderr, "\t-M|--mixed              mix metadata and data together\n");
-	fprintf(stderr, "\t-n|--nodesize SIZE      size of btree nodes\n");
-	fprintf(stderr, "\t-s|--sectorsize SIZE    min block allocation (may not mountable by current kernel)\n");
-	fprintf(stderr, "\t-r|--rootdir DIR        the source directory\n");
-	fprintf(stderr, "\t-K|--nodiscard          do not perform whole device TRIM\n");
-	fprintf(stderr, "\t-O|--features LIST      comma separated list of filesystem features, use '-O list-all' to list features\n");
-	fprintf(stderr, "\t-U|--uuid UUID          specify the filesystem UUID\n");
-	fprintf(stderr, "\t-q|--quiet              no messages except errors\n");
-	fprintf(stderr, "\t-V|--version            print the mkfs.btrfs version and exit\n");
+	printf("usage: mkfs.btrfs [options] dev [ dev ... ]\n");
+	printf("options:\n");
+	printf("\t-A|--alloc-start START  the offset to start the FS\n");
+	printf("\t-b|--byte-count SIZE    total number of bytes in the FS\n");
+	printf("\t-d|--data PROFILE       data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
+	printf("\t-f|--force              force overwrite of existing filesystem\n");
+	printf("\t-l|--leafsize SIZE      deprecated, alias for nodesize\n");
+	printf("\t-L|--label LABEL        set a label\n");
+	printf("\t-m|--metadata PROFILE   metadata profile, values like data profile\n");
+	printf("\t-M|--mixed              mix metadata and data together\n");
+	printf("\t-n|--nodesize SIZE      size of btree nodes\n");
+	printf("\t-s|--sectorsize SIZE    min block allocation (may not mountable by current kernel)\n");
+	printf("\t-r|--rootdir DIR        the source directory\n");
+	printf("\t-K|--nodiscard          do not perform whole device TRIM\n");
+	printf("\t-O|--features LIST      comma separated list of filesystem features, use '-O list-all' to list features\n");
+	printf("\t-U|--uuid UUID          specify the filesystem UUID\n");
+	printf("\t-q|--quiet              no messages except errors\n");
+	printf("\t-V|--version            print the mkfs.btrfs version and exit\n");
 	exit(ret);
 }
 
 static void print_version(void) __attribute__((noreturn));
 static void print_version(void)
 {
-	fprintf(stderr, "mkfs.btrfs, part of %s\n", PACKAGE_STRING);
+	printf("mkfs.btrfs, part of %s\n", PACKAGE_STRING);
 	exit(0);
 }
 
-- 
2.7.1

