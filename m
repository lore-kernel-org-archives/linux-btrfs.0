From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Sun, 10 Apr 2011 18:13:51 +0800
Message-ID: <4DA182DF.6010703@cn.fujitsu.com>
References: <BjW+GU4y1uB@helmut.hullen.de> <20110409091141.GE5301@carfax.org.uk>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Hugo Mills <hugo-lkml@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409091141.GE5301@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On sat, 9 Apr 2011 10:11:41 +0100, Hugo Mills wrote:
> On Sat, Apr 09, 2011 at 08:25:00AM +0200, Helmut Hullen wrote:
>> Hallo, linux-btrfs,
>>
>> First I create an array of 2 disks with
>>
>>   mkfs.btrfs -d raid0 -m raid1 /dev/sdb1 /dev/sdd1
>>
>> and mount it at /srv/MM.
>>
>> Then I fill it with about 1,6 TByte.
>> And then I add /dev/sde1 via
>>
>>   btrfs device add /dev/sde1 /srv/MM
>>   btrfs filesystem balance /srv/MM
>>     (it run about 20 hours)
>>
>> Then I work on it, copy some new files, delete some old files - all  
>> works well. Only
>>
>>   df /srv/MM
>>   btrfs filesystem df /srv/MM
>>
>> show some completely wrong values:
>>
>> # df /srv/MM
>>
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> /dev/sdd1            5846053400 1593436456 2898463184  36% /srv/MM
>>
>> # btrfs filesystem df /srv/MM
>>
>> Data, RAID0: total=1.67TB, used=1.48TB
>> System, RAID1: total=16.00MB, used=112.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, RAID1: total=3.75GB, used=2.26GB
>>
>> # btrfs-show
>>
>> Label: MMedia  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
>> 	Total devices 3 FS bytes used 1.48TB
>> 	devid    3 size 1.81TB used 573.76GB path /dev/sdb1
>> 	devid    2 size 1.81TB used 573.77GB path /dev/sde1
>> 	devid    1 size 1.82TB used 570.01GB path /dev/sdd1
>>
>> Btrfs Btrfs v0.19
>>
>> ------------------------------------------------
>>
>> "df" shows an "Available" value which isn't related to any real value.  
> 
>    I _think_ that value is the amount of space not allocated to any
> block group. If that's so, then Available (from df) plus the three
> "total" values (from btrfs fi df) should equal the size value from df.

This value excludes the space that can not be allocated to any block group,
This feature was implemented to fix the bug df command add the disk space, which
can not be allocated to any block group forever, into the "Available" value.
(see the changelog of the commit 6d07bcec969af335d4e35b3921131b7929bd634e)

This implementation just like fake chunk allocation, but the fake allocation
just allocate the space from two of these three disks, doesn't spread the
stripes over all the disks, which has enough space.
 
I will post a patch to fix it soon.

> 
>> The sum of "used" and "Available" is far away from the really existent  
>> disk space. When I copy additional files to "/srv/MM" then "used" still  
>> shows the right value, and the sum grows (slowly) to the max. available  
>> space.
>>
>> In "btrfs filesystem df /srv/MM" the line
>>
>>   Data, RAID0: total=1.67TB, used=1.48TB
>>
>> shows a "total" value which isn't related to any existent value; maybe  
>> it still shows the used space before adding the third partition.
>> This (wrong) value seems not to change.
> 
>    It's not wrong -- it simply doesn't mean what you think it does. :)
> 
>    The total value in the output of "btrfs fi df" is the total space
> allocated to block groups. As the filesystem needs more space, it
> will allocate more block groups from the available raw storage pool,
> and the number will go up.
> 
>    This is explained on the wiki at [1].
> 
>    HTH,
>    Hugo.
> 
> [1] https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F
> 

