From: Stephane Chazelas <stephane.chazelas@googlemail.com>
Subject: Re: btrfs balancing start - and stop?
Date: Fri, 01 Apr 2011 19:33:30 +0100
Message-ID: <1301682810.11424.5.camel@sc.lan>
References: <Bj0igski1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj0igski1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2011-04-01 at 14:12 +0200, Helmut Hullen wrote:
> Hallo, Struan,
> 
> Du meintest am 01.04.11:
> 
> > 1) Is the balancing operation expected to take many hours (or days?)
> > on a filesystem such as this? Or are there known issues with the
> > algorithm that are yet to be addressed?
> 
> May be. Balancing about 15 GByte needed about 2 hours (or less),  
> balancing about 2 TByte needed about 20 hours.
[...]

I've got a balance running since Monday on a 9TB volume (3.5 of which
are used, 3.2 allegedly free), showing no sign of finishing soon. Should
I be worried?

Using /proc/sys/vm/block_dump, I can see it's seeking all over the
place, which is probably why throughput is not high. I can also see it
writing several times to the same sectors.

# df -h /backup
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda4             8.2T  3.5T  3.2T  53% /backup
# btrfs fi sh
Label: none  uuid: ...
        Total devices 3 FS bytes used 3.43TB
        devid    4 size 2.73TB used 1.16TB path /dev/sdc
        devid    3 size 2.73TB used 1.16TB path /dev/sdb
        devid    2 size 2.70TB used 1.14TB path /dev/sda4

Btrfs Btrfs v0.19
# ps -eolstart,args | grep balance
Mon Mar 28 11:18:18 2011 sudo btrfs fi balance /backup
Mon Mar 28 11:18:18 2011 btrfs fi balance /backup
# date
Fri Apr  1 19:28:40 BST 2011
# btrfs fi df /backup
Data, RAID0: total=3.41TB, used=3.41TB
System, RAID1: total=16.00MB, used=232.00KB
Metadata, RAID1: total=27.75GB, used=20.47GB
# iostat -md
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda              14.49         2.37         2.39     903123     913112
sdc             501.23         2.68         5.06    1022456    1928462
sdb             477.28         2.58         5.06     982853    1928482

It's already written more than the used space.

Cheers,
Stephane

