From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Sat, 9 Apr 2011 10:46:14 +0100
Message-ID: <20110409094614.GA6883@yahoo.fr>
References: <BjW+GU4y1uB@helmut.hullen.de>
 <20110409091141.GE5301@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo-lkml@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409091141.GE5301@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

2011-04-09 10:11:41 +0100, Hugo Mills:
[...]
> > # df /srv/MM
> > 
> > Filesystem           1K-blocks      Used Available Use% Mounted on
> > /dev/sdd1            5846053400 1593436456 2898463184  36% /srv/MM
> > 
> > # btrfs filesystem df /srv/MM
> > 
> > Data, RAID0: total=1.67TB, used=1.48TB
> > System, RAID1: total=16.00MB, used=112.00KB
> > System: total=4.00MB, used=0.00
> > Metadata, RAID1: total=3.75GB, used=2.26GB
> > 
> > # btrfs-show
> > 
> > Label: MMedia  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
> > 	Total devices 3 FS bytes used 1.48TB
> > 	devid    3 size 1.81TB used 573.76GB path /dev/sdb1
> > 	devid    2 size 1.81TB used 573.77GB path /dev/sde1
> > 	devid    1 size 1.82TB used 570.01GB path /dev/sdd1
> > 
> > Btrfs Btrfs v0.19
> > 
> > ------------------------------------------------
> > 
> > "df" shows an "Available" value which isn't related to any real value.  
> 
>    I _think_ that value is the amount of space not allocated to any
> block group. If that's so, then Available (from df) plus the three
> "total" values (from btrfs fi df) should equal the size value from df.
[...]

Well,

$ echo $((2898463184 + 1.67*2**30 + 4*2**10 + 16*2**10*2 + 3.75*2**20*2))
4699513214.0799999

I do get the same kind of discrepancy:

$ df -h /mnt
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb              8.2T  3.5T  3.2T  53% /mnt
$ sudo btrfs fi show
Label: none  uuid: ...
        Total devices 3 FS bytes used 3.43TB
        devid    4 size 2.73TB used 1.17TB path /dev/sdc
        devid    3 size 2.73TB used 1.17TB path /dev/sdb
        devid    2 size 2.70TB used 1.14TB path /dev/sda4
$ sudo btrfs fi df /mnt
Data, RAID0: total=3.41TB, used=3.41TB
System, RAID1: total=16.00MB, used=232.00KB
Metadata, RAID1: total=35.25GB, used=20.55GB


$ echo $((3.2 + 3.41 + 2*16/2**20 + 2*35.25/2**10))
6.6788476562500003

-- 
Stephane

