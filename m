Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16608 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758201AbaDBI3I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:08 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Srka014982
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 21/27] btrfs-progs: Convert man page for btrfs-map-logical.
Date: Wed, 2 Apr 2014 16:29:32 +0800
Message-ID: <1396427378-10487-22-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-map-logical.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile              |  2 +-
 Documentation/btrfs-map-logical.txt | 49 +++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-map-logical.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 6954a51..d418681 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -8,7 +8,7 @@ MAN8_TXT += btrfs-convert.txt
 MAN8_TXT += btrfs-debug-tree.txt
 MAN8_TXT += btrfs-find-root.txt
 MAN8_TXT += btrfs-image.txt
-#MAN8_TXT += btrfs-map-logical.txt
+MAN8_TXT += btrfs-map-logical.txt
 #MAN8_TXT += btrfs-show-super.txt
 #MAN8_TXT += btrfstune.txt
 #MAN8_TXT += btrfs-zero-log.txt
diff --git a/Documentation/btrfs-map-logical.txt b/Documentation/btrfs-map-logical.txt
new file mode 100644
index 0000000..2a93fb0
--- /dev/null
+++ b/Documentation/btrfs-map-logical.txt
@@ -0,0 +1,49 @@
+btrfs-map-logical(8)
+====================
+
+NAME
+----
+btrfs-map-logical - map btrfs logical extent to physical extent
+
+SYNOPSIS
+--------
+'btrfs-map-logical' <options> <device>
+
+DESCRIPTION
+-----------
+'btrfs-map-logical' can be used to find out what the physical offsets are
+on the mirrors, the result is dumped into stdout in default.
+
+Mainly used for debug purpose.
+
+OPTIONS
+-------
+-l|--logical <logical_num>::
+Logical extent to map.
+-c|--copy <copy>::
+Copy of the extent to read(usually 1 or 2).
+-o|--output <filename>::
+Output file to hold the extent.
+-b|--bytes <bytes>::
+Number of bytes to read.
+
+EXIT STATUS
+-----------
+'btrfs-map-logical' will return 0 if no error happened.
+If any problems happened, 1 will be returned.
+
+AUTHOR
+------
+Written by Shilong Wang and Wenruo Qu.
+
+COPYRIGHT
+---------
+Copyright (C) 2013 FUJITSU LIMITED.
+
+License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
+
+This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8)
-- 
1.9.1

