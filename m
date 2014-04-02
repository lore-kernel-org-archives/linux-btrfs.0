Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758161AbaDBI3G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:06 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Spub014973
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 19/27] btrfs-progs: Convert man page for btrfs-find-root.
Date: Wed, 2 Apr 2014 16:29:30 +0800
Message-ID: <1396427378-10487-20-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-find-root.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile            |  2 +-
 Documentation/btrfs-find-root.txt | 45 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-find-root.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 460c14f..7a38df9 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -6,7 +6,7 @@ MAN8_TXT += btrfs.txt
 MAN8_TXT += btrfsck.txt
 MAN8_TXT += btrfs-convert.txt
 MAN8_TXT += btrfs-debug-tree.txt
-#MAN8_TXT += btrfs-find-root.txt
+MAN8_TXT += btrfs-find-root.txt
 #MAN8_TXT += btrfs-image.txt
 #MAN8_TXT += btrfs-map-logical.txt
 #MAN8_TXT += btrfs-show-super.txt
diff --git a/Documentation/btrfs-find-root.txt b/Documentation/btrfs-find-root.txt
new file mode 100644
index 0000000..18b1e84
--- /dev/null
+++ b/Documentation/btrfs-find-root.txt
@@ -0,0 +1,45 @@
+btrfs-find-root(8)
+==================
+
+NAME
+----
+btrfs-find-root - filter to find btrfs root
+
+SYNOPSIS
+--------
+'btrfs-find-root' [options] <dev>
+
+DESCRIPTION
+-----------
+'btrfs-find-root' is used to find the satisfied root, you can filter by
+root tree's objectid, generation, level.
+
+OPTIONS
+-------
+-g <generation>::
+Filter root tree by it's original transaction id, tree root's generation in default.
+-o <objectid>::
+Filter root tree by it's objectid,tree root's objectid in default.
+-l <level>::
+Filter root tree by B-+ tree's level, level 0 in default.
+
+EXIT STATUS
+-----------
+'btrfs-find-root' will return 0 if no error happened.
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
+This is free software: you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8)
-- 
1.9.1

