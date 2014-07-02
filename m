Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8338 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750861AbaGBGSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 02:18:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s626Il0U028486
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Jul 2014 14:18:47 +0800
Message-ID: <53B3A488.4030406@cn.fujitsu.com>
Date: Wed, 2 Jul 2014 14:19:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs fi df <mount point> outputs info instead of error even
 when <mount-point> is just a directory
References: <20140702051444.GA5459@mail2.smcindiaonline.com>
In-Reply-To: <20140702051444.GA5459@mail2.smcindiaonline.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: btrfs fi df <mount point> outputs info instead of error even 
when <mount-point> is just a directory
From: Vikram Goyal <vikigoyal@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: 2014年07月02日 13:14
> Hi,
>
> As the subject specifies there is some confusion (at least with me:) as
> to what should be the ouput/behaviour of command btrfs fi df
>
> Please refer to https://bugzilla.redhat.com/show_bug.cgi?id=1114995
>
> The comment by Eric Sendeen further complicates the understanding.
> (again with me:)
>
> 1} The command btrfs fi df has been more or less been equated with
>   traditional df. The problem is that traditional df does not output
>   error when no path is given as what currently is done by btrfs fi df
It is OK to show all btrfs usage info when no path is given.
If no one rejects, I'll try to make patch to change the behavior of 
'btrfs fi di'
> 2} Traditional df outputs a column 'Mounted on' for each device/fs it
>   finds which btrfs fi df does not. For Ex.
>
>   [vikram@localhost ~]# df
>   Filesystem     1K-blocks      Used Available Use% Mounted on
>   /dev/sdb6      153942744  69903440  81431312  47% /
>   devtmpfs         1520392         0   1520392   0% /dev
>   tmpfs            1527612      1444   1526168   1% /dev/shm
>   tmpfs            1527612      9108   1518504   1% /run
>   tmpfs            1527612         0   1527612   0% /sys/fs/cgroup
>   tmpfs            1527612       120   1527492   1% /tmp
>   /dev/sda1        1515376    172040   1248312  13% /boot
>   /dev/dm-0      330327632 230022072  97561080  71% /home/vikram
>
>   [vikram@localhost ~]# btrfs fi df /usr/
>   Data, RAID1: total=42.00GiB, used=32.44GiB
>   System, RAID1: total=32.00MiB, used=12.00KiB
>   Metadata, RAID1: total=2.00GiB, used=915.04MiB
>
>   [vikram@localhost ~]# btrfs fi df /
>   Data, RAID1: total=42.00GiB, used=32.44GiB
>   System, RAID1: total=32.00MiB, used=12.00KiB
>   Metadata, RAID1: total=2.00GiB, used=915.04MiB
'btrfs fi df' uses btrfs-only ioctl to get usage info, so it's OK when a 
non-mountpoint
file is given.
Although this should be fixed by checking whether the parameter is a 
mountpoint.
I'll also try to fix this too.
>
>  [ivikram@localhost ~]# btrfs fi show
>  Label: 'fedora'  uuid: d2b3420c-99c1-44cc-a922-ac266072c7fb
>          Total devices 2 FS bytes used 33.33GiB
>          devid    2 size 73.51GiB used 44.03GiB path /dev/sdb6
>          devid    3 size 73.30GiB used 44.03GiB path /dev/sda2
>
>  Label: 'Vikram'  uuid: 0809b072-35f3-4866-92b8-af4772b23ed6
>          Total devices 2 FS bytes used 109.68GiB
>          devid    1 size 158.03GiB used 157.00GiB path /dev/dm-0
>          devid    2 size 157.00GiB used 157.00GiB path /dev/mapper/sdb1
>
I'm very sorry that I did catch the point why 'btrfs fi show' is used 
here and what's the problem.
It would be very nice if you can explain what's wrong with 'btrfs fi show'.

> So there in no way to understand if there was an error (except for non 
> existant
> path) in the path argument given to btrfs fi df. This can create a lot of
> confusion in administeration.
>
> So IMHO some changes need to done to btrfs fi df.
>
> 1} The requirement for path arg be removed, since that gives a false 
> impression
>   by a valid output that the arg was correct as in fs mount point 
> sense POV.
As mentioned above, there are 2 points related to it.
1.1) default behavior change when no arg is given
It is OK to show all btrfs disk usage when no arg is given just like 
'df' command.

1.2) add mount point check
This can be done quite easily.

>
> 2} btrfs fi df should output the mount point in all cases:
>   a} Where arg path is valid but not a mount point. Should output 
> btrfs FS info with mount point as traditional df.
Nice idea. I'll add a warning about this.
>   b} Where arg path is valid & is also a mount point. Should show 
> output for that mount only.
Current behavior already.
>   c} Where no arg is given, Should output all btrfs FSes info with 
> mount points.
Point 1.1) will cover this.
>
> 3} btrfs fi df should error out on an invalid path as it does currently.
Point 1.2) will cover this.
>
> Thanks for your precious time.
>

