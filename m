Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758183AbaDBI26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:58 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Sdlm014930
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/27] btrfs-progs: Convert man page for btrfs-check.
Date: Wed, 2 Apr 2014 16:29:18 +0800
Message-ID: <1396427378-10487-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-check.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile        |  2 +-
 Documentation/btrfs-check.txt | 45 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-check.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 68b7e1f..a838ca1 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -21,7 +21,7 @@ MAN8_TXT += btrfs-filesystem.txt
 MAN8_TXT += btrfs-balance.txt
 MAN8_TXT += btrfs-device.txt
 MAN8_TXT += btrfs-scrub.txt
-#MAN8_TXT += btrfs-check.txt
+MAN8_TXT += btrfs-check.txt
 #MAN8_TXT += btrfs-rescue.txt
 #MAN8_TXT += btrfs-inspect-internal.txt
 #MAN8_TXT += btrfs-send.txt
diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
new file mode 100644
index 0000000..accbed4
--- /dev/null
+++ b/Documentation/btrfs-check.txt
@@ -0,0 +1,45 @@
+btrfs-check(8)
+==============
+
+NAME
+----
+btrfs-check - check or repair a btrfs filesystem offline
+
+SYNOPSIS
+--------
+'btrfs check' [options] <device>
+
+DESCRIPTION
+-----------
+'btrfs check' is used to check or repair a btrfs filesystem offline.
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
+'btrfs check' returns a zero exist status if it succeeds. Non zero is
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
+`btrfsck`(8)
-- 
1.9.1

