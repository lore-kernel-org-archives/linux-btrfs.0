Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34172 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbcJJN4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 09:56:49 -0400
Received: by mail-lf0-f53.google.com with SMTP id b81so126965258lfe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 06:56:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6KGPSYXsU4DQ1x62Wyi+xpEd-EE5hEHPbY-CJfokey94mzoQ@mail.gmail.com>
References: <CAG6KGPS8Gvy2zGCe22mMmk4uXrqVyRP8FHayhe0ph-8vC+kA4A@mail.gmail.com>
 <CAG6KGPSeR1zAuU0Xo9DrEpd-0QC9agB7p7z+Lb69hxS233_Cvg@mail.gmail.com> <CAG6KGPSYXsU4DQ1x62Wyi+xpEd-EE5hEHPbY-CJfokey94mzoQ@mail.gmail.com>
From: Martin Dev <mrturtledev@gmail.com>
Date: Mon, 10 Oct 2016 14:56:45 +0100
Message-ID: <CAG6KGPRPsYKFcJ_Ksgw9W20uYS3RVHKsc_TcimLUJ8jyZrqA7w@mail.gmail.com>
Subject: Re: csum failed during copy/compare
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After some investigation this seems to follow the discard flag set in fstab.

9 or so reproductions with discard on partition 2 fail
move discard flag to partition 1, then partition 1 fails.

Re-running our tests with no discard options set in fstab

