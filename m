From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Wed, 13 Apr 2011 13:35:53 +0800
Message-ID: <4DA53639.20702@cn.fujitsu.com>
References: <BjW+GU4y1uB@helmut.hullen.de> <20110409091141.GE5301@carfax.org.uk> <4DA182DF.6010703@cn.fujitsu.com> <chaz20110411072946.GA5587@seebyte.com> <4DA3FDD1.2090804@cn.fujitsu.com> <chaz20110412081721.GA3982@seebyte.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110412081721.GA3982@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 12 Apr 2011 09:17:21 +0100, Stephane Chazelas wrote:
> 2011-04-12 15:22:57 +0800, Miao Xie:
> [...]
>> But the algorithm of df command doesn't simulate the above allocation correctly, this
>> simulated allocation just allocates the stripes from two disks, and then, these two disks
>> have no free space, but the third disk still has 1.2TB free space, df command thinks
>> this space can be used to make a new RAID0 block group and ignores it. This is a bug,
>> I think.
> [...]
> 
> Thanks a lot Miao for the detailed explanation. So, the disk
> space is not lost, it's just df not reporting the available
> space correctly. That's me relieved.
> 
> It explains why I'm getting:
> 
> # blockdev --getsize64 /dev/sda4
> 2967698087424
> # blockdev --getsize64 /dev/sdb
> 3000592982016
> # blockdev --getsize64 /dev/sdc
> 3000592982016
> # truncate -s 2967698087424 a
> # truncate -s 3000592982016 b
> # truncate -s 3000592982016 c
> # losetup /dev/loop0 ./a
> # losetup /dev/loop1 ./b
> # losetup /dev/loop2 ./c
> # mkfs.btrfs a b c
> # btrfs device scan /dev/loop[0-2]
> Scanning for Btrfs filesystems in '/dev/loop0'
> Scanning for Btrfs filesystems in '/dev/loop1'
> Scanning for Btrfs filesystems in '/dev/loop2'
> # mount  /dev/loop0 /mnt/1
> # df -k /mnt/1
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/loop0           8758675828        56 5859474304   1% /mnt/1
> # echo $(((8758675828 - 5859474304)*2**10))
> 2968782360576
> 
> One disk worth of space lost according to df.
> 
> While it should have been more something like
> $(((3000592982016-2967698087424)*2)) (about 60GB), or about 0
> after the quasi-round-robin allocation patch, right?

I think btrfs can utilize the disk space very well(perhaps all the space).
The last 60GB is on the different disks, so btrfs can utilize the space to
make up new RAID0 block groups with two stripes.

> Best regards,
> Stephane
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

