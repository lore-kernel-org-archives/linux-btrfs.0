Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10372 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751370AbaLSGPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 01:15:16 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBJ6EmcH027637
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:14:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs-progs: Makefile: Move linker only option to LDFLAGS
Date: Fri, 19 Dec 2014 14:13:08 +0800
Message-ID: <1418969592-21278-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move the linker only option -rdynamic to LDFLAGS.
This resolve lots of the following warning if using clang as CC:
clang: warning: argument unused during compilation: '-rdynamic'

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e1b0a88..be0f48b 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,8 @@ CC = gcc
 LN = ln
 AR = ar
 AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fno-strict-aliasing -fPIC
-CFLAGS = -g -O1 -fno-strict-aliasing -rdynamic
+CFLAGS = -g -O1 -fno-strict-aliasing
+LDFLAGS = -rdynamic
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-- 
2.1.3

