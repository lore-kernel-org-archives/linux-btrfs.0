Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758199AbaDBI3E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:04 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SlJu014962
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 16/27] btrfs-progs: Convert man page for btrfsck
Date: Wed, 2 Apr 2014 16:29:27 +0800
Message-ID: <1396427378-10487-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfsck.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile    |  2 +-
 Documentation/btrfsck.txt | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfsck.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 4040951..b4d8281 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -3,7 +3,7 @@ MAN8_TXT =
 
 # Top level commands
 MAN8_TXT += btrfs.txt
-#MAN8_TXT += btrfsck.txt
+MAN8_TXT += btrfsck.txt
 #MAN8_TXT += btrfs-convert.txt
 #MAN8_TXT += btrfs-debug-tree.txt
 #MAN8_TXT += btrfs-find-root.txt
diff --git a/Documentation/btrfsck.txt b/Documentation/btrfsck.txt
new file mode 100644
index 0000000..751c4d0
--- /dev/null
+++ b/Documentation/btrfsck.txt
@@ -0,0 +1,55 @@
+btrfsck(8)
+==========
+
+NAME
+----
+btrfsck - check or repair a btrfs filesystem offline
+
+SYNOPSIS
+--------
+'btrfsck' [options] <device>
+
+DESCRIPTION
+-----------
+'btrfsck' is used to check and optionally repair of a Btrfs filesystem.
+
+Now, it can only be run on an unmounted FS.
+<device> is the device file where the filesystem is stored.
+
+'btrfsck' is just an alias of 'btrfs check' command.
+
+WARNING: Considering it is not well-tested in real-life situations yet.
+If you have a broken Btrfs filesystem, btrfsck may not repair but cause
+additional damages. 
+
+
+OPTIONS
+-------
+-s|--support <superblock>::
+use <superblock>th superblock copy.
+--repair::
+try to repair the filesystem.
+--init-csum-tree::
+create a new CRC tree.
+--init-extent-tree::
+create a new extent tree.
+
+EXIT STATUS
+-----------
+'btrfsck' returns a zero exist status if it succeeds. Non zero is
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
+`btrfs-scrub`(8),
+`btrfs-rescue`(8)
+`btrfs-check`(8)
-- 
1.9.1

