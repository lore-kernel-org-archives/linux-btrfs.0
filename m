Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758072AbeD0S4q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 14:56:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1C1B0ADAE
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 18:56:45 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/3] btrfs-progs: build: use m4_flatten instead of m4_chomp
Date: Fri, 27 Apr 2018 14:56:37 -0400
Message-Id: <20180427185637.16642-4-jeffm@suse.com>
In-Reply-To: <20180427185637.16642-1-jeffm@suse.com>
References: <20180427185637.16642-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Commit 2e1932e6a38 (btrfs-progs: build: simplify version tracking)
started m4_chomp to strip the newlines from the version file.  m4_chomp
was introduced in autoconf 2.64 but SLE11 ships with autoconf 2.63.
For purposes of just stripping the newline, m4_flatten is sufficient.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 17880206..a0cebf15 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 AC_INIT([btrfs-progs],
-	m4_chomp(m4_include([VERSION])),
+	m4_flatten(m4_include([VERSION])),
 	[linux-btrfs@vger.kernel.org],,
 	[http://btrfs.wiki.kernel.org])
 
-- 
2.12.3

