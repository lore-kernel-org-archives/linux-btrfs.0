Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56908 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933689AbcJXI3v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 04:29:51 -0400
From: slyich@gmail.com
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH] ioctl.h: add missing kernel compatibility header for BUILD_ASSERT
Date: Mon, 24 Oct 2016 09:29:12 +0100
Message-Id: <20161024082912.20253-1-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Header breakage noticed by cynede. Reproducible as:

    $ gcc -c /usr/include/btrfs/ioctl.h -o /tmp/a.o
        /usr/include/btrfs/ioctl.h:42:14: error: expected declaration specifiers or '...' before 'sizeof'
     BUILD_ASSERT(sizeof(struct btrfs_ioctl_vol_args) == 4096);
                  ^~~~~~

Basically gcc tries to say us BUILD_ASSERT is not visible.

BUILD_ASSERT lives in kerncompat.h which this change adds.

Reported-by: Mikhail Pukhlikov <cynede@gentoo.org>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 ioctl.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index 238e7ef..ee650a9 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -26,6 +26,12 @@ extern "C" {
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
+#if BTRFS_FLAT_INCLUDES
+#include "kerncompat.h"
+#else
+#include <btrfs/kerncompat.h>
+#endif /* BTRFS_FLAT_INCLUDES */
+
 #ifndef __user
 #define __user
 #endif
-- 
2.10.1

