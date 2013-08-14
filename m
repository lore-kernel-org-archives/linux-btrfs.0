Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933427Ab3HNXRZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:25 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHNNZ015159
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:24 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSw017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:23 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/15] btrfs-progs: don't use <linux/fs.h>
Date: Wed, 14 Aug 2013 16:16:43 -0700
Message-Id: <1376522205-16992-14-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sparse can freak out when <linux/fs.h> is included because it redefines
approximately a gazillion symbols already found in <sys/mount.h>:

/usr/include/linux/fs.h:203:9: warning: preprocessor token MS_RDONLY redefined
/usr/include/sys/mount.h:37:9: this was the original definition

Happily, we don't actually need to include the low-level <linux/fs.h>
for anything.  One assumes it was just carried over from kernel space.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-convert.c | 1 -
 mkfs.c          | 1 -
 2 files changed, 2 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 828f361..a1fb645 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -31,7 +31,6 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
-#include <linux/fs.h>
 
 #include "ctree.h"
 #include "disk-io.h"
diff --git a/mkfs.c b/mkfs.c
index 5724dec..8e38db7 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -33,7 +33,6 @@
 #include <unistd.h>
 #include <getopt.h>
 #include <uuid/uuid.h>
-#include <linux/fs.h>
 #include <ctype.h>
 #include <attr/xattr.h>
 #include <blkid/blkid.h>
-- 
1.7.11.7

