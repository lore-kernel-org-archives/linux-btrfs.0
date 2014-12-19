Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4599 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015AbaLSGPT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 01:15:19 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBJ6EqaB027655
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:14:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs-progs: Remove deprecated _BSD_SOURCE macro.
Date: Fri, 19 Dec 2014 14:13:12 +0800
Message-ID: <1418969592-21278-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the following gcc(>4.9) and clang warning:

In file included from cmds-receive.c:24:
In file included from ./kerncompat.h:22:
In file included from /usr/include/stdio.h:27:
/usr/include/features.h:148:3: warning: "_BSD_SOURCE and _SVID_SOURCE
are deprecated, use _DEFAULT_SOURCE" [-W#warnings]
  ^
1 warning generated.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-receive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 358df1f..5bc8f8c 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -19,7 +19,7 @@
 #define _GNU_SOURCE
 #define _POSIX_C_SOURCE 200809
 #define _XOPEN_SOURCE 700
-#define _BSD_SOURCE
+#define _DEFAILT_SOURCE
 
 #include "kerncompat.h"
 
-- 
2.1.3

