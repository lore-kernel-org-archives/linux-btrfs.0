Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:57780 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2JHTIN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 15:08:13 -0400
From: Dieter Ries <mail@dieterries.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: Dieter Ries <mail@dieterries.net>
Subject: [PATCH 1/4] btrfs-progs: Remove redundant "Btrfs" string from version string
Date: Mon,  8 Oct 2012 21:07:47 +0200
Message-Id: <1349723270-12773-2-git-send-email-mail@dieterries.net>
In-Reply-To: <1349723270-12773-1-git-send-email-mail@dieterries.net>
References: <1349723270-12773-1-git-send-email-mail@dieterries.net>
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

