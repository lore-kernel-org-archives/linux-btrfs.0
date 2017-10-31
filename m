Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:53012 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751620AbdJaM7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 08:59:52 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-btrfs@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] btrfs-progs: convert: add missing types header
Date: Tue, 31 Oct 2017 14:57:54 +0200
Message-Id: <dda485a3d788c47bb6849218f695db7b51822872.1509454674.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Build with musl libc needs the sys/types.h header for the dev_t type,
since this header is not included indirectly. This fixes the following
build failure:

In file included from convert/source-fs.c:23:0:
./convert/source-fs.h:112:1: error: unknown type name ‘dev_t’
 dev_t decode_dev(u32 dev);
 ^~~~~
convert/source-fs.c:31:1: error: unknown type name ‘dev_t’
 dev_t decode_dev(u32 dev)
 ^~~~~

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 convert/source-fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/convert/source-fs.h b/convert/source-fs.h
index 23f33567b42d..4e5babefe6a2 100644
--- a/convert/source-fs.h
+++ b/convert/source-fs.h
@@ -19,6 +19,7 @@
 
 #include "kerncompat.h"
 #include <linux/kdev_t.h>
+#include <sys/types.h>
 #include <pthread.h>
 
 #define CONV_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
-- 
2.14.2

