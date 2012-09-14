Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:39152 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab2INQ7o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 12:59:44 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id aJwQ9hGbjMGAk0YJ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 10:59:43 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use vfree instead of kfree
Date: Fri, 14 Sep 2012 13:05:09 -0400
Message-ID: <1347642309-29242-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are vmalloc()'ing the fspath now so we should be vfree'ing it and not
kfreeing it.  Thanks,

Reported-by: Dave Sterba <dave@jikos.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/backref.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index fb72931..395d912 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1634,6 +1634,6 @@ void free_ipath(struct inode_fs_paths *ipath)
 {
 	if (!ipath)
 		return;
-	kfree(ipath->fspath);
+	vfree(ipath->fspath);
 	kfree(ipath);
 }
-- 
1.7.7.6

