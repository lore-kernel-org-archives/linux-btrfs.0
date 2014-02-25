Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59062 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaBYHmi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 02:42:38 -0500
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id B36763EE14C
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 16:42:37 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id A3FCC45DEB5
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 16:42:37 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 8CDEB45DD77
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 16:42:37 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 7AC0A1DB8038
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 16:42:37 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 20F411DB803B
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 16:42:37 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id EB7D3584004
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 16:42:36 +0900 (JST)
Received: from [127.0.0.1] (FMVDA2A041.g01.fujitsu.local [10.124.102.125])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 98892584001
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 16:42:36 +0900 (JST)
Message-ID: <530C4965.5020801@jp.fujitsu.com>
Date: Tue, 25 Feb 2014 16:42:29 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Copyright string update
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix corporate name for copyright.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 btrfs-list.h               |    2 +-
 btrfsck.h                  |    2 +-
 chunk-recover.c            |    2 +-
 man/btrfs-convert.8.in     |    2 +-
 man/btrfs-debug-tree.8.in  |    2 +-
 man/btrfs-find-root.8.in   |    2 +-
 man/btrfs-map-logical.8.in |    2 +-
 man/btrfs-show-super.8.in  |    2 +-
 man/btrfs-zero-log.8.in    |    2 +-
 man/btrfstune.8.in         |    2 +-
 math.h                     |    2 +-
 super-recover.c            |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/btrfs-list.h b/btrfs-list.h
index 724e973..8ead9da 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2012 Fujitsu.  All rights reserved.
+ * Copyright (C) 2012 FUJITSU LIMITED.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
diff --git a/btrfsck.h b/btrfsck.h
index f73c605..356c767 100644
--- a/btrfsck.h
+++ b/btrfsck.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013 Fujitsu.  All rights reserved.
+ * Copyright (C) 2013 FUJITSU LIMITED.  All rights reserved.
  * Written by Miao Xie <miaox@cn.fujitsu.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/chunk-recover.c b/chunk-recover.c
index 69f5854..a05e644 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013 Fujitsu.  All rights reserved.
+ * Copyright (C) 2013 FUJITSU LIMITED.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
diff --git a/man/btrfs-convert.8.in b/man/btrfs-convert.8.in
index 9d4c642..85cfa61 100644
--- a/man/btrfs-convert.8.in
+++ b/man/btrfs-convert.8.in
@@ -24,7 +24,7 @@ If any problems happened, 1 will be returned.
 Written by Shilong Wang and Wenruo Qu.
 
 .SH COPYRIGHT
-Copyright \(co 2013 Fujitsu, Inc.
+Copyright \(co 2013 FUJITSU LIMITED.
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
diff --git a/man/btrfs-debug-tree.8.in b/man/btrfs-debug-tree.8.in
index 9b0420b..eed7097 100644
--- a/man/btrfs-debug-tree.8.in
+++ b/man/btrfs-debug-tree.8.in
@@ -27,7 +27,7 @@ If any problems happened, 1 will be returned.
 Written by Shilong Wang and Wenruo Qu.
 
 .SH COPYRIGHT
-Copyright \(co 2013 Fujitsu, Inc.
+Copyright \(co 2013 FUJITSU LIMITED.
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
diff --git a/man/btrfs-find-root.8.in b/man/btrfs-find-root.8.in
index 398aa41..c1f48a0 100644
--- a/man/btrfs-find-root.8.in
+++ b/man/btrfs-find-root.8.in
@@ -22,7 +22,7 @@ If any problems happened, 1 will be returned.
 Written by Shilong Wang and Wenruo Qu.
 
 .SH COPYRIGHT
-Copyright \(co 2013 Fujitsu, Inc.
+Copyright \(co 2013 FUJITSU LIMITED.
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
diff --git a/man/btrfs-map-logical.8.in b/man/btrfs-map-logical.8.in
index d50ac96..a253051 100644
--- a/man/btrfs-map-logical.8.in
+++ b/man/btrfs-map-logical.8.in
@@ -25,7 +25,7 @@ If any problems happened, 1 will be returned.
 Written by Shilong Wang and Wenruo Qu.
 
 .SH COPYRIGHT
-Copyright \(co 2013 Fujitsu, Inc.
+Copyright \(co 2013 FUJITSU LIMITED.
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
diff --git a/man/btrfs-show-super.8.in b/man/btrfs-show-super.8.in
index ad04a42..3fe8bde 100644
--- a/man/btrfs-show-super.8.in
+++ b/man/btrfs-show-super.8.in
@@ -22,7 +22,7 @@ If any problems happened, 1 will be returned.
 Written by Shilong Wang and Wenruo Qu.
 
 .SH COPYRIGHT
-Copyright \(co 2013 Fujitsu, Inc.
+Copyright \(co 2013 FUJITSU LIMITED.
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
diff --git a/man/btrfs-zero-log.8.in b/man/btrfs-zero-log.8.in
index 80aaa9a..0ccfb0e 100644
--- a/man/btrfs-zero-log.8.in
+++ b/man/btrfs-zero-log.8.in
@@ -15,7 +15,7 @@ Other exit code means some problems happened.
 Written by Shilong Wang and Wenruo Qu.
 
 .SH COPYRIGHT
-Copyright \(co 2013 Fujitsu, Inc.
+Copyright \(co 2013 FUJITSU LIMITED.
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
diff --git a/man/btrfstune.8.in b/man/btrfstune.8.in
index 0313324..c7fff9a 100644
--- a/man/btrfstune.8.in
+++ b/man/btrfstune.8.in
@@ -23,7 +23,7 @@ If any problems happened, 1 will be returned.
 Written by Shilong Wang and Wenruo Qu.
 
 .SH COPYRIGHT
-Copyright \(co 2013 Fujitsu, Inc.
+Copyright \(co 2013 FUJITSU LIMITED.
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
diff --git a/math.h b/math.h
index 482dba3..0c16104 100644
--- a/math.h
+++ b/math.h
@@ -1,6 +1,6 @@
 
 /*
- * Copyright (C) 2012 Fujitsu.  All rights reserved.
+ * Copyright (C) 2012 FUJITSU LIMITED.  All rights reserved.
  * Written by Miao Xie <miaox@cn.fujitsu.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/super-recover.c b/super-recover.c
index a6271a2..cd6ba37 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013 Fujitsu.  All rights reserved.
+ * Copyright (C) 2013 FUJITSU LIMITED.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
-- 
1.7.1

