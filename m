Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60635 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752504AbaHNEFj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 00:05:39 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: bug adding device to seed device, btrfs fi show fails
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5371E1E5.1030909@cn.fujitsu.com>
Date: Wed, 13 Aug 2014 22:05:35 -0600
Cc: Anand Jain <Anand.Jain@oracle.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Message-Id: <91408049-2586-446C-BD11-D3E33A5ECD27@colorremedies.com>
References: <29B81ECC-8877-4BBB-9701-1CB5C46717ED@colorremedies.com> <53702B42.8040806@oracle.com> <5371E1E5.1030909@cn.fujitsu.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> On 05/11/2014 09:51 AM, Chris Murphy wrote:
>>> kernel 3.15.0-0.rc5.git0.1.fc21.x86_64
>>> btrfs-progs 3.14
>>> 
>>> /dev/sdb2 = existing btrfs fs
>>> /dev/sdc3 = unformatted partition
>>> 
>>> 
>>> # btrfstune -S1 /dev/sdb2
>>> # mount /dev/sdb2 /mnt
>>> mount: /dev/sdb2 is write-protected, mounting read-only
>>> # btrfs device add /dev/sdc3 /mnt
>>> Performing full device TRIM (75.90GiB) ...
>>> # btrfs fi show
>>> Label: 'rawhide'  uuid: d372e5d1-386f-460c-b036-611469e0155e
>>>    Total devices 1 FS bytes used 7.55GiB
>>>    devid    1 size 79.31GiB used 11.04GiB path /dev/sda3
>>> 
>>> btrfs: utils.c:1769: get_fs_info: Assertion `!(ndevs >= fi_args->num_devices)' failed.

Old bug. I thought this patch would fix it, and see it is in integration branch. So I built a kernel and also btrfs-progs to test, but both 'fi show' and 'replace start' fail. However, 'device delete' works.

[PATCH 01/10] Btrfs: Fix the problem that the replace destroys the seed filesystem
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35774.html


This is what I just did. /dev/sdb is an existing btrfs volume not mounted, /dev/sdc is blank (a new VDI so it's definitely full of zeros.)

# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdb               8:16   0   80G  0 disk 
sdc               8:32   0   80G  0 disk 
# btrfs fi show
Label: none  uuid: caeaf998-6063-4c09-9088-0e05d4d4f54e
	Total devices 1 FS bytes used 2.47GiB
	devid    1 size 80.00GiB used 11.02GiB path /dev/sdb

Btrfs v3.14.2-167-ge514381
# btrfstune -S1 /dev/sdb
# mount /dev/sdb /mnt
mount: /dev/sdb is write-protected, mounting read-only
# btrfs device add /dev/sdc /mnt
# btrfs fi show
btrfs: utils.c:1939: get_fs_info: Assertion `!(ndevs >= fi_args->num_devices)' failed.
Aborted (core dumped)
# umount /mnt
# mount /dev/sdc /mnt
# btrfs replace start -f 0 2 /mnt
btrfs: utils.c:1939: get_fs_info: Assertion `!(ndevs >= fi_args->num_devices)' failed.
Aborted (core dumped)
# btrfs device delete /dev/sdc /mnt
ERROR: error removing the device '/dev/sdc' - unable to remove the only writeable device
# btrfs device delete /dev/sdb /mnt

The last command does complete and both /dev/sdb and /dev/sdc appear to work.

For above, this is what I get in dmesg:
[   60.089303]  sdb: unknown partition table
[   69.945922] BTRFS info (device sdb): disk space caching is enabled
[   69.969784] SELinux: initialized (dev sdb, type btrfs), uses xattr
[   84.141416]  sdc: unknown partition table
[   84.180189]  sdc: unknown partition table
[   84.268800] BTRFS info (device sdb): relocating block group 12905873408 flags 2
[   84.338819] BTRFS info (device sdb): relocating block group 0 flags 2
[   84.393097] BTRFS info (device sdb): disk added /dev/sdc
[   84.396880]  sdc: unknown partition table
[  341.031180] BTRFS info (device sdc): disk space caching is enabled
[  341.050933] BTRFS: checking UUID tree
[  341.053573] SELinux: initialized (dev sdc, type btrfs), uses xattr
[  403.316005] BTRFS info (device sdc): relocating block group 10758389760 flags 1
[  403.422962] BTRFS info (device sdc): found 35 extents
[  403.561964] BTRFS info (device sdc): found 35 extents
[  403.597289] BTRFS info (device sdc): relocating block group 9684647936 flags 1
[  403.634505] BTRFS info (device sdc): relocating block group 8610906112 flags 1
[  406.168389] BTRFS info (device sdc): found 2907 extents
[  407.379575] BTRFS info (device sdc): found 2907 extents
[  407.415344] BTRFS info (device sdc): relocating block group 7537164288 flags 1
[  409.497717] BTRFS info (device sdc): found 613 extents
[  412.010498] BTRFS info (device sdc): found 613 extents
[  412.040723] BTRFS info (device sdc): relocating block group 6463422464 flags 1
[  414.782188] BTRFS info (device sdc): found 1613 extents
[  417.343576] BTRFS info (device sdc): found 1613 extents
[  417.379543] BTRFS info (device sdc): relocating block group 5389680640 flags 1
[  419.068584] BTRFS info (device sdc): found 1060 extents
[  420.789650] BTRFS info (device sdc): found 1060 extents
[  420.823006] BTRFS info (device sdc): relocating block group 4315938816 flags 1
[  423.647962] BTRFS info (device sdc): found 3354 extents
[  425.073006] BTRFS info (device sdc): found 3354 extents
[  425.108412] BTRFS info (device sdc): relocating block group 3242196992 flags 1
[  427.212816] BTRFS info (device sdc): found 2493 extents
[  428.217004] BTRFS info (device sdc): found 2493 extents
[  428.246424] BTRFS info (device sdc): relocating block group 2168455168 flags 1
[  437.060542] BTRFS info (device sdc): found 22108 extents
[  440.286964] BTRFS info (device sdc): found 22108 extents
[  440.442528] BTRFS info (device sdc): relocating block group 1094713344 flags 1
[  449.026968] BTRFS info (device sdc): found 3914 extents
[  453.901003] BTRFS info (device sdc): found 3914 extents
[  453.952946] BTRFS info (device sdc): relocating block group 20971520 flags 4
[  454.848005] BTRFS info (device sdc): found 1352 extents
[  454.903087] BTRFS info (device sdc): relocating block group 12582912 flags 1
[  454.997235] BTRFS info (device sdc): found 46 extents
[  455.169779] BTRFS info (device sdc): found 46 extents
[  455.210596] BTRFS info (device sdc): relocating block group 4194304 flags 4
[  455.261987] BTRFS info (device sdc): disk deleted /dev/sdb
[  455.267911]  sdb: unknown partition table

Looks like device delete did work; and now fi show also works.

# btrfs fi show
Label: none  uuid: 9a072c79-db71-4bfb-914c-9ebf06215c3e
	Total devices 1 FS bytes used 2.47GiB
	devid    2 size 80.00GiB used 4.03GiB path /dev/sdc

Label: none  uuid: caeaf998-6063-4c09-9088-0e05d4d4f54e
	Total devices 1 FS bytes used 2.47GiB
	devid    1 size 80.00GiB used 11.02GiB path /dev/sdb


The following patch is not in integration. Anand Jain asked me to try it in May for this problem, but I forgot.

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/33276

Should I try it?



Chris Murphy

