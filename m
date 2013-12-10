Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab3LJL5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 06:57:55 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BC80CA7D46
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 12:57:53 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs-progs: add fsck.btrfs stub and manpage
Date: Tue, 10 Dec 2013 12:57:50 +0100
Message-Id: <1386676670-9208-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1386612840-8897-1-git-send-email-dsterba@suse.cz>
References: <1386612840-8897-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
v2:
* install the new file

 Makefile            |  1 +
 fsck.btrfs          | 40 ++++++++++++++++++++++++++++++++++++++++
 man/Makefile        |  3 ++-
 man/fsck.btrfs.8.in | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100755 fsck.btrfs
 create mode 100644 man/fsck.btrfs.8.in

diff --git a/Makefile b/Makefile
index 0874a412ebb8..278ef4c13ad0 100644
--- a/Makefile
+++ b/Makefile
@@ -236,6 +236,7 @@ $(CLEANDIRS):
 install: $(libs) $(progs) $(INSTALLDIRS)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+	$(INSTALL) fsck.btrfs $(DESTDIR)$(bindir)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
 	$(LN) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
diff --git a/fsck.btrfs b/fsck.btrfs
new file mode 100755
index 000000000000..e90043a5cd45
--- /dev/null
+++ b/fsck.btrfs
@@ -0,0 +1,40 @@
+#!/bin/sh -f
+#
+# Copyright (c) 2013 SUSE
+#
+# copied from fsck.xfs
+# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+# fsck.btrfs is a type of utility that should exist for any filesystem and is
+# called during system setup when the corresponding /etc/fstab entries contain
+# non-zero value for fs_passno. (See fstab(5) for more.)
+#
+# Traditional filesystems need to run their respective fsck utility in case the
+# filesystem was not unmounted cleanly and the log needs to be replayed before
+# mount. This is not needed for BTRFS. You should set fs_passno to 0.
+#
+# If you wish to check the consistency of a BTRFS filesystem or repair a
+# damaged filesystem, see btrfs(8) subcommand 'check'. By default the
+# filesystem consistency is checked, the repair mode is enabled via --repair
+# option (use with care!).
+
+AUTO=false
+while getopts ":aApy" c
+do
+	case $c in
+	a|A|p|y)	AUTO=true;;
+	esac
+done
+eval DEV=\${$#}
+if [ ! -e $DEV ]; then
+	echo "$0: $DEV does not exist"
+	exit 8
+fi
+if $AUTO; then
+	echo "$0: BTRFS file system."
+else
+	echo "If you wish to check the consistency of a BTRFS filesystem or"
+	echo "repair a damaged filesystem, see btrfs(8) subcommand 'check'."
+fi
+exit 0
diff --git a/man/Makefile b/man/Makefile
index eb91e0c536a4..552c9f767075 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -13,7 +13,8 @@ man8dir = $(mandir)/man8
 
 MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz \
 	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz btrfs-find-root.8.gz \
-	   btrfs-convert.8.gz btrfstune.8.gz btrfs-zero-log.8.gz btrfs-map-logical.8.gz
+	   btrfs-convert.8.gz btrfstune.8.gz btrfs-zero-log.8.gz btrfs-map-logical.8.gz \
+	   fsck.btrfs.8.gz
 INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
diff --git a/man/fsck.btrfs.8.in b/man/fsck.btrfs.8.in
new file mode 100644
index 000000000000..eb21c89f8693
--- /dev/null
+++ b/man/fsck.btrfs.8.in
@@ -0,0 +1,47 @@
+.TH fsck.btrfs 8
+.SH NAME
+fsck.btrfs \- do nothing, successfully
+.SH SYNOPSIS
+.B fsck.btrfs
+[\fB-aApy\fP]
+[\fBdevice...\fP]
+.SH DESCRIPTION
+.B fsck.btrfs
+is a type of utility that should exist for any filesystem and is
+called during system setup when the corresponding
+.BR /etc/fstab
+entries contain non-zero value for
+.BR fs_passno
+, see
+.BR fstab(5)
+for more.
+.PP
+Traditional filesystems need to run their respective fsck utility in case the
+filesystem was not unmounted cleanly and the log needs to be replayed before
+mount. This is not needed for BTRFS. You should set fs_passno to 0.
+.PP
+If you wish to check the consistency of a BTRFS filesystem or repair a damaged
+filesystem, see
+.BR btrfs(8)
+subcommand 'check'. By default the filesystem
+consistency is checked, the repair mode is enabled via --repair option (use
+with care!).
+.SH OPTIONS
+The options detect if \fBfsck.btrfs\fP is executed in non-interactive mode and exits
+with success, otherwise prints a message about \fBbtrfs check\fP.
+.SH EXIT CODE
+There are two possible exit code returned:
+.RS
+.IP 0 5
+No errors
+.IP 8 5
+Operational error, eg. device does not exist
+.RE
+.
+.SH FILES
+.IR /etc/fstab .
+.SH SEE ALSO
+.BR btrfs (8),
+.BR fsck (8),
+.BR fstab (5),
+.\" btrfsck is intentionally left out
-- 
1.8.5

