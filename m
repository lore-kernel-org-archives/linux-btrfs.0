Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33057 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbHNXkv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 19:40:51 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t7ENeoQg005264
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 23:40:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t7ENeoT0000332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 23:40:50 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t7ENeoBY028862
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 23:40:50 GMT
Message-ID: <55CE7C78.1020509@oracle.com>
Date: Sat, 15 Aug 2015 07:40:40 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [survey] sysfs layout for btrfs
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

as of now btrfs sysfs does not include the attributes for the volume 
manager part in its sysfs layout, so its being developed and there are 
two types of layout here below, so I have a quick survey to know which 
will be preferred. contenders are:
1. FS and VM (volume manager) attributes[1] merged sysfs layout
2. FS and VM attributes separated sysfs layout.

These two choices differ whether the VM attributes are amalgamate with 
existing FS attributes or if VM attributes are put under a kobject named 
"pools/volumes" under /sys/fs/btrfs. More in the below example. which 
would highlight the trade off between these two.

Eg for #1 (above):
The existing sysfs for btrfs, has the top kobject <fsid>

   /sys/fs/btrfs/<fsid> <-- holds FS attr, VM attr will be added here.
   /sys/fs/btrfs/<fsid>/devices/<uuid [2] > <-- btrfs_devices attr here
   /sys/fs/btrfs/<fsid>/devices/<uuid>/state
   /sys/fs/btrfs/<fsid>/devices/<uuid>/offline

we won't be able to change the sysfs entries which is already there. 
However we could change the context in which they are created and 
destroyed that is, from mount and unmount, to device scan and module 
unload respectively. And so this will enable us to implement the # 1 
(above).

Eg for #2 (above):
For the 2nd choice, a new 'pools or volumes' kobject will be created 
under existing /sys/fs/btrfs/ which will hold the VM attributes. 
(however note that: there will be duplicate kobjects like <fsid> both 
under FS and VM in this choice #2).

  /sys/fs/btrfs/<fsid> <--- as is, will continue to hold fs attributes.
  /sys/fs/btrfs/pools/<fsid>/ <-- will hold VM attributes
  /sys/fs/btrfs/pools/<fsid>/devices/<sdx> <-- btrfs_devices attr here
  /sys/fs/btrfs/pools/<fsid>/devices/<sdx>/state
  /sys/fs/btrfs/pools/<fsid>/devices/<sdx>/offline

There is certainly a small trade-off between these two. Your comments / 
feedback are kindly appreciated.

Thanks, Anand

[1] attributes will be of the btrfs_fs_devices structure. And few newly 
introduced attributes like 'state', to state the volume current state.

[2] note that we can not use <sdx> here since a link to the block device 
already exists with that name.
