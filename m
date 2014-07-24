Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41603 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753215AbaGXJf6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 05:35:58 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O9ZYK4006084
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 17:35:34 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: remove author and copyright info from man page
Date: Thu, 24 Jul 2014 17:30:15 +0800
Message-ID: <1406194215-7774-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From:
http://man7.org/linux/man-pages/man7/man-pages.7.html
...
AUTHORS lists authors of the documentation or program.Use of
an AUTHORS section is strongly discouraged. Generally,
it is better not to clutter every page with a list of
(over time potentially numerous) authors; if you write
or significantly amend a page, add a copyright notice
as a comment in the source file.  If you are the author
of a device driver and want to include an address for
reporting bugs, place this under the BUGS section.
...

Suggested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-convert.txt     | 12 ------------
 Documentation/btrfs-debug-tree.txt  | 12 ------------
 Documentation/btrfs-find-root.txt   | 12 ------------
 Documentation/btrfs-image.txt       | 12 ------------
 Documentation/btrfs-map-logical.txt | 12 ------------
 Documentation/btrfs-show-super.txt  | 12 ------------
 Documentation/btrfs-zero-log.txt    | 12 ------------
 Documentation/btrfstune.txt         | 12 ------------
 8 files changed, 96 deletions(-)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index 1eff0bf..11d6044 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -31,18 +31,6 @@ EXIT STATUS
 *btrfs-convert* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
-AUTHOR
-------
-Written by Shilong Wang and Wenruo Qu.
-
-COPYRIGHT
----------
-Copyright (C) 2013 FUJITSU LIMITED.
-
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
-
-This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
-
 SEE ALSO
 --------
 `mkfs.btrfs`(8)
diff --git a/Documentation/btrfs-debug-tree.txt b/Documentation/btrfs-debug-tree.txt
index bfc8aa4..23fc115 100644
--- a/Documentation/btrfs-debug-tree.txt
+++ b/Documentation/btrfs-debug-tree.txt
@@ -33,18 +33,6 @@ EXIT STATUS
 *btrfs-debug-tree* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
-AUTHOR
-------
-Written by Shilong Wang and Wenruo Qu.
-
-COPYRIGHT
----------
-Copyright (C) 2013 FUJITSU LIMITED.
-
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
-
-This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
-
 SEE ALSO
 --------
 `mkfs.btrfs`(8)
diff --git a/Documentation/btrfs-find-root.txt b/Documentation/btrfs-find-root.txt
index a360f8f..c934b4c 100644
--- a/Documentation/btrfs-find-root.txt
+++ b/Documentation/btrfs-find-root.txt
@@ -28,18 +28,6 @@ EXIT STATUS
 *btrfs-find-root* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
-AUTHOR
-------
-Written by Shilong Wang and Wenruo Qu.
-
-COPYRIGHT
----------
-Copyright (C) 2013 FUJITSU LIMITED.
-
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
-
-This is free software: you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.
-
 SEE ALSO
 --------
 `mkfs.btrfs`(8)
diff --git a/Documentation/btrfs-image.txt b/Documentation/btrfs-image.txt
index 155194a..b7751f9 100644
--- a/Documentation/btrfs-image.txt
+++ b/Documentation/btrfs-image.txt
@@ -56,18 +56,6 @@ EXIT STATUS
 *btrfs-image* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
-AUTHOR
-------
-Written by Shilong Wang and Wenruo Qu.
-
-COPYRIGHT
----------
-Copyright (C) 2013 FUJITSU LIMITED.
-
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
-
-This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
-
 SEE ALSO
 --------
 `mkfs.btrfs`(8)
diff --git a/Documentation/btrfs-map-logical.txt b/Documentation/btrfs-map-logical.txt
index a8710bf..a3d110c 100644
--- a/Documentation/btrfs-map-logical.txt
+++ b/Documentation/btrfs-map-logical.txt
@@ -32,18 +32,6 @@ EXIT STATUS
 *btrfs-map-logical* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
-AUTHOR
-------
-Written by Shilong Wang and Wenruo Qu.
-
-COPYRIGHT
----------
-Copyright (C) 2013 FUJITSU LIMITED.
-
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
-
-This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
-
 SEE ALSO
 --------
 `mkfs.btrfs`(8)
diff --git a/Documentation/btrfs-show-super.txt b/Documentation/btrfs-show-super.txt
index 6fee0f1..1646be3 100644
--- a/Documentation/btrfs-show-super.txt
+++ b/Documentation/btrfs-show-super.txt
@@ -45,18 +45,6 @@ EXIT STATUS
 *btrfs-show-super* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
-AUTHOR
-------
-Written by Shilong Wang and Wenruo Qu.
-
-COPYRIGHT
----------
-Copyright (C) 2013 FUJITSU LIMITED.
-
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
-
-This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
-
 SEE ALSO
 --------
 `mkfs.btrfs`(8)
diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-zero-log.txt
index 0a8d3e3..498ecd6 100644
--- a/Documentation/btrfs-zero-log.txt
+++ b/Documentation/btrfs-zero-log.txt
@@ -40,18 +40,6 @@ EXIT STATUS
 *btrfs-zero-log* will return 0 if no error happened.
 Other exit code means some problems happened.
 
-AUTHOR
-------
-Written by Shilong Wang and Wenruo Qu.
-
-COPYRIGHT
----------
-Copyright (C) 2013 FUJITSU LIMITED.
-
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
-
-This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
-
 SEE ALSO
 --------
 `mkfs.btrfs`(8)
diff --git a/Documentation/btrfstune.txt b/Documentation/btrfstune.txt
index bf44bdf..56cf66b 100644
--- a/Documentation/btrfstune.txt
+++ b/Documentation/btrfstune.txt
@@ -31,18 +31,6 @@ EXIT STATUS
 *btrfstune* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
-AUTHOR
-------
-Written by Shilong Wang and Wenruo Qu.
-
-COPYRIGHT
----------
-Copyright (C) 2013 FUJITSU LIMITED.
-
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
-
-This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
-
 SEE ALSO
 --------
 `mkfs.btrfs`(8)
-- 
1.9.0

