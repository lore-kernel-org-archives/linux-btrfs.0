Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:55766 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbaEaBGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 21:06:16 -0400
Received: by mail-yk0-f169.google.com with SMTP id 200so2163803ykr.28
        for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 18:06:15 -0700 (PDT)
From: Augusto Mecking Caringi <augustocaringi@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Augusto Mecking Caringi <augustocaringi@gmail.com>
Subject: [PATCH] Add information about libblkid requirement to INSTALL file
Date: Fri, 30 May 2014 22:05:10 -0300
Message-Id: <1401498310-9176-1-git-send-email-augustocaringi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 INSTALL |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/INSTALL b/INSTALL
index 8ead607..2f15e5e 100644
--- a/INSTALL
+++ b/INSTALL
@@ -16,6 +16,9 @@ The Btrfs utility programs require libuuid to build.  This can be found
 in the e2fsprogs sources, and is usually available as libuuid or
 e2fsprogs-devel from various distros.
 
+The Btrfs utility programs also require libblkid (block device identification
+library). This library is usually available as libblkid-dev or libblkid-devel.
+
 Building the utilities is just make ; make install.  The programs go
 into /usr/local/bin.  The mains commands available are:
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
