Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:14327 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab2JTKGQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Oct 2012 06:06:16 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by ysabell.rzone.de (Postfix) with ESMTP id 3B4633C4
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Oct 2012 12:06:14 +0200 (MEST)
From: Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Fits: tool to hash a filesystem into a single sum
Date: Sat, 20 Oct 2012 12:06:14 +0200
Message-Id: <1350727574-16142-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tool can also generate a manifest file. Given the manifest file, it
can determine which files are missing or in excess, and inform about
metadata / data checksum mismatches.

It builds for linux and solaris.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---

It can also be found at

git://git.kernel.org/pub/scm/linux/kernel/git/arne/fits-progs.git

---
 Makefile |   12 +-
 fssum.c  |  638 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 649 insertions(+), 1 deletions(-)
 create mode 100644 fssum.c

diff --git a/Makefile b/Makefile
index 1c56476..5584f07 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,14 @@
-all: fitsparse
+OS = $(shell uname -s)
+ifeq "$(OS)" "Linux"
+CFLAGS = -D__LINUX__
+else
+CFLAGS = -D__SOLARIS__
+endif
+
+all: fitsparse fssum
 
 fitsparse: fitsparse.c
 	gcc -Wall fitsparse.c -o fitsparse
+
+fssum: fssum.c
+	gcc -Wall $(CFLAGS) fssum.c -o fssum -lssl -lcrypto
diff --git a/fssum.c b/fssum.c
new file mode 100644
index 0000000..491baef
--- /dev/null
+++ b/fssum.c
@@ -0,0 +1,638 @@
+/*
+ * Copyright (C) 2012 STRATO AG.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+#ifdef __LINUX__
+#define _BSD_SOURCE
+#define _LARGEFILE64_SOURCE
+#endif
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#ifdef __SOLARIS__
+#include <sys/mkdev.h>
+#endif
+#include <openssl/md5.h>
+#include <netinet/in.h>
+#include <inttypes.h>
+
+#define CS_SIZE 16
+#define CHUNKS	128
+
+#ifdef __LINUX__
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define htonll(x)     __bswap_64 (x)
+#endif
+#endif
+
+/* TODO: add hardlink recognition */
+/* TODO: add xattr/acl */
+
+int gen_manifest = 0;
+int in_manifest = 0;
+char *checksum = NULL;
+FILE *out_fp;
+FILE *in_fp;
+
+enum _flags {
+	FLAG_UID,
+	FLAG_GID,
+	FLAG_MODE,
+	FLAG_ATIME,
+	FLAG_MTIME,
+	FLAG_CTIME,
+	FLAG_DATA,
+	NUM_FLAGS
+};
+
+const char flchar[] = "ugoamcd";
+char line[65536];
+
+int flags[NUM_FLAGS] = { 1, 1, 1, 1, 1, 0, 1 };
+
+char *
+getln(char *buf, int size, FILE *fp)
+{
+	char *p;
+	int l;
+
+	p = fgets(buf, size, fp);
+	if (!p)
+		return NULL;
+
+	l = strlen(p);
+	while(l > 0  && (p[l - 1] == '\n' || p[l - 1] == '\r'))
+		p[--l] = 0;
+
+	return p;
+}
+
+void
+parse_flag(int c)
+{
+	int i;
+	int is_upper = 0;
+
+	if (c >= 'A' && c <= 'Z') {
+		is_upper = 1;
+		c += 'a' - 'A';
+	}
+	for (i = 0; flchar[i]; ++i) {
+		if (flchar[i] == c) {
+			flags[i] = is_upper ? 0 : 1;
+			return;
+		}
+	}
+	fprintf(stderr, "unrecognized flag %c\n", c);
+	exit(-1);
+}
+
+void
+parse_flags(char *p)
+{
+	while (*p)
+		parse_flag(*p++);
+}
+
+void
+usage(void)
+{
+	fprintf(stderr, "usage: fssum <options> <path>\n");
+	fprintf(stderr, "  options:\n");
+	fprintf(stderr, "    -f          : write out a full manifest file\n");
+	fprintf(stderr, "    -w <file>   : send output to file\n");
+	fprintf(stderr,
+		"    -r <file>   : read checksum or manifest from file\n");
+	fprintf(stderr, "    -[ugoamcd]  : specify which fields to include in checksum calculation.\n");
+	fprintf(stderr, "         u      : include uid\n");
+	fprintf(stderr, "         g      : include gid\n");
+	fprintf(stderr, "         o      : include mode\n");
+	fprintf(stderr, "         m      : include mtime\n");
+	fprintf(stderr, "         a      : include atime\n");
+	fprintf(stderr, "         c      : include ctime\n");
+	fprintf(stderr, "         d      : include file data\n");
+	fprintf(stderr, "    -[UGOAMCD]  : exclude respective field from calculation\n");
+	fprintf(stderr, "    -n          : reset all flags\n");
+	fprintf(stderr, "    -N          : set all flags\n");
+	fprintf(stderr, "    -h          : this help\n\n");
+	fprintf(stderr, "The default field mask is ugoamCd. If the checksum/manifest is read from a\n");
+	fprintf(stderr, "file, the mask is taken from there and the values given on the command line\n");
+	fprintf(stderr, "are ignored.\n");
+	exit(-1);
+}
+
+static char buf[65536];
+
+typedef struct _sum {
+	MD5_CTX 	md5;
+	unsigned char	out[16];
+} sum_t;
+
+void *
+alloc(size_t sz)
+{
+	void *p = malloc(sz);
+
+	if (!p) {
+		fprintf(stderr, "malloc failed\n");
+		exit(-1);
+	}
+
+	return p;
+}
+
+void
+sum_init(sum_t *cs)
+{
+	MD5_Init(&cs->md5);
+}
+
+void
+sum_fini(sum_t *cs)
+{
+	MD5_Final(cs->out, &cs->md5);
+}
+
+void
+sum_add(sum_t *cs, void *buf, int size)
+{
+	MD5_Update(&cs->md5, buf, size);
+}
+
+void
+sum_add_sum(sum_t *dst, sum_t *src)
+{
+	sum_add(dst, src->out, sizeof(src->out));
+}
+
+void
+sum_add_u64(sum_t *dst, uint64_t val)
+{
+	uint64_t v = htonll(val);
+	sum_add(dst, &v, sizeof(v));
+}
+
+void
+sum_add_time(sum_t *dst, time_t t)
+{
+	sum_add_u64(dst, t);
+}
+
+char *
+sum_to_string(sum_t *dst)
+{
+	int i;
+	char *s = alloc(CS_SIZE * 2 + 1);
+
+	for (i = 0; i < CS_SIZE; ++i)
+		sprintf(s + i * 2, "%02x", dst->out[i]);
+
+	return s;
+}
+
+char *
+escape(char *in)
+{
+	char *out = alloc(strlen(in) * 3 + 1);
+	char *src = in;
+	char *dst = out;
+
+	for (; *src; ++src) {
+		if (*src >= 32 && *src < 127 && *src != '\\') {
+			*dst++ = *src;
+		} else {
+			sprintf(dst, "\\%02x", (unsigned char)*src);
+			dst += 3;
+		}
+	}
+	*dst = 0;
+
+	return out;
+}
+
+void
+excess_file(const char *fn)
+{
+	printf("only in local fs: %s\n", fn);
+}
+
+void
+missing_file(const char *fn)
+{
+	printf("only in remote fs: %s\n", fn);
+}
+
+int
+pathcmp(const char *a, const char *b)
+{
+	int len_a = strlen(a);
+	int len_b = strlen(b);
+
+	/*
+	 * as the containing directory is sent after the files, it has to
+	 * come out bigger in the comparison.
+	 */
+	if (len_a < len_b && a[len_a - 1] == '/' && strncmp(a, b, len_a) == 0)
+		return 1;
+	if (len_a > len_b && b[len_b - 1] == '/' && strncmp(a, b, len_b) == 0)
+		return -1;
+
+	return strcmp(a, b);
+}
+
+void
+check_match(char *fn, char *local_m, char *remote_m,
+	    char *local_c, char *remote_c)
+{
+	int match_m = !strcmp(local_m, remote_m);
+	int match_c = !strcmp(local_c, remote_c);
+
+	if (match_m && !match_c) {
+		printf("data mismatch in %s\n", fn);
+	} else if (!match_m && match_c) {
+		printf("metadata mismatch in %s\n", fn);
+	} else if (!match_m && !match_c) {
+		printf("metadata and data mismatch in %s\n", fn);
+	}
+}
+
+char *prev_fn;
+char *prev_m;
+char *prev_c;
+void
+check_manifest(char *fn, char *m, char *c, int last_call)
+{
+	char *rem_m;
+	char *rem_c;
+	char *l;
+	int cmp;
+
+	if (prev_fn) {
+		if (last_call)
+			cmp = -1;
+		else
+			cmp = pathcmp(prev_fn, fn);
+		if (cmp < 0) {
+			excess_file(fn);
+			return;
+		} else if (cmp < 0) {
+			missing_file(prev_fn);
+		} else {
+			check_match(fn, m, prev_m, c, prev_c);
+		}
+		free(prev_fn);
+		free(prev_m);
+		free(prev_c);
+		prev_fn = NULL;
+		prev_m = NULL;
+		prev_c = NULL;
+		if (cmp == 0)
+			return;
+	}
+	while ((l = getln(line, sizeof(line), in_fp))) {
+		rem_c = strrchr(l, ' ');
+		if (!rem_c) {
+			/* final cs */
+			checksum = strdup(l);
+			break;
+		}
+		if (rem_c == l) {
+malformed:
+			fprintf(stderr, "malformed input\n");
+			exit(-1);
+		}
+		*rem_c++ = 0;
+		rem_m = strrchr(l, ' ');
+		if (!rem_m)
+			goto malformed;
+		*rem_m++ = 0;
+
+		if (last_call)
+			cmp = -1;
+		else
+			cmp = pathcmp(l, fn);
+		if (cmp == 0) {
+			check_match(fn, m, rem_m, c, rem_c);
+			return;
+		} else if (cmp > 0) {
+			excess_file(fn);
+			prev_fn = strdup(l);
+			prev_m = strdup(rem_m);
+			prev_c = strdup(rem_c); 
+			return;
+		}
+		missing_file(l);
+	}
+	if (!last_call)
+		excess_file(fn);
+}
+
+int
+namecmp(const void *aa, const void *bb)
+{
+	char * const *a = aa;
+	char * const *b = bb;
+
+	return strcmp(*a, *b);
+}
+
+void
+sum(int dirfd, int level, sum_t *dircs, char *path_in)
+{
+	DIR *d;
+	struct dirent *de;
+	char **namelist = NULL;
+	int alloclen = 0;
+	int entries = 0;
+	int i;
+	int ret;
+	int fd;
+
+	d = fdopendir(dirfd);
+	if (!d) {
+		perror("opendir");
+		exit(-1);
+	}
+	while((de = readdir(d))) {
+		if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, ".."))
+			continue;
+		if (entries == alloclen) {
+			alloclen += CHUNKS;
+			namelist = realloc(namelist,
+					   alloclen * sizeof(*namelist));
+			if (!namelist) {
+				fprintf(stderr, "malloc failed\n");
+				exit(-1);
+			}
+		}
+		namelist[entries] = strdup(de->d_name);
+		if (!namelist[entries]) {
+			fprintf(stderr, "malloc failed\n");
+			exit(-1);
+		}
+		++entries;
+	}
+	qsort(namelist, entries, sizeof(*namelist), namecmp);
+	for (i = 0; i < entries; ++i) {
+		struct stat64 st;
+		sum_t cs;
+		sum_t meta;
+		char *path;
+
+		sum_init(&cs);
+		sum_init(&meta);
+		path = alloc(strlen(path_in) + strlen(namelist[i]) + 3);
+		sprintf(path, "%s/%s", path_in, namelist[i]);
+		
+		ret = fchdir(dirfd);
+		if (ret == -1) {
+			perror("fchdir");
+			exit(-1);
+		}
+		ret = lstat64(namelist[i], &st);
+		if (ret) {
+			fprintf(stderr, "stat failed for %s: %s\n", namelist[i],
+				strerror(errno));
+			exit(-1);
+		}
+		sum_add_u64(&meta, level);
+		sum_add(&meta, namelist[i], strlen(namelist[i]));
+		if (!S_ISDIR(st.st_mode))
+			sum_add_u64(&meta, st.st_nlink);
+		if (flags[FLAG_UID])
+			sum_add_u64(&meta, st.st_uid);
+		if (flags[FLAG_GID])
+			sum_add_u64(&meta, st.st_gid);
+		if (flags[FLAG_MODE])
+			sum_add_u64(&meta, st.st_mode);
+		if (flags[FLAG_ATIME])
+			sum_add_time(&meta, st.st_atime);
+		if (flags[FLAG_MTIME])
+			sum_add_time(&meta, st.st_mtime);
+		if (flags[FLAG_CTIME])
+			sum_add_time(&meta, st.st_ctime);
+		if (S_ISDIR(st.st_mode)) {
+			fd = openat(dirfd, namelist[i], 0);
+			if (fd == -1) {
+				fprintf(stderr, "open failed for %s: %s\n",
+					namelist[i], strerror(errno));
+				exit(-1);
+			}
+			sum(fd, level + 1, &cs, path);
+			close(fd);
+		} else if (S_ISREG(st.st_mode)) {
+			sum_add_u64(&meta, st.st_size);
+			if (flags[FLAG_DATA]) {
+				fd = openat(dirfd, namelist[i], 0);
+				if (fd == -1) {
+					fprintf(stderr,
+						"open failed for %s: %s\n",
+						namelist[i], strerror(errno));
+					exit(-1);
+				}
+				while((ret = read(fd, buf, sizeof(buf))) > 0)
+					sum_add(&cs, buf, ret);
+				if (ret < 0) {
+					fprintf(stderr,
+						"read failed for %s: %s\n",
+						namelist[i], strerror(errno));
+					exit(-1);
+				}
+				close(fd);
+			}
+		} else if (S_ISLNK(st.st_mode)) {
+			ret = readlink(namelist[i], buf, sizeof(buf));
+			if (ret == -1) {
+				perror("readlink");
+				exit(-1);
+			}
+			sum_add(&cs, buf, ret);
+		} else {
+			sum_add_u64(&cs, major(st.st_dev));
+			sum_add_u64(&cs, minor(st.st_dev));
+		}
+		sum_fini(&cs);
+		sum_fini(&meta);
+		if (gen_manifest || in_manifest) {
+			char *fn;
+			char *m;
+			char *c;
+
+			if (S_ISDIR(st.st_mode))
+				strcat(path, "/");
+			fn = escape(path);
+			m = sum_to_string(&meta);
+			c = sum_to_string(&cs);
+
+			if (gen_manifest)
+				fprintf(out_fp, "%s %s %s\n", fn, m, c);
+			if (in_manifest)
+				check_manifest(fn, m, c, 0);
+			free(c);
+			free(m);
+			free(fn);
+		}
+		sum_add_sum(dircs, &cs);
+		sum_add_sum(dircs, &meta);
+		free(path);
+	}
+}
+
+int
+main(int argc, char *argv[])
+{
+	extern char *optarg;
+	extern int optind;
+	int	c;
+	char *path;
+	int fd;
+	sum_t cs;
+	char flagstring[sizeof(flchar)];
+	int i;
+
+	out_fp = stdout;
+	while ((c = getopt(argc, argv, "hfuUgGoOaAmMcCdDnNw:r:")) != EOF) {
+		switch(c) {
+		case 'f':
+			gen_manifest = 1;
+			break;
+		case 'u':
+		case 'U':
+		case 'g':
+		case 'G':
+		case 'o':
+		case 'O':
+		case 'a':
+		case 'A':
+		case 'm':
+		case 'M':
+		case 'c':
+		case 'C':
+		case 'd':
+		case 'D':
+			parse_flag(c);
+			break;
+		case 'n':
+			for (i = 0; i < NUM_FLAGS; ++i)
+				flags[i] = 0;
+			break;
+		case 'N':
+			for (i = 0; i < NUM_FLAGS; ++i)
+				flags[i] = 1;
+			break;
+		case 'w':
+			out_fp = fopen(optarg, "w");
+			if (!out_fp) {
+				fprintf(stderr,
+					"failed to open output file: %s\n",
+					strerror(errno));
+				exit(-1);
+			}
+			break;
+		case 'r':
+			in_fp = fopen(optarg, "r");
+			if (!in_fp) {
+				fprintf(stderr,
+					"failed to open input file: %s\n",
+					strerror(errno));
+				exit(-1);
+			}
+			break;
+		case 'h':
+		case '?':
+			usage();
+		}
+	}
+
+	if (optind + 1 != argc) {
+		fprintf(stderr, "missing path\n");
+		usage();
+	}
+
+	if (in_fp) {
+		char *l = getln(line, sizeof(line), in_fp);
+		char *p;
+
+		if (l == NULL) {
+			fprintf(stderr, "failed to read line from input\n");
+			exit(-1);
+		}
+		if (strncmp(l, "Flags: ", 7) == 0) {
+			l += 7;
+			in_manifest = 1;
+			parse_flags(l);
+		} else if ((p = strchr(l, ':'))) {
+			*p++ = 0;
+			parse_flags(l);
+			checksum = strdup(p);
+		} else {
+			fprintf(stderr, "invalid input file format\n");
+			exit(-1);
+		}
+	}
+	strcpy(flagstring, flchar);
+	for (i = 0; i < NUM_FLAGS; ++i) {
+		if (flags[i] == 0)
+			flagstring[i] -= 'a' - 'A';
+	}
+
+	path = argv[optind];
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1) {
+		fprintf(stderr, "failed to open %s: %s\n", path,
+			strerror(errno));
+		exit(-1);
+	}
+
+	if (gen_manifest)
+		fprintf(out_fp, "Flags: %s\n", flagstring);
+
+	sum_init(&cs);
+	sum(fd, 1, &cs, "");
+	sum_fini(&cs);
+
+	close(fd);
+	if (in_manifest)
+		check_manifest("", "", "", 1);
+
+	if (!checksum) {
+		if (in_manifest) {
+			fprintf(stderr, "malformed input\n");
+			exit(-1);
+		}
+		if (!gen_manifest)
+			fprintf(out_fp, "%s:", flagstring);
+
+		fprintf(out_fp, "%s\n", sum_to_string(&cs));
+	} else {
+		if (strcmp(checksum, sum_to_string(&cs)) == 0) {
+			printf("OK\n");
+			exit(0);
+		} else {
+			printf("FAIL\n");
+			exit(1);
+		}
+	}
+
+	exit(0);
+}
-- 
1.7.7

