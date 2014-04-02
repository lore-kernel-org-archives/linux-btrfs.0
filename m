Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758201AbaDBI3F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:05 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Sm0R014966
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 17/27] btrfs-progs: Convert man page for btrfs-convert.
Date: Wed, 2 Apr 2014 16:29:28 +0800
Message-ID: <1396427378-10487-18-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-convert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile          |  2 +-
 Documentation/btrfs-convert.txt | 49 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-convert.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index b4d8281..b2afc7a 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -4,7 +4,7 @@ MAN8_TXT =
 # Top level commands
 MAN8_TXT += btrfs.txt
 MAN8_TXT += btrfsck.txt
-#MAN8_TXT += btrfs-convert.txt
+MAN8_TXT += btrfs-convert.txt
 #MAN8_TXT += btrfs-debug-tree.txt
 #MAN8_TXT += btrfs-find-root.txt
 #MAN8_TXT += btrfs-image.txt
diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
new file mode 100644
index 0000000..780ca9e
--- /dev/null
+++ b/Documentation/btrfs-convert.txt
@@ -0,0 +1,49 @@
+btrfs-convert(8)
+================
+
+NAME
+----
+btrfs-convert - convert from ext2/3/4 filesystem to btrfs or rollback
+
+SYNOPSIS
+--------
+'btrfs-convert' [options] <device>
+
+DESCRIPTION
+-----------
+'btrfs-convert' is used to convert existed ext2/3/4 to btrfs filesystem,
+and the original filesystem image is accessible as from separate subvolume
+named 'ext2_subvol' as file image.
+
+OPTIONS
+-------
+-d::
+Disable data checksum.
+-i::
+Ignore xattrs and ACLs.
+-n::
+Disable packing of small files.
+-r::
+Roll back to ext2fs.
+
+EXIT STATUS
+-----------
+'btrfs-convert' will return 0 if no error happened.
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
+
-- 
1.9.1

