Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538C6C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 18:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2673821773
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553799327;
	bh=8uROn+88m0/a5WipLGXYVgUK9IfhRM5t5+x1yds8tXc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=dMREQbcuHYCym9oqniiu58AngH1MsXGrG2CL299bXJSZhpI/JG14GIr1tHjcV3euB
	 0PlK1ZU2pBqlUuW1v2VZZr3cR6OmzLZ1atNKNU/EbaZpFbhh5ijbFlDpSrJFZXNyCC
	 VZmRFfdtjmc3C+KSMpHpqg5tO7gnERVtoUgt7OwA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfC1Sz0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 14:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbfC1Sz0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 14:55:26 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 233A22173C;
        Thu, 28 Mar 2019 18:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553799325;
        bh=8uROn+88m0/a5WipLGXYVgUK9IfhRM5t5+x1yds8tXc=;
        h=From:To:Cc:Subject:Date:From;
        b=h3KH/ZhsFgvd0ZoSJmECxGSNqF3GS4KdGqsl3PvMvmhnnp+hxksVx3kCn5gMsjIyt
         r6op8JNCpWw42SfBHmtdT8+SK0tAbwJPnOaX0cUehQgV/eRtX+OHN/sG5LseS8KZBz
         KFu2b4M5e05IM7rEKS7IVA1lPnOVtZJyRMiMFT80=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 7/7] fssum: add support for checking xattrs
Date:   Thu, 28 Mar 2019 18:55:20 +0000
Message-Id: <20190328185520.29140-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Currently fssum, mostly used for btrfs test cases that test the btrfs send
feature, ignores completely the existence of xattrs. This change teaches
fssum to find xattrs and make them contribute to the checksum of a
filesystem, so that we can catch filesystem bugs regarding missing, corrupt
or not supposed to exist xattrs (i.e. that an incremental btrfs send does
not forget to create, update or remove xattrs).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 src/fssum.c | 143 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 129 insertions(+), 14 deletions(-)

diff --git a/src/fssum.c b/src/fssum.c
index f1da72fb..6ba0a95c 100644
--- a/src/fssum.c
+++ b/src/fssum.c
@@ -20,6 +20,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
+#include <sys/xattr.h>
 #ifdef __SOLARIS__
 #include <sys/mkdev.h>
 #endif
@@ -40,7 +41,6 @@
 #endif
 
 /* TODO: add hardlink recognition */
-/* TODO: add xattr/acl */
 
 struct excludes {
 	char *path;
@@ -71,15 +71,16 @@ enum _flags {
 	FLAG_MTIME,
 	FLAG_CTIME,
 	FLAG_DATA,
+	FLAG_XATTRS,
 	FLAG_OPEN_ERROR,
 	FLAG_STRUCTURE,
 	NUM_FLAGS
 };
 
-const char flchar[] = "ugoamcdes";
+const char flchar[] = "ugoamcdxes";
 char line[65536];
 
-int flags[NUM_FLAGS] = {1, 1, 1, 1, 1, 0, 1, 0, 0};
+int flags[NUM_FLAGS] = {1, 1, 1, 1, 1, 0, 1, 1, 0, 0};
 
 char *
 getln(char *buf, int size, FILE *fp)
@@ -135,7 +136,7 @@ usage(void)
 	fprintf(stderr, "    -v          : verbose mode (debugging only)\n");
 	fprintf(stderr,
 		"    -r <file>   : read checksum or manifest from file\n");
-	fprintf(stderr, "    -[ugoamcde] : specify which fields to include in checksum calculation.\n");
+	fprintf(stderr, "    -[ugoamcdxe]: specify which fields to include in checksum calculation.\n");
 	fprintf(stderr, "         u      : include uid\n");
 	fprintf(stderr, "         g      : include gid\n");
 	fprintf(stderr, "         o      : include mode\n");
@@ -143,9 +144,10 @@ usage(void)
 	fprintf(stderr, "         a      : include atime\n");
 	fprintf(stderr, "         c      : include ctime\n");
 	fprintf(stderr, "         d      : include file data\n");
+	fprintf(stderr, "         x      : include xattrs\n");
 	fprintf(stderr, "         e      : include open errors (aborts otherwise)\n");
 	fprintf(stderr, "         s      : include block structure (holes)\n");
-	fprintf(stderr, "    -[UGOAMCDES]: exclude respective field from calculation\n");
+	fprintf(stderr, "    -[UGOAMCDXES]: exclude respective field from calculation\n");
 	fprintf(stderr, "    -n          : reset all flags\n");
 	fprintf(stderr, "    -N          : set all flags\n");
 	fprintf(stderr, "    -x path     : exclude path when building checksum (multiple ok)\n");
@@ -221,6 +223,106 @@ sum_to_string(sum_t *dst)
 }
 
 int
