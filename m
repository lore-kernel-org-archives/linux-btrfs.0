Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51682 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2ITV1C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 17:27:02 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Thu, 20 Sep 2012 17:27:01 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q8KLQwTV108252
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 17:26:58 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q8KLQwAQ019671
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 17:26:58 -0400
From: clinew@linux.vnet.ibm.com
To: linux-btrfs@vger.kernel.org
Cc: cmm@linux.vnet.ibm.com, Wade Cline <clinew@linux.vnet.ibm.com>
Subject: [PATCH] Btrfs-progs: Fix compiler warnings on PPC64
Date: Thu, 20 Sep 2012 14:26:28 -0700
Message-Id: <1348176388-3524-1-git-send-email-clinew@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wade Cline <clinew@linux.vnet.ibm.com>

The kernel uses unsigned long long for u64, but PPC64 uses unsigned
long by default. This results in compilation warnings such as:

print-tree.c:333: warning: format '%llu' expects type 'long long
unsigned int', but argument 4 has type 'u64'

To fix this, the macro __KERNEL__ needs to be defined before including
the file <asm/types.h>. This can be done by defining the macro in
"kerncompat.h" and making it the first included file in the relevant
header files; this fixes the compiler warnings on PPC64.

Signed-off-by: Wade Cline <clinew@linux.vnet.ibm.com>
---
 cmds-receive.c |    2 ++
 cmds-scrub.c   |    2 ++
 cmds-send.c    |    2 ++
 convert.c      |    5 ++++-
 kerncompat.h   |   12 ++++++++++++
 mkfs.c         |    3 ++-
 restore.c      |    5 ++++-
 7 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..a21c037 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -21,6 +21,8 @@
 #define _XOPEN_SOURCE 700
 #define _BSD_SOURCE
 
+#include "kerncompat.h"
+
 #include <unistd.h>
 #include <stdint.h>
 #include <dirent.h>
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 24be20f..e29db27 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include "kerncompat.h"
+
 #include <sys/ioctl.h>
 #include <sys/wait.h>
 #include <sys/stat.h>
diff --git a/cmds-send.c b/cmds-send.c
index 41ea523..9da2af4 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -18,6 +18,8 @@
 
 #define _GNU_SOURCE
 
+#include "kerncompat.h"
+
 #include <unistd.h>
 #include <stdint.h>
 #include <dirent.h>
diff --git a/convert.c b/convert.c
index fa7bf8c..1de2a44 100644
--- a/convert.c
+++ b/convert.c
@@ -18,6 +18,9 @@
 
 #define _XOPEN_SOURCE 600
 #define _GNU_SOURCE 1
+
+#include "kerncompat.h"
+
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
@@ -31,7 +34,7 @@
 #include <unistd.h>
 #include <uuid/uuid.h>
 #include <linux/fs.h>
-#include "kerncompat.h"
+
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"
diff --git a/kerncompat.h b/kerncompat.h
index 46236cd..d60f722 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -18,6 +18,7 @@
 
 #ifndef __KERNCOMPAT
 #define __KERNCOMPAT
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <errno.h>
@@ -57,11 +58,22 @@
 #endif
 
 #ifndef __CHECKER__
+/*
+ * Since we're using primitive definitions from kernel-space, we need to
+ * define __KERNEL__ so that system header files know which definitions
+ * to use.
+ */
+#define __KERNEL__
 #include <asm/types.h>
 typedef __u32 u32;
 typedef __u64 u64;
 typedef __u16 u16;
 typedef __u8 u8;
+/*
+ * Continuing to define __KERNEL__ breaks others parts of the code, so
+ * we can just undefine it now that we have the correct headers...
+ */
+#undef __KERNEL__
 #else
 typedef unsigned int u32;
 typedef unsigned int __u32;
diff --git a/mkfs.c b/mkfs.c
index dff5eb8..c3d5cf7 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -19,6 +19,8 @@
 #define _XOPEN_SOURCE 500
 #define _GNU_SOURCE
 
+#include "kerncompat.h"
+
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
@@ -37,7 +39,6 @@
 #include <linux/fs.h>
 #include <ctype.h>
 #include <attr/xattr.h>
-#include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"
diff --git a/restore.c b/restore.c
index d1ac542..248c473 100644
--- a/restore.c
+++ b/restore.c
@@ -18,6 +18,9 @@
 
 #define _XOPEN_SOURCE 500
 #define _GNU_SOURCE 1
+
+#include "kerncompat.h"
+
 #include <ctype.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -25,7 +28,7 @@
 #include <fcntl.h>
 #include <sys/stat.h>
 #include <zlib.h>
-#include "kerncompat.h"
+
 #include "ctree.h"
 #include "disk-io.h"
 #include "print-tree.h"
-- 
1.7.8.6

