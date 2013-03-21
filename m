Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:39636 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3CUHS1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 03:18:27 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Thu, 21 Mar 2013 01:18:26 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] btrfs-progs: fix one bracket issue in mkfs.btrfs manpage
Date: Thu, 21 Mar 2013 15:17:17 +0800
Message-Id: <1363850237-21276-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  In "[ \fB\-f\fP\fI ]", the "\fI" will result in the front half "["of
"[ -f ]" doesn't the back half "]"; When you issue the command
"man mkfs.btrfs", you will see the difference.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 man/mkfs.btrfs.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index cdccd6a..a3f1503 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -6,7 +6,7 @@ mkfs.btrfs \- create a btrfs filesystem
 [ \fB\-A\fP\fI alloc-start\fP ]
 [ \fB\-b\fP\fI byte-count\fP ]
 [ \fB\-d\fP\fI data-profile\fP ]
-[ \fB\-f\fP\fI ]
+[ \fB\-f\fP ]
 [ \fB\-l\fP\fI leafsize\fP ]
 [ \fB\-L\fP\fI label\fP ]
 [ \fB\-m\fP\fI metadata profile\fP ]
-- 
1.7.11.7

