Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53097 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750860AbdH3Vxd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 17:53:33 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7ULqGOG010401
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 14:53:32 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2cnsxcuqu9-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 14:53:32 -0700
From: Nick Terrell <terrelln@fb.com>
To: Nick Terrell <terrelln@fb.com>
CC: <kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Add zstd support
Date: Wed, 30 Aug 2017 14:53:22 -0700
Message-ID: <20170830215322.782399-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds zstd support to the btrfs program, and a dependency on libzstd >=
1.0.0.

The patch is also available in my fork of btrfs-progs [1], which passes
Travis-CI. I tested each command that is effected in my test script [2].

I haven't updated Android.mk since I have no way to test it, and am not
certain if it is used.

[1] https://github.com/terrelln/btrfs-progs/tree/devel
[2] https://gist.github.com/terrelln/4136a369c5d10092956781433eed0a23

Signed-off-by: Nick Terrell <terrelln@fb.com>
---
 .travis.yml                             |  9 +++++++
 Documentation/btrfs-filesystem.asciidoc |  2 +-
 Documentation/btrfs-man5.asciidoc       |  8 +++++-
 Documentation/btrfs-property.asciidoc   |  2 +-
 INSTALL                                 |  1 +
 Makefile.inc.in                         |  4 +--
 cmds-filesystem.c                       | 16 ++++++------
 cmds-inspect-dump-super.c               |  2 +-
 cmds-restore.c                          | 44 +++++++++++++++++++++++++++++++++
 configure.ac                            |  4 ++-
 ctree.h                                 | 15 ++++-------
 fsfeatures.h                            |  2 +-
 print-tree.c                            |  3 +++
 13 files changed, 87 insertions(+), 25 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 2aa44bd..50b3c1c 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -59,6 +59,15 @@ before_install:
      sudo make install;
      cd ../..
     "
+  - "mkdir tmp-zstd;
+     cd tmp-zstd;
+     wget https://github.com/facebook/zstd/archive/v1.3.1.tar.gz;
+     tar xf v1.3.1.tar.gz;
+     cd zstd-1.3.1;
+     make;
+     sudo make install PREFIX=/usr;
+     cd ../..
+    "
   - "./autogen.sh && ./configure --disable-documentation && make"

 addons:
diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index b60ef74..41b3032 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -112,7 +112,7 @@ KiB, MiB, GiB, TiB, PiB, or EiB, respectively (case does not matter).
 be verbose, print file names as they're submitted for defragmentation
 -c[<algo>]::::
 compress file contents while defragmenting. Optional argument selects the compression
-algorithm, 'zlib' (default) or 'lzo'. Currently it's not possible to select no
+algorithm, 'zlib' (default), 'lzo' or 'zstd'. Currently it's not possible to select no
 compression. See also section 'EXAMPLES'.
 -r::::
 defragment files recursively in given directories
diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index 8d9031f..3981435 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -118,7 +118,7 @@ but a warning is printed if it's more than 300 seconds (5 minutes).
 (default: off)
 +
 Control BTRFS file data compression.  Type may be specified as 'zlib',
-'lzo' or 'no' (for no compression, used for remounting).  If no type
+'lzo', 'zstd' or 'no' (for no compression, used for remounting).  If no type
 is specified, 'zlib' is used.  If 'compress-force' is specified,
 the compression will allways be attempted, but the data may end up uncompressed
 if the compression would make them larger.
@@ -472,6 +472,12 @@ page size
 the 'lzo' compression has been used on the filesystem, either as a mount option
 or via *btrfs filesystem defrag*.

+*compress_zstd*::
+(since: 4.14)
++
+the 'zstd' compression has been used on the filesystem, either as a mount option
+or via *btrfs filesystem defrag*.
+
 *default_subvol*::
 (since: 2.6.34)
 +
diff --git a/Documentation/btrfs-property.asciidoc b/Documentation/btrfs-property.asciidoc
index 05ab0bc..7ed6a7d 100644
--- a/Documentation/btrfs-property.asciidoc
+++ b/Documentation/btrfs-property.asciidoc
@@ -43,7 +43,7 @@ read-only flag of subvolume: true or false
 label::::
 label of device
 compression::::
-compression setting for an inode: lzo, zlib, or "" (empty string)
+compression setting for an inode: lzo, zlib, zstd, or "" (empty string)

 *list* [-t <type>] <object>::
 Lists available properties with their descriptions for the given object.
