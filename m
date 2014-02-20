Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:53732 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaBTTRy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 14:17:54 -0500
Message-ID: <530654F2.1050208@inwind.it>
Date: Thu, 20 Feb 2014 20:18:10 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Kostia Khlebopros <kkhlebopros@netgear.com>
Subject: Re: [PATCH][BTRFS-PROGS][v4] Enhance btrfs fi df
References: <52FD1A72.5060307@libero.it> <20140220180857.GW16073@twin.jikos.cz>
In-Reply-To: <20140220180857.GW16073@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

below my comments

On 02/20/2014 07:08 PM, David Sterba wrote:
> On Thu, Feb 13, 2014 at 08:18:10PM +0100, Goffredo Baroncelli wrote:
>> space (if the next chunk are allocated as SINGLE) or the minimum one (
>> if the next chunks are allocated as DUP/RAID1/RAID10).
>>
>> The other two commands show the chunks in the disks.
>>
>> $ sudo btrfs filesystem disk-usage /mnt/btrfs1/
>> Data,Single: Size:8.00MB, Used:0.00
>>    /dev/vdb	    8.00MB
> 
> The information about per-device usage can be enhanced and there's
> enough space to print that:
> 
> * allocated in chunks (the number above)
This is the value already written.


> * actually used (simiar to what 'btrfs fi show' prints as 'used')

The "used" is a value returned by the ioctl BTRFS_IOC_SPACE_INFO,
which returns this value per group-block basis. See below.


> 
> I don't see a reason why it would not fit here, nor any other place
> where this can be obtained.
> 
> There is the cumulative number of 'Used' for all devices, but I'd like
> to see it per-device as well.
> 
>> or in tabular format
>>
>> $ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/
>>          Data   Data    Metadata Metadata System System             
>>          Single RAID6   Single   RAID5    Single RAID5   Unallocated
>>                                                                     
>> /dev/vdb 8.00MB  1.00GB   8.00MB   1.00GB 4.00MB  4.00MB     97.98GB
>> /dev/vdc      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
>> /dev/vdd      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
>> /dev/vde      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
>>          ====== ======= ======== ======== ====== ======= ===========
>> Total    8.00MB  2.00GB   8.00MB   3.00GB 4.00MB 12.00MB    391.97GB
>> Used       0.00 11.25MB     0.00  36.00KB   0.00  4.00KB            
>>
>> These are the most complete output, where it is possible to know which
>> disk a chunk uses and the usage of every chunk.
> 
> Though not per-device, similar to the above, but the tabular output is
> limited compared to the sequential output. Not sure what to do here.

The tabular is to have a "friendly" summary of how the filesystem is span 
on the different disks. I suggest to not add more info in the tabular

> 
>> Finally the last command shows which chunks a disk hosts:
>>
>> $ sudo ./btrfs device disk-usage /mnt/btrfs1/
>> /dev/vdb	  100.00GB
>>    Data,Single:              8.00MB
>>    Data,RAID6:               1.00GB
>>    Metadata,Single:          8.00MB
>>    Metadata,RAID5:           1.00GB
>>    System,Single:            4.00MB
>>    System,RAID5:             4.00MB
>>    Unallocated:             97.98GB
>>
>> /dev/vdc	  100.00GB
>>    Data,RAID6:               1.00GB
>>    Metadata,RAID5:           1.00GB
>>    System,RAID5:             4.00MB
>>    Unallocated:             98.00GB
>>
>> /dev/vdd	  100.00GB
>>    Data,RAID6:               1.00GB
>>    Metadata,RAID5:           1.00GB
>>    System,RAID5:             4.00MB
>>    Unallocated:             98.00GB
>>
>> /dev/vde	  100.00GB
>>    Data,RAID6:               1.00GB
>>    Metadata,RAID5:           1.00GB
>>    System,RAID5:             4.00MB
>>    Unallocated:             98.00GB
> 
>> More or less are the same information above, only grouped by disk.
> 
> Ie. it's only a variant of the 'filesystem usage' where it is grouped by
> blockgroup type.
> 
> Why doesn't 'btrfs device usage' take a device instead of the whole
> filesystem? This seems counterintuitive. It should be possible to
> ask for a device by it or path.

If a device is passed, what you would expect as output: the list of all the devices involved,or only the one(s) passed ? In other terms, the device passed has to act 
also as filter, or it is only a different way to indicate the path ?

> 
> Also, I'd like to see all useful information about the device:
> 
> * id, path, uuid, ... whatever
ok, we can add a "-v" switch to add these further information

> * physical device size
ok, it is already written

> * size visible by the filesystem
Could you be more explicit ? a) For each chunk (in each disk) or b) for each disk ? And how
this information per disk basis would be useful ?

Example (supposing 4 disks)
a)
/dev/vde	  100.00GB
    Data,RAID6:               Disk size:  1.00GB, FS size: 512.00MB
    Metadata,RAID5:           Disk size:  1.00GB, FS size: 750.00MB
    System,RAID5:             Disk size:  4.00MB, FS size;   3.00MB
    Unallocated:              Disk size: 98.00GB

b)
/dev/vde	  Disk size: 100.00GB, FS size: 1.28GB
    Data,RAID6:               1.00GB
    Metadata,RAID5:           1.00GB
    System,RAID5:             4.00MB
    Unallocated:             98.00GB



> * space allocated in chunks
ok, it is already written

> * space actually used
See my other comments


I am not against to add further information to btrfs dev [disk-]usage, but I liked 
the idea to add the minimum information to avoid ambiguities:
- the number on the left of the device is the device size 
- the number on the left of the block group is the space allocated on the disk
All the number are in terms of disk space.

> 
>> Unfortunately I don't have any information about the chunk usage per disk basis.
> 
> And I'm missing it. Is it a fundamental problem or just not addressed in
> this patchset?

As above, the "used" is a value returned by the ioctl BTRFS_IOC_SPACE_INFO,
which returns this value per group-block basis. I don't know how
calculates this values per device basis. If you give me some hints on 
how we can get these information, I can improve
the output.


> 
>> Finally I have to point out that the command btrfs fi df previous didn't require 
>> the root capability, now with my patches it is required, because I need 
>> to know some info about the chunks so I need to use the 
>> "BTRFS_IOC_TREE_SEARCH".
>>
>> I think that there are the following possibilities:
>> 1) accept this regresssion
>> 2) remove the command "btrfs fi df" and leave only "btrfs fi disk-usage" and
>>    "btrfs dev disk-usage"
>> 3) adding a new ioctl which could be used without root capability. Of course
>>    this ioctl would return only a subset of the BTRFS_IOC_TREE_SEARCH info
>>
>> I think that the 3) would be the "long term" solution. I am not happy about
>> the 1), so as "short term solution" I think that we should go with the 2).
>> What do you think ?
> 
> No sorry, 1) is not acceptable. We can live with this limitation only
> during development so we're not blocked by some new ioctl development.
> 
> No for 2), 'fi df' is useful as and widely used in existing scripts.

Of course I meant "from my patchset". I would leave the actual "fi df" implementation.
Anyway if you are talking about "existing scripts", this means that we cannot
touch the actual btrfs fi df at all, but we have to add a another 
command (btrfs fi free ?)

> 
> Yes for 3), we may also export the information through the existing
> ioctls if possible (eg. IOC_FS_INFO).

Of course this would be the best. But what if we do "btrfs fi df" in 
an old kernel ? It is acceptable to fall-back to the old output ?



> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
