Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbbBEUbb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Feb 2015 15:31:31 -0500
Message-ID: <54D3D31D.40802@redhat.com>
Date: Thu, 05 Feb 2015 14:31:25 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: allow CFLAGS specification in new build
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Disclaimer: I am not an auto$FOO expert by any means.

But I could find no way to specify additional CFLAGS, and I think
that this is because they are hard-coded in configure.ac.

The below works for me, but I don't know if it's the right solution...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Makefile.in b/Makefile.in
index 93b6a3c..4a36f6a 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -12,6 +12,7 @@ DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
 
 # Non-static compilation flags
 CFLAGS = @CFLAGS@ \
+	 -g -O1 \
 	 -include config.h -Wall \
 	 -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES \
 	 -D_XOPEN_SOURCE=700  \
diff --git a/configure.ac b/configure.ac
index cbad099..f6ebb7d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,8 +8,6 @@ LIBBTRFS_MAJOR=0
 LIBBTRFS_MINOR=1
 LIBBTRFS_PATCHLEVEL=1
 
-CFLAGS="-g -O1"
-
 AC_PREREQ([2.60])
 
 AC_CONFIG_AUX_DIR([config])

