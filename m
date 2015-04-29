Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35847 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbbD2Tup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 15:50:45 -0400
Received: by lagv1 with SMTP id v1so28370456lag.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 12:50:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5536EB13.8060902@cn.fujitsu.com>
References: <CAJF-kYngS4U6=oiXhs0ZF3Na3ezTGcMX1Wyd5HVVm887V61mWw@mail.gmail.com>
 <5535C11C.2050308@cn.fujitsu.com> <20150421151714.GA19017@hungrycats.org> <5536EB13.8060902@cn.fujitsu.com>
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Wed, 29 Apr 2015 21:50:23 +0200
Message-ID: <CAJF-kY=eqWA_hc+XCHYUEH58x7=hKQ0rm+bSGiaXoWv+tppGyQ@mail.gmail.com>
Subject: Re: Carefully crafted BTRFS-image causes kernel to crash
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a patch was posted by Qu which should fix the issue, I did not check
though. To give some context: Testing the userland tools to some
depths comes back with around 13 percent of all execution paths in
around 40 million runs to result in a segmentation fault, an uncatched
divide-by-zero or self-destruction due to a heap buffer overflow
catched by glibc. That is to be compared with zero crashes in the
ext2fs userland tools.

I'll pull in Qu's patch once there are patches for the other problems
that were already posted and continue testing then.

Best regards
Lukas

