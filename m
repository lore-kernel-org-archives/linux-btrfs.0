Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933280Ab3HNXRV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:21 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHLOs030715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:21 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSl017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:20 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/15] btrfs-progs: remove __CHECKER__ from main code
Date: Wed, 14 Aug 2013 16:16:32 -0700
Message-Id: <1376522205-16992-3-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__CHECKER__ is only for the type juggling used to tell sparse which
types need conversion between address spaces.  It is not OK to use to
change the code that gets checked to avoid bugs elsewhere in the build
infrastructure.  We want to check the code that builds when the checker
isn't enabled.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-convert.c | 2 --
 btrfs-list.c    | 2 --
 cmds-device.c   | 9 ---------
 mkfs.c          | 3 ---
 utils.c         | 7 -------
 5 files changed, 23 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a4608ec..9a7da57 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -21,10 +21,8 @@
 
 #include "kerncompat.h"
 
-#ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
-#endif
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
diff --git a/btrfs-list.c b/btrfs-list.c
index 072a592..214cb45 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -17,11 +17,9 @@
  */
 
 #define _GNU_SOURCE
-#ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
 #include "ioctl.h"
-#endif
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
diff --git a/cmds-device.c b/cmds-device.c
index be2aaff..48ac526 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -30,15 +30,6 @@
 
 #include "commands.h"
 
-/* FIXME - imported cruft, fix sparse errors and warnings */
-#ifdef __CHECKER__
-#define BLKGETSIZE64 0
-#define BTRFS_IOC_SNAP_CREATE_V2 0
-#define BTRFS_VOL_NAME_MAX 255
-struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
-static inline int ioctl(int fd, int define, void *arg) { return 0; }
-#endif
-
 static const char * const device_cmd_group_usage[] = {
 	"btrfs device <command> [<args>]",
 	NULL
diff --git a/mkfs.c b/mkfs.c
index 8183879..5724dec 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -21,12 +21,9 @@
 
 #include "kerncompat.h"
 
-#ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
 #include "ioctl.h"
-#endif
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
diff --git a/utils.c b/utils.c
index 86ee948..e0417cb 100644
--- a/utils.c
+++ b/utils.c
@@ -24,10 +24,8 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
-#endif
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <uuid/uuid.h>
@@ -50,11 +48,6 @@
 #include "volumes.h"
 #include "ioctl.h"
 
-#ifdef __CHECKER__
-#define BLKGETSIZE64 0
-static inline int ioctl(int fd, int define, u64 *size) { return 0; }
-#endif
-
 #ifndef BLKDISCARD
 #define BLKDISCARD	_IO(0x12,119)
 #endif
-- 
1.7.11.7

