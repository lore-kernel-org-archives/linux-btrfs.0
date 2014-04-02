Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16608 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757976AbaDBI3G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:06 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SoDQ014969
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 18/27] btrfs-progs: Convert man page for btrfs-debug-tree.
Date: Wed, 2 Apr 2014 16:29:29 +0800
Message-ID: <1396427378-10487-19-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-debug-tree.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile             |  2 +-
 Documentation/btrfs-debug-tree.txt | 50 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-debug-tree.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index b2afc7a..460c14f 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -5,7 +5,7 @@ MAN8_TXT =
 MAN8_TXT += btrfs.txt
 MAN8_TXT += btrfsck.txt
 MAN8_TXT += btrfs-convert.txt
-#MAN8_TXT += btrfs-debug-tree.txt
+MAN8_TXT += btrfs-debug-tree.txt
 #MAN8_TXT += btrfs-find-root.txt
 #MAN8_TXT += btrfs-image.txt
 #MAN8_TXT += btrfs-map-logical.txt
diff --git a/Documentation/btrfs-debug-tree.txt b/Documentation/btrfs-debug-tree.txt
new file mode 100644
index 0000000..80a85d4
--- /dev/null
+++ b/Documentation/btrfs-debug-tree.txt
@@ -0,0 +1,50 @@
+btrfs-debug-tree(8)
+===================
+
+NAME
+----
+btrfs-debug-tree - dump btrfs filesystem metadata into stdout
+
+SYNOPSIS
+--------
+'btrfs-debug-tree' [options] <device>
+
+DESCRIPTION
+-----------
+'btrfs-debug-tree' is used to dump the whole tree of the given device.
+
+This is maybe useful for analyzing filesystem state or inconsistence and has
+a positive educational effect on understanding the internal structure.
+<device> is the device file where the filesystem is stored.
+
+OPTIONS
+-------
+-e::
+Print detailed extents info.
+-d::
+Print info of btrfs device and root tree dirs only.
+-r::
+Print info of roots only.
+-b <block_num>::
+Print info of the specified block only.
+
+EXIT STATUS
+-----------
+'btrfs-debug-tree' will return 0 if no error happened.
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

