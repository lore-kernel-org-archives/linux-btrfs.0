Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.anti-virus.by ([93.125.111.29]:42726 "EHLO tux.vba.com.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2JKIuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 04:50:09 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fusionio.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [btrfs-progs: PATCH] version.sh: fix version when built from tarball
Date: Thu, 11 Oct 2012 11:43:48 +0300
Message-Id: <1349945028-19523-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

[from 0.20-rc1 tarball]

Before the patch:
  $ ./btrfs --version
  Btrfs Btrfs v0.19

After the patch:
  $ ./btrfs --version
  Btrfs v0.20-rc1

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 version.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/version.sh b/version.sh
index af3e441..b81040e 100644
--- a/version.sh
+++ b/version.sh
@@ -6,7 +6,7 @@
 # Copyright 2008, Oracle
 # Released under the GNU GPLv2
  
-v="Btrfs v0.19"
+v="v0.20-rc1"
 
 which git &> /dev/null
 if [ $? == 0 -a -d .git ]; then
-- 
1.7.12

