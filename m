Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:44041 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2I3OYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 10:24:47 -0400
From: Dieter Ries <mail@dieterries.net>
To: linux-btrfs@vger.kernel.org
Cc: Dieter Ries <mail@dieterries.net>
Subject: [PATCH 1/3] btrfs-progs: Remove redundant "Btrfs" string from version string
Date: Sun, 30 Sep 2012 16:18:28 +0200
Message-Id: <1349014710-16089-2-git-send-email-mail@dieterries.net>
In-Reply-To: <1349014710-16089-1-git-send-email-mail@dieterries.net>
References: <1349014710-16089-1-git-send-email-mail@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the first line of version.sh, $v was set to "Btrfs vx.yy", and in
the end "Btrfs $v" was echoed to the version.h file. This resulted in
the version string "Btrfs Btrfs vx.yy". This patch removes the second
occurrence of "Btrfs".

Signed-off-by: Dieter Ries <mail@dieterries.net>
---
 version.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/version.sh b/version.sh
index af3e441..2c1aff1 100644
--- a/version.sh
+++ b/version.sh
@@ -46,7 +46,7 @@ fi
  
 echo "#ifndef __BUILD_VERSION" > .build-version.h
 echo "#define __BUILD_VERSION" >> .build-version.h
-echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
+echo "#define BTRFS_BUILD_VERSION \"$v\"" >> .build-version.h
 echo "#endif" >> .build-version.h
 
 diff -q version.h .build-version.h >& /dev/null
-- 
1.7.3.GIT

