Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26548 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2LTSoc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 13:44:32 -0500
Date: Thu, 20 Dec 2012 21:44:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fusionio.com>, Miao Xie <miaox@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [josef-btrfs:master 21/21] fs/btrfs/ioctl.c:1436
 btrfs_ioctl_resize() error: 'device' dereferencing possible ERR_PTR()
Message-ID: <20121220184429.GY5083@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ get_avail_device() sometimes returns an ERR_PTR ]

Hi Liu,

FYI, there are new smatch warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
head:   3d294381647ab114f525a0ccf3d28f8172ce6a5f
commit: 3d294381647ab114f525a0ccf3d28f8172ce6a5f [21/21] Btrfs: resize all devices when we dont assign a specific, device id

  fs/btrfs/ioctl.c:386 create_subvol() warn: function puts 544 bytes on stack
+ fs/btrfs/ioctl.c:1436 btrfs_ioctl_resize() error: 'device' dereferencing possible ERR_PTR()

git remote add josef-btrfs git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
git remote update josef-btrfs
git checkout 3d294381647ab114f525a0ccf3d28f8172ce6a5f
vim +/device +1436 fs/btrfs/ioctl.c

3d294381 Liu Bo            2012-12-20  1420  			ret = -EINVAL;
3d294381 Liu Bo            2012-12-20  1421  			goto out_free;
3d294381 Liu Bo            2012-12-20  1422  		}
3d294381 Liu Bo            2012-12-20  1423  	}
3d294381 Liu Bo            2012-12-20  1424  
3d294381 Liu Bo            2012-12-20  1425  	if (devid < -1ULL)
3d294381 Liu Bo            2012-12-20  1426  		device = btrfs_find_device(root->fs_info, devid, NULL, NULL);
3d294381 Liu Bo            2012-12-20  1427  	else
3d294381 Liu Bo            2012-12-20  1428  		device = get_avail_device(root, 0);
3d294381 Liu Bo            2012-12-20  1429  again:
f46b5a66 Christoph Hellwig 2008-06-11  1430  	if (!device) {
5bb14682 Arnd Hannemann    2011-11-20  1431  		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
21380931 Joel Becker       2009-04-21  1432  		       (unsigned long long)devid);
f46b5a66 Christoph Hellwig 2008-06-11  1433  		ret = -EINVAL;
c9e9f97b Ilya Dryomov      2012-01-16  1434  		goto out_free;
f46b5a66 Christoph Hellwig 2008-06-11  1435  	}
4e42ae1b Liu Bo            2012-06-14 @1436  	if (device->fs_devices && device->fs_devices->seeding) {
4e42ae1b Liu Bo            2012-06-14  1437  		printk(KERN_INFO "btrfs: resizer unable to apply on "
a8c4a33b Chris Mason       2012-06-15  1438  		       "seeding device %llu\n",
a8c4a33b Chris Mason       2012-06-15  1439  		       (unsigned long long)devid);
4e42ae1b Liu Bo            2012-06-14  1440  		ret = -EINVAL;
4e42ae1b Liu Bo            2012-06-14  1441  		goto out_free;
4e42ae1b Liu Bo            2012-06-14  1442  	}
4e42ae1b Liu Bo            2012-06-14  1443  
3d294381 Liu Bo            2012-12-20  1444  	if (use_max)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
