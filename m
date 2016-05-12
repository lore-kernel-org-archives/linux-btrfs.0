Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42898 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbcELKqb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 06:46:31 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id BED53489F963
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 18:46:18 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: autogen: Avoid chdir fail on dirname with blank
Date: Thu, 12 May 2016 18:42:45 +0800
Message-ID: <61ca47efb3599997cf0eb7431f31e92f3819546a.1463049696.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If source put in dir with blanks, as:
  /var/lib/jenkins/workspace/btrfs progs

autogen will failed:
./autogen.sh: line 95: cd: /var/lib/jenkins/workspace/btrfs: No such file or directory

Can be fixed by adding quotes into cd command.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 autogen.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/autogen.sh b/autogen.sh
index 9669850..8b9a9cb 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -92,7 +92,7 @@ find_autofile config.guess
 find_autofile config.sub
 find_autofile install-sh
 
-cd $THEDIR
+cd "$THEDIR"
 
 echo
 echo "Now type '$srcdir/configure' and 'make' to compile."
-- 
1.8.5.1



