Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab2FNIQI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:08 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/10] Btrfs: update MAINTAINERS info for BTRFS FILE SYSTEM
Date: Thu, 14 Jun 2012 16:23:25 +0800
Message-Id: <1339662206-5307-10-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update to the latest btrfs's maintainer mail and git repo.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b362709..8bfa7f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1630,11 +1630,11 @@ S:	Maintained
 F:	drivers/gpio/gpio-bt8xx.c
 
 BTRFS FILE SYSTEM
-M:	Chris Mason <chris.mason@oracle.com>
+M:	Chris Mason <chris.mason@fusionio.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
 Q:	http://patchwork.kernel.org/project/linux-btrfs/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
 S:	Maintained
 F:	Documentation/filesystems/btrfs.txt
 F:	fs/btrfs/
-- 
1.6.5.2

