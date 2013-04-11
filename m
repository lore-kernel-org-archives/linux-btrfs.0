Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60225 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3DKLMC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 07:12:02 -0400
Message-ID: <51669069.50207@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 18:28:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: mfasheh@suse.de
Subject: [PATCH] Btrfs-progs: don't set INCOMPAT_EXTENDED_IREF flag when making
 a new fs
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no extended irefs in the new fs, and we can mount it on
the old kernel without extended iref function safely. So we needn't
set INCOMPAT_EXTENDED_IREF flag when making a new fs, and just set
it when we actually insert a extended iref.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Mark Fasheh <mfasheh@suse.de>
---
 mkfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c8cb395..aca6e46 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1654,8 +1654,6 @@ raid_groups:
 
 	super = root->fs_info->super_copy;
 	flags = btrfs_super_incompat_flags(super);
-	flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
-
 	if (mixed)
 		flags |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
 
-- 
1.8.0.1
