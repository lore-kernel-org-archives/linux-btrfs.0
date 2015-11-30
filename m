Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbbK3JsI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 04:48:08 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 86819ACA5
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 09:46:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: install to /usr/local by default again
Date: Mon, 30 Nov 2015 10:46:15 +0100
Message-Id: <1448876775-4979-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The conversion to autotools changed the default prefix to /usr. There's
no reason to diverge. Distributions builds set prefix the /usr path and
local builds are supposed to go to /usr/local .

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=108571
Reported-by: Karl Richter <krichter722@aol.de>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index c3a22d1315c7..c1140973d0d7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,7 +23,7 @@ dnl the compiler (like AC_PROG_LIBTOOL) to avoid autoconf errors.
 AC_USE_SYSTEM_EXTENSIONS
 
 AC_CONFIG_SRCDIR([btrfs.c])
-AC_PREFIX_DEFAULT([/usr])
+AC_PREFIX_DEFAULT([/usr/local])
 
 AC_PROG_CC
 AC_CANONICAL_HOST
-- 
2.6.2

