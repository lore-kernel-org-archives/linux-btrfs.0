Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbaKSNmC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 08:42:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 088D9AC32
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 13:42:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: use system attr instead of attr library
Date: Wed, 19 Nov 2014 14:42:00 +0100
Message-Id: <1416404520-30045-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use the attr version provided by system in other places already,
now we can remove dependency on the separate attr library.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 props.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/props.c b/props.c
index 9fd612f97026..c7c67529fd79 100644
--- a/props.c
+++ b/props.c
@@ -17,7 +17,7 @@
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
-#include <attr/xattr.h>
+#include <sys/xattr.h>
 #include <fcntl.h>
 #include <unistd.h>
 
@@ -29,6 +29,12 @@
 #define XATTR_BTRFS_PREFIX     "btrfs."
 #define XATTR_BTRFS_PREFIX_LEN (sizeof(XATTR_BTRFS_PREFIX) - 1)
 
+/*
+ * Defined as synonyms in attr/xattr.h
+ */
+#ifndef ENOATTR
+#define ENOATTR ENODATA
+#endif
 
 static int prop_read_only(enum prop_object_type type,
 			  const char *object,
-- 
2.1.3

