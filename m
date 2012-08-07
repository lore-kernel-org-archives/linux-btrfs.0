Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:23742 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2HGI5q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 04:57:46 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q778viAr003545
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:57:45 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q778vie0024391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:57:44 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q778vhjQ029134
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 03:57:43 -0500
Message-ID: <5020D85C.5020204@oracle.com>
Date: Tue, 07 Aug 2012 16:57:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 1/5] btrfs-progs: make ino_resovle() shared
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <5020D84E.4010900@oracle.com>

 Make ino_resolve() shared so that we can call it at snapshot diff module.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 btrfs-list.c |    3 +--
 btrfs-list.h |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)
 create mode 100644 btrfs-list.h

diff --git a/btrfs-list.c b/btrfs-list.c
index c53d016..75681e1 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -474,8 +474,7 @@ char *build_name(char *dirid, char *name)
  * cache the results so we can avoid tree searches if a later call goes
  * to the same directory or file name
  */
-static char *ino_resolve(int fd, u64 ino, u64 *cache_dirid, char **cache_name)
-
+char *ino_resolve(int fd, u64 ino, u64 *cache_dirid, char **cache_name)
 {
 	u64 dirid;
 	char *dirname;
diff --git a/btrfs-list.h b/btrfs-list.h
new file mode 100644
index 0000000..70b2078
--- /dev/null
+++ b/btrfs-list.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2007 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef __BTRFS_LIST_
+#define __BTRFS_LIST_
+char *ino_resolve(int fd, u64 ino, u64 *cache_dirid, char **cache_name);
+#endif
-- 
1.7.4.1
