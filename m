Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16608 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758185AbaDBI27 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:59 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SebP014938
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/27] btrfs-progs: Convert man page for btrfs-inspect-internal
Date: Wed, 2 Apr 2014 16:29:20 +0800
Message-ID: <1396427378-10487-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-inspect-internal.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile                   |  2 +-
 Documentation/btrfs-inspect-internal.txt | 69 ++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-inspect-internal.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index ebe0455..6655f06 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -23,7 +23,7 @@ MAN8_TXT += btrfs-device.txt
 MAN8_TXT += btrfs-scrub.txt
 MAN8_TXT += btrfs-check.txt
 MAN8_TXT += btrfs-rescue.txt
-#MAN8_TXT += btrfs-inspect-internal.txt
+MAN8_TXT += btrfs-inspect-internal.txt
 #MAN8_TXT += btrfs-send.txt
 #MAN8_TXT += btrfs-receive.txt
 #MAN8_TXT += btrfs-quota.txt
diff --git a/Documentation/btrfs-inspect-internal.txt b/Documentation/btrfs-inspect-internal.txt
new file mode 100644
index 0000000..4555c70
--- /dev/null
+++ b/Documentation/btrfs-inspect-internal.txt
@@ -0,0 +1,69 @@
+btrfs-inspect-internal(8)
+=========================
+
+NAME
+----
+btrfs-inspect-internal - resolve different btrfs items for debug purpose
+
+SYNOPSIS
+--------
+'btrfs inspect-internal' <subcommand> <args>
+
+DESCRIPTION
+-----------
+'btrfs inspect-internal' is used to resolve different items for debug purpose.
+
+SUBCOMMAND
+----------
+'inode-resolve' [-v] <inode> <path>::
+Resolves an <inode> in subvolume <path> to all filesystem paths.
++
+`Options`
++
+-v::::
+verbose mode. print count of returned paths and ioctl() return value
+
+'logical-resolve' [-Pv] [-s bufsize] <logical> <path>::
+Resolves a <logical> address in the filesystem mounted at <path> to all inodes.
++
+By default, each inode is then resolved to a file system path (similar to the
+inode-resolve subcommand).
++
+`Options`
++
+-P::::
+skip the path resolving and print the inodes instead
+-v::::
+verbose mode. print count of returned paths and all ioctl() return values
+-s <bufsize>::::
+set inode container's size.
++
+This is used to increase inode container's size in case it is
+not enough to read all the resolved results. The max value one can set is 64k.
+
+'subvolid-resolve' <subvolid> <path>::
+Get file system paths for the given subvolume ID.
+
+'rootid' <path>::
+For a given file or directory, return the containing tree root id. For a
+subvolume return it's own tree id.
++
+The result is undefined for the so-called empty subvolumes (identified by inode number 2).
+
+EXIT STATUS
+-----------
+'btrfs inspect-internal' returns a zero exist status if it succeeds. Non zero is
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
+`btrfs-debug-tree`(8)
-- 
1.9.1

