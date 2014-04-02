Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757956AbaDBI2s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:48 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SYvP014908
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/27] btrfs-progs: Introduce asciidoc based man page and btrfs man page.
Date: Wed, 2 Apr 2014 16:29:12 +0800
Message-ID: <1396427378-10487-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The old man page of btrfs will grow larger with new functions adding to
btrfs-progs and harder to maintain because the reader-unfriendly roff
grammar and one LARGE btrfs.in.

This patch will introduce the simplified Documentation directory mainly
'stolen' from git and include the first man page for 'btrfs(8)'.
This time, man page will be written in human-friendly asciidoc grammar
and each commands of btrfs will have a separate man page, which I hope
can reduce the effort to maintain the man page.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .gitignore                             |   1 +
 Documentation/Makefile                 |  91 +++++++++++++++++++++++++
 Documentation/asciidoc.conf            |  42 ++++++++++++
 Documentation/btrfs.txt                | 117 +++++++++++++++++++++++++++++++++
 Documentation/manpage-base.xsl         |  35 ++++++++++
 Documentation/manpage-bold-literal.xsl |  17 +++++
 Documentation/manpage-normal.xsl       |  13 ++++
 7 files changed, 316 insertions(+)
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/asciidoc.conf
 create mode 100644 Documentation/btrfs.txt
 create mode 100644 Documentation/manpage-base.xsl
 create mode 100644 Documentation/manpage-bold-literal.xsl
 create mode 100644 Documentation/manpage-normal.xsl

