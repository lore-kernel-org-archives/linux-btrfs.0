Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37320 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3DZVGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:14 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/9] Btrfs-progs: remove dead btrfs-defrag.c
Date: Fri, 26 Apr 2013 16:06:02 -0500
Message-Id: <1367010370-21571-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Files with only #include directives are boring. :)

This is just a leftover after the move to the btrfs tool.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 btrfs-defrag.c |   39 ---------------------------------------
 1 files changed, 0 insertions(+), 39 deletions(-)
 delete mode 100644 btrfs-defrag.c

diff --git a/btrfs-defrag.c b/btrfs-defrag.c
deleted file mode 100644
index 8f1525a..0000000
--- a/btrfs-defrag.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Copyright (C) 2010 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef __CHECKER__
-#include <sys/ioctl.h>
-#include <sys/mount.h>
-#include "ioctl.h"
-#endif
-#include <stdio.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <ctype.h>
-#include <unistd.h>
-#include <dirent.h>
-#include <libgen.h>
-#include <getopt.h>
-#include "kerncompat.h"
-#include "ctree.h"
-#include "transaction.h"
-#include "utils.h"
-#include "version.h"
-
-- 
1.7.1

