Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50452 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3GDEHE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 00:07:04 -0400
Date: Thu, 4 Jul 2013 12:06:47 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] Btrfs-progs: introduce chunk recover function
Message-ID: <20130704040646.GA3577@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
 <20130703203644.14981.18637@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130703203644.14981.18637@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 03, 2013 at 04:36:44PM -0400, Chris Mason wrote:
> Quoting Miao Xie (2013-07-03 09:25:08)
> > This patchset introduced chunk recover function, which was implemented by
> > scanning the whoel disks in the filesystem. Now, we can recover Single,
> > Dup, RAID1 chunks, and RAID0, RAID10, RAID5, RAID6 metadata chunks.
> 
> Really nice.  I've integrated this with Liu Bo's btrfs-image fixes and
> put it into a branch called integration.  I've tested both repair and
> image here, but if you could please double check the merge I'd
> appreciate it.

We still need another patch to make image work(actually we need to initialize
missing device's uuid to NULL).

It's the read_one_dev() part in

https://patchwork.kernel.org/patch/2787291/

diff --git a/volumes.c b/volumes.c
index d6f81f8..061f094 100644
--- a/volumes.c
+++ b/volumes.c
@@ -116,6 +116,7 @@ static int device_list_add(const char *path,
 			/* we can safely leave the fs_devices entry around */
 			return -ENOMEM;
 		}
+		device->fd = -1;
 		device->devid = devid;
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
@@ -1628,10 +1629,10 @@ static int read_one_dev(struct btrfs_root *root,
 	if (!device) {
 		printk("warning devid %llu not found already\n",
 			(unsigned long long)devid);
-		device = kmalloc(sizeof(*device), GFP_NOFS);
+		device = kzalloc(sizeof(*device), GFP_NOFS);
 		if (!device)
 			return -ENOMEM;
-		device->total_ios = 0;
+		device->fd = -1;
 		list_add(&device->dev_list,
 			 &root->fs_info->fs_devices->devices);
 	}

-liubo
