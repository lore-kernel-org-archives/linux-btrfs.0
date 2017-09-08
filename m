Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50462 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756290AbdIHU3d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 16:29:33 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v88KQoVQ017753
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Sep 2017 13:29:32 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2cv1eng4bj-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 13:29:32 -0700
From: Nick Terrell <terrelln@fb.com>
To: Nick Terrell <terrelln@fb.com>
CC: <kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: Add zstd support
Date: Fri, 8 Sep 2017 13:29:23 -0700
Message-ID: <20170908202923.240776-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds zstd support to the btrfs program. An optional dependency on libzstd
>= 1.0.0 is added. Autoconf accepts `--enable-zstd' or `--disable-zstd' and
defaults to detecting if libzstd is present using `pkg-config'. Adds tests
for the new features based on a prebuilt btrfs image with a zstd compressed
file.

The patch is also available in my fork of btrfs-progs [1], which passes
Travis-CI with the new tests. The prebuilt binary is available there.

I haven't updated Android.mk.

[1] https://github.com/terrelln/btrfs-progs/tree/devel

Signed-off-by: Nick Terrell <terrelln@fb.com>
---
v1 -> v2:
- Allow zstd support to be disabled, defaulting to auto detection
- Print if zstd is enabled/disabled when `./configure' finishes
- Add zstd test to patch with prebuilt image`

 .travis.yml                                        |   9 ++++
 Documentation/btrfs-filesystem.asciidoc            |   2 +-
 Documentation/btrfs-man5.asciidoc                  |   8 +++-
 Documentation/btrfs-property.asciidoc              |   2 +-
 INSTALL                                            |   1 +
 Makefile                                           |   1 +
 Makefile.inc.in                                    |   5 +-
 cmds-filesystem.c                                  |  16 ++++---
 cmds-inspect-dump-super.c                          |   2 +-
 cmds-restore.c                                     |  50 ++++++++++++++++++++
 configure.ac                                       |  41 ++++++++++++-----
 ctree.h                                            |  15 ++----
 fsfeatures.h                                       |   2 +-
 print-tree.c                                       |   3 ++
 .../022-zstd-compression/compress.raw.xz           | Bin 0 -> 18256 bytes
 tests/misc-tests/022-zstd-compression/test.sh      |  51 +++++++++++++++++++++
 16 files changed, 172 insertions(+), 36 deletions(-)
 create mode 100644 tests/misc-tests/022-zstd-compression/compress.raw.xz
 create mode 100755 tests/misc-tests/022-zstd-compression/test.sh

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
index 0465fb0..e7f8184 100644
--- a/INSTALL
+++ b/INSTALL
@@ -7,6 +7,7 @@ The Btrfs utility programs require the following libraries/tools to build:
 - libblkid - block device id library
 - liblzo2 - LZO data compression library
 - zlib - ZLIB data compression library
+- libzstd - ZSTD data compression library version >= 1.0.0 (optional)
 
 For the btrfs-convert utility:
 
diff --git a/Makefile b/Makefile
index a114eca..a98cd7e 100644
--- a/Makefile
+++ b/Makefile
@@ -209,6 +209,7 @@ btrfs_fragments_libs = -lgd -lpng -ljpeg -lfreetype
 btrfs_debug_tree_objects = cmds-inspect-dump-tree.o
 btrfs_show_super_objects = cmds-inspect-dump-super.o
 btrfs_calc_size_objects = cmds-inspect-tree-stats.o
+cmds_restore_cflags = -DBTRFSRESTORE_ZSTD=$(BTRFSRESTORE_ZSTD)
 
 # collect values of the variables above
 standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs)))),$($(dep)))
diff --git a/Makefile.inc.in b/Makefile.inc.in
index 3c7bc03..5627190 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -13,14 +13,15 @@ DISABLE_DOCUMENTATION = @DISABLE_DOCUMENTATION@
 DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
 BTRFSCONVERT_EXT2 = @BTRFSCONVERT_EXT2@
 BTRFSCONVERT_REISERFS = @BTRFSCONVERT_REISERFS@
+BTRFSRESTORE_ZSTD = @BTRFSRESTORE_ZSTD@
 
 SUBST_CFLAGS = @CFLAGS@
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
index ebc5e5a..6196a1e 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -29,6 +29,9 @@
 #include <lzo/lzoconf.h>
 #include <lzo/lzo1x.h>
 #include <zlib.h>
+#if BTRFSRESTORE_ZSTD
+#include <zstd.h>
+#endif
 #include <regex.h>
 #include <getopt.h>
 #include <sys/types.h>
@@ -156,6 +159,50 @@ static int decompress_lzo(struct btrfs_root *root, unsigned char *inbuf,
 	return 0;
 }
 
+static int decompress_zstd(const char *inbuf, char *outbuf, u64 compress_len,
+			   u64 decompress_len)
+{
+#if !BTRFSRESTORE_ZSTD
+	error("btrfs not compiled with zstd support");
+	return -1;
+#else
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
+#endif
+}
+
 static int decompress(struct btrfs_root *root, char *inbuf, char *outbuf,
 			u64 compress_len, u64 *decompress_len, int compress)
 {
@@ -166,6 +213,9 @@ static int decompress(struct btrfs_root *root, char *inbuf, char *outbuf,
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
index ac92442..f273bbe 100644
--- a/configure.ac
+++ b/configure.ac
@@ -182,6 +182,23 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
 PKG_CHECK_MODULES(ZLIB, [zlib])
 PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
 
+AC_ARG_ENABLE([zstd],
+	AS_HELP_STRING([--enable-zstd@<:@=auto@:>@], [build with zstd support (default: auto)]),
+	[], [enable_zstd=auto]
+)
+
+if test "x$enable_zstd" = xauto; then
+	PKG_CHECK_EXISTS([libzstd >= 1.0.0], [enable_zstd=yes], [enable_zstd=no])
+fi
+
+if test "x$enable_zstd" = xyes; then
+	PKG_CHECK_MODULES(ZSTD, [libzstd >= 1.0.0])
+	PKG_STATIC(ZSTD_LIBS_STATIC, [libzstd])
+fi
+
+AS_IF([test "x$enable_zstd" = xyes], [BTRFSRESTORE_ZSTD=1], [BTRFSRESTORE_ZSTD=0])
+AC_SUBST(BTRFSRESTORE_ZSTD)
+
 # udev v190 introduced the btrfs builtin and a udev rule to use it.
 # Our udev rule gives us the friendly dm names but isn't required (or valid)
 # on earlier releases.
@@ -221,21 +238,21 @@ AC_OUTPUT
 AC_MSG_RESULT([
 	${PACKAGE_NAME} ${PACKAGE_VERSION}
 
-	prefix:            ${prefix}
-	exec prefix:       ${exec_prefix}
+	prefix:             ${prefix}
+	exec prefix:        ${exec_prefix}
 
-	bindir:            ${bindir}
-	libdir:            ${libdir}
-	includedir:        ${includedir}
+	bindir:             ${bindir}
+	libdir:             ${libdir}
+	includedir:         ${includedir}
 
-	compiler:          ${CC}
-	cflags:            ${CFLAGS}
-	ldflags:           ${LDFLAGS}
+	compiler:           ${CC}
+	cflags:             ${CFLAGS}
+	ldflags:            ${LDFLAGS}
 
-	documentation:     ${enable_documentation}
-	backtrace support: ${enable_backtrace}
-	btrfs-convert:     ${enable_convert} ${convertfs:+($convertfs)}
+	documentation:      ${enable_documentation}
+	backtrace support:  ${enable_backtrace}
+	btrfs-convert:      ${enable_convert} ${convertfs:+($convertfs)}
+	btrfs-restore zstd: ${enable_zstd}
 
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
diff --git a/tests/misc-tests/022-zstd-compression/compress.raw.xz b/tests/misc-tests/022-zstd-compression/compress.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..ff85da69daefb368fcf80b207135eb8f6ab763ea
GIT binary patch
literal 18256
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

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/022-zstd-compression/test.sh b/tests/misc-tests/022-zstd-compression/test.sh
new file mode 100755
index 0000000..7a36e4b
--- /dev/null
+++ b/tests/misc-tests/022-zstd-compression/test.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+# Test zstd compression support on a prebuilt btrfs image
+
+source "$TOP/tests/common"
+
+check_prereq btrfs
+
+# Extract the test image
+image=$(extract_image compress.raw.xz)
+
+check_dump_tree() {
+	local image=$1
+	local string=$2
+	"$TOP/btrfs" inspect-internal dump-tree "$image" \
+		| grep "$string" > /dev/null \
+		|| _fail "btrfs inspect-internal dump-tree didn't print $string"
+}
+# Check that there are blocks of each compression type
+check_dump_tree "$image" "extent compression 1 (zlib)"
+check_dump_tree "$image" "extent compression 2 (lzo)"
+check_dump_tree "$image" "extent compression 3 (zstd)"
+
+# Check that the filesystem has incompat COMPRESS_ZSTD
+"$TOP/btrfs" inspect-internal dump-super -f "$image" \
+	| grep COMPRESS_ZSTD > /dev/null \
+	|| _fail "btrfs inspect-internal dump-super no incompat COMPRESS_ZSTD"
+
+# Create a temporary directory and restore the filesystem
+restore_tmp=$(mktemp --tmpdir -d btrfs-progs-022-zstd-compression.XXXXXXXXXX)
+run_check "$TOP/btrfs" restore "$image" "$restore_tmp"
+
+# Expect 3 files
+num_files=$(ls -1 "$restore_tmp" | wc -l)
+[ "$num_files" == 3 ] || _fail "number of files does not match"
+
+check_md5() {
+	local file="$1"
+	local expect_md5="$2"
+	md5=$(run_check_stdout md5sum "$file" | cut -d ' ' -f 1)
+	[ "$md5" == "$expect_md5" ] \
+		|| _fail "$file digest $md5 does not match $expect_md5"
+}
+# Each should be 200K of zeros
+expect_md5=$(run_check_stdout head -c 200K /dev/zero | md5sum | cut -d ' ' -f 1)
+check_md5 "$restore_tmp/zlib" "$expect_md5"
+check_md5 "$restore_tmp/lzo" "$expect_md5"
+check_md5 "$restore_tmp/zstd" "$expect_md5"
+
+# Clean up
+rm -r -- "$restore_tmp"
+rm -- "$image"
-- 
2.9.5

