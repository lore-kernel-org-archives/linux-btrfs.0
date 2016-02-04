Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31477 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965075AbcBDBlt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 20:41:49 -0500
Subject: Re: btrfs partition spontaneously corrupted - No recovery options.
 Kernel oops / "Kernel Bug"?
To: Dion Gullotta <Dion.Gullotta@faredge.com.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CCD0821AE781994EB8BAB510676B5EF502F2987D7119@ZEUS.faredge.local>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56B2AC54.5080505@cn.fujitsu.com>
Date: Thu, 4 Feb 2016 09:41:40 +0800
MIME-Version: 1.0
In-Reply-To: <CCD0821AE781994EB8BAB510676B5EF502F2987D7119@ZEUS.faredge.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dion Gullotta wrote on 2016/02/04 12:28 +1100:
> Hi,
>
> We have a btrfs partition that was working fine up until last night whereupon it stopped working. The first thing I tried was rebooting the server, which got stuck on a hung mount process. I've tried every diagnostic and recovery option I can find online and nothing is working.
>
> We did have regular snapshots being taken, and regular scrubbing was being performed as well. If you need any information I'm more than happy to provide.
>
> The OS is ReadyNAS which is linux under the hood. Readynas OS version 6.2.4
>
> Here are the relevant details:
>
> Broken device is /dev/md127 which is usually mounted under /data
>
> root@odin:/var/readynasd# uname -a
> Linux odin 3.0.101.RN2120.3 #1 SMP Wed Apr 1 16:09:30 PDT 2015 armv7l GNU/Linux
>
> root@odin:/var/readynasd# btrfs fi show
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> Csum didn't match
> Couldn't read chunk root

One of the most deadly corruption for current btrfs, chunk tree root 
corrupt.

Normally, btrfs rescue chunk-recovery should be the correct tool to fix 
it, but several bug and some bad design makes chunk-recovery quite easy 
to crash, and not recover the fs.

But you can alwasy try that tool.

Other idea including try to use backup roots manually, but under most 
case it doesn't work as backup root is only up to 4 backups, which 
normally doesn't contain the needed chunk root.

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
> Adding 1047420k swap on /dev/md1. Priority:-1 extents:1 across:1047420k
> BTRFS critical (device md127): unable to find logical 1357341392896 len 4096
> kernel BUG at fs/btrfs/inode.c:1621!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = f0260000
> [00000000] *pgd=30015831, *pte=00000000, *ppte=00000000
> Internal error: Oops: 817 [#1] SMP
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
> root@odin:/tmp# btrfs-zero-log /dev/md127
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> Csum didn't match
> Couldn't read chunk root
>
>
> root@odin:/tmp# btrfs restore -F -i -D -v /dev/md127 /dev/null
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> Csum didn't match
> Couldn't read chunk root
> Could not open root, trying backup super
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> Csum didn't match
> Couldn't read chunk root
> Could not open root, trying backup super
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> Csum didn't match
> Couldn't read chunk root
>
>
> root@odin:/tmp# btrfs-find-root /dev/md127
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> checksum verify failed on 18949527437312 found 4A677799 wanted CB641650
> Csum didn't match
> Couldn't read chunk root
> Open ctree failed
>
> root@odin:/tmp# btrfsck /dev/md127
> Couldn't open file system
>
> oot@odin:/tmp# btrfs rescue super-recover -v /dev/md127
> All Devices:
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
> root@odin:/tmp# btrfs check /dev/md127
> Couldn't open file system
> root@odin:/tmp# btrfsck /dev/md127
> Couldn't open file system
>
> Other info
>
> root@odin:/tmp# lsblk -o name,type,size,fstype,mountpoint
> NAME TYPE SIZE FSTYPE MOUNTPOINT
> mtdblock0 disk 1.5M
> mtdblock1 disk 128K
> mtdblock2 disk 6M
> mtdblock3 disk 4M
> mtdblock4 disk 116M
> sda disk 7.3T
> ├─sda1 part 4G linux_raid_member
> │ └─md0 raid1 4G ext4 /
> ├─sda2 part 512M linux_raid_member
> │ └─md1 raid6 1022.9M swap [SWAP]
> └─sda3 part 7.3T linux_raid_member
> └─md127 raid5 21.8T btrfs
> sdb disk 7.3T
> ├─sdb1 part 4G linux_raid_member
> │ └─md0 raid1 4G ext4 /
> ├─sdb2 part 512M linux_raid_member
> │ └─md1 raid6 1022.9M swap [SWAP]
> └─sdb3 part 7.3T linux_raid_member
> └─md127 raid5 21.8T btrfs
> sdc disk 7.3T
> ├─sdc1 part 4G linux_raid_member
> │ └─md0 raid1 4G ext4 /
> ├─sdc2 part 512M linux_raid_member
> │ └─md1 raid6 1022.9M swap [SWAP]
> └─sdc3 part 7.3T linux_raid_member
> └─md127 raid5 21.8T btrfs
> sdd disk 7.3T
> ├─sdd1 part 4G linux_raid_member
> │ └─md0 raid1 4G ext4 /
> ├─sdd2 part 512M linux_raid_member
> │ └─md1 raid6 1022.9M swap [SWAP]
> └─sdd3 part 7.3T linux_raid_member
> └─md127 raid5 21.8T btrfs
>
>
>   Disk health seems fine:
> root@odin:/tmp# smartctl -a /dev/sda | grep PASSED
> SMART overall-health self-assessment test result: PASSED
> root@odin:/tmp# smartctl -a /dev/sdb | grep PASSED
> SMART overall-health self-assessment test result: PASSED
> root@odin:/tmp# smartctl -a /dev/sdc | grep PASSED
> SMART overall-health self-assessment test result: PASSED
> root@odin:/tmp# smartctl -a /dev/sdd | grep PASSED
> SMART overall-health self-assessment test result: PASSED
>
>
>
>
> Dion
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


