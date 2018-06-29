Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bosmailout04.eigbox.net ([66.96.187.4]:52495 "EHLO
        bosmailout04.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934268AbeF2SbL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 14:31:11 -0400
Received: from bosmailscan09.eigbox.net ([10.20.15.9])
        by bosmailout04.eigbox.net with esmtp (Exim)
        id 1fYxcb-0007lv-Fr
        for linux-btrfs@vger.kernel.org; Fri, 29 Jun 2018 13:55:49 -0400
Received: from [10.115.3.32] (helo=bosimpout12)
        by bosmailscan09.eigbox.net with esmtp (Exim)
        id 1fYxcb-000168-CV
        for linux-btrfs@vger.kernel.org; Fri, 29 Jun 2018 13:55:49 -0400
Received: from [127.0.0.1] (helo=ipage)
        by boswebmail13.eigbox.net with esmtp (Exim)
        id 1fYxcY-0006KQ-4V
        for linux-btrfs@vger.kernel.org; Fri, 29 Jun 2018 13:55:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 29 Jun 2018 13:55:46 -0400
From: j@livingrock.ca
To: linux-btrfs@vger.kernel.org
Subject: Removed Disk - Super Error - Scrub did not fix - next steps?
Message-ID: <028df9e3bc13286d08fade17fe90b179@livingrock.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I recently was mounting some drives in the free drive bays of my server 
and accidentally removed one of my drives from my raid1 btrfs array.  I 
immediately put it back in - but whatever damage that would have caused 
seems to be already done.

I got these log errors [dmesg -T] and after reading up it seemed that 
all I *probably* needed to do was a scrub:

Finally - the original logs I found by running "dmesg -T|grep -i btrfs" 
- from where the log started to where the scrub begain:

[Tue Jun 26 18:30:08 2018] BTRFS error (device sdb): bdev /dev/sdh errs: 
wr 40547, rd 42808, flush 2, corrupt 0, gen 0

[Tue Jun 26 18:33:19 2018] btrfs_dev_stat_print_on_error: 2056 callbacks 
suppressed

A bunch of these errors...

Then later:

[Tue Jun 26 19:19:52 2018] BTRFS warning (device sdb): lost page write 
due to IO error on /dev/sdh

I think this is where I unmounted/remounted /mnt/titan:

[Tue Jun 26 19:49:18 2018] BTRFS info (device sdb): disk space caching 
is enabled
[Tue Jun 26 19:49:18 2018] BTRFS info (device sdb): has skinny extents
[Tue Jun 26 19:49:18 2018] BTRFS info (device sdb): bdev /dev/sdh errs: 
wr 55907, rd 59133, flush 2, corrupt 0, gen 0
[Tue Jun 26 19:49:57 2018] btrfs_dev_stat_print_on_error: 49 callbacks 
suppressed
[Tue Jun 26 19:49:57 2018] BTRFS error (device sdb): bdev /dev/sdh errs: 
wr 55907, rd 59133, flush 2, corrupt 0, gen 1
[Tue Jun 26 19:49:57 2018] BTRFS error (device sdb): bdev /dev/sdh errs: 
wr 55907, rd 59133, flush 2, corrupt 0, gen 2
[Tue Jun 26 19:49:57 2018] BTRFS error (device sdb): bdev /dev/sdh errs: 
wr 55907, rd 59133, flush 2, corrupt 0, gen 3
[Tue Jun 26 19:50:09 2018] BTRFS error (device sdb): parent transid 
verify failed on 9081264963584 wanted 8663 found 8321
[Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081264963584 (dev /dev/sdh sector 17728418112)
[Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081264967680 (dev /dev/sdh sector 17728418120)
[Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081264971776 (dev /dev/sdh sector 17728418128)
[Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081264975872 (dev /dev/sdh sector 17728418136)
[Tue Jun 26 19:50:09 2018] BTRFS error (device sdb): parent transid 
verify failed on 9081265356800 wanted 8663 found 8321
[Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081265356800 (dev /dev/sdh sector 17728418880)
[Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081265360896 (dev /dev/sdh sector 17728418888)
[Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081265364992 (dev /dev/sdh sector 17728418896)
[Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081265369088 (dev /dev/sdh sector 17728418904)

According to btrfs scrub status this is when the scrub began...

[Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid 
verify failed on 9081265061888 wanted 8663 found 8321
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081265061888 (dev /dev/sdh sector 17728418304)
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081265065984 (dev /dev/sdh sector 17728418312)
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081265070080 (dev /dev/sdh sector 17728418320)
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081265074176 (dev /dev/sdh sector 17728418328)
[Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid 
verify failed on 9081263046656 wanted 8664 found 8662
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081263046656 (dev /dev/sdh sector 17728414368)
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081263050752 (dev /dev/sdh sector 17728414376)
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081263054848 (dev /dev/sdh sector 17728414384)
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081263058944 (dev /dev/sdh sector 17728414392)
[Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid 
verify failed on 9081263194112 wanted 8664 found 8662
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081263194112 (dev /dev/sdh sector 17728414656)
[Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error 
corrected: ino 0 off 9081263198208 (dev /dev/sdh sector 17728414664)
[Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid 
verify failed on 9081264128000 wanted 8664 found 8662
[Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid 
verify failed on 9081265520640 wanted 8665 found 8321

So I ran btrfs scrub and this was my post-scrub status:

Idoru:/ # btrfs scrub status -d /mnt/titan
scrub status for e7c494fc-ac4e-4644-a2f2-66f25543708b
scrub device /dev/sdb (id 1) history
     scrub started at Tue Jun 26 19:50:29 2018 and finished after 
16:10:04
     total bytes scrubbed: 8.57TiB with 0 errors
scrub device /dev/sdh (id 2) history
     scrub started at Tue Jun 26 19:50:29 2018 and finished after 
16:13:31
     total bytes scrubbed: 8.57TiB with 3 errors
     error details: super=3
     corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

On a side note - I'm not sure if it matters (or why it 
might/could/would) - but I actually used entire drives [as opposed to 
making partitions and using them] to create my mirror.

Idoru:/ # gdisk -l /dev/sdb
GPT fdisk (gdisk) version 1.0.1

Partition table scan:
   MBR: not present
   BSD: not present
   APM: not present
   GPT: not present

Creating new GPT entries.
Disk /dev/sdb: 19532873728 sectors, 9.1 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): DEDB0F7A-93A7-45C9-8235-828492422559
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 19532873694
Partitions will be aligned on 2048-sector boundaries
Total free space is 19532873661 sectors (9.1 TiB)

Number  Start (sector)    End (sector)  Size       Code  Name

Also, here is the device usage - post scrub [it seems to be the same 
byte for byte]:

Idoru:/ # btrfs device usage -b /mnt/titan
/dev/sdb, ID: 1
    Device size:          10000831348736
    Device slack:                  0
    Data,RAID1:           9428526956544
    Metadata,RAID1:       13958643712
    System,RAID1:            8388608
    Unallocated:          558337359872

/dev/sdh, ID: 2
    Device size:          10000831348736
    Device slack:                  0
    Data,RAID1:           9428526956544
    Metadata,RAID1:       13958643712
    System,RAID1:            8388608
    Unallocated:          558337359872

I unmounted again and ran btrfs check [without repair] again - after 
doing scrub:

Idoru:/ # btrfs check /dev/sdh
Checking filesystem on /dev/sdh
UUID: e7c494fc-ac4e-4644-a2f2-66f25543708b
checking extents
checking free space cache
checking fs roots
checking only csum items (without verifying data)
checking root refs
found 9414630215796 bytes used, no error found
total csum bytes: 9191775488
total tree bytes: 12803850240
total fs tree bytes: 3054665728
total extent tree bytes: 230211584
btree space waste bytes: 782320214
file data blocks allocated: 132510269804544
  referenced 132509780557824

Idoru:/ # btrfs check /dev/sdb
Checking filesystem on /dev/sdb
UUID: e7c494fc-ac4e-4644-a2f2-66f25543708b
checking extents
checking free space cache
checking fs roots
checking only csum items (without verifying data)
checking root refs
found 9414630215796 bytes used, no error found
total csum bytes: 9191775488
total tree bytes: 12803850240
total fs tree bytes: 3054665728
total extent tree bytes: 230211584
btree space waste bytes: 782320214
file data blocks allocated: 132510269804544
  referenced 132509780557824

Everything seems identical [and OK].

So I tried remounting and found the following in my dmesg log:

Fri Jun 29 13:27:21 2018] BTRFS info (device sdb): disk space caching is 
enabled
[Fri Jun 29 13:27:21 2018] BTRFS info (device sdb): has skinny extents
[Fri Jun 29 13:27:21 2018] BTRFS info (device sdb): bdev /dev/sdh errs: 
wr 55907, rd 59133, flush 2, corrupt 0, gen 3

So I still seem to have a problem...

I guess I'm wondering why the super errors were not corrected in the 
scrub [uncorrectable errors:0 - super but it didn't correct - or even 
try to - correct the super errors]?

Is there an easy way to tell the drive I removed to "resync" to the 
drive that was not removed?  I actually assumed [yes - I know what they 
say about assumptions] that the OS would know which drive was valid in 
event of disagreement and would *easily* catch and correct this.

Since that doesn't seem to be the case - I'm wondering if there is a 
command I'm overlooking or if I need to break and rebuild the entire 
mirror again?  Or is this something that btrfs check -repair is for (it 
doesn't seem to be saying anything is wrong when run without -repair)?  
Is there a way to revalidate and repair only the superblock [perhaps by 
using the superblock from the drive that wasn't removed]?  I definitely 
don't want "btrfs check -repair" deciding there's a problem with my 
"good drive" and breaking it in the process of fixing things - lol.

It's also more than a bit scary that "btrfs check -repair" is always 
mentioned "as a last resort" - thus my writing and hoping to avoid it 
[unless it's the proper next step?]

Apologies for the long post - I'm hoping it's enough information to 
assist me without being overwhelmingly useless.

Thank you to any and all who can help :)

J

P.S:  Requisite info requested from 
https://btrfs.wiki.kernel.org/index.php/Btrfs_mailing_list

Idoru:/ # uname -a
Linux Idoru 4.16.12-2-default #1 SMP PREEMPT Fri May 25 18:40:19 UTC 
2018 (39c7522) x86_64 x86_64 x86_64 GNU/Linux

Idoru:/ # btrfs --version
btrfs-progs v4.17 [I'm running openSUSE tumbleweed and I noticed a 
kernel update has occured without reboot so I suspect I may have 
originally been running btrfs scrub from v4.16 tools instead]

Idoru:/ # btrfs fi show /mnt/titan
Label: 'Titan A.E.'  uuid: e7c494fc-ac4e-4644-a2f2-66f25543708b
     Total devices 2 FS bytes used 8.57TiB
     devid    1 size 9.10TiB used 8.59TiB path /dev/sdb
     devid    2 size 9.10TiB used 8.59TiB path /dev/sdh [was /dev/sdc 
before removal + reinsertion]

Idoru:/boot # btrfs fi df /mnt/titan/
Data, RAID1: total=8.58TiB, used=8.56TiB
System, RAID1: total=8.00MiB, used=1.19MiB
Metadata, RAID1: total=13.00GiB, used=11.92GiB
GlobalReserve, single: total=512.00MiB, used=0.00

Re: dmesg - I am hoping there is enough relevance in the dmesg info I 
have already included - I would only rather include the log if 
*absolutely* necessary - thank you :)
