From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Tue, 12 Apr 2011 15:22:57 +0800
Message-ID: <4DA3FDD1.2090804@cn.fujitsu.com>
References: <BjW+GU4y1uB@helmut.hullen.de> <20110409091141.GE5301@carfax.org.uk> <4DA182DF.6010703@cn.fujitsu.com> <chaz20110411072946.GA5587@seebyte.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110411072946.GA5587@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 11 Apr 2011 08:29:46 +0100, Stephane Chazelas wrote:
> 2011-04-10 18:13:51 +0800, Miao Xie:
> [...]
>>>> # df /srv/MM
>>>>
>>>> Filesystem           1K-blocks      Used Available Use% Mounted on
>>>> /dev/sdd1            5846053400 1593436456 2898463184  36% /srv/MM
>>>>
>>>> # btrfs filesystem df /srv/MM
>>>>
>>>> Data, RAID0: total=1.67TB, used=1.48TB
>>>> System, RAID1: total=16.00MB, used=112.00KB
>>>> System: total=4.00MB, used=0.00
>>>> Metadata, RAID1: total=3.75GB, used=2.26GB
>>>>
>>>> # btrfs-show
>>>>
>>>> Label: MMedia  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
>>>> 	Total devices 3 FS bytes used 1.48TB
>>>> 	devid    3 size 1.81TB used 573.76GB path /dev/sdb1
>>>> 	devid    2 size 1.81TB used 573.77GB path /dev/sde1
>>>> 	devid    1 size 1.82TB used 570.01GB path /dev/sdd1
>>>>
>>>> Btrfs Btrfs v0.19
>>>>
>>>> ------------------------------------------------
>>>>
>>>> "df" shows an "Available" value which isn't related to any real value.  
>>>
>>>    I _think_ that value is the amount of space not allocated to any
>>> block group. If that's so, then Available (from df) plus the three
>>> "total" values (from btrfs fi df) should equal the size value from df.
>>
>> This value excludes the space that can not be allocated to any block group,
>> This feature was implemented to fix the bug df command add the disk space, which
>> can not be allocated to any block group forever, into the "Available" value.
>> (see the changelog of the commit 6d07bcec969af335d4e35b3921131b7929bd634e)
>>
>> This implementation just like fake chunk allocation, but the fake allocation
>> just allocate the space from two of these three disks, doesn't spread the
>> stripes over all the disks, which has enough space.
> [...]
> 
> Hi Miao,
> 
> would you care to expand a bit on that. In Helmut's case above
> where all the drives have at least 1.2TB free, how would there
> be un-allocatable space?
> 
> What's the implication of having disks of differing sizes? Does
> that mean that the extra space on larger disks is lost?

I'm sorry that I couldn't explain it clearly.

As we know, Btrfs introduced RAID fucntion, and it can allocate some stripes from
different disks to make up a RAID block group. But if there is not enough disk space
to allocate enough stripes, btrfs can't make up a new block group, and the left disk
space can't be used forever. 

For example, If we have two disks, one is 5GB, and the other is 10GB, and we use RAID0
block groups to store the file data. The RAID0 block group needs two stripes which are
on the different disks at least. After all space on the 5GB disk is allocated, there is
about 5GB free space on the 10GB disk, this space can not be used because we have
no free space on the other disk to allocate, and can't make up a new RAID0 block group. 

Beside the two-stripe limit, the chunk allocator will allocate stripes from every disk
as much as possible, to make up a new RAID0 block group. That is if all the disks have
enough free space, the allocator will allocate stripes from all the disks.

In Helmut's case, the chunk allocator will allocate three same-size stripes from those
three disks to make up the new RAID0 block group, every time btrfs allocate new chunks
(block groups), until there is no free space on two disks. So btrfs can use most of the
disk space for RAID0 block group.

But the algorithm of df command doesn't simulate the above allocation correctly, this
simulated allocation just allocates the stripes from two disks, and then, these two disks
have no free space, but the third disk still has 1.2TB free space, df command thinks
this space can be used to make a new RAID0 block group and ignores it. This is a bug,
I think.

BTW: "Available" value is the size of the free space that we may use it to store the file
data. In btrfs filesystem, it is hard to calculate, because the block groups are allocated
dynamically, not all the free space on the disks is allocated to make up data block groups,
some of the space may be allocated to make up data block groups. So we just tell the users
the size of free space maybe they can use to store the file data.

Thanks
Miao

> 
> Thanks,
> Stephane
> 

