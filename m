Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60599 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935193AbeCHClH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0761AAE5D
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:06 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 18/20] btrfs-progs: add generic support for json output
Date: Wed,  7 Mar 2018 21:40:45 -0500
Message-Id: <20180308024047.10104-19-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch adds support for JSON and JSON-compat output.  The latter is
intended to be compatible with Javascript's integers being represented
as 64-bit floats, with only 53 bits usable for the integer component.
Compat mode output will post 64-bit integers as an array of two 32-bit
integers in [high, low] format.

This patch also adds support for reporting which output formats a
command supports as well as detection of the json-c library.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Makefile.inc.in |  4 ++--
 commands.h      | 13 +++++++++++++
 configure.ac    |  6 ++++++
 help.c          | 25 ++++++++++++++-----------
 4 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/Makefile.inc.in b/Makefile.inc.in
index 56271903..68bddbed 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -18,9 +18,9 @@ BTRFSRESTORE_ZSTD = @BTRFSRESTORE_ZSTD@
 SUBST_CFLAGS = @CFLAGS@
 SUBST_LDFLAGS = @LDFLAGS@
 
-LIBS_BASE = @UUID_LIBS@ @BLKID_LIBS@ -L. -pthread
+LIBS_BASE = @UUID_LIBS@ @BLKID_LIBS@ @JSON_LIBS@ -L. -pthread
 LIBS_COMP = @ZLIB_LIBS@ @LZO2_LIBS@ @ZSTD_LIBS@
-STATIC_LIBS_BASE = @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ -L. -pthread
+STATIC_LIBS_BASE = @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ @JSON_LIBS_STATIC@ -L. -pthread
 STATIC_LIBS_COMP = @ZLIB_LIBS_STATIC@ @LZO2_LIBS_STATIC@ @ZSTD_LIBS_STATIC@
 
 prefix ?= @prefix@
diff --git a/commands.h b/commands.h
index 83316c6d..bf74eaf8 100644
--- a/commands.h
+++ b/commands.h
@@ -19,9 +19,22 @@
 
 enum cmd_output {
 	CMD_OUTPUT_TEXT = 0,
+#ifdef HAVE_JSON
+	CMD_OUTPUT_JSON,
+	CMD_OUTPUT_JSON_COMPAT,
+#endif
 	CMD_OUTPUT_MAX,
 };
 
+/*
+ * If we don't have the JSON library, map the flags to text to avoid
+ * more ifdefs elsewhere.
+ */
+#ifndef HAVE_JSON
+#define CMD_OUTPUT_JSON		CMD_OUTPUT_TEXT
+#define CMD_OUTPUT_JSON_COMPAT	CMD_OUTPUT_TEXT
+#endif
+
 #define CMD_OUTPUT_FLAG(x)	(1 << (CMD_OUTPUT_##x))
 
 struct cmd_context {
diff --git a/configure.ac b/configure.ac
index 56d17c3a..6aec672a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -197,6 +197,12 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
 PKG_CHECK_MODULES(ZLIB, [zlib])
 PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
 
+PKG_CHECK_MODULES(JSON, [json-c], [
+	AC_DEFINE(HAVE_JSON, [1], [Have JSON]),
+	PKG_STATIC(JSON_LIBS_STATIC, [json-c], [
+		AC_DEFINE(HAVE_JSON_STATIC, [1], [Have JSON static])], [true])
+	], [true])
+
 AC_ARG_ENABLE([zstd],
 	AS_HELP_STRING([--disable-zstd], [build without zstd support]),
 	[], [enable_zstd=yes]
diff --git a/help.c b/help.c
index 063e9740..f1710621 100644
--- a/help.c
+++ b/help.c
@@ -32,6 +32,10 @@
 
 const char *cmd_outputs[CMD_OUTPUT_MAX] = {
 	"text",
+#ifdef HAVE_JSON
+	[CMD_OUTPUT_JSON] = "json",
+	[CMD_OUTPUT_JSON_COMPAT] = "json:compat",
+#endif
 };
 
 static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
@@ -186,18 +190,17 @@ static int do_usage_one_command(const char * const *usagestr,
 		fprintf(outf, "%*s%s\n", pad, "", *usagestr++);
 
 	/* options (optional) */
-	if (!*usagestr || ((flags & USAGE_OPTIONS) == 0))
-		return 0;
-
-	/*
-	 * options (if present) should always (even if there is no long
-	 * description) be prepended with an empty line, skip it
-	 */
-	usagestr++;
+	if (*usagestr && (flags & USAGE_OPTIONS)) {
+		/*
+		 * options (if present) should always (even if there is no long
+		 * description) be prepended with an empty line, skip it
+		 */
+		usagestr++;
 
-	fputc('\n', outf);
-	while (*usagestr)
-		fprintf(outf, "%*s%s\n", pad, "", *usagestr++);
+		fputc('\n', outf);
+		while (*usagestr)
+			fprintf(outf, "%*s%s\n", pad, "", *usagestr++);
+	}
 
 	if (flags & USAGE_FORMAT) {
 		/* We always support text */
-- 
2.12.3

