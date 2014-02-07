Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:34241 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaBGPVN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 10:21:13 -0500
Received: by mail-qa0-f51.google.com with SMTP id f11so5363997qae.38
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 07:21:12 -0800 (PST)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] btrfs-progs: Change BUG() to use assert.
Date: Fri,  7 Feb 2014 09:21:00 -0600
Message-Id: <1391786460-19571-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the definition of BUG() to use assert instead of abort to
provide information about the location of the issue.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 kerncompat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kerncompat.h b/kerncompat.h
index 1fc2b34..f370cd8 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -50,7 +50,7 @@
 #define ULONG_MAX       (~0UL)
 #endif
 
-#define BUG() abort()
+#define BUG() assert(0)
 #ifdef __CHECKER__
 #define __force    __attribute__((force))
 #define __bitwise__ __attribute__((bitwise))
-- 
1.8.3.2

