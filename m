Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:34108 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760197Ab2JYT67 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 15:58:59 -0400
Message-ID: <50899A28.1050907@inwind.it>
Date: Thu, 25 Oct 2012 21:59:36 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it> <CAE5mzvgem05HN1QTFb6FkhHv0U=e1PTo7idPy06SR97cMbpFLg@mail.gmail.com>
In-Reply-To: <CAE5mzvgem05HN1QTFb6FkhHv0U=e1PTo7idPy06SR97cMbpFLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-25 21:40, cwillu wrote:
>> I don't publish the patched because aren't in a good shape. However I
>> really like the output. The example is a filesystem based on three
>> disks of 3GB.
>>
>> It is clear that:
>> - - RAID0 uses all the disks
>> - - RAID1 uses two different disks
>>
>> Comments are welcome.
>>
>> Known bugs:
>> - - if a filesystem uses a disk but there is any chunk, the disk is not
>> shown (solvable)
>> - - this command need root capability (I use the BTRFS_IOC_TREE_SEARCH
>> to get the chunk info; so that is unavoidable)
>>
>>
>> ghigo@emulato:~$ sudo ./btrfs fi df /mnt/btrfs1/
>> [sudo] password for ghigo:
>> Path: /mnt/btrfs1
>> Summary:
>>   Disk_size:               9.00GB
>>   Disk_allocated:          1.83GB
>>   Disk_unallocated:        7.17GB
>>   Used:                  284.00KB
>>   Free_(Estimated):        6.76GB       (Max: 8.54GB, min: 4.96GB)
>>   Data_to_disk_ratio:        75 %
>>
>> Allocated_area:
>>   Data,RAID0: Size:921.75MB, Used:256.00KB
>>      /dev/vdc     307.25MB
>>      /dev/vdb     307.25MB
>>      /dev/vdd     307.25MB
>>
>>   Data,Single: Size:8.00MB, Used:0.00
>>      /dev/vdb       8.00MB
>>
>>   System,RAID1: Size:8.00MB, Used:4.00KB
>>      /dev/vdd       8.00MB
>>      /dev/vdc       8.00MB
>>
>>   System,Single: Size:4.00MB, Used:0.00
>>      /dev/vdb       4.00MB
>>
>>   Metadata,RAID1: Size:460.94MB, Used:24.00KB
>>      /dev/vdb     460.94MB
>>      /dev/vdd     460.94MB
>>
>>   Metadata,Single: Size:8.00MB, Used:0.00
>>      /dev/vdb       8.00MB
>>
>>   Unused:
>>      /dev/vdb       2.23GB
>>      /dev/vdc       2.69GB
>>      /dev/vdd       2.24GB
> 
> Couple minor things, in order of personal opinion of severity:
> 
> * Devices should be listed in a consistent order; device names are
> just too consistently similar
Could you elaborate ? I didn't understood well

> 
> * System chunks shouldn't be listed between data and metadata; really,
> they're just noise 99% of the time anyway

Frankly speaking I don't know what contains. We can discuss a sorting or
an option to show/hide (depending by by the default)

> 
> * I think it may be more useful to display each disk, with the
> profiles in use underneath.  With a larger number of disks, that would
> make it _much_ easier to tell at-a-glance what is currently on a disk
> (that I may want to remove, or which I may suspect to be unreliable).
> 
> * I'd rename "Unused" to "Unallocated" for consistency with the section title
Yes


> * (and I still detest the_underscores_between_all_the_words; it
> doesn't make parsing significantly easier, and it's an eyesore)
:-) we can work on that.

> 
> * Three coats of blue paint plus a clear-coat is the One True Paint-Job.
> .
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
