Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20722 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbbKYMI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:08:58 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Subject: [PATCH 7/7] btrfs-progs: add -O comp= option for btrfs-convert
Date: Wed, 25 Nov 2015 20:08:20 +0800
Message-Id: <1448453300-8449-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

User may want to convert the FS to a minimum kernel version. As they may need
to use btrfs on a set of known kernel versions. And have the disk layout compatible.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-convert.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index b0a998b..01b8940 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2879,6 +2879,8 @@ static void print_usage(void)
 	printf("\t-L|--copy-label        use label from converted filesystem\n");
 	printf("\t-p|--progress          show converting progress (default)\n");
 	printf("\t-O|--features LIST     comma separated list of filesystem features\n");
+	printf("\t                         use '-O list-all' to list features\n");
+	printf("\t                         use '-O comp=<x.y>|<x.y.z>' x.y.z is the minimum kernel version to be supported\n");
 	printf("\t--no-progress          show only overview, not the detailed progress\n");
 }
 
@@ -2970,6 +2972,24 @@ int main(int argc, char *argv[])
 			case 'O': {
 				char *orig = strdup(optarg);
 				char *tmp = orig;
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
@@ -2979,6 +2999,7 @@ int main(int argc, char *argv[])
 					free(orig);
 					exit(1);
 				}
+cont:
 				free(orig);
 				if (features & BTRFS_FEATURE_LIST_ALL) {
 					btrfs_list_all_fs_features(
-- 
2.6.2

