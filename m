Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758199AbaDBI3J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:09 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SuUU014991
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 23/27] btrfs-progs: Convert man page for btrfstune.
Date: Wed, 2 Apr 2014 16:29:34 +0800
Message-ID: <1396427378-10487-24-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfstune.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile      |  2 +-
 Documentation/btrfstune.txt | 47 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfstune.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 2013d65..e002d53 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -10,7 +10,7 @@ MAN8_TXT += btrfs-find-root.txt
 MAN8_TXT += btrfs-image.txt
 MAN8_TXT += btrfs-map-logical.txt
 MAN8_TXT += btrfs-show-super.txt
-#MAN8_TXT += btrfstune.txt
+MAN8_TXT += btrfstune.txt
 #MAN8_TXT += btrfs-zero-log.txt
 #MAN8_TXT += fsck.btrfs.txt
 #MAN8_TXT += mkfs.btrfs.txt
diff --git a/Documentation/btrfstune.txt b/Documentation/btrfstune.txt
new file mode 100644
index 0000000..bf4bfce
--- /dev/null
+++ b/Documentation/btrfstune.txt
@@ -0,0 +1,47 @@
+btrfstune(8)
+============
+
+NAME
+----
+btrfstune - tune various btrfs filesystem parameters
+
+SYNOPSIS
+--------
+'btrfstune' [options] <dev> [<dev>...]
+
+DESCRIPTION
+-----------
+'btrfstune' is used to tune various btrfs filesystem parameters,you can
+enable/disable some extended features for btrfs.
+
+OPTIONS
+-------
+-S <value>::
+Updates the seeding value, it forces a fs readonly so that you can use it to
+build other filesystems.
+-r::
+Enable extended inode refs.
+-x::
+Enable skinny metadata extent refs.
+
+
+EXIT STATUS
+-----------
+'btrfstune' will return 0 if no error happened.
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

