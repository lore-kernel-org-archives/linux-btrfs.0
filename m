Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56028 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2ILXWI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 19:22:08 -0400
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Wed, 12 Sep 2012 19:22:04 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 8AC4B38C8039
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 19:22:02 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q8CNM2ke144954
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 19:22:02 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q8CNM1R4011598
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 20:22:02 -0300
From: clinew@linux.vnet.ibm.com
To: linux-btrfs@vger.kernel.org
Cc: cmm@linux.vnet.ibm.com, Wade Cline <clinew@linux.vnet.ibm.com>
Subject: [RFC][PATCH] Btrfs-progs: Fix compiler warnings on PPC64.
Date: Wed, 12 Sep 2012 16:21:56 -0700
Message-Id: <1347492116-16317-1-git-send-email-clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wade Cline <clinew@linux.vnet.ibm.com>

The kernel uses unsigned long long for u64, but PPC64 uses unsigned
long by default. This results in print warnings such as:

print-tree.c:333: warning: format ‘%llu’ expects type ‘long long
unsigned int’, but argument 4 has type ‘u64’

Defining __KERNEL__ before the file <asm/types.h>, or any file that
includes this file, will let PPC64 know to use unsigned long long
for u64 instead. This patch adds the defines and fixes the print
warnings on PPC64.

Signed-off-by: Wade Cline <clinew@linux.vnet.ibm.com>
---
 cmds-receive.c |    1 +
 cmds-scrub.c   |    2 ++
 convert.c      |    1 +
 kerncompat.h   |    6 ++++++
 mkfs.c         |    1 +
 5 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..6cb51fe 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -20,6 +20,7 @@
 #define _POSIX_C_SOURCE 200809
 #define _XOPEN_SOURCE 700
 #define _BSD_SOURCE
+#define __KERNEL__
 
 #include <unistd.h>
 #include <stdint.h>
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 24be20f..7f6aa68 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define __KERNEL__
+
 #include <sys/ioctl.h>
 #include <sys/wait.h>
 #include <sys/stat.h>
diff --git a/convert.c b/convert.c
index fa7bf8c..74ffceb 100644
--- a/convert.c
+++ b/convert.c
@@ -18,6 +18,7 @@
 
 #define _XOPEN_SOURCE 600
 #define _GNU_SOURCE 1
+#define __KERNEL__
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
diff --git a/kerncompat.h b/kerncompat.h
index 46236cd..2e571b8 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -57,11 +57,17 @@
 #endif
 
 #ifndef __CHECKER__
+/*
+ * PPC64 uses unsigned long for u64 while the kernel uses unsigned long long;
+ * Specifying this will let PPC64 know to use unsigned long long instead.
+ */
+#define __KERNEL__
 #include <asm/types.h>
 typedef __u32 u32;
 typedef __u64 u64;
 typedef __u16 u16;
 typedef __u8 u8;
+#undef __KERNEL__
 #else
 typedef unsigned int u32;
 typedef unsigned int __u32;
diff --git a/mkfs.c b/mkfs.c
index dff5eb8..1c88804 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -18,6 +18,7 @@
 
 #define _XOPEN_SOURCE 500
 #define _GNU_SOURCE
+#define __KERNEL__
 
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
-- 
1.7.1

