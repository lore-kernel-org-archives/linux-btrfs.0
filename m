Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pecan2-mail.exetel.com.au ([220.233.0.71]:50445 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaKCKAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Nov 2014 05:00:32 -0500
Received: from 233.33.70.115.static.exetel.com.au ([115.70.33.233] helo=office.waterlogic.com.au)
	by smtp.po.exetel.com.au with esmtp (Exim 4.80)
	(envelope-from <paul@pauljones.id.au>)
	id 1XlER5-00047f-Lr
	for linux-btrfs@vger.kernel.org; Mon, 03 Nov 2014 21:00:31 +1100
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs check - Couldn't open file system
Date: Mon, 3 Nov 2014 10:00:28 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64593F39764B@Server.waterlogic.com.au>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
As the topic says, btrfs check - Couldn't open file system. Check runs fine on all btrfs volumes except one - "Backup". There is nothing special about it, it uses the same options as all the other ones (raid1, compress).
As you can see in the output below I double check the filesystem is unmounted, and then try and check it (using a few different devices) but it won't work. Checking another volume works fine.
There are no error or warning messages in dmesg.
Any ideas??

Thanks,
Paul.

IWT-VM ~ # uname -a
Linux IWT-VM 3.17.2-gentoo #1 SMP Mon Nov 3 15:46:50 AEDT 2014 x86_64 Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz GenuineIntel GNU/Linux
IWT-VM ~ # mount
/dev/sdb2 on / type btrfs (rw,noatime,compress=zlib,ssd,noacl,space_cache)
/dev/sdh1 on /media/fast type btrfs (rw,noatime,ssd,noacl,space_cache)
/dev/sdg3 on /media/backup type btrfs (rw,noatime,compress=zlib,noacl,space_cache)
/dev/sda1 on /media/data type btrfs (rw,noatime,compress=zlib,noacl,space_cache)
IWT-VM ~ # btrfs fi sh
Label: 'Root'  uuid: 61f6ce80-6d05-414f-9f0f-3d540fa82f2e
        Total devices 2 FS bytes used 6.58GiB
        devid    4 size 60.00GiB used 18.03GiB path /dev/sdb2
        devid    5 size 59.93GiB used 18.03GiB path /dev/sdi3

Label: 'Fast'  uuid: c41dc6db-6f00-4d60-a2f7-acbceb25e4e7
        Total devices 3 FS bytes used 396.85GiB
        devid    1 size 471.93GiB used 416.02GiB path /dev/sdh1
        devid    2 size 412.00GiB used 356.01GiB path /dev/sdi1
        devid    3 size 163.57GiB used 108.01GiB path /dev/sdb1

Label: 'Backup'  uuid: 92162be2-e52f-42fe-a9fd-da4f26c6abd1
        Total devices 5 FS bytes used 2.74TiB
        devid    6 size 891.50GiB used 822.00GiB path /dev/sdg3
        devid    8 size 698.64GiB used 629.00GiB path /dev/sdd1
        devid    9 size 891.51GiB used 821.03GiB path /dev/sde3
        devid   10 size 2.73TiB used 2.66TiB path /dev/sdc1
        devid   11 size 931.51GiB used 924.00GiB path /dev/sdf1

Label: 'Data'  uuid: 89181f84-bace-43f8-9534-693f99c4d033
        Total devices 2 FS bytes used 42.50GiB
        devid    1 size 279.46GiB used 211.03GiB path /dev/sda1
        devid    2 size 279.46GiB used 211.03GiB path /dev/sdj1

Btrfs v3.17
IWT-VM ~ # umount /media/backup
umount: /media/backup: not mounted
IWT-VM ~ # btrfs check /dev/sdg3
Couldn't open file system
IWT-VM ~ # btrfs check /dev/sdd1
Couldn't open file system
IWT-VM ~ # btrfs check /dev/sde3
Couldn't open file system
IWT-VM ~ # btrfs check /dev/sda1
Checking filesystem on /dev/sda1
UUID: 89181f84-bace-43f8-9534-693f99c4d033
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 38060448123 bytes used err is 0
total csum bytes: 44401072
total tree bytes: 110723072
total fs tree bytes: 50872320
total extent tree bytes: 9994240
btree space waste bytes: 12145264
file data blocks allocated: 45618331648
 referenced 48120782848
Btrfs v3.17
