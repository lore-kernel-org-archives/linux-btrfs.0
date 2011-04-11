From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Mon, 11 Apr 2011 08:29:46 +0100
Message-ID: <chaz20110411072946.GA5587@seebyte.com>
References: <BjW+GU4y1uB@helmut.hullen.de> <20110409091141.GE5301@carfax.org.uk> <4DA182DF.6010703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA182DF.6010703@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-04-10 18:13:51 +0800, Miao Xie:
[...]
> >> # df /srv/MM
> >>
> >> Filesystem           1K-blocks      Used Available Use% Mounted on
> >> /dev/sdd1            5846053400 1593436456 2898463184  36% /srv/MM
> >>
> >> # btrfs filesystem df /srv/MM
> >>
> >> Data, RAID0: total=1.67TB, used=1.48TB
> >> System, RAID1: total=16.00MB, used=112.00KB
> >> System: total=4.00MB, used=0.00
> >> Metadata, RAID1: total=3.75GB, used=2.26GB
> >>
> >> # btrfs-show
> >>
> >> Label: MMedia  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
> >> 	Total devices 3 FS bytes used 1.48TB
> >> 	devid    3 size 1.81TB used 573.76GB path /dev/sdb1
> >> 	devid    2 size 1.81TB used 573.77GB path /dev/sde1
> >> 	devid    1 size 1.82TB used 570.01GB path /dev/sdd1
> >>
> >> Btrfs Btrfs v0.19
> >>
> >> ------------------------------------------------
> >>
> >> "df" shows an "Available" value which isn't related to any real value.  
> > 
> >    I _think_ that value is the amount of space not allocated to any
> > block group. If that's so, then Available (from df) plus the three
> > "total" values (from btrfs fi df) should equal the size value from df.
> 
> This value excludes the space that can not be allocated to any block group,
> This feature was implemented to fix the bug df command add the disk space, which
> can not be allocated to any block group forever, into the "Available" value.
> (see the changelog of the commit 6d07bcec969af335d4e35b3921131b7929bd634e)
> 
> This implementation just like fake chunk allocation, but the fake allocation
> just allocate the space from two of these three disks, doesn't spread the
> stripes over all the disks, which has enough space.
[...]

Hi Miao,

would you care to expand a bit on that. In Helmut's case above
where all the drives have at least 1.2TB free, how would there
be un-allocatable space?

What's the implication of having disks of differing sizes? Does
that mean that the extra space on larger disks is lost?

Thanks,
Stephane
