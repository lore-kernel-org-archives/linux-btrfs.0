Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:55441 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaEaG0L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 02:26:11 -0400
Received: by mail-yk0-f180.google.com with SMTP id q9so2245081ykb.39
        for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 23:26:10 -0700 (PDT)
From: Augusto Mecking Caringi <augustocaringi@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Augusto Mecking Caringi <augustocaringi@gmail.com>
Subject: [PATCH] Add more detailed package dependency information to INSTALL file
Date: Sat, 31 May 2014 03:24:46 -0300
Message-Id: <1401517486-26769-1-git-send-email-augustocaringi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Augusto Mecking Caringi <augustocaringi@gmail.com>
---
 INSTALL |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/INSTALL b/INSTALL
index 8ead607..9a4ab64 100644
--- a/INSTALL
+++ b/INSTALL
@@ -12,9 +12,16 @@ complete:
 modprobe libcrc32c
 insmod btrfs.ko
 
-The Btrfs utility programs require libuuid to build.  This can be found
-in the e2fsprogs sources, and is usually available as libuuid or
-e2fsprogs-devel from various distros.
+The Btrfs utility programs require the following libraries/tools to build:
+
+- libuuid (This can be found in the e2fsprogs sources, and is usually available
+  as libuuid or e2fsprogs-devel from various distros).
+- libattr (Extended attribute library - Development files)
+- libblkid (Block device id library - Development files)
+- liblzo2 (LZO data compression library - Development files)
+- libacl (Access control list library - Development files)
+- e2fslibs (ext2/ext3/ext4 file system libraries - Development files)
+- asciidoc (Text document format tool - For documentation)
 
 Building the utilities is just make ; make install.  The programs go
 into /usr/local/bin.  The mains commands available are:
-- 
1.7.10.4