2015-04-22 2:28 GMT+02:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
>
>
> -------- Original Message  --------
> Subject: Re: Carefully crafted BTRFS-image causes kernel to crash
> From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2015年04月21日 23:17
>
>> On Tue, Apr 21, 2015 at 11:16:44AM +0800, Qu Wenruo wrote:
>>>
>>> -------- Original Message  --------
>>> Subject: Carefully crafted BTRFS-image causes kernel to crash
>>> From: Lukas Lueg <lukas.lueg@gmail.com>
>>> To: <linux-btrfs@vger.kernel.org>
>>> Date: 2015年04月21日 07:04
>>>
>>>> See also https://bugzilla.kernel.org/show_bug.cgi?id=96971
>>>>
>>>>
>>>> I've identified some problems in the btrfs code and attached a
>>>> btrfs-image which causes the userland tools to crash and the kernel to
>>>> immediately freeze once the filesystem get's mounted and one of the
>>>> files is accessed. Putting the image onto a usb-drive gives you a
>>>> freeze-on-a-stick :-)
>>>>
>>>> "btrfs check" crashes due to a SIGFPE in count_csum_range(). The
>>>> culprit is struct btrfs_root->fs_info->super_copy->csum_size being 0,
>>>> which goes unchecked before entering a division.
>>>> I was not able to identify where the kernel crashes (system goes down
>>>> the tubes), yet the problem is probably the same.
>>>
>>> Thanks for the bug report.
>>>
>>> Although we may add extra check for such problem to improve robustness,
>>> but IMHO it's not a real world problem.
>>
>>
>> It depends on context.
>>
>> If your real world involves putting hostile USB sticks into your computer
>> (e.g. you are a lawyer and your day job involves receiving electronic
>> documents from hostile and sometimes technically sophisticated opponents),
>> then this is definitely a real world problem.  It needs to be treated as a
>> security vulnerability (a minor one, given the requirement for physical
>> access and no data loss except for the kernel crash), maybe assigned a
>> CVE, and fixed with some urgency.
>
> Oh, I forgot the hostile USB case.
>
> And for that case, I think is is worthy to fix.
> For kernel, IIRC, there is a function to check superblock validation,
> so just one or two new lines to check csum size.
>
> And for btrfs-progs, we can add such function too.
>
> I'll send the patch recently
>
> BUT I also want to show the fact that, BTRFS is still under heavy
> development for its features and stability, so robustness may not be the
> primary concern yet.
> (More daily operation can cause problems, see fstests, run with old
> kernels and you should get a lot of hangs)
> Although any such report is still welcomed and I'll try to fix them if I
> have spare time.
>
> Thanks,
> Qu
>
>>
>> If your real world involves running racks of machines with no USB ports
>> in a locked data center then this issue is irrelevant noise.  Other btrfs
>> issues are *much* more likely to crash the kernel before this one.  ;)
>>
>>> For normal case, csum will not be zero for sure.
>>> And even for corrupted superblock, sb csum will prevent btrfs from using
>>> it.
>>>
>>> This problem will only happen, as your mentioned, by a specially
>>> crafted image or a known bug which btrfs will still use corruped sb
>>> even sb csum dismatches.
>>>
>>> Thanks,
>>> Qu
>>>>
>>>>
>>>> "btrfs version" is v3.19.1; bug is also present in latest git (kdave
>>>> and unstable) as of 2015/04/21
>>>>
>>>>
>>>> Full gdb output:
>>>>
>>>> gdb btrfs
>>>> GNU gdb (GDB) Fedora 7.8.2-38.fc21
>>>> Copyright (C) 2014 Free Software Foundation, Inc.
>>>> License GPLv3+: GNU GPL version 3 or later
>>>> <http://gnu.org/licenses/gpl.html>
>>>> This is free software: you are free to change and redistribute it.
>>>> There is NO WARRANTY, to the extent permitted by law.  Type "show
>>>> copying"
>>>> and "show warranty" for details.
>>>> This GDB was configured as "x86_64-redhat-linux-gnu".
>>>> Type "show configuration" for configuration details.
>>>> For bug reporting instructions, please see:
>>>> <http://www.gnu.org/software/gdb/bugs/>.
>>>> Find the GDB manual and other documentation resources online at:
>>>> <http://www.gnu.org/software/gdb/documentation/>.
>>>> For help, type "help".
>>>> Type "apropos word" to search for commands related to "word"...
>>>> Reading symbols from btrfs...Reading symbols from
>>>> /usr/lib/debug/usr/sbin/btrfs.debug...done.
>>>> done.
>>>> (gdb) run check btrfs_fukked.bin
>>>> Starting program: /usr/sbin/btrfs check btrfs_fukked.bin
>>>> [Thread debugging using libthread_db enabled]
>>>> Using host libthread_db library "/lib64/libthread_db.so.1".
>>>> Checking filesystem on btrfs_fukked.bin
>>>> UUID: cdd8684f-9eb1-40a4-91ec-1ed7c3cb444c
>>>> checking extents
>>>> checking free space cache
>>>> checking fs roots
>>>>
>>>> Program received signal SIGFPE, Arithmetic exception.
>>>> count_csum_range (root=<optimized out>, root=<optimized out>,
>>>>      found=<synthetic pointer>, len=7385088, start=7471104) at
>>>> cmds-check.c:1455
>>>> 1455 csum_end = key.offset + (size / csum_size) * root->sectorsize;
>>>> (gdb) bt
>>>> #0  count_csum_range (root=<optimized out>, root=<optimized out>,
>>>>      found=<synthetic pointer>, len=7385088, start=7471104) at
>>>> cmds-check.c:1455
>>>> #1  process_file_extent (active_node=0x7fffffffd710, key=0x7fffffffd680,
>>>>      slot=11, eb=<optimized out>, root=0x894b10) at cmds-check.c:1551
>>>> #2  process_one_leaf (wc=0x7fffffffd6c0, eb=<optimized out>,
>>>> root=0x894b10)
>>>>      at cmds-check.c:1617
>>>> #3  walk_down_tree (level=<synthetic pointer>, wc=0x7fffffffd6c0,
>>>>      path=0x7fffffffd7f0, root=0x894b10) at cmds-check.c:1742
>>>> #4  check_fs_root (wc=0x7fffffffd6c0, root_cache=0x7fffffffdb20,
>>>> root=0x894b10)
>>>>      at cmds-check.c:3380
>>>> #5  check_fs_roots (root_cache=root_cache@entry=0x7fffffffdb20,
>>>> root=0x894b10)
>>>>      at cmds-check.c:3516
>>>> #6  0x0000000000428aea in cmd_check (argc=<optimized out>,
>>>>      argv=<optimized out>) at cmds-check.c:9465
>>>> #7  0x000000000040e5a2 in main (argc=2, argv=0x7fffffffdeb0) at
>>>> btrfs.c:245
>>>> (gdb) p csum_size
>>>> $2 = 0
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
