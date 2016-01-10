Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33650 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbcAJDEc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 22:04:32 -0500
Received: by mail-pa0-f52.google.com with SMTP id cy9so303298120pac.0
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jan 2016 19:04:32 -0800 (PST)
From: Khem Raj <raj.khem@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] btrfs-corrupt-blocks: Include limits.h
Date: Sat,  9 Jan 2016 19:04:23 -0800
Message-Id: <1452395063-8414-1-git-send-email-raj.khem@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

limits.h is needed for PATH_MAX definition

Fixes
| btrfs-corrupt-block.c: In function 'corrupt_dir_item':
| btrfs-corrupt-block.c:478:12: error: 'PATH_MAX' undeclared (first use in this function)
|   char name[PATH_MAX];

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 btrfs-corrupt-block.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 0b26903..c908b7e 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -21,6 +21,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <getopt.h>
+#include <limits.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
-- 
2.7.0