On Mon, Oct 10, 2016 at 1:02 PM, Martin Dev <mrturtledev@gmail.com> wrote:
> Additional BTRFS scrub logs
>
> root@xxxx# btrfs scrub start -B /mnt/g/
> scrub done for 554b0043-052f-48d1-986f-5a6154496d89
>     scrub started at Mon Oct 10 12:52:40 2016 and finished after 00:00:39
>     total bytes scrubbed: 20.03GiB with 46304 errors
>     error details: csum=46304
>     corrected errors: 0, uncorrectable errors: 46304, unverified errors: 0
> ERROR: there are uncorrectable errors
>
> I've attached the dmesg log incase gmail wordwrap completely destroys formatting
>
> dmesg :
> [10284.452766] BTRFS warning (device sdb2): checksum error at logical
> 143896739840 on dev /dev/sdb2, sector 42509568, root 5, inode 270,
> offset 10548412416, length 4096, links 1 (path: shutdown-4.bin)
> [10284.452775] BTRFS warning (device sdb2): checksum error at logical
> 143896608768 on dev /dev/sdb2, sector 42509312, root 5, inode 270,
> offset 10548281344, length 4096, links 1 (path: shutdown-4.bin)
> [10284.452784] BTRFS warning (device sdb2): checksum error at logical
> 143896346624 on dev /dev/sdb2, sector 42508800, root 5, inode 270,
> offset 10548019200, length 4096, links 1 (path: shutdown-4.bin)
> [10284.452792] BTRFS warning (device sdb2): checksum error at logical
> 143896215552 on dev /dev/sdb2, sector 42508544, root 5, inode 270,
> offset 10547888128, length 4096, links 1 (path: shutdown-4.bin)
> [10284.452800] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 1, gen 0
> [10284.452804] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 2, gen 0
> [10284.452810] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 3, gen 0
> [10284.452813] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896608768 on dev /dev/sdb2
> [10284.452815] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896346624 on dev /dev/sdb2
> [10284.452820] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896215552 on dev /dev/sdb2
> [10284.452840] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 4, gen 0
> [10284.452845] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896739840 on dev /dev/sdb2
> [10284.452906] BTRFS warning (device sdb2): checksum error at logical
> 143896084480 on dev /dev/sdb2, sector 42508288, root 5, inode 270,
> offset 10547757056, length 4096, links 1 (path: shutdown-4.bin)
> [10284.453082] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 5, gen 0
> [10284.453087] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896084480 on dev /dev/sdb2
> [10284.453107] BTRFS warning (device sdb2): checksum error at logical
> 143896743936 on dev /dev/sdb2, sector 42509576, root 5, inode 270,
> offset 10548416512, length 4096, links 1 (path: shutdown-4.bin)
> [10284.453113] BTRFS warning (device sdb2): checksum error at logical
> 143896612864 on dev /dev/sdb2, sector 42509320, root 5, inode 270,
> offset 10548285440, length 4096, links 1 (path: shutdown-4.bin)
> [10284.453122] BTRFS warning (device sdb2): checksum error at logical
> 143896350720 on dev /dev/sdb2, sector 42508808, root 5, inode 270,
> offset 10548023296, length 4096, links 1 (path: shutdown-4.bin)
> [10284.453126] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 6, gen 0
> [10284.453130] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896612864 on dev /dev/sdb2
> [10284.453134] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 7, gen 0
> [10284.453137] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896350720 on dev /dev/sdb2
> [10284.453153] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 8, gen 0
> [10284.453157] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896743936 on dev /dev/sdb2
> [10284.453190] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 9, gen 0
> [10284.453194] BTRFS warning (device sdb2): checksum error at logical
> 143896219648 on dev /dev/sdb2, sector 42508552, root 5, inode 270,
> offset 10547892224, length 4096, links 1 (path: shutdown-4.bin)
> [10284.453198] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0,
> rd 0, flush 0, corrupt 10, gen 0
> [10284.453201] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896219648 on dev /dev/sdb2
> [10284.453207] BTRFS error (device sdb2): unable to fixup (regular)
> error at logical 143896616960 on dev /dev/sdb2
> [10284.453238] BTRFS warning (device sdb2): checksum error at logical
> 143896477696 on dev /dev/sdb2, sector 42509056, root 5, inode 270,
> offset 10548150272, length 4096, links 1 (path: shutdown-4.bin)
>
> Important to note this happens across 2 machines, now 3 different
> drives (all different brand SSDs), on a Z170 chipset and C612 chipset.
>
> On Mon, Oct 10, 2016 at 10:44 AM, Martin Dev <mrturtledev@gmail.com> wrote:
>> Hey everyone,
>>
>> I work for system verification of SSDs and we've recently come up
>> against an issue with BTRFS on Ubuntu 16.04. We have a framework which
>> follows the following steps:
>>
>> Generate verifiable 10GB file with FIO on internal drive
>> Copy 10GB file to 2 target partitions on DUT (using "cp" command)
>> Sync
>> Verify copied files with FIO (using direct=1)
>> Perform a power event (restart, shutdown, suspend, or hibernate)
>> Verify both 10GB files
>> Repeat.
>>
>> We keep the files from the first iteration on the target partitions,
>> but subsequent iterations are deleted after verification. Every
>> command is monitored for exit status and framework will fail with
>> error if anything exits non zero.
>>
>> We've found that during this process (between 2-9 iterations of
>> restarts or shutdowns) BTRFS will fail the pre-power verification of
>> the file with 100% reproduction rate out of 7 attempts. So this is a
>> "cp" command to copy from the internal to the btrfs partition, a sync,
>> then a verify with fio. This seems to be a recent change as the same
>> process has been used for the last 2 years including over the last
>> month with no issues.
>>
>> Here are some more details:
>>
>> Linux ht_stress_b6_20 4.4.0-21-generic #37-Ubuntu SMP Mon Apr 18
>> 18:33:37 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
>>
>> btrfs-progs v4.4
>>
>> Label: none  uuid: 554b0043-052f-48d1-986f-5a6154496d89
>>     Total devices 1 FS bytes used 20.03GiB
>>     devid    1 size 29.81GiB used 22.26GiB path /dev/sdb2
>>
>> Data, single: total=22.00GiB, used=20.00GiB
>> System, single: total=4.00MiB, used=16.00KiB
>> Metadata, single: total=264.00MiB, used=20.64MiB
>> GlobalReserve, single: total=16.00MiB, used=0.00B
>>
>>
>> df -hT
>> /dev/sdb1      ext4       30G   21G  7.7G  73% /mnt/f
>> /dev/sdb2      btrfs      30G   21G  9.6G  68% /mnt/g
>> /dev/sdb3      xfs        30G   33M   30G   1% /mnt/h
>> /dev/sdb4      ext4       30G   44M   28G   1% /mnt/i
>>
>> /etc/fstab
>> /dev/sdb2                                       /mnt/g/ btrfs
>> defaults,discard       0       0
>>
>> root@xxxx: ls -l /mnt/g/
>> total 20971520
>> -rw-r--r-- 1 root root 10737418240 Oct 10 09:42 shutdown-1.bin
>> -rw-r--r-- 1 root root 10737418240 Oct 10 10:03 shutdown-4.bin
>>
>>
>> root@xxxx# cat fio-screenlog.log
>> test: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K,
>> ioengine=libaio, iodepth=32
>> fio-2.13-88-g32bc8-dirty
>> Starting 1 process
>> verify: bad magic header 101, wanted acca at file
>> /mnt/g/shutdown-4.bin offset 10547757056, length 131072
>> verify: bad magic header 101, wanted acca at file
>> /mnt/g/shutdown-4.bin offset 10547888128, length 131072
>> fio: pid=2288, err=84/file:io_u.c:1978, func=io_u_queued_complete,
>> error=Invalid or incomplete multibyte or wide character
>>
>> In this situation, FIO is reading "101" instead of the correct data
>> from the shutdown-4.bin file. from the "ls -l" above, we can see the
>> shutdown-1.bin and shutdown-4.bin are the same size and we know the cp
>> command exited 0.
>>
>> shutdown-1.bin (OK):
>> dd if=/mnt/g/shutdown-1.bin of=/tmp/header bs=512 count=1 skip=20601088
>> 1+0 records in
>> 1+0 records out
>> 512 bytes copied, 0.00247518 s, 207 kB/s
>>
>> Data:
>> 0000000 acca 0001 0000 0002 3d92 e664 178e 8421
>> 0000010 0000 74b2 0002 0000 0016 0000 2bfa 0009
>> 0000020 0001 3a59 c82b 1b3a a7b8 ee74 881a 0747
>> 0000030 94f7 09f2 79c9 04e3 d29e d6c2 ea3f 04b8
>> ...
>>
>> shutdown-4.bin (FAILS):
>> dd if=/mnt/g/shutdown-4.bin of=/tmp/header bs=512 count=1 skip=20601088
>> dd: error reading '/mnt/g/shutdown-4.bin': Input/output error
>> 0+0 records in
>> 0+0 records out
>> 0 bytes copied, 0.00230287 s, 0.0 kB/s
>>
>> We can't even read the file at that offset correctly and have to go
>> back to 20601087 (1 512 byte sector) before I can get valid data.
>> What's interesting, is over 2 different drives, 2 different machines,
>> and 7 reproductions, the data is always "101", this might be a quirk
>> of FIO, as I would hope that btrfs would not return corrupt data to
>> the user.
>>
>> Reproduction is straight forward, and takes around an hour. I have a
>> large amount of duplicate machines at my disposal if debug /
>> investigations need to be run. I can provide portions of our
>> automation logs, full dmesg (attached), and any other information that
>> needs to be gathered.
