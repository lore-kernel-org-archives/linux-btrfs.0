Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55021 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755680AbaCSGKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 02:10:22 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2J69wtD013048
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 14:09:58 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: Fix memleak in get_raid56_used()
Date: Wed, 19 Mar 2014 06:10:02 +0000
Message-ID: <1395209466-17042-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix memleak in get_raid56_used().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-fi-disk_usage.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index a3b06be..2bd591d 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -352,6 +352,7 @@ static int get_raid56_used(int fd, u64 *raid5_used, u64 *raid6_used)
 		if (p->type & BTRFS_BLOCK_GROUP_RAID6)
 			(*raid6_used) += p->size / (p->num_stripes -2);
 	}
+	free(info_ptr);
 
 	return 0;
 
-- 
1.9.0
