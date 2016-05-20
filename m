Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbcETCVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 22:21:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fsck: Add more explanation on low memory mode
Date: Fri, 20 May 2016 10:21:07 +0800
Message-Id: <1463710867-27127-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems the initial support for low memory mode will come in recent
release, it's better to add more explanation on the unsupported
functions, to avoid user reporting known bugs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-check.asciidoc | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index 4e27863..6b09662 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -97,7 +97,14 @@ NOTE: Do not use unless you know what you're doing.
 check fs in low memory usage mode(experimental)
 May takes longer time than normal check.
 +
-NOTE: Doesn't work with '--repair' option yet.
+[NOTE]
+==========================
+As this feature is still under development, some functions are not implemented
+yet
+
+- No support for '--repair' yet.
+- Only reduce memory usage of extent tree check. No effect for fs tree yet.
+==========================
 
 EXIT STATUS
 -----------
-- 
2.8.2