diff --git a/INSTALL b/INSTALL
index 0465fb0..686cefb 100644
--- a/INSTALL
+++ b/INSTALL
@@ -7,6 +7,7 @@ The Btrfs utility programs require the following libraries/tools to build:
 - libblkid - block device id library
 - liblzo2 - LZO data compression library
 - zlib - ZLIB data compression library
+- libzstd - ZSTD data compression library version >= 1.0.0

 For the btrfs-convert utility:

diff --git a/Makefile.inc.in b/Makefile.inc.in
index 3c7bc03..4076add 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -18,9 +18,9 @@ SUBST_CFLAGS = @CFLAGS@
 SUBST_LDFLAGS = @LDFLAGS@

 LIBS_BASE = @UUID_LIBS@ @BLKID_LIBS@ -L. -pthread
-LIBS_COMP = @ZLIB_LIBS@ @LZO2_LIBS@
+LIBS_COMP = @ZLIB_LIBS@ @LZO2_LIBS@ @ZSTD_LIBS@
 STATIC_LIBS_BASE = @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ -L. -pthread
-STATIC_LIBS_COMP = @ZLIB_LIBS_STATIC@ @LZO2_LIBS_STATIC@
+STATIC_LIBS_COMP = @ZLIB_LIBS_STATIC@ @LZO2_LIBS_STATIC@ @ZSTD_LIBS_STATIC@

 prefix ?= @prefix@
 exec_prefix = @exec_prefix@
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 018857c..dec0f26 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -952,6 +952,8 @@ static int parse_compress_type(char *s)
 		return BTRFS_COMPRESS_ZLIB;
 	else if (strcmp(optarg, "lzo") == 0)
 		return BTRFS_COMPRESS_LZO;
