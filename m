Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:31900 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2HGI6A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 04:58:00 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q778vw45008525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:57:59 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q778vwwq007849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:57:58 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q778vvSb029261
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 03:57:57 -0500
Message-ID: <5020D86A.6080502@oracle.com>
Date: Tue, 07 Aug 2012 16:57:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 2/5] btrfs-progs:  header file of snapshot diff
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <5020D84E.4010900@oracle.com>

Maybe it's better to put those #defines to the source file of snapshot diff as no other modules
need them.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 diff-snapshot.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)
 create mode 100644 diff-snapshot.h

diff --git a/diff-snapshot.h b/diff-snapshot.h
new file mode 100644
index 0000000..0ba09da
--- /dev/null
+++ b/diff-snapshot.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2012 Oracle.  All rights reserved.
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
+#ifndef __SNAPSHOT_DIFF_
+#define __SNAPSHOT_DIFF_
+
+#define SNAPSHOT_DIFF_LIST_NEW_ITEM	(1 << 0)
+#define SNAPSHOT_DIFF_LIST_REMOVED_ITEM	(1 << 1)
+#define SNAPSHOT_DIFF_LIST_UPDATED_ITEM	(1 << 2)
+#define SNAPSHOT_DIFF_LIST_ALL		(1 << 3)
+
+#define SNAPSHOT_DIFF_SHOW_NEW_ITEM(flags)		\
+	((flags & SNAPSHOT_DIFF_LIST_NEW_ITEM) ||		\
+	 (flags & SNAPSHOT_DIFF_LIST_ALL))
+
+#define SNAPSHOT_DIFF_SHOW_REMOVED_ITEM(flags)		\
+	((flags & SNAPSHOT_DIFF_LIST_REMOVED_ITEM) ||	\
+	 (flags & SNAPSHOT_DIFF_LIST_ALL))
+
+#define SNAPSHOT_DIFF_SHOW_UPDATED_ITEM(flags)		\
+	((flags & SNAPSHOT_DIFF_LIST_UPDATED_ITEM) ||	\
+	 (flags & SNAPSHOT_DIFF_LIST_ALL))
+
+enum {
+	SNAPSHOT_DIFF_NEW_ITEM = 0,
+	SNAPSHOT_DIFF_REMOVED_ITEM,
+	SNAPSHOT_DIFF_UPDATED_ITEM,
+};
+
+int snapshot_diff(int src_fd, int dst_fd, const char *src_snapshot,
+		  const char *dest_snapshot, unsigned int diff_flags);
+#endif
-- 
1.7.4.1
