From: TAXI <taxi@a-city.de>
Subject: Re: How to expand a BTRFS partition... backwards
Date: Sun, 02 May 2010 10:10:12 +0200
Message-ID: <4BDD3364.2050600@a-city.de>
References: <j2v8a48dc7a1005012232pa765876fscc41e97b940333de@mail.gmail.com>	 <4BDD128C.7020606@a-city.de> <v2x8a48dc7a1005012323je884dfc4qc7a7f7bd67f786aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <v2x8a48dc7a1005012323je884dfc4qc7a7f7bd67f786aa@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I played a bit with my btrfs partition and btrfs filesystem resize
didn't work.
But I found a commando that worked:
btrfsctl -r max /mnt/btrfs
(yes, on the mounted FS -
http://kerneltrap.org/Linux/Btrfs_Online_Resizing_Ext3_Conversion_and_More )

But I don't know if expanding is possible backwards. I have no free
drive to test.

Am 02.05.2010 08:23, schrieb Sebastian 'gonX' Jensen:
> Thanks, I figured that the new btrfs tool would have something easier.
> Now I only need to know whether expanding btrfs is also possible
> backwards on the harddrive.
> 
> Regards,
> Sebastian J.
> 
> On 2 May 2010 07:50, TAXI <taxi@a-city.de> wrote:
>> The manpage says:
>>       filesystem resize [+/-]<size>[gkm]|max <path>
>>              Resize  a filesystem identified by <path>.  The <size>
>> parameter
>>              specifies the new size of the filesystem.  If the prefix +
>> or  -
>>              is  present  the  size is increased or decreased by the
>> quantity
>>              <size>.  If no units are  specified,  the  unit  of  the
>> <size>
>>              parameter  defaults to bytes. Optionally, the size
>> parameter may
>>              be suffixed by one of the following the units designators:
>>  'K',
>>              'M', or 'G', kilobytes, megabytes, or gigabytes, respectively.
>>
>>              If  'max'  is  passed,  the filesystem will occupy all
>> available
>>              space on the volume(s).
>>
>>              The resize command does not manipulate the  size  of
>> underlying
>>              partition.  If you wish to enlarge/reduce a filesystem,
>> you must
>>              make sure you can expand  the  partition  before
>> enlarging  the
>>              filesystem  and  shrink the partition after reducing the
>> size of
>>              the filesystem.
>>
>> (this is for the new btrfs - btrfsctl shoud do something similar).
>> So, as I read it, simply expand (recreate) the partitions (as you sayed)
>> and use:
>> btrfs resize max /dev/sdxY (or something similay in brtfsctl).
>>
>> But I can't give you a guarantee as I simply interpreted the manpage
>> right now and never tried this.
>>
>> P.s. sorry for my bad english :)
>>
>> Am 02.05.2010 07:32, schrieb Sebastian 'gonX' Jensen:
>>> Hey guys,
>>>
>>> I kinda figured out the syntax for resizing BTRFS arrays, but is it
>>> possible to use free space that is behind the current BTRFS partition?
>>> I kinda figure it's not, but ideally I'd like it so that there is no
>>> unused disk space on the disk.
>>>
>>> My partition setup looks something like this:
>>>
>>> Partition 1: 100MB (used)
>>> Partition 2: 256MB (not used, this is what I want to use)
>>> Partition 3: 200GB (used, for BTRFS)
>>> Partition 4: 50GB (not used, but this will be expanded to the current
>>> BTRFS partition)
>>>
>>> Also as a last note (just in case I've misunderstood something), to
>>> resize properly, you should first delete the partition using a
>>> partition editor like fdisk, then recreate a new partition with the
>>> same start cylinders as the original setup, but with bigger/later end
>>> cylinders than the original setup, right? Then e.g. btrfsctl -r +45G /
>>> What if I have a RAID-0 array (which I do), which uses the RAID-0
>>> routine by BTRFS (and not mdraid or dmraid). Should I then do a
>>> "btrfsctl -R +(size*disks)G /" or btrfsctl -R +(size of all disks)G
>>> /"?
>>>
>>> Regards,
>>> Sebastian J.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 