diff --git a/.gitignore b/.gitignore
index ab8b81c..fc8c07a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,6 +5,7 @@
 version.h
 version
 man/*.gz
+Documentation/*.gz
 btrfs
 btrfs.static
 btrfs-debug-tree
diff --git a/Documentation/Makefile b/Documentation/Makefile
new file mode 100644
index 0000000..bf38617
--- /dev/null
+++ b/Documentation/Makefile
@@ -0,0 +1,91 @@
+# Guard against environment variables
+MAN8_TXT =
+
+# Top level commands
+MAN8_TXT += btrfs.txt
+#MAN8_TXT += btrfsck.txt
+#MAN8_TXT += btrfs-convert.txt
+#MAN8_TXT += btrfs-debug-tree.txt
+#MAN8_TXT += btrfs-find-root.txt
+#MAN8_TXT += btrfs-image.txt
+#MAN8_TXT += btrfs-map-logical.txt
+#MAN8_TXT += btrfs-show-super.txt
+#MAN8_TXT += btrfstune.txt
+#MAN8_TXT += btrfs-zero-log.txt
+#MAN8_TXT += fsck.btrfs.txt
+#MAN8_TXT += mkfs.btrfs.txt
+
+# Sub commands for btrfs
+#MAN8_TXT += btrfs-subvolume.txt
+#MAN8_TXT += btrfs-filesystem.txt
+#MAN8_TXT += btrfs-balance.txt
+#MAN8_TXT += btrfs-device.txt
+#MAN8_TXT += btrfs-scrub.txt
+#MAN8_TXT += btrfs-check.txt
+#MAN8_TXT += btrfs-rescue.txt
+#MAN8_TXT += btrfs-inspect-internal.txt
+#MAN8_TXT += btrfs-send.txt
+#MAN8_TXT += btrfs-receive.txt
+#MAN8_TXT += btrfs-quota.txt
+#MAN8_TXT += btrfs-replace.txt
+#MAN8_TXT += btrfs-dedup.txt
+
+MAN_TXT = $(MAN8_TXT)
+MAN_XML = $(patsubst %.txt,%.xml,$(MAN_TXT))
+DOC_MAN8 = $(patsubst %.txt,%.8,$(MAN8_TXT))
+GZ_MAN8 = $(patsubst %.txt,%.8.gz,$(MAN8_TXT))
+
+mandir ?= $(prefix)/share/man
+man8dir = $(mandir)/man8
+
+ASCIIDOC = asciidoc
+ASCIIDOC_EXTRA =
+MANPAGE_XSL = manpage-normal.xsl
+XMLTO = xmlto
+XMLTO_EXTRA =
+XMLTO_EXTRA = -m manpage-bold-literal.xsl
+GZIP = gzip
+INSTALL ?= install
+RM ?= rm -f
+BTRFS_VERSION = $(shell sed -n 's/.*BTRFS_BUILD_VERSION "Btrfs \(.*\)"/\1/p'\
+		  ../version.h)
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifndef V
+	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
+	QUIET_XMLTO	= @echo '   ' XMLTO $@;
+	QUIET_GZIP	= @echo '   ' GZIP $@;
+	QUIET_STDERR	= 2> /dev/null
+	QUIET_SUBDIR0	= +@subdir=
+	QUIET_SUBDIR1	= ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+			  $(MAKE) $(PRINT_DIR) -C $$subdir
+	export V
+endif
+endif
+
+all: man
+man: man8
+man8: $(GZ_MAN8)
+
+install: install-man
+
+install-man: man
+	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
+	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
+
+clean:
+	$(RM) *.xml *.xml+ *.8 *.8.gz
+
+%.8.gz : %.8
+	$(QUIET_GZIP)$(GZIP) -n -c $< > $@
+
+%.8 : %.xml 
+	$(QUIET_XMLTO)$(RM) $@ && \
+	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+
+%.xml : %.txt asciidoc.conf
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
+		$(ASCIIDOC_EXTRA) -abtrfs_version=$(BTRFS_VERSION) \
+		-o $@+ $< && \
+	mv $@+ $@
diff --git a/Documentation/asciidoc.conf b/Documentation/asciidoc.conf
new file mode 100644
index 0000000..313f185
--- /dev/null
+++ b/Documentation/asciidoc.conf
@@ -0,0 +1,42 @@
+## linkbtrfs: macro
+#
+# Usage: linkbtrfs:command[manpage-section]
+#
+# Note, {0} is the manpage section, while {target} is the command.
+#
+# Show Btrfslink as: <command>(<section>); if section is defined, else just show
+# the command.
+
+[macros]
+(?su)[\\]?(?P<name>linkbtrfs):(?P<target>\S*?)\[(?P<attrlist>.*?)\]=
+
+[attributes]
+asterisk=&#42;
+plus=&#43;
+caret=&#94;
+startsb=&#91;
+endsb=&#93;
+backslash=&#92;
+tilde=&#126;
+apostrophe=&#39;
+backtick=&#96;
+litdd=&#45;&#45;
+
+ifdef::doctype-manpage[]
+ifdef::backend-docbook[]
+[header]
+template::[header-declarations]
+<refentry>
+<refmeta>
+<refentrytitle>{mantitle}</refentrytitle>
+<manvolnum>{manvolnum}</manvolnum>
+<refmiscinfo class="source">Btrfs</refmiscinfo>
+<refmiscinfo class="version">{btrfs_version}</refmiscinfo>
+<refmiscinfo class="manual">Btrfs Manual</refmiscinfo>
+</refmeta>
+<refnamediv>
+  <refname>{manname}</refname>
+  <refpurpose>{manpurpose}</refpurpose>
+</refnamediv>
+endif::backend-docbook[]
+endif::doctype-manpage[]
diff --git a/Documentation/btrfs.txt b/Documentation/btrfs.txt
new file mode 100644
index 0000000..c9bed70
--- /dev/null
+++ b/Documentation/btrfs.txt
@@ -0,0 +1,117 @@
+btrfs(8)
+========
+
+NAME
+----
+btrfs - control a btrfs filesystem
+
+SYNOPSIS
+--------
+'btrfs' <command> [<args>]
+
+DESCRIPTION
+-----------
+'btrfs' is used to control the filesystem and the files and directories stored.
+It is the tool to create or destroy a snapshot or a subvolume for the
+filesystem, to defrag a file or a directory, flush the data to the disk,
+to resize the filesystem, to scan the device.
+
+It is possible to abbreviate the commands unless the commands are ambiguous.
+For example: it is possible to run 'btrfs sub snaps' instead of
+'btrfs subvolume snapshot'.
+But 'btrfs file s' is not allowed, because 'file s' may be interpreted
+both as 'filesystem show' and as 'filesystem sync'.
+
+If a command is terminated by '--help', the detailed help is showed.
+If the passed command matches more commands,
+detailed help of all the matched commands is showed. For example
+'btrfs dev --help' shows the help of all 'device*' commands.
+
+COMMANDS
+--------
+'subvolume'::
+	Create/delete/list/manage btrfs subvolume. +
+	See `btrfs-subvolume`(8) for details.
+
+'filesystem'::
+	Manage a btrfs filesystem, including label setting/sync and so on. +
+	See `btrfs-filesystem`(8) for details.
+
+'[filesystem] balance'::
+	Balance btrfs filesystem chunks across single or several devices. +
+	See `btrfs-balance`(8) for details.
+
+'device'::
+	Manage devices managed by btrfs, including add/delete/scan and so
+	on. +
+	See `btrfs-device`(8) for details.
+
+'scrub'::
+	Scrub a btrfs filesystem. +
+	See `btrfs-scrub`(8) for details.
+
+'check'::
+	Do off-line check on a btrfs filesystem. +
+	See `btrfs-check`(8) for details.
+
+'rescue'::
+	Try to rescue damaged btrfs filesystem. +
+	See `btrfs-rescue`(8) for details.
+
+'restore'::
+	Manage a btrfs filesystem, including label setting/sync and so on. +
+	See `btrfs-restore`(8) for details.
+
+'inspect-internal'::
+	Debug tools for developers/hackers. +
+	See `btrfs-inspect-internal`(8) for details.
+
+'send'::
+	Send subvolume data to stdout/file for backup and etc. +
+	See `btrfs-send`(8) for details.
+
+'receive'::
+	Receive subvolume data from stdin/file for restore and etc. +
+	See `btrfs-receive`(8) for details.
+'quota'::
+	Manage quota on btrfs filesystem like enabling/rescan and etc. +
+	See `btrfs-quota`(8) and `btrfs-qgroup`(8) for details.
+
+'qgroup'::
+	Manage quota group(qgroup) for btrfs filesystem. +
+	See `btrfs-qgroup`(8) for details.
+
+'replace'::
+	Replace btrfs devices. +
+	See `btrfs-replace`(8) for details.
+
+EXIT STATUS
+-----------
+'btrfs' returns a zero exist status if it succeeds. Non zero is returned in
+case of failure.
+
+AVAILABILITY
+------------
+'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8), `ionice`(1),
+`btrfs-subvolume`(8),
+`btrfs-filesystem`(8),
+`btrfs-balance`(8),
+`btrfs-device`(8),
+`btrfs-scrub`(8),
+`btrfs-check`(8),
+`btrfs-rescue`(8),
+`btrfs-restore`(8),
+`btrfs-inspect-internal`(8),
+`btrfs-send`(8),
+`btrfs-receive`(8),
+`btrfs-quota`(8),
+`btrfs-qgroup`(8),
+`btrfs-replace`(8),
diff --git a/Documentation/manpage-base.xsl b/Documentation/manpage-base.xsl
new file mode 100644
index 0000000..a264fa6
--- /dev/null
+++ b/Documentation/manpage-base.xsl
@@ -0,0 +1,35 @@
+<!-- manpage-base.xsl:
+     special formatting for manpages rendered from asciidoc+docbook -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<!-- these params silence some output from xmlto -->
+<xsl:param name="man.output.quietly" select="1"/>
+<xsl:param name="refentry.meta.get.quietly" select="1"/>
+
+<!-- convert asciidoc callouts to man page format;
+     git.docbook.backslash and git.docbook.dot params
+     must be supplied by another XSL file or other means -->
+<xsl:template match="co">
+	<xsl:value-of select="concat(
+			      $git.docbook.backslash,'fB(',
+			      substring-after(@id,'-'),')',
+			      $git.docbook.backslash,'fR')"/>
+</xsl:template>
+<xsl:template match="calloutlist">
+	<xsl:value-of select="$git.docbook.dot"/>
+	<xsl:text>sp&#10;</xsl:text>
+	<xsl:apply-templates/>
+	<xsl:text>&#10;</xsl:text>
+</xsl:template>
+<xsl:template match="callout">
+	<xsl:value-of select="concat(
+			      $git.docbook.backslash,'fB',
+			      substring-after(@arearefs,'-'),
+			      '. ',$git.docbook.backslash,'fR')"/>
+	<xsl:apply-templates/>
+	<xsl:value-of select="$git.docbook.dot"/>
+	<xsl:text>br&#10;</xsl:text>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/Documentation/manpage-bold-literal.xsl b/Documentation/manpage-bold-literal.xsl
new file mode 100644
index 0000000..608eb5d
--- /dev/null
+++ b/Documentation/manpage-bold-literal.xsl
@@ -0,0 +1,17 @@
+<!-- manpage-bold-literal.xsl:
+     special formatting for manpages rendered from asciidoc+docbook -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<!-- render literal text as bold (instead of plain or monospace);
+     this makes literal text easier to distinguish in manpages
+     viewed on a tty -->
+<xsl:template match="literal">
+	<xsl:value-of select="$git.docbook.backslash"/>
+	<xsl:text>fB</xsl:text>
+	<xsl:apply-templates/>
+	<xsl:value-of select="$git.docbook.backslash"/>
+	<xsl:text>fR</xsl:text>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/Documentation/manpage-normal.xsl b/Documentation/manpage-normal.xsl
new file mode 100644
index 0000000..a48f5b1
--- /dev/null
+++ b/Documentation/manpage-normal.xsl
@@ -0,0 +1,13 @@
+<!-- manpage-normal.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles anything we want to keep away from docbook-xsl 1.72.0 -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<xsl:import href="manpage-base.xsl"/>
+
+<!-- these are the normal values for the roff control characters -->
+<xsl:param name="git.docbook.backslash">\</xsl:param>
+<xsl:param name="git.docbook.dot"	>.</xsl:param>
+
+</xsl:stylesheet>
-- 
1.9.1