+	else if (strcmp(optarg, "zstd") == 0)
+		return BTRFS_COMPRESS_ZSTD;
 	else {
 		error("unknown compression type %s", s);
 		exit(1);
@@ -962,13 +964,13 @@ static const char * const cmd_filesystem_defrag_usage[] = {
 	"btrfs filesystem defragment [options] <file>|<dir> [<file>|<dir>...]",
 	"Defragment a file or a directory",
 	"",
-	"-v             be verbose",
-	"-r             defragment files recursively",
-	"-c[zlib,lzo]   compress the file while defragmenting",
-	"-f             flush data to disk immediately after defragmenting",
-	"-s start       defragment only from byte onward",
-	"-l len         defragment only up to len bytes",
-	"-t size        target extent size hint (default: 32M)",
+	"-v                  be verbose",
+	"-r                  defragment files recursively",
+	"-c[zlib,lzo,zstd]   compress the file while defragmenting",
+	"-f                  flush data to disk immediately after defragmenting",
+	"-s start            defragment only from byte onward",
+	"-l len              defragment only up to len bytes",
+	"-t size             target extent size hint (default: 32M)",
 	NULL
 };

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 3b9e85e..48c1fee 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -223,7 +223,7 @@ static struct readable_flag_entry incompat_flags_array[] = {
 	DEF_INCOMPAT_FLAG_ENTRY(DEFAULT_SUBVOL),
 	DEF_INCOMPAT_FLAG_ENTRY(MIXED_GROUPS),
 	DEF_INCOMPAT_FLAG_ENTRY(COMPRESS_LZO),
-	DEF_INCOMPAT_FLAG_ENTRY(COMPRESS_LZOv2),
+	DEF_INCOMPAT_FLAG_ENTRY(COMPRESS_ZSTD),
 	DEF_INCOMPAT_FLAG_ENTRY(BIG_METADATA),
 	DEF_INCOMPAT_FLAG_ENTRY(EXTENDED_IREF),
 	DEF_INCOMPAT_FLAG_ENTRY(RAID56),
diff --git a/cmds-restore.c b/cmds-restore.c
index ebc5e5a..b81decd 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1,3 +1,4 @@
+#define ZSTD_STATIC_LINKING_ONLY
 /*
  * Copyright (C) 2011 Red Hat.  All rights reserved.
  *
@@ -29,6 +30,7 @@
 #include <lzo/lzoconf.h>
 #include <lzo/lzo1x.h>
 #include <zlib.h>
+#include <zstd.h>
 #include <regex.h>
 #include <getopt.h>
 #include <sys/types.h>
@@ -156,6 +158,45 @@ static int decompress_lzo(struct btrfs_root *root, unsigned char *inbuf,
 	return 0;
 }

+static int decompress_zstd(const char *inbuf, char *outbuf, u64 compress_len,
+			   u64 decompress_len)
+{
+	ZSTD_DStream *strm;
+	size_t zret;
+	int ret = 0;
+	ZSTD_inBuffer in = {inbuf, compress_len, 0};
+	ZSTD_outBuffer out = {outbuf, decompress_len, 0};
+
+	strm = ZSTD_createDStream();
+	if (!strm) {
+		error("zstd create failed");
+		return -1;
+	}
+
+	zret = ZSTD_initDStream(strm);
+	if (ZSTD_isError(zret)) {
+		error("zstd init failed: %s", ZSTD_getErrorName(zret));
+		ret = -1;
+		goto out;
+	}
+
+	zret = ZSTD_decompressStream(strm, &out, &in);
+	if (ZSTD_isError(zret)) {
+		error("zstd decompress failed %s\n", ZSTD_getErrorName(zret));
+		ret = -1;
+		goto out;
+	}
+	if (zret != 0) {
+		error("zstd frame incomplete");
+		ret = -1;
+		goto out;
+	}
+
+out:
+	ZSTD_freeDStream(strm);
+	return ret;
+}
+
 static int decompress(struct btrfs_root *root, char *inbuf, char *outbuf,
 			u64 compress_len, u64 *decompress_len, int compress)
 {
@@ -166,6 +207,9 @@ static int decompress(struct btrfs_root *root, char *inbuf, char *outbuf,
 	case BTRFS_COMPRESS_LZO:
 		return decompress_lzo(root, (unsigned char *)inbuf, outbuf,
 					compress_len, decompress_len);
+	case BTRFS_COMPRESS_ZSTD:
+		return decompress_zstd(inbuf, outbuf, compress_len,
+				       *decompress_len);
 	default:
 		break;
 	}
diff --git a/configure.ac b/configure.ac
index ac92442..267ba23 100644
--- a/configure.ac
+++ b/configure.ac
@@ -182,6 +182,9 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
 PKG_CHECK_MODULES(ZLIB, [zlib])
 PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])

+PKG_CHECK_MODULES(ZSTD, [libzstd])
+PKG_STATIC(ZSTD_LIBS_STATIC, [libzstd])
+
 # udev v190 introduced the btrfs builtin and a udev rule to use it.
 # Our udev rule gives us the friendly dm names but isn't required (or valid)
 # on earlier releases.
@@ -238,4 +241,3 @@ AC_MSG_RESULT([

 	Type 'make' to compile.
 ])
-
diff --git a/ctree.h b/ctree.h
index 2818441..ef97b66 100644
--- a/ctree.h
+++ b/ctree.h
@@ -482,14 +482,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
 #define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
-
-/*
- * some patches floated around with a second compression method
- * lets save that incompat here for when they do get in
- * Note we don't actually support it, we're just reserving the
- * number
- */
-#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZOv2   (1ULL << 4)
+#define BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD	(1ULL << 4)

 /*
  * older kernels tried to do bigger metadata blocks, but the
@@ -514,6 +507,7 @@ struct btrfs_super_block {
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
 	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD |		\
 	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
@@ -675,8 +669,9 @@ typedef enum {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
+	BTRFS_COMPRESS_ZSTD  = 3,
+	BTRFS_COMPRESS_TYPES = 3,
+	BTRFS_COMPRESS_LAST  = 4,
 } btrfs_compression_type;

 /* we don't understand any encryption methods right now */
diff --git a/fsfeatures.h b/fsfeatures.h
index 513ed1e..3cc9452 100644
--- a/fsfeatures.h
+++ b/fsfeatures.h
@@ -31,7 +31,7 @@
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF			\
 	| BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL			\
 	| BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO			\
-	| BTRFS_FEATURE_INCOMPAT_COMPRESS_LZOv2			\
+	| BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD			\
 	| BTRFS_FEATURE_INCOMPAT_BIG_METADATA			\
 	| BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF			\
 	| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA		\
diff --git a/print-tree.c b/print-tree.c
index 4d251b5..e453885 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -316,6 +316,9 @@ static void compress_type_to_str(u8 compress_type, char *ret)
 	case BTRFS_COMPRESS_LZO:
 		strcpy(ret, "lzo");
 		break;
+	case BTRFS_COMPRESS_ZSTD:
+		strcpy(ret, "zstd");
+		break;
 	default:
 		sprintf(ret, "UNKNOWN.%d", compress_type);
 	}
--
2.9.5
