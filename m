Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33406 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbcGGGkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 02:40:33 -0400
Received: by mail-pf0-f173.google.com with SMTP id i123so3566507pfg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 23:40:33 -0700 (PDT)
Subject: Re: raid1 has failing disks, but smart is clear
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
References: <577D82AE.3040005@gmail.com>
 <03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Corey Coughlin <corey.coughlin.cc3@gmail.com>
Message-ID: <577DF95E.7080100@gmail.com>
Date: Wed, 6 Jul 2016 23:40:30 -0700
MIME-Version: 1.0
In-Reply-To: <03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Tomasz,
     Thanks for the response!  I should clear some things up, though.

On 07/06/2016 03:59 PM, Tomasz Kusmierz wrote:
>> On 6 Jul 2016, at 23:14, Corey Coughlin <corey.coughlin.cc3@gmail.com> wrote:
>>
>> Hi all,
>>     Hoping you all can help, have a strange problem, think I know what's going on, but could use some verification.  I set up a raid1 type btrfs filesystem on an Ubuntu 16.04 system, here's what it looks like:
>>
>> btrfs fi show
>> Label: none  uuid: 597ee185-36ac-4b68-8961-d4adc13f95d4
>>     Total devices 10 FS bytes used 3.42TiB
>>     devid    1 size 1.82TiB used 1.18TiB path /dev/sdd
>>     devid    2 size 698.64GiB used 47.00GiB path /dev/sdk
>>     devid    3 size 931.51GiB used 280.03GiB path /dev/sdm
>>     devid    4 size 931.51GiB used 280.00GiB path /dev/sdl
>>     devid    5 size 1.82TiB used 1.17TiB path /dev/sdi
>>     devid    6 size 1.82TiB used 823.03GiB path /dev/sdj
>>     devid    7 size 698.64GiB used 47.00GiB path /dev/sdg
>>     devid    8 size 1.82TiB used 1.18TiB path /dev/sda
>>     devid    9 size 1.82TiB used 1.18TiB path /dev/sdb
>>     devid   10 size 1.36TiB used 745.03GiB path /dev/sdh
Now when I say that the drives mount points change, I'm not saying they 
change when I reboot.  They change while the system is running.  For 
instance, here's the fi show after I ran a "check --repair" run this 
afternoon:

btrfs fi show
Label: none  uuid: 597ee185-36ac-4b68-8961-d4adc13f95d4
     Total devices 10 FS bytes used 3.42TiB
     devid    1 size 1.82TiB used 1.18TiB path /dev/sdd
     devid    2 size 698.64GiB used 47.00GiB path /dev/sdk
     devid    3 size 931.51GiB used 280.03GiB path /dev/sdm
     devid    4 size 931.51GiB used 280.00GiB path /dev/sdl
     devid    5 size 1.82TiB used 1.17TiB path /dev/sdi
     devid    6 size 1.82TiB used 823.03GiB path /dev/sds
     devid    7 size 698.64GiB used 47.00GiB path /dev/sdg
     devid    8 size 1.82TiB used 1.18TiB path /dev/sda
     devid    9 size 1.82TiB used 1.18TiB path /dev/sdb
     devid   10 size 1.36TiB used 745.03GiB path /dev/sdh

Notice that /dev/sdj in the previous run changed to /dev/sds.  There was 
no reboot, the mount just changed.  I don't know why that is happening, 
but it seems like the majority of the errors are on that drive.  But 
given that I've fixed the start/stop issue on that disk, it probably 
isn't a WD Green issue.

>>
>> I added a couple disks, and then ran a balance operation, and that took about 3 days to finish.  When it did finish, tried a scrub and got this message:
>>
>> scrub status for 597ee185-36ac-4b68-8961-d4adc13f95d4
>>     scrub started at Sun Jun 26 18:19:28 2016 and was aborted after 01:16:35
>>     total bytes scrubbed: 926.45GiB with 18849935 errors
>>     error details: read=18849935
>>     corrected errors: 5860, uncorrectable errors: 18844075, unverified errors: 0
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
>>   But I have all the data on it backed up on another system, so I can recreate this if I need to.  But here's what I want to know:
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
OK, I'll see if I can narrow things down to a faulty component or 
memory.  It could definitely be the drive controller or sas/sata cable.
>> 2.  If that is the case:
>>     a.) Is there any way I can stop the /dev/sd* mount points from changing?  Or can I set up the filesystem using UUIDs or something more solid?  I googled about it, but found conflicting info
> Don’t get it the wrong way but I’m personally surprised that anybody still uses mount points rather than UUID. Devices change from boot to boot for a lot of people and most of distros moved to uuid (2 years ago ? even the swap is mounted via UUID now)
Well yeah, if I was mounting all the disks to different mount points, I 
would definitely use UUIDs to get them mounted.  But I haven't seen any 
way to set up a "mkfs.btrfs" command to use UUID or anything else for 
individual drives.  Am I missing something?  I've been doing a lot of 
googling.

>
>>     b.) Or, is there something else changing my drive devices?  I have most of drives on an LSI SAS 9201-16i card, is there something I need to do to make them fixed?
> I’ll let more senior data storage experts to speak up but most of the time people frowned on me for mentioning anything different than north bridge / Intel raid card / super micro / 3 ware .
>
> (And yes I did found the hard way they were right:
> - marvel controller on my mobo randomly writes garbage to your drives
> - adapted PCI express card was switching of all the drives mid flight while pretending “it’s OK” resulting in very peculiar data losses in the middle of big files)
Hmm.... good to know.  Might see if I can find a more reliable sata 
controller card.
>
>>     c.) Or, is there a script or something I can use to figure out if the disks will change mounts?
>>     d.) Or, if I wipe everything and rebuild, will the disks with the idle3ctl fix work now?
>>
>> Regardless of whether or not it's a WD Green drive issue, should I just wipefs all the disks and rebuild it?  Is there any way to recover this?  Thanks for any help!
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
I'm not worried about the data, it's all backed up.  But ok, I can get a 
couple of drives and start testing stuff.  I think I found the script 
you meant (stress.sh I'm hoping) so I can get that running. But as far 
as the old fs goes, I can just wipe that and start fresh.  Thanks for 
all the tips!

     ------- Corey

>
>>     ------- Corey
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

