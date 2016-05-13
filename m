Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37833 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbcEMDsm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 23:48:42 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id EAE8B42B6713
	for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 11:48:25 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 2/3] btrfs-progs: autogen: Make build success in CentOS 6 and 7
Date: Fri, 13 May 2016 11:44:52 +0800
Message-ID: <f8ecf2186c2258745885e7a136ea4b467334e140.1463110976.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1463110976.git.zhaolei@cn.fujitsu.com>
References: <cover.1463110976.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs build failed in CentOS 6 and 7:
 #./autogen.sh
 ...
 configure.ac:131: error: possibly undefined macro: PKG_CHECK_VAR
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.
 ...

Seems PKG_CHECK_VAR is new in pkgconfig 0.28 (24-Jan-2013):
http://redmine.audacious-media-player.org/boards/1/topics/736

And the max available version for CentOS 7 in yum-repo and
rpmfind.net is: pkgconfig-0.27.1-4.el7
http://rpmfind.net/linux/rpm2html/search.php?query=pkgconfig&submit=Search+...&system=centos&arch=

I updated my pkgconfig to 0.30, but still failed at above error.
(Maybe it is my setting problem)

To make user in centos 6 and 7 building btrfs-progs without
more changes, we can avoid using PKG_CHECK_VAR in following
way found in:
https://github.com/audacious-media-player/audacious-plugins/commit/f95ab6f939ecf0d9232b3165f9241d2ea9676b9e

Changelog v1->v2:
1: Add AC_SUBST(UDEVDIR)
   Suggested by: Jeff Mahoney <jeffm@suse.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 configure.ac | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 4688bc7..c79472c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -128,7 +128,8 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
 PKG_CHECK_MODULES(ZLIB, [zlib])
 PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
 
-PKG_CHECK_VAR([UDEVDIR], [udev], [udevdir])
+UDEVDIR="$(pkg-config udev --variable=udevdir)"
+AC_SUBST(UDEVDIR)
 
 dnl lzo library does not provide pkg-config, let use classic way
 AC_CHECK_LIB([lzo2], [lzo_version], [
-- 
1.8.5.1



