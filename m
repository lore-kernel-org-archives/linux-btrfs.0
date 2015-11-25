Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20729 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbbKYMI7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:08:59 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Subject: [PATCH 6/7] btrfs-progs: add -O comp= option for mkfs.btrfs
Date: Wed, 25 Nov 2015 20:08:19 +0800
Message-Id: <1448453300-8449-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This provides default feature set by version, for mkfs.btrfs
through the new option '-O comp=<x.y>|<x.y.z>', where x.y.z is the
minimum kernel version that should be supported.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 6cb998b..34ba77d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -324,7 +324,9 @@ static void print_usage(int ret)
 	fprintf(stderr, "\t-s|--sectorsize SIZE    min block allocation (may not mountable by current kernel)\n");
 	fprintf(stderr, "\t-r|--rootdir DIR        the source directory\n");
 	fprintf(stderr, "\t-K|--nodiscard          do not perform whole device TRIM\n");
-	fprintf(stderr, "\t-O|--features LIST      comma separated list of filesystem features, use '-O list-all' to list features\n");
+	fprintf(stderr, "\t-O|--features LIST      comma separated list of filesystem features\n");
+	fprintf(stderr, "\t                          use '-O list-all' to list features\n");
+	fprintf(stderr, "\t                          use '-O comp=<x.y>|<x.y.z>' x.y.z is the minimum kernel version to be supported\n");
 	fprintf(stderr, "\t-U|--uuid UUID          specify the filesystem UUID\n");
 	fprintf(stderr, "\t-q|--quiet              no messages except errors\n");
 	fprintf(stderr, "\t-V|--version            print the mkfs.btrfs version and exit\n");
@@ -1439,7 +1441,24 @@ int main(int ac, char **av)
 			case 'O': {
 				char *orig = strdup(optarg);
 				char *tmp = orig;
-
+				char *tok;
+
+				tok = strtok(tmp, "=");
+				if (!strcmp(tok, "comp")) {
+					tok = strtok(NULL, "=");
+					if (!tok) {
+						fprintf(stderr,
+				"Provide a version for 'comp=' option, ref to 'mkfs.btrfs -O list-all'\n");
+						exit(1);
+					}
+					if (btrfs_features_allowed_by_version(tok, &features) < 0) {
+						fprintf(stderr, "Wrong version format: '%s'\n", tok);
+						exit(1);
+					}
+					features &= BTRFS_MKFS_DEFAULT_FEATURES;
+					goto cont;
+				}
+				tmp = orig;
 				tmp = btrfs_parse_fs_features(tmp, &features);
 				if (tmp) {
 					fprintf(stderr,
@@ -1448,6 +1467,7 @@ int main(int ac, char **av)
 					free(orig);
 					exit(1);
 				}
+cont:
 				free(orig);
 				if (features & BTRFS_FEATURE_LIST_ALL) {
 					btrfs_list_all_fs_features(0);
-- 
2.6.2

