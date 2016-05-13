Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37833 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682AbcEMDss (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 23:48:48 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 8443542B6716
	for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 11:48:26 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 3/3] btrfs-progs: autogen: Don't show success message on fail
Date: Fri, 13 May 2016 11:44:53 +0800
Message-ID: <26779eedaf64f2c678fc68647a5edd9450003e68.1463110976.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1463110976.git.zhaolei@cn.fujitsu.com>
References: <cover.1463110976.git.zhaolei@cn.fujitsu.com>
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



