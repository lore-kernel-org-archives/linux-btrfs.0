Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab2KOWYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 17:24:47 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qAFMOlbb014136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2012 17:24:47 -0500
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qAFMOksQ016013
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2012 17:24:46 -0500
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix 32bit int/pointer cast warnings
Date: Thu, 15 Nov 2012 14:24:03 -0800
Message-Id: <1353018243-25896-1-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This uses uintptr_t to cast pointers to u64 ioctl arguments to silence
some 32bit build warnings:

cmds-inspect.c: In function ‘__ino_to_path_fd’:
cmds-inspect.c:47:15: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
cmds-inspect.c: In function ‘cmd_logical_resolve’:
cmds-inspect.c:171:15: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-inspect.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index edabff5..25b83d2 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -17,6 +17,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <stdint.h>
 #include <sys/ioctl.h>
 #include <errno.h>
 
@@ -44,7 +45,7 @@ static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 
 	ipa.inum = inum;
 	ipa.size = 4096;
-	ipa.fspath = (u64)fspath;
+	ipa.fspath = (uintptr_t)fspath;
 
 	ret = ioctl(fd, BTRFS_IOC_INO_PATHS, &ipa);
 	if (ret) {
@@ -168,7 +169,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 
 	loi.logical = atoll(argv[optind]);
 	loi.size = size;
-	loi.inodes = (u64)inodes;
+	loi.inodes = (uintptr_t)inodes;
 
 	fd = open_file_or_dir(argv[optind+1]);
 	if (fd < 0) {
-- 
1.7.11.4

