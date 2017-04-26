Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46285 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1434256AbdDZBWz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 21:22:55 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id EEED247E6342
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Apr 2017 09:22:42 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: tests: fssum, fix memory leak
Date: Wed, 26 Apr 2017 09:22:41 +0800
Message-ID: <20170426012241.29814-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Free the alloced memory and close dir before exit.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 tests/fssum.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/tests/fssum.c b/tests/fssum.c
index 83bd4106..8be44547 100644
--- a/tests/fssum.c
+++ b/tests/fssum.c
@@ -420,6 +420,9 @@ check_manifest(char *fn, char *m, char *c, int last_call)
 	while ((l = getln(line, sizeof(line), in_fp))) {
 		rem_c = strrchr(l, ' ');
 		if (!rem_c) {
+			if (checksum)
+				free(checksum);
+
 			/* final cs */
 			checksum = strdup(l);
 			break;
@@ -503,6 +506,7 @@ sum(int dirfd, int level, sum_t *dircs, char *path_prefix, char *path_in)
 		}
 		++entries;
 	}
+
 	qsort(namelist, entries, sizeof(*namelist), namecmp);
 	for (i = 0; i < entries; ++i) {
 		struct stat64 st;
@@ -624,7 +628,11 @@ sum(int dirfd, int level, sum_t *dircs, char *path_prefix, char *path_in)
 		sum_add_sum(dircs, &meta);
 next:
 		free(path);
+		free(namelist[i]);
 	}
+
+	free(namelist);
+	closedir(d);
 }
 
 int
@@ -636,7 +644,9 @@ main(int argc, char *argv[])
 	char *path;
 	int fd;
 	sum_t cs;
+	char *sumstring;
 	char flagstring[sizeof(flchar)];
+	int ret = 0;
 	int i;
 	int plen;
 	int elen;
@@ -736,6 +746,9 @@ main(int argc, char *argv[])
 		} else if ((p = strchr(l, ':'))) {
 			*p++ = 0;
 			parse_flags(l);
+
+			if (checksum)
+				free(checksum);
 			checksum = strdup(p);
 		} else {
 			fprintf(stderr, "invalid input file format\n");
@@ -798,16 +811,28 @@ main(int argc, char *argv[])
 		if (!gen_manifest)
 			fprintf(out_fp, "%s:", flagstring);
 
-		fprintf(out_fp, "%s\n", sum_to_string(&cs));
+		sumstring = sum_to_string(&cs);
+		fprintf(out_fp, "%s\n", sumstring);
+		free(sumstring);
 	} else {
-		if (strcmp(checksum, sum_to_string(&cs)) == 0) {
+		sumstring = sum_to_string(&cs);
+		if (strcmp(checksum, sumstring) == 0) {
 			printf("OK\n");
-			exit(0);
+			ret = 0;
 		} else {
 			printf("FAIL\n");
-			exit(1);
+			ret = 1;
 		}
+
+		free(checksum);
+		free(sumstring);
 	}
 
-	exit(0);
+	if (in_fp)
+		fclose(in_fp);
+
+	if (out_fp != stdout)
+		fclose(out_fp);
+
+	exit(ret);
 }
-- 
2.12.2



