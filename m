Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42898 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751940AbcELKqd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 06:46:33 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id E684E489F961
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 18:46:19 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: autogen: Don't show success message on fail
Date: Thu, 12 May 2016 18:42:47 +0800
Message-ID: <18530fa49b6aceb93878590a832c60ee90afc670.1463049696.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <61ca47efb3599997cf0eb7431f31e92f3819546a.1463049696.git.zhaolei@cn.fujitsu.com>
References: <61ca47efb3599997cf0eb7431f31e92f3819546a.1463049696.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When autogen.sh failed, the success message is still in output:
 # ./autogen.sh
 ...
 configure.ac:131: error: possibly undefined macro: PKG_CHECK_VAR
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.

 Now type './configure' and 'make' to compile.
 #

Fixed by check return value of autoconf.

After patch:
 # ./autogen.sh
 ...
 configure.ac:132: error: possibly undefined macro: PKG_CHECK_VAR
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.
 #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 autogen.sh | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index 8b9a9cb..a5f9af2 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -64,9 +64,10 @@ echo "   automake:   $(automake --version | head -1)"
 chmod +x version.sh
 rm -rf autom4te.cache
 
-aclocal $AL_OPTS
-autoconf $AC_OPTS
-autoheader $AH_OPTS
+aclocal $AL_OPTS &&
+autoconf $AC_OPTS &&
+autoheader $AH_OPTS ||
+exit 1
 
 # it's better to use helper files from automake installation than
 # maintain copies in git tree
-- 
1.8.5.1



