Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758205AbaDBI3I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:08 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SsN3014988
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 22/27] btrfs-progs: Convert man page for btrfs-show-super.
Date: Wed, 2 Apr 2014 16:29:33 +0800
Message-ID: <1396427378-10487-23-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-show-super.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile             |  2 +-
 Documentation/btrfs-show-super.txt | 53 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-show-super.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index d418681..2013d65 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -9,7 +9,7 @@ MAN8_TXT += btrfs-debug-tree.txt
 MAN8_TXT += btrfs-find-root.txt
 MAN8_TXT += btrfs-image.txt
 MAN8_TXT += btrfs-map-logical.txt
-#MAN8_TXT += btrfs-show-super.txt
+MAN8_TXT += btrfs-show-super.txt
 #MAN8_TXT += btrfstune.txt
 #MAN8_TXT += btrfs-zero-log.txt
 #MAN8_TXT += fsck.btrfs.txt
diff --git a/Documentation/btrfs-show-super.txt b/Documentation/btrfs-show-super.txt
new file mode 100644
index 0000000..e8e17ab
--- /dev/null
+++ b/Documentation/btrfs-show-super.txt
@@ -0,0 +1,53 @@
+btrfs-show-super(8)
+====================
+
+NAME
+----
+btrfs-show-super - show btrfs superblock information stored in devices
+
+SYNOPSIS
+--------
+'btrfs-show-super' [options] <dev> [<dev>...]
+
+DESCRIPTION
+-----------
+'btrfs-show-super' is used to print the information of superblock,
+you can specify which mirror to print out.
+
+By default, every device's first superblock will be printed out.
+
+Mainly used for debug purpose.
+
+OPTIONS
+-------
+-a::
+Print all the superblock information.
++
+If this option is given, '-i' option will be ignored.
+
+-i <super_mirror>::
+Specify which mirror to print out.
++
+<super_mirror> is between 0 and 2.
+If several '-i <super_mirror>' are given, only the last one is valid.
+
+EXIT STATUS
+-----------
+'btrfs-show-super' will return 0 if no error happened.
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

