Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:56085 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbbIBDdQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 23:33:16 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Subject: [PATCH] btrfs-progs: doc: document btrfs-select-super(8)
Date: Wed,  2 Sep 2015 05:00:46 +0200
Message-Id: <1441162846-1653-1-git-send-email-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 Documentation/Makefile.in                 |  1 +
 Documentation/btrfs-select-super.asciidoc | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 Documentation/btrfs-select-super.asciidoc

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index 0c8b5ba..b03eaf2 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -9,6 +9,7 @@ MAN8_TXT += btrfs-find-root.asciidoc
 MAN8_TXT += btrfs-image.asciidoc
 MAN8_TXT += btrfs-map-logical.asciidoc
 MAN8_TXT += btrfs-show-super.asciidoc
+MAN8_TXT += btrfs-select-super.asciidoc
 MAN8_TXT += btrfstune.asciidoc
 MAN8_TXT += fsck.btrfs.asciidoc
 MAN8_TXT += mkfs.btrfs.asciidoc
diff --git a/Documentation/btrfs-select-super.asciidoc b/Documentation/btrfs-select-super.asciidoc
new file mode 100644
index 0000000..a8d7ef0
--- /dev/null
+++ b/Documentation/btrfs-select-super.asciidoc
@@ -0,0 +1,29 @@
+btrfs-select-super(8)
+=====================
+
+NAME
+----
+btrfs-select-super - overwrite superblock with a backup
+
+SYNOPSIS
+--------
+*btrfs-select-super* -s number dev
+
+DESCRIPTION
+-----------
+*btrfs-select-super* destructively overwrites all copies of the superblock
+with a specified copy.  This helps with certain cases of damage, especially
+when barriers were disabled during a power failure.  You can find a valid
+copy of the superblock with *btrfs check -s*.
+
+The filesystem specified by `dev` must not be mounted.
+
+OPTIONS
+-------
+-s|--super <superblock>::
+use <superblock>th superblock copy, valid values are 0 up to 2 if the
+respective superblock offset is within the filesystem
+
+SEE ALSO
+--------
+`btrfsck check`(8)
-- 
2.1.4

