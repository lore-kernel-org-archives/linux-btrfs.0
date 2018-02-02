Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57739 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBBCwk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Feb 2018 21:52:40 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ehRQa-0003M1-N5
        for linux-btrfs@vger.kernel.org; Fri, 02 Feb 2018 03:50:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs - kernel warning
Date: Fri, 2 Feb 2018 02:49:52 +0000 (UTC)
Message-ID: <pan$c028e$56b76f3d$ec4b4337$c0f444fe@cox.net>
References: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
        <a95b4757-c63a-3566-e6ed-9065240a6f1d@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Fri, 02 Feb 2018 09:40:30 +0800 as excerpted:


> 
> On 2018年02月02日 05:06, Patrik Ostrihon wrote:
>> Hi,
>> 
>> Today I saw warning in dmesg output. But I don't know what it means.
>> Could you help me please? Is it something dangerous for my dato on this
>> filesystem?
>> 
>> Thanks
>> 
>> pa3k
>> 
>> root@merkur:~# uname -a
>> 
>> Linux merkur 4.14.8-041408-generic #201712200555 SMP Wed Dec 20
>> 10:57:38 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>> 
>> root@merkur:~# btrfs --version Btrfs v3.12
>> 
>> root@merkur:~# btrfs fi show
>> 
>> Label: none  uuid: 96f60fa9-c20e-4a13-82b1-9074dd942eab
>>         Total devices 2 FS bytes used 2.43TiB devid    1 size 8.19TiB
>>         used 2.45TiB path /dev/sdc2 devid    2 size 8.19TiB used
>>         2.45TiB path /dev/sdd2
>> 
>> Label: none  uuid: 2da0261b-143a-4814-aacb-de46373aebe9
>>         Total devices 2 FS bytes used 203.11GiB devid    1 size
>>         930.00GiB used 206.03GiB path /dev/sdc1 devid    2 size
>>         930.00GiB used 206.01GiB path /dev/sdd1
>> 
>> Btrfs v3.12
>> 
>> 
>> root@merkur:~# btrfs fi df /usr/local/data
>> 
>> Data, RAID1: total=2.44TiB, used=2.43TiB Data, single: total=8.00MiB,
>> used=0.00 System, RAID1: total=8.00MiB, used=368.00KiB System, single:
>> total=4.00MiB, used=0.00 Metadata, RAID1: total=5.00GiB, used=3.33GiB
>> Metadata, single: total=8.00MiB, used=0.00 unknown, single:
>> total=512.00MiB, used=0.00 root@merkur:~# btrfs fi df
>> /usr/local/data/hts Data, RAID1: total=205.00GiB, used=202.90GiB Data,
>> single: total=8.00MiB, used=0.00 System, RAID1: total=8.00MiB,
>> used=48.00KiB System, single: total=4.00MiB, used=0.00 Metadata, RAID1:
>> total=1.00GiB, used=213.25MiB Metadata, single: total=8.00MiB,
>> used=0.00 unknown, single: total=211.78MiB, used=0.00
>> 
>> 
>> [ 4084.704514] ------------[ cut here ]------------
>> [ 4084.704561] WARNING: CPU: 3 PID: 1865 at
>> /home/kernel/COD/linux/fs/btrfs/ctree.h:1564
> 
> This normally means your device size is not aligned to 4K.
> 
> It's normal if your fs has some age as old mkfs.btrfs doesn't align
> device size.

And... btrfs-progs-3.12, as reported, is _old_, certainly old enough to 
create both the unaligned filesystem ends, as Qu says here, as well as 
the unused single-chunks as a remnant of the mkfs.btrfs process, as Chris 
Murphy says.

While in normal btrfs runtime it's the kernel version that's critical, as 
most runtime commands (balance, scrub...) simply call the appropriate 
kernel functionality to do the real work, once something goes wrong it's 
the btrfs-progs userspace tools that do the fixing, and btrfs-progs 3.12 
is positively ancient, in btrfs terms.  So you _really_ want a newer 
btrfs-progs if you plan on doing any repairs or the like.

As CMurphy says, 4.11-ish is starting to be reasonable.  But you're on 
the LTS kernel 4.14 series and userspace 4.14 was developed in parallel, 
so btrfs-progs-3.14 would be ideal.

That should eliminate similar problems with newly created btrfs, since 
recent mkfs.btrfs neither creates those unused single chunks during the 
mkfs process, nor unaligned btrfs ends on the device.

> And recently kernel makes the device size alignment check more restrict,
> so it will cause such warning.
> 
> 
> Fortunately btrfs-progs provides offline tool to fix it.
> You could use "btrfs rescue fix-device-size <device>" to easily fix it.
> And since it's an offline tool, you need to umount your fs first.

Again, you'll certainly need something well newer than btrfs-progs 3.12 
for that, tho.  That's ~4.5 years outdated, right after btrfs officially 
removed the experimental warnings, and a _LOT_ of bugs (including both of 
those mentioned here) have been fixed since then!


Meanwhile, reemphasizing something CMurphy said as well.  I like to point 
out the sysadmin's first rule of backups:  The true value you place on 
your data is defined not by any arbitrary claims, as those are just 
words, but rather, by the number of backups you consider it worth the 
time/trouble/resources to create, of that data.

Given that, you can *always* rest easy when something goes wrong and the 
filesystem won't mount, because regardless of whether you have a backup 
or not, you /always/ saved what you defined as most important to you, 
either the data, because it was backed up, or the time/trouble/resources 
you would have spent on that data has it been of more than the trivial 
value necessary to make it worth having that backup.

Similarly with backup updates, only in the case of updates it's the data 
in the delta between your last backup and the current state.  As soon as 
the change to your data since the last backup becomes more valuable than 
the time/trouble/resources necessary to update your backup, you will do 
so.  If you haven't, it simply means you're defining the changes since 
your last backup as of less value than the time/trouble/resources 
necessary to do that update, so again, you can *always* rest easy in the 
face of filesystem or device problems, because you either have it backed 
up, or by definition of /not/ having it backed up, it was self-evidently 
not worth the trouble to do so yet, so you saved what was most important 
to you either way.

So think about your value definitions regarding your data and change them 
if you need to... while you still have the chance. =:^)

(And the implications of the above change how you deal with a broken 
filesystem too.  With either current backups or what you've literally 
defined as throw-away data due to it not being worth the trouble of 
backups, it makes little sense to spend more than a trivial amount of 
time trying to recover data from a messed up filesystem, especially given 
that there's no guarantee you'll get it all back undamaged even if you 
/do/ spend time time.  It's often simpler and takes less time, as well as 
more success-sure, to simply blow away the defective filesystem with a 
fresh mkfs and restore the data from backups, since that way you know 
you'll have a fresh filesystem and known-good data from the backup, as 
opposed to no guarantees /what/ you'll end up with trying to recover/
repair the old filesystem.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

