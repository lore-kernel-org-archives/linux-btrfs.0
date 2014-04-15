Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28924 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbaDOHDx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 03:03:53 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3F73juL001758
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 15:03:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] btrfs-progs: Convert man page for btrfs-restore.
Date: Tue, 15 Apr 2014 15:04:49 +0800
Message-ID: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-restore, which I forgot to convert in the
previous patchset. :P

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile          |  1 +
 Documentation/btrfs-restore.txt | 72 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)
 create mode 100644 Documentation/btrfs-restore.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 97a775a..dfacb93 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -30,6 +30,7 @@ MAN8_TXT += btrfs-quota.txt
 MAN8_TXT += btrfs-qgroup.txt
 MAN8_TXT += btrfs-replace.txt
 MAN8_TXT += btrfs-dedup.txt
+MAN8_TXT += btrfs-restore.txt
 
 MAN_TXT = $(MAN8_TXT)
 MAN_XML = $(patsubst %.txt,%.xml,$(MAN_TXT))
diff --git a/Documentation/btrfs-restore.txt b/Documentation/btrfs-restore.txt
new file mode 100644
index 0000000..ea18ebb
--- /dev/null
+++ b/Documentation/btrfs-restore.txt
@@ -0,0 +1,72 @@
+btrfs-restore(8)
+================
+
+NAME
+----
+btrfs-restore - try to restore files from a damaged btrfs filesystem(unmounted)
+
+SYNOPSIS
+--------
+'btrfs restore' [options] <device> <path> | -l <device>
+
+DESCRIPTION
+-----------
+'btrfs restore' is used to try to salvage files from a damaged filesystem and
+restore them into <path> or just list the tree roots.
+
+Since current `btrfsck`(8) or `btrfs-rescue`(8) only has very limited usage,
+'btrfs restore' is normally a better choice.
+
+OPTIONS
+-------
+-s::
+get snapshots.
+
+-x::
+get extended attributes.
+
+-v::
+verbose.
+
+-i::
+ignore errors.
+
+-o::
+overwrite directories/files in <path>.
+
+-t <location>::
+use <location> to read root tree.
+
+-f <offset>::
+use <offset> to read fs tree.
+
+-u <block>::
+use given superblock mirror identified by <block>.
+
+-r <rootid>::
+use <rootid> as root objectid.
+
+-d::
+find dir.
+
+-l::
+list tree roots.
+
+EXIT STATUS
+-----------
+'btrfs restore' returns a zero exist status if it succeeds. Non zero is
+returned in case of failure.
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
+`mkfs.btrfs`(8),
+`btrfs-rescue`(8),
+`btrfs-check`(8)
-- 
1.9.2

