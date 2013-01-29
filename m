Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:42343 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3A2GGt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:06:49 -0500
Received: by mail-oa0-f73.google.com with SMTP id n12so15826oag.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 22:06:48 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 2/3] Add support for Btrfs ioctls: infrastructure to decode ioctl structs
Date: Mon, 28 Jan 2013 22:06:37 -0800
Message-Id: <1359439598-4141-3-git-send-email-filbranden@google.com>
In-Reply-To: <1359439598-4141-1-git-send-email-filbranden@google.com>
References: <1359439598-4141-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a new btrfs_ioctl() function that can be used to decode Btrfs structs
from Btrfs-specific ioctls. It adds a new case to ioctl_decode() to handle
Btrfs ioctls.

This adds autoconf detection of header file linux/btrfs.h so that the code can
be disabled when the header is not present.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 Makefile.am  |  2 +-
 btrfs.c      | 39 +++++++++++++++++++++++++++++++++++++++
 configure.ac |  1 +
 defs.h       |  1 +
 ioctl.c      |  2 ++
 5 files changed, 44 insertions(+), 1 deletion(-)
 create mode 100644 btrfs.c

diff --git a/Makefile.am b/Makefile.am
index aa1a5f4..fe809b8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -18,7 +18,7 @@ strace_SOURCES = strace.c syscall.c count.c util.c desc.c file.c ipc.c \
 		 io.c ioctl.c mem.c net.c process.c bjm.c quota.c \
 		 resource.c signal.c sock.c system.c term.c time.c \
 		 scsi.c stream.c block.c pathtrace.c mtd.c vsprintf.c \
-		 loop.c
+		 loop.c btrfs.c
 noinst_HEADERS = defs.h
 
 EXTRA_DIST = $(man_MANS) errnoent.sh signalent.sh syscallent.sh ioctlsort.c \
diff --git a/btrfs.c b/btrfs.c
new file mode 100644
index 0000000..a4895e4
--- /dev/null
+++ b/btrfs.c
@@ -0,0 +1,39 @@
+/*
+ * Copyright (c) 2013 Filipe Brandenburger <filbranden@google.com>
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
+ * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include "defs.h"
+#include <sys/ioctl.h>
+
+#ifdef HAVE_LINUX_BTRFS_H
+#include <linux/btrfs.h>
+#endif /* HAVE_LINUX_BTRFS_H */
+
+int
+btrfs_ioctl(struct tcb *tcp, long code, long arg)
+{
+	return 0;
+}
diff --git a/configure.ac b/configure.ac
index f44eaf1..9021fe1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -222,6 +222,7 @@ AC_CHECK_HEADERS([asm/sigcontext.h], [], [], [#include <signal.h>])
 AC_CHECK_TYPES([struct sigcontext_struct,
 		struct sigcontext],,, [#include <signal.h>])
 AC_CHECK_HEADERS([netinet/tcp.h netinet/udp.h],,, [#include <netinet/in.h>])
+AC_CHECK_HEADERS([linux/btrfs.h])
 
 AC_CHECK_MEMBERS([struct msghdr.msg_control],,, [#include <sys/socket.h>])
 
diff --git a/defs.h b/defs.h
index 0e05c6e..9270786 100644
--- a/defs.h
+++ b/defs.h
@@ -631,6 +631,7 @@ extern int scsi_ioctl(struct tcb *, long, long);
 extern int block_ioctl(struct tcb *, long, long);
 extern int mtd_ioctl(struct tcb *, long, long);
 extern int loop_ioctl(struct tcb *, long, long);
+extern int btrfs_ioctl(struct tcb *, long, long);
 
 extern int tv_nz(struct timeval *);
 extern int tv_cmp(struct timeval *, struct timeval *);
diff --git a/ioctl.c b/ioctl.c
index 323946d..6c39fc0 100644
--- a/ioctl.c
+++ b/ioctl.c
@@ -92,6 +92,8 @@ ioctl_decode(struct tcb *tcp, long code, long arg)
 		return loop_ioctl(tcp, code, arg);
 	case 'M':
 		return mtd_ioctl(tcp, code, arg);
+	case 0x94:
+		return btrfs_ioctl(tcp, code, arg);
 	default:
 		break;
 	}
-- 
1.7.11.7

