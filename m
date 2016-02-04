Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from molniya.faredge.com.au ([220.233.140.169]:59251 "EHLO
	molniya.faredge.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbcBDBxW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 20:53:22 -0500
From: Dion Gullotta <Dion.Gullotta@faredge.com.au>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Thu, 4 Feb 2016 12:53:04 +1100
Subject: RE: btrfs partition spontaneously corrupted - No recovery options.
 Kernel oops / "Kernel Bug"?
Message-ID: <CCD0821AE781994EB8BAB510676B5EF502F2987D711D@ZEUS.faredge.local>
References: <CCD0821AE781994EB8BAB510676B5EF502F2987D7119@ZEUS.faredge.local>
 <56B2AC54.5080505@cn.fujitsu.com>
In-Reply-To: <56B2AC54.5080505@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu, thanks so much for your fast reply. 

I'm running this right now and hoping for some good results:

root@odin:/var/readynasd# btrfs rescue chunk-recover -vy /dev/md127
All Devices:
        Device: id = 1, name = /dev/md127


You said " Other idea including try to use backup roots manually" how do I do this? I tried btrfs-find-root but it doesn't find anything. 

Any further info appreciated.

Cheers,
Dion


-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
Sent: Thursday, 4 February 2016 12:42 PM
To: Dion Gullotta <Dion.Gullotta@faredge.com.au>; linux-btrfs@vger.kernel.org
Subject: Re: btrfs partition spontaneously corrupted - No recovery options. Kernel oops / "Kernel Bug"?



Dion Gullotta wrote on 2016/02/04 12:28 +1100:
> Hi,
>
> We have a btrfs partition that was working fine up until last night whereupon it stopped working. The first thing I tried was rebooting the server, which got stuck on a hung mount process. I've tried every diagnostic and recovery option I can find online and nothing is working.
>
> We did have regular snapshots being taken, and regular scrubbing was being performed as well. If you need any information I'm more than happy to provide.
>
> The OS is ReadyNAS which is linux under the hood. Readynas OS version 
> 6.2.4
>
> Here are the relevant details:
>
> Broken device is /dev/md127 which is usually mounted under /data
>
> root@odin:/var/readynasd# uname -a
> Linux odin 3.0.101.RN2120.3 #1 SMP Wed Apr 1 16:09:30 PDT 2015 armv7l 
> GNU/Linux
>
> root@odin:/var/readynasd# btrfs fi show checksum verify failed on 
> 18949527437312 found 4A677799 wanted CB641650 checksum verify failed 
> on 18949527437312 found 4A677799 wanted CB641650 checksum verify 
> failed on 18949527437312 found 4A677799 wanted CB641650 checksum 
> verify failed on 18949527437312 found 4A677799 wanted CB641650 Csum 
> didn't match Couldn't read chunk root

One of the most deadly corruption for current btrfs, chunk tree root corrupt.

Normally, btrfs rescue chunk-recovery should be the correct tool to fix it, but several bug and some bad design makes chunk-recovery quite easy to crash, and not recover the fs.

But you can alwasy try that tool.

Other idea including try to use backup roots manually, but under most case it doesn't work as backup root is only up to 4 backups, which normally doesn't contain the needed chunk root.

Thanks,
Qu


> Label: '2fe6230e:data'  uuid: 04c95625-4927-4ade-80e7-de45a7536271
>          Total devices 1 FS bytes used 13.62TiB
>          devid    1 size 21.82TiB used 14.24TiB path /dev/md127
>
> Btrfs v3.17.3
>
> This is the relevant part of dmesg
>
> udevd[862]: starting version 175
> btrfs: device label 2fe6230e:data devid 1 transid 248531 /dev/md127 
> Adding 1047420k swap on /dev/md1. Priority:-1 extents:1 
> across:1047420k BTRFS critical (device md127): unable to find logical 
> 1357341392896 len 4096 kernel BUG at fs/btrfs/inode.c:1621!
> Unable to handle kernel NULL pointer dereference at virtual address 
> 00000000 pgd = f0260000 [00000000] *pgd=30015831, *pte=00000000, 
> *ppte=00000000 Internal error: Oops: 817 [#1] SMP
>
> Note the kernel bug and kernel oops lines.
>
>
> I've tried the following things, results shown:
>
> mount -o recovery /dev/md127 /data
>
> mount -o ro,recovery /dev/md127 /data
>
> mount -o ro /dev/md127 /data
>
> All of these just hang and a reboot is necessary in order to kill the process.
>
>
>
> Things that don't work:
>
> root@odin:/tmp# btrfs-zero-log /dev/md127 checksum verify failed on 
> 18949527437312 found 4A677799 wanted CB641650 checksum verify failed 
> on 18949527437312 found 4A677799 wanted CB641650 checksum verify 
> failed on 18949527437312 found 4A677799 wanted CB641650 checksum 
> verify failed on 18949527437312 found 4A677799 wanted CB641650 Csum 
> didn't match Couldn't read chunk root
>
>
> root@odin:/tmp# btrfs restore -F -i -D -v /dev/md127 /dev/null 
> checksum verify failed on 18949527437312 found 4A677799 wanted 
> CB641650 checksum verify failed on 18949527437312 found 4A677799 
> wanted CB641650 checksum verify failed on 18949527437312 found 
> 4A677799 wanted CB641650 checksum verify failed on 18949527437312 
> found 4A677799 wanted CB641650 Csum didn't match Couldn't read chunk 
> root Could not open root, trying backup super checksum verify failed 
> on 18949527437312 found 4A677799 wanted CB641650 checksum verify 
> failed on 18949527437312 found 4A677799 wanted CB641650 checksum 
> verify failed on 18949527437312 found 4A677799 wanted CB641650 
> checksum verify failed on 18949527437312 found 4A677799 wanted 
> CB641650 Csum didn't match Couldn't read chunk root Could not open 
> root, trying backup super checksum verify failed on 18949527437312 
> found 4A677799 wanted CB641650 checksum verify failed on 
> 18949527437312 found 4A677799 wanted CB641650 checksum verify failed 
> on 18949527437312 found 4A677799 wanted CB641650 checksum verify 
> failed on 18949527437312 found 4A677799 wanted CB641650 Csum didn't 
> match Couldn't read chunk root
>
>
> root@odin:/tmp# btrfs-find-root /dev/md127 checksum verify failed on 
> 18949527437312 found 4A677799 wanted CB641650 checksum verify failed 
> on 18949527437312 found 4A677799 wanted CB641650 checksum verify 
> failed on 18949527437312 found 4A677799 wanted CB641650 checksum 
> verify failed on 18949527437312 found 4A677799 wanted CB641650 Csum 
> didn't match Couldn't read chunk root Open ctree failed
>
> root@odin:/tmp# btrfsck /dev/md127
> Couldn't open file system
>
> oot@odin:/tmp# btrfs rescue super-recover -v /dev/md127 All Devices:
> Device: id = 1, name = /dev/md127
>
> Before Recovering:
> [All good supers]:
> device name = /dev/md127
> superblock bytenr = 65536
>
> device name = /dev/md127
> superblock bytenr = 67108864
>
> device name = /dev/md127
> superblock bytenr = 274877906944
>
> [All bad supers]:
>
> All supers are valid, no need to recover
>
>
> root@odin:/tmp# btrfs check /dev/md127 Couldn't open file system 
> root@odin:/tmp# btrfsck /dev/md127 Couldn't open file system
>
> Other info
>
> root@odin:/tmp# lsblk -o name,type,size,fstype,mountpoint NAME TYPE 
> SIZE FSTYPE MOUNTPOINT
> mtdblock0 disk 1.5M
> mtdblock1 disk 128K
> mtdblock2 disk 6M
> mtdblock3 disk 4M
> mtdblock4 disk 116M
> sda disk 7.3T
> â”œâ”€sda1 part 4G linux_raid_member
> â”‚ â””â”€md0 raid1 4G ext4 /
> â”œâ”€sda2 part 512M linux_raid_member
> â”‚ â””â”€md1 raid6 1022.9M swap [SWAP]
> â””â”€sda3 part 7.3T linux_raid_member
> â””â”€md127 raid5 21.8T btrfs
> sdb disk 7.3T
> â”œâ”€sdb1 part 4G linux_raid_member
> â”‚ â””â”€md0 raid1 4G ext4 /
> â”œâ”€sdb2 part 512M linux_raid_member
> â”‚ â””â”€md1 raid6 1022.9M swap [SWAP]
> â””â”€sdb3 part 7.3T linux_raid_member
> â””â”€md127 raid5 21.8T btrfs
> sdc disk 7.3T
> â”œâ”€sdc1 part 4G linux_raid_member
> â”‚ â””â”€md0 raid1 4G ext4 /
> â”œâ”€sdc2 part 512M linux_raid_member
> â”‚ â””â”€md1 raid6 1022.9M swap [SWAP]
> â””â”€sdc3 part 7.3T linux_raid_member
> â””â”€md127 raid5 21.8T btrfs
> sdd disk 7.3T
> â”œâ”€sdd1 part 4G linux_raid_member
> â”‚ â””â”€md0 raid1 4G ext4 /
> â”œâ”€sdd2 part 512M linux_raid_member
> â”‚ â””â”€md1 raid6 1022.9M swap [SWAP]
> â””â”€sdd3 part 7.3T linux_raid_member
> â””â”€md127 raid5 21.8T btrfs
>
>
>   Disk health seems fine:
> root@odin:/tmp# smartctl -a /dev/sda | grep PASSED SMART 
> overall-health self-assessment test result: PASSED root@odin:/tmp# 
> smartctl -a /dev/sdb | grep PASSED SMART overall-health 
> self-assessment test result: PASSED root@odin:/tmp# smartctl -a 
> /dev/sdc | grep PASSED SMART overall-health self-assessment test 
> result: PASSED root@odin:/tmp# smartctl -a /dev/sdd | grep PASSED 
> SMART overall-health self-assessment test result: PASSED
>
>
>
>
> Dion
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
