Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758056AbaDBI3H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:07 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SqXC014979
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 20/27] btrfs-progs: Convert man page for btrfs-image.
Date: Wed, 2 Apr 2014 16:29:31 +0800
Message-ID: <1396427378-10487-21-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-image.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile        |  2 +-
 Documentation/btrfs-image.txt | 70 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-image.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 7a38df9..6954a51 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -7,7 +7,7 @@ MAN8_TXT += btrfsck.txt
 MAN8_TXT += btrfs-convert.txt
 MAN8_TXT += btrfs-debug-tree.txt
 MAN8_TXT += btrfs-find-root.txt
-#MAN8_TXT += btrfs-image.txt
+MAN8_TXT += btrfs-image.txt
 #MAN8_TXT += btrfs-map-logical.txt
 #MAN8_TXT += btrfs-show-super.txt
 #MAN8_TXT += btrfstune.txt
diff --git a/Documentation/btrfs-image.txt b/Documentation/btrfs-image.txt
new file mode 100644
index 0000000..bd74a86
--- /dev/null
+++ b/Documentation/btrfs-image.txt
@@ -0,0 +1,70 @@
+btrfs-image(8)
+==============
+
+NAME
+----
+btrfs-image - create/restore an image of the filesystem
+
+SYNOPSIS
+--------
+'btrfs-image' [options] <source> <target>
+
+DESCRIPTION
+-----------
+'btrfs-image' is used to create an image of a btrfs filesystem.
+All data will be zeroed, but metadata and the like is preserved.
+
+Mainly used for debug purpose.
+
+OPTIONS
+-------
+-r::
+Restore metadump image. By default, this fixes super's chunk tree, by
+using 1 stripe pointing to primary device, so that file system can be
+restored by running tree log reply if possible. To restore without
+changing number of stripes in chunk tree check -o option.
+
+-c value::
+Compression level (0 ~ 9).
+
+-t value::
+Number of threads (1 ~ 32) to be used to process the image dump or restore.
+
+-o::
+Use the old restore method, this does not fixup the chunk tree so the restored
+file system will not be able to be mounted.
+
+-s::
+Sanitize the file names when generating the image. One -s means just
+generate random garbage, which means that the directory indexes won't match up
+since the hashes won't match with the garbage filenames. Using -ss will
+calculate a collision for the filename so that the hashes match, and if it
+can't calculate a collision then it will just generate garbage.  The collision
+calculator is very time and CPU intensive so only use it if you are having
+problems with your file system tree and need to have it mostly working.
+
+-w::
+Walk all the trees manually and copy any blocks that are referenced. Use this
+option if your extent tree is corrupted to make sure that all of the metadata is
+captured.
+
+EXIT STATUS
+-----------
+'btrfs-image' will return 0 if no error happened.
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

