Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43973 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaARHyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jan 2014 02:54:17 -0500
Received: by mail-ea0-f172.google.com with SMTP id g15so1535305eak.31
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 23:54:15 -0800 (PST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: ENOSPC during balance
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
In-Reply-To: <20140113174344.GQ6498@twin.jikos.cz>
Date: Sat, 18 Jan 2014 08:54:13 +0100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B94AC96D-3F9A-42DD-BC97-2029CEEBA16D@yerf-it.nl>
References: <97A7F0AC-8A96-4BFA-A6C0-DD878629FCF2@yerf-it.nl> <20140113174344.GQ6498@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



i did a `btrfs file convert -dconvert=raid10,soft /data`, which converted the whole filesystem back to raid10, it completed without errors.
then i did a `btrfs convert -dconvert=raid1 /data`, which completed with 184 ENOSPC errors, exactly the same amount as before the covert back to raid10



On 13 Jan 2014, at 18:43, David Sterba <dsterba@suse.cz> wrote:

> On Sun, Jan 12, 2014 at 03:49:12PM +0100, Remco Hosman - Yerf IT wrote:
>> I am trying to convert my array from raid10 to 1, and its partially
>> completed, but at the moment i am getting a '59366.459092] btrfs: 185
>> enospc errors during balance’ when i try to balance anything more with
>> `btrfs bal start -dconvert=raid1,soft /mountpoint`
>> 
>> I have already scanned for files with extends over 1gig gig, and there
>> is at least 100gig unallocated on each of the disks, and scrub reports
>> no error at all.
>> Kernel is 3.13-rc7 and tools are latest from git.
> 
> By unalocated you mean from 'btrfs fi df' output "total - used = 100G"
> or that the sum of all occupied space is 100G less than the device size?
> So if there's some space left to allocate new 1G-chunks for balance.
> 
> How many disks does the fs contain?
> 

filesystem is 6 disks of varying sizes.

>> Anything else i can try ?
> 
> Run
> $ btrfs balance start -dusage=0,profiles=raid10\|raid1 /mnt
> 
> if there are some chunks preallocated from previous balance runs, this
> will clean them. The -musage=0 filter could also get some space.
> 
> I've experienced similar problems with conversion from raid1 to raid10,
> where it's probably worse regarding the 1G-chunks, because the raid-0
> level needs the chunk on each disk, while raid1 is fine with just 2.
> 
> I had done the -dusage=0 cleanup step every time the 'enospc during
> balance' was hit, and it finished in the end. Not perfect, an automatic
> and more intelligent chunk reclaim is among the project ideas though.
> 
> If nothing from above helps, please post the output of 'fi df' and 'fi
> show' commands.
> 

i did a `btrfs bal start -dconvert=raid10,soft /data`, and it completed without errors.
then a `btrfs bal start -donvert=raid1 /data`, which resulted in 184 ENOSPC errors.

currently, the filesystem looks like this:

Data, RAID10: total=431.57GiB, used=430.22GiB
Data, RAID1: total=5.18TiB, used=5.18TiB
System, RAID10: total=96.00MiB, used=804.00KiB
Metadata, RAID10: total=12.38GiB, used=9.34GiB

Label: data  uuid: a8626d67-4684-4b23-99b3-8d5fa8e7fd69
	Total devices 6 FS bytes used 5.61TiB
	devid    1 size 1.82TiB used 1.27TiB path /dev/sdg2
	devid    2 size 1.82TiB used 1.27TiB path /dev/sdb2
	devid    3 size 1.82TiB used 1.27TiB path /dev/sdf2
	devid    5 size 2.73TiB used 2.17TiB path /dev/sdd2
	devid    10 size 2.73TiB used 2.18TiB path /dev/sde2
	devid    11 size 3.64TiB used 3.08TiB path /dev/sdc1

when i do a `btrfs bal start -dconvert=raid1,soft /data` :
dmesg: [560325.834835] btrfs: 184 enospc errors during balance

Data, RAID10: total=428.57GiB, used=428.57GiB
Data, RAID1: total=5.72TiB, used=5.18TiB
System, RAID10: total=96.00MiB, used=880.00KiB
Metadata, RAID10: total=12.38GiB, used=9.34GiB

Label: data  uuid: a8626d67-4684-4b23-99b3-8d5fa8e7fd69
	Total devices 6 FS bytes used 5.61TiB
	devid    1 size 1.82TiB used 1.45TiB path /dev/sdg2
	devid    2 size 1.82TiB used 1.44TiB path /dev/sdb2
	devid    3 size 1.82TiB used 1.44TiB path /dev/sdf2
	devid    5 size 2.73TiB used 2.35TiB path /dev/sdd2
	devid    10 size 2.73TiB used 2.36TiB path /dev/sde2
	devid    11 size 3.64TiB used 3.26TiB path /dev/sdc1

so it looks like it did allocate all the space it needed, but still failed

kernel is currently 3.13-rc7

Remco


> 
> david



