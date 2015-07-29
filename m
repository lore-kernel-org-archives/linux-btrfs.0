Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37130 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbG2Shm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 14:37:42 -0400
Received: by wibud3 with SMTP id ud3so38260963wib.0
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2015 11:37:41 -0700 (PDT)
From: Brendan Heading <brendanheading@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Brendan Heading <brendanheading@gmail.com>
Subject: [PATCH 1/1] btrfs-progs: compilation errors when using musl libc
Date: Wed, 29 Jul 2015 19:37:37 +0100
Message-Id: <1438195057-9400-1-git-send-email-brendanheading@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- limits.h must be included to pick up PATH_MAX.
- remove double declaration of BTRFS_DISABLE_BACKTRACE

kerncompat.h assumed that if __GLIBC__ was not defined,
it could safely define BTRFS_DISABLE_BACKTRACE, however this can be
defined by the configure script. Added a check to ensure it is not
defined first.

Signed-off-by: Brendan Heading <brendanheading@gmail.com>
---
 cmds-inspect.c | 1 +
 cmds-receive.c | 1 +
 cmds-scrub.c   | 1 +
 cmds-send.c    | 1 +
 kerncompat.h   | 2 ++
 5 files changed, 6 insertions(+)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 71451fe..9712581 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -20,6 +20,7 @@
 #include <stdint.h>
 #include <sys/ioctl.h>
 #include <errno.h>
+#include <limits.h>
 
 #include "kerncompat.h"
 #include "ioctl.h"
diff --git a/cmds-receive.c b/cmds-receive.c
index 071bea9..d4b3103 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -28,6 +28,7 @@
 #include <wait.h>
 #include <assert.h>
 #include <getopt.h>
+#include <limits.h>
 
 #include <sys/stat.h>
 #include <sys/types.h>
diff --git a/cmds-scrub.c b/cmds-scrub.c
index b7aa809..5a85dc4 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -34,6 +34,7 @@
 #include <ctype.h>
 #include <signal.h>
 #include <stdarg.h>
+#include <limits.h>
 
 #include "ctree.h"
 #include "ioctl.h"
diff --git a/cmds-send.c b/cmds-send.c
index 20bba18..a0b7f95 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -33,6 +33,7 @@
 #include <assert.h>
 #include <getopt.h>
 #include <uuid/uuid.h>
+#include <limits.h>
 
 #include "ctree.h"
 #include "ioctl.h"
diff --git a/kerncompat.h b/kerncompat.h
index 5d92856..7c627ba 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -33,7 +33,9 @@
 #include <features.h>
 
 #ifndef __GLIBC__
+#ifndef BTRFS_DISABLE_BACKTRACE
 #define BTRFS_DISABLE_BACKTRACE
+#endif
 #define __always_inline __inline __attribute__ ((__always_inline__))
 #endif
 
-- 
2.4.3

