Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34408 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaF3JNG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 05:13:06 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s5U9D46I021109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 09:13:05 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5U9D4Ga022539
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 09:13:04 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5U9D3YN022524
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 09:13:04 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix null pointer dereference in btrfs_show_devname when name is null
Date: Mon, 30 Jun 2014 17:12:48 +0800
Message-Id: <1404119568-4097-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1404119568-4097-1-git-send-email-Anand.Jain@oracle.com>
References: <1404119568-4097-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dev->name is null but missing flag is not set.
Strictly speaking the missing flag should have been set, but there
are more places where code just checks if name is null. For now this
patch does the same.

stack:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
IP: [<ffffffffa0228908>] btrfs_show_devname+0x58/0xf0 [btrfs]

[<ffffffff81198879>] show_vfsmnt+0x39/0x130
[<ffffffff81178056>] m_show+0x16/0x20
[<ffffffff8117d706>] seq_read+0x296/0x390
[<ffffffff8115aa7d>] vfs_read+0x9d/0x160
[<ffffffff8115b549>] SyS_read+0x49/0x90
[<ffffffff817abe52>] system_call_fastpath+0x16/0x1b

reproducer:
mkfs.btrfs -draid1 -mraid1 /dev/sdg1 /dev/sdg2
btrfstune -S 1 /dev/sdg1
modprobe -r btrfs && modprobe btrfs
mount -o degraded /dev/sdg1 /btrfs
btrfs dev add /dev/sdg3 /btrfs

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 74ef9bf..cac015f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1940,6 +1940,8 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 		list_for_each_entry(dev, head, dev_list) {
 			if (dev->missing)
 				continue;
+			if (!dev->name)
+				continue;
 			if (!first_dev || dev->devid < first_dev->devid)
 				first_dev = dev;
 		}
-- 
2.0.0.257.g75cc6c6

