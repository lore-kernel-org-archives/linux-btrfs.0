Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34373 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbcHaBPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 21:15:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DBCAEAAF1
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 01:15:46 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfsprogs: only install udev rules for udev >= 190
Message-ID: <57C62FC0.6020206@suse.com>
Date: Tue, 30 Aug 2016 21:15:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Prior to udev v190, there was no btrfs builtin helper.  Installing it on
systems with an older udev will cause problems.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 configure.ac |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 97e89f2..8fd8f42 100644
--- a/configure.ac
+++ b/configure.ac
@@ -161,7 +161,13 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
 PKG_CHECK_MODULES(ZLIB, [zlib])
 PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
 
-UDEVDIR="$(pkg-config udev --variable=udevdir)"
+# udev v190 introduced the btrfs builtin and a udev rule to use it.
+# Our udev rule gives us the friendly dm names but isn't required (or valid)
+# on earlier releases.
+UDEVDIR=
+if pkg-config udev --atleast-version 190; then
+	UDEVDIR="$(pkg-config udev --variable=udevdir)"
+fi
 AC_SUBST(UDEVDIR)
 
 dnl lzo library does not provide pkg-config, let use classic way

-- 
Jeff Mahoney
SUSE Labs
