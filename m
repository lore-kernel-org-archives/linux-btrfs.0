Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36140 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbcGGL6t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 07:58:49 -0400
Received: by mail-io0-f182.google.com with SMTP id l202so17589216ioe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 04:58:48 -0700 (PDT)
Subject: Re: raid1 has failing disks, but smart is clear
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>,
        Corey Coughlin <corey.coughlin.cc3@gmail.com>
References: <577D82AE.3040005@gmail.com>
 <03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7d6827bd-a978-13ab-6732-b7cf7d21bdb8@gmail.com>
Date: Thu, 7 Jul 2016 07:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-06 18:59, Tomasz Kusmierz wrote:
>
>> On 6 Jul 2016, at 23:14, Corey Coughlin <corey.coughlin.cc3@gmail.com> wrote:
>>
>> Hi all,
>>    Hoping you all can help, have a strange problem, think I know what's going on, but could use some verification.  I set up a raid1 type btrfs filesystem on an Ubuntu 16.04 system, here's what it looks like:
>>
>> btrfs fi show
>> Label: none  uuid: 597ee185-36ac-4b68-8961-d4adc13f95d4
>>    Total devices 10 FS bytes used 3.42TiB
>>    devid    1 size 1.82TiB used 1.18TiB path /dev/sdd
>>    devid    2 size 698.64GiB used 47.00GiB path /dev/sdk
>>    devid    3 size 931.51GiB used 280.03GiB path /dev/sdm
>>    devid    4 size 931.51GiB used 280.00GiB path /dev/sdl
>>    devid    5 size 1.82TiB used 1.17TiB path /dev/sdi
>>    devid    6 size 1.82TiB used 823.03GiB path /dev/sdj
>>    devid    7 size 698.64GiB used 47.00GiB path /dev/sdg
>>    devid    8 size 1.82TiB used 1.18TiB path /dev/sda
>>    devid    9 size 1.82TiB used 1.18TiB path /dev/sdb
>>    devid   10 size 1.36TiB used 745.03GiB path /dev/sdh
>>
>> I added a couple disks, and then ran a balance operation, and that took about 3 days to finish.  When it did finish, tried a scrub and got this message:
>>
>> scrub status for 597ee185-36ac-4b68-8961-d4adc13f95d4
>>    scrub started at Sun Jun 26 18:19:28 2016 and was aborted after 01:16:35
>>    total bytes scrubbed: 926.45GiB with 18849935 errors
>>    error details: read=18849935
>>    corrected errors: 5860, uncorrectable errors: 18844075, unverified errors: 0
>>
>> So that seems bad.  Took a look at the devices and a few of them have errors:
>> ...
>> [/dev/sdi].generation_errs 0
>> [/dev/sdj].write_io_errs   289436740
>> [/dev/sdj].read_io_errs    289492820
>> [/dev/sdj].flush_io_errs   12411
>> [/dev/sdj].corruption_errs 0
>> [/dev/sdj].generation_errs 0
>> [/dev/sdg].write_io_errs   0
>> ...
>> [/dev/sda].generation_errs 0
>> [/dev/sdb].write_io_errs   3490143
>> [/dev/sdb].read_io_errs    111
>> [/dev/sdb].flush_io_errs   268
>> [/dev/sdb].corruption_errs 0
>> [/dev/sdb].generation_errs 0
>> [/dev/sdh].write_io_errs   5839
>> [/dev/sdh].read_io_errs    2188
>> [/dev/sdh].flush_io_errs   11
>> [/dev/sdh].corruption_errs 1
>> [/dev/sdh].generation_errs 16373
>>
>> So I checked the smart data for those disks, they seem perfect, no reallocated sectors, no problems.  But one thing I did notice is that they are all WD Green drives.  So I'm guessing that if they power down and get reassigned to a new /dev/sd* letter, that could lead to data corruption.  I used idle3ctl to turn off the shut down mode on all the green drives in the system, but I'm having trouble getting the filesystem working without the errors.  I tried a 'check --repair' command on it, and it seems to find a lot of verification errors, but it doesn't look like things are getting fixed.
>>  But I have all the data on it backed up on another system, so I can recreate this if I need to.  But here's what I want to know:
>>
>> 1.  Am I correct about the issues with the WD Green drives, if they change mounts during disk operations, will that corrupt data?
> I just wanted to chip in with WD Green drives. I have a RAID10 running on 6x2TB of those, actually had for ~3 years. If disk goes down for spin down, and you try to access something - kernel & FS & whole system will wait for drive to re-spin and everything works OK. I’ve never had a drive being reassigned to different /dev/sdX due to spin down / up.
> 2 years ago I was having a corruption due to not using ECC ram on my system and one of RAM modules started producing errors that were never caught up by CPU / MoBo. Long story short, guy here managed to point me to the right direction and I started shifting my data to hopefully new and not corrupted FS … but I was sceptical of similar issue that you have described AND I did raid1 and while mounted I did shift disk from one SATA port to another and FS managed to pick up the disk in new location and did not even blinked (as far as I remember there was syslog entry to say that disk vanished and then that disk was added)
>
> Last word, you got plenty of errors in your SMART for transfer related stuff, please be advised that this may mean:
> - faulty cable
> - faulty mono controller
> - faulty drive controller
> - bad RAM - yes, mother board CAN use your ram for storing data and transfer related stuff … specially chapter ones.
It's worth pointing out that the most likely point here for data 
corruption assuming the cable and controllers are OK is during the DMA 
transfer from system RAM to the drive controller.  Even when dealing 
with really good HBA's that have an on-board NVRAM cache, you still have 
to copy the data out of system RAM at some point, and that's usually 
when the corruption occurs if the problem is with the RAM, CPU or MB.
>
>> 2.  If that is the case:
>>    a.) Is there any way I can stop the /dev/sd* mount points from changing?  Or can I set up the filesystem using UUIDs or something more solid?  I googled about it, but found conflicting info
> Don’t get it the wrong way but I’m personally surprised that anybody still uses mount points rather than UUID. Devices change from boot to boot for a lot of people and most of distros moved to uuid (2 years ago ? even the swap is mounted via UUID now)
>
Providing there are no changes in hardware configuration, device nodes 
(which is what /dev/sd* are, not mount points) remain relatively stable 
across boot.  My personal recommendation would be to mount by label, not 
UUID, and give your filesystems relatively unique names (in my case, I 
have a short identifier to ID the system the FS is for, followed by a 
tag identifying where in the hierarchy it gets mounted).  Mounting by 
UUID works, until you have to recreate the FS from scratch and restore a 
backup, because then you have a different UUID.
>>    b.) Or, is there something else changing my drive devices?  I have most of drives on an LSI SAS 9201-16i card, is there something I need to do to make them fixed?
> I’ll let more senior data storage experts to speak up but most of the time people frowned on me for mentioning anything different than north bridge / Intel raid card / super micro / 3 ware .
>
> (And yes I did found the hard way they were right:
> - marvel controller on my mobo randomly writes garbage to your drives
> - adapted PCI express card was switching of all the drives mid flight while pretending “it’s OK” resulting in very peculiar data losses in the middle of big file.
Based on personal experience:
1. LSI Logic, Super Micro, Intel, and 3 Ware all generally have very 
high quality HBA's (both RAID and non-RAID)
2. HighPoint and ASMedia (ASUS's internal semi-conductor branch) are 
decent if you get recent cards.
3. Marvell, Adaptec, and Areca are hit or miss, some work great, some 
are horrible.
4. I have never had a JMicron based card that worked reliably.
5. If it's in a server and branded by the manufacturer of that server, 
it's probably a good adapter.
>
>>    c.) Or, is there a script or something I can use to figure out if the disks will change mounts?
>>    d.) Or, if I wipe everything and rebuild, will the disks with the idle3ctl fix work now?
>>
>> Regardless of whether or not it's a WD Green drive issue, should I just wipefs all the disks and rebuild it?  Is there any way to recover this?  Thanks for any help!
>
> IF you remotelly care about the data that you have (I think you should if you came here), I would suggest a good exercise:
> - unplug all the drives you use for this file system and stop toying with it because you may loose more data (I did because I thought I knew better)
> - get your self 2 new drives
> - find my thread from ~2 years ago on this mailing list (might be different email address)
> - try to locate Chris Mason reply with a script “my old friend”
> - run this script on you system for couple of DAYS and you will see whenever you have any corruption creeping in
> - if corruptions are creeping in, change a component in your system (controller / RAM / mobo / CPU / PSU) and repeat exercise (best to organise your self access to some spare parts / extra machine.
> - when all is good, make and FS out of those 2 new drives, and try to rescue data from OLD FS !
> - unplug new FS and put it one the shelf
> - try to fix old FS … this will be a FUN and very educating exercise …
FWIW, based on what's been said, I'm almost certain it's a hardware 
issue, and would give better than 50/50 odds that it's bad RAM or a bad 
storage controller.  In general, here's the order I'd swap things in if 
you have spares:
1. RAM (If you find that RAM is the issue, try each individual module 
separately to figure out which one is bad, if they all appear bad, it's 
either a power issue or something is wrong with your MB).
2. Storage Controller
3. PSU (if you have a multi-meter and a bit of wire, or a PSU tester, 
you can check this without needing a spare).
4. MB
5. CPU

Other things to consider regarding power:
1. If you're using a UPS, make sure it lists either 'True sine wave 
output' or 'APFC' support, many cheap ones produce a quantized sine wave 
output which causes issues with many modern computer PSU's.
2. If you're not using a UPS, you may have issues with what's 
colloquially known as 'dirty' power.  In signal theory terms, this means 
that you've got a noise source mixed in with the 50/60Hz sine wave 
that's supposed to be present on line power.  This is actually a 
surprisingly common issue in many parts of the world because of the 
conditions of the transmission lines and the power plant itself. 
Somewhat ironically, one of the most reliable ways to deal with this is 
to get a UPS (and if you do, make sure and look for one that meets what 
I said above)
Both issues can manifest almost identically to having bad RAM or a bad 
PSU, but they're often expensive to fix, and in the second case, not 
easy to test for.