+namecmp(const void *aa, const void *bb)
+{
+	char * const *a = aa;
+	char * const *b = bb;
+
+	return strcmp(*a, *b);
+}
+
+int
+sum_xattrs(int fd, sum_t *dst)
+{
+	ssize_t buflen;
+	ssize_t len;
+	char *buf;
+	char *p;
+	char **names = NULL;
+	int num_xattrs = 0;
+	int ret = 0;
+	int i;
+
+	buflen = flistxattr(fd, NULL, 0);
+	if (buflen < 0)
+		return -errno;
+	/* no xattrs exist */
+	if (buflen == 0)
+		return 0;
+
+	buf = malloc(buflen);
+	if (!buf)
+		return -ENOMEM;
+
+	buflen = flistxattr(fd, buf, buflen);
+	if (buflen < 0) {
+		ret = -errno;
+		goto out;
+	}
+
+	/*
+	 * Keep the list of xattrs sorted, because the order in which they are
+	 * listed is filesystem dependent, so we want to get the same checksum
+	 * on different filesystems.
+	 */
+
+	p = buf;
+	len = buflen;
+	while (len > 0) {
+		int keylen;
+
+		keylen = strlen(p) + 1; /* +1 for NULL terminator */
+		len -= keylen;
+		p += keylen;
+		num_xattrs++;
+	}
+
+	names = malloc(sizeof(char *) * num_xattrs);
+	if (!names) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	p = buf;
+	for (i = 0; i < num_xattrs; i++) {
+		names[i] = p;
+		p += strlen(p) + 1; /* +1 for NULL terminator */
+	}
+
+	qsort(names, num_xattrs, sizeof(char *), namecmp);
+
+	for (i = 0; i < num_xattrs; i++) {
+		len = fgetxattr(fd, names[i], NULL, 0);
+		if (len < 0) {
+			ret = -errno;
+			goto out;
+		}
+		sum_add(dst, names[i], strlen(names[i]));
+		/* no value */
+		if (len == 0)
+			continue;
+		p = malloc(len);
+		if (!p) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		len = fgetxattr(fd, names[i], p, len);
+		if (len < 0) {
+			ret = -errno;
+			free(p);
+			goto out;
+		}
+		sum_add(dst, p, len);
+		free(p);
+	}
+out:
+	free(buf);
+	free(names);
+
+	return ret;
+}
+
+int
 sum_file_data_permissive(int fd, sum_t *dst)
 {
 	int ret;
@@ -401,15 +503,6 @@ malformed:
 		excess_file(fn);
 }
 
-int
-namecmp(const void *aa, const void *bb)
-{
-	char * const *a = aa;
-	char * const *b = bb;
-
-	return strcmp(*a, *b);
-}
-
 void
 sum(int dirfd, int level, sum_t *dircs, char *path_prefix, char *path_in)
 {
@@ -493,6 +586,28 @@ sum(int dirfd, int level, sum_t *dircs, char *path_prefix, char *path_in)
 			sum_add_time(&meta, st.st_mtime);
 		if (flags[FLAG_CTIME])
 			sum_add_time(&meta, st.st_ctime);
+		if (flags[FLAG_XATTRS] &&
+		    (S_ISDIR(st.st_mode) || S_ISREG(st.st_mode))) {
+			fd = openat(dirfd, namelist[i], 0);
+			if (fd == -1 && flags[FLAG_OPEN_ERROR]) {
+				sum_add_u64(&meta, errno);
+			} else if (fd == -1) {
+				fprintf(stderr, "open failed for %s/%s: %s\n",
+					path_prefix, path, strerror(errno));
+				exit(-1);
+			} else {
+				ret = sum_xattrs(fd, &meta);
+				close(fd);
+				if (ret < 0) {
+					fprintf(stderr,
+						"failed to read xattrs from "
+						"%s/%s: %s\n",
+						path_prefix, path,
+						strerror(-ret));
+					exit(-1);
+				}
+			}
+		}
 		if (S_ISDIR(st.st_mode)) {
 			fd = openat(dirfd, namelist[i], 0);
 			if (fd == -1 && flags[FLAG_OPEN_ERROR]) {
-- 
2.11.0

