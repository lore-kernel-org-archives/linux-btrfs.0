Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-226-31-50-static.hfc.comcastbusiness.net ([50.226.31.50]:55555
        "EHLO linux-q7u8.site" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753683AbeD3Om2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 10:42:28 -0400
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/3] btrfs-progs: build: autoconf 2.63 compatibility
Date: Mon, 30 Apr 2018 10:37:07 -0400
Message-Id: <1525099028-11737-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1525099028-11737-1-git-send-email-jeffm@suse.com>
References: <1525099028-11737-1-git-send-email-jeffm@suse.com>
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
index 2dea1c6..9e5603b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 AC_INIT([btrfs-progs],
-	m4_chomp(m4_include([VERSION])),
+	m4_flatten(m4_include([VERSION])),
 	[linux-btrfs@vger.kernel.org],,
 	[http://btrfs.wiki.kernel.org])
 
-- 
1.7.12.4

