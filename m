Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:63252 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcCOAKn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 20:10:43 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id ADF54AC00E3
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 09:10:35 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs: Simplify conditions about compress while mapping btrfs
 flags to inode flags
Message-ID: <56E752D7.1050802@jp.fujitsu.com>
Date: Tue, 15 Mar 2016 09:09:59 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to 4.5
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 48aee98..b474e32 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -123,10 +123,10 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;

-	if ((flags & BTRFS_INODE_COMPRESS) && !(flags & BTRFS_INODE_NOCOMPRESS))
-		iflags |= FS_COMPR_FL;
-	else if (flags & BTRFS_INODE_NOCOMPRESS)
+	if (flags & BTRFS_INODE_NOCOMPRESS)
 		iflags |= FS_NOCOMP_FL;
+	else if (flags & BTRFS_INODE_COMPRESS)
+		iflags |= FS_COMPR_FL;

 	return iflags;
 }
-- 
2.5.0
