Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57570 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2GaEfa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 00:35:30 -0400
Received: by eeil10 with SMTP id l10so1478210eei.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 21:35:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50173C37.9090607@cn.fujitsu.com>
References: <CA+M2DjmS0xB8zinvELi5SBg1QRxabvHfpd1MqJxqCB65qq1ceA@mail.gmail.com>
	<50173C37.9090607@cn.fujitsu.com>
Date: Mon, 30 Jul 2012 23:35:29 -0500
Message-ID: <CA+M2Dj=oG_1QZKn1Y3wncmCw=dmLF9psBH6PPhe1Xha5-P=h9A@mail.gmail.com>
Subject: Re: balance disables nodatacow
From: Kyle Gates <kylegates@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2012 at 9:00 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 07/31/2012 03:55 AM, Kyle Gates wrote:
>
>> I have a 3 disk raid1 filesystem mounted with nodatacow. I have a
>> folder in said filesystem with the 'C' NOCOW & 'Z' Not_Compressed
>> flags set for good measure. I then copy in a large file and proceed to
>> make random modifications. Filefrag shows no additional extents
>> created, good so far. A big thank you to the those devs who got that
>> working.
>> However, after a balance run (which crashed btw), modifications to the
>> file result in increasing extent counts, ie. no longer obeying
>> nodatacow mount option nor the 'C' flag.
>> I realize that a balance will cow the data but it should not disable
>> the ability to make nodatacow inline changes to a file.
>>
>> I'm currently running 3.5.0 mainline Ubuntu kernel with the latest
>> master of btrfs-progs from a ppa.
>>
>
>
> hmm, I want to know if your 3.5.0 mainline ubuntu kernel has the commit:
>
> Btrfs: make btrfs's allocation smoothly with preallocation
>
> This commit may help you out of trouble.
> Please let us know the result.
>
> thanks,
> liubo
>
>> Thank you.
>> Kyle Gates
I didn't have that commit before but I do now:
Linux home 3.5.0-999-generic #201207290405 SMP Sun Jul 29 08:13:26 UTC
2012 i686 athlon i386 GNU/Linux

One of my disk is having some issues though. I got this why running a
balance which is now hung:

Jul 30 23:26:38 home kernel: [ 3809.072508] btrfs: found 43 extents
Jul 30 23:26:41 home kernel: [ 3811.987119] btrfs: found 43 extents
Jul 30 23:26:41 home kernel: [ 3812.264800] btrfs: relocating block
group 1270947512320 flags 17
Jul 30 23:26:55 home kernel: [ 3825.690152] ata3.00: exception Emask
0x0 SAct 0x0 SErr 0x0 action 0x0
Jul 30 23:26:55 home kernel: [ 3825.690161] ata3.00: BMDMA stat 0x64
Jul 30 23:26:55 home kernel: [ 3825.690166] ata3.00: failed command:
READ DMA EXT
Jul 30 23:26:55 home kernel: [ 3825.690174] ata3.00: cmd
25/00:00:00:44:2d/00:04:0c:00:00/e0 tag 0 dma 524288 in
Jul 30 23:26:55 home kernel: [ 3825.690174]          res
51/40:00:bd:45:2d/40:00:0c:00:00/e0 Emask 0x9 (media error)
Jul 30 23:26:55 home kernel: [ 3825.690177] ata3.00: status: { DRDY ERR }
Jul 30 23:26:55 home kernel: [ 3825.690180] ata3.00: error: { UNC }
Jul 30 23:26:55 home kernel: [ 3825.712355] ata3.00: configured for UDMA/133
Jul 30 23:26:55 home kernel: [ 3825.712396] sd 2:0:0:0: [sdd]
Unhandled sense code
Jul 30 23:26:55 home kernel: [ 3825.712400] sd 2:0:0:0: [sdd]
Jul 30 23:26:55 home kernel: [ 3825.712402] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Jul 30 23:26:55 home kernel: [ 3825.712405] sd 2:0:0:0: [sdd]
Jul 30 23:26:55 home kernel: [ 3825.712408] Sense Key : Medium Error
[current] [descriptor]
Jul 30 23:26:55 home kernel: [ 3825.712412] Descriptor sense data with
sense descriptors (in hex):
Jul 30 23:26:55 home kernel: [ 3825.712414]         72 03 11 04 00 00
00 0c 00 0a 80 00 00 00 00 00
Jul 30 23:26:55 home kernel: [ 3825.712424]         0c 2d 45 bd
Jul 30 23:26:55 home kernel: [ 3825.712429] sd 2:0:0:0: [sdd]
Jul 30 23:26:55 home kernel: [ 3825.712433] Add. Sense: Unrecovered
read error - auto reallocate failed
Jul 30 23:26:55 home kernel: [ 3825.712437] sd 2:0:0:0: [sdd] CDB:
Jul 30 23:26:55 home kernel: [ 3825.712439] Read(10): 28 00 0c 2d 44
00 00 04 00 00
Jul 30 23:26:55 home kernel: [ 3825.712448] end_request: I/O error,
dev sdd, sector 204293565
Jul 30 23:26:55 home kernel: [ 3825.712453] btrfs: bdev /dev/sdd6
errs: wr 0, rd 70, flush 0, corrupt 0, gen 0
Jul 30 23:26:55 home kernel: [ 3825.712457] btrfs: bdev /dev/sdd6
errs: wr 0, rd 71, flush 0, corrupt 0, gen 0
Jul 30 23:26:55 home kernel: [ 3825.712463] btrfs: bdev /dev/sdd6
errs: wr 0, rd 72, flush 0, corrupt 0, gen 0
Jul 30 23:26:55 home kernel: [ 3825.712466] btrfs: bdev /dev/sdd6
errs: wr 0, rd 73, flush 0, corrupt 0, gen 0
Jul 30 23:26:55 home kernel: [ 3825.712470] btrfs: bdev /dev/sdd6
errs: wr 0, rd 74, flush 0, corrupt 0, gen 0
Jul 30 23:26:55 home kernel: [ 3825.712484] ata3: EH complete
Jul 30 23:29:10 home kernel: [ 3960.660091] INFO: task btrfs:4600
blocked for more than 120 seconds.
Jul 30 23:29:10 home kernel: [ 3960.660099] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 30 23:29:10 home kernel: [ 3960.660102] btrfs           D f8540aba
    0  4600   4598 0x00000000
Jul 30 23:29:10 home kernel: [ 3960.660109]  c5d2dc20 00000082
c5d2dc28 f8540aba f55da048 c185f220 c198f080 c198f080
Jul 30 23:29:10 home kernel: [ 3960.660116]  d3e86224 0000037a
f73f0080 cabe8000 f51cb2c0 00000000 00000000 f6dea000
Jul 30 23:29:10 home kernel: [ 3960.660122]  f52f8800 0000db6b
00000000 00000000 00000004 00000000 00000001 cabe8000
Jul 30 23:29:10 home kernel: [ 3960.660128] Call Trace:
Jul 30 23:29:10 home kernel: [ 3960.660207]  [<f8540aba>] ?
reserve_metadata_bytes.isra.70+0x31a/0x590 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660217]  [<c1094d28>] ?
ktime_get_ts+0xb8/0xe0
Jul 30 23:29:10 home kernel: [ 3960.660225]  [<c15dabd3>] schedule+0x23/0x60
Jul 30 23:29:10 home kernel: [ 3960.660229]  [<c15dac88>] io_schedule+0x78/0xb0
Jul 30 23:29:10 home kernel: [ 3960.660237]  [<c110772d>] sleep_on_page+0xd/0x20
Jul 30 23:29:10 home kernel: [ 3960.660241]  [<c15d9777>]
__wait_on_bit_lock+0x47/0x90
Jul 30 23:29:10 home kernel: [ 3960.660244]  [<c1107720>] ?
__lock_page+0x80/0x80
Jul 30 23:29:10 home kernel: [ 3960.660248]  [<c1107718>] __lock_page+0x78/0x80
Jul 30 23:29:10 home kernel: [ 3960.660255]  [<c1068e00>] ?
autoremove_wake_function+0x50/0x50
Jul 30 23:29:10 home kernel: [ 3960.660259]  [<c110782d>]
find_lock_page+0x5d/0x70
Jul 30 23:29:10 home kernel: [ 3960.660292]  [<f859912d>]
relocate_file_extent_cluster+0x17d/0x3e0 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660316]  [<f8599486>]
relocate_data_extent.isra.47+0xf6/0x120 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660339]  [<f859c695>]
relocate_block_group+0x295/0x5a0 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660363]  [<f859cb32>]
btrfs_relocate_block_group+0x192/0x2e0 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660386]  [<f8576ec9>]
btrfs_relocate_chunk.isra.50+0x59/0x3c0 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660408]  [<f85764ca>] ?
should_balance_chunk.isra.54+0x3a/0x350 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660431]  [<f857351e>] ?
free_extent_buffer+0x2e/0x80 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660453]  [<f857bf19>]
__btrfs_balance+0x389/0x470 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660476]  [<f857c384>]
btrfs_balance+0x384/0x560 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660482]  [<c11457a1>] ?
kmem_cache_alloc_trace+0x111/0x140
Jul 30 23:29:10 home kernel: [ 3960.660504]  [<f858493d>]
btrfs_ioctl_balance+0xed/0x380 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660528]  [<f85864b1>]
btrfs_ioctl+0x561/0x890 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660551]  [<f8585f50>] ?
update_ioctl_balance_args+0x2c0/0x2c0 [btrfs]
Jul 30 23:29:10 home kernel: [ 3960.660558]  [<c116565f>]
do_vfs_ioctl+0x7f/0x2f0
Jul 30 23:29:10 home kernel: [ 3960.660562]  [<c116593f>] sys_ioctl+0x6f/0x80
Jul 30 23:29:10 home kernel: [ 3960.660570]  [<c15e29df>]
sysenter_do_call+0x12/0x28
Jul 30 23:31:10 home kernel: [ 4080.660090] INFO: task btrfs:4600
blocked for more than 120 seconds.
Jul 30 23:31:10 home kernel: [ 4080.660098] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 30 23:31:10 home kernel: [ 4080.660101] btrfs           D f8540aba
    0  4600   4598 0x00000000
Jul 30 23:31:10 home kernel: [ 4080.660107]  c5d2dc20 00000082
c5d2dc28 f8540aba f55da048 c185f220 c198f080 c198f080
Jul 30 23:31:10 home kernel: [ 4080.660114]  d3e86224 0000037a
f73f0080 cabe8000 f51cb2c0 00000000 00000000 f6dea000
Jul 30 23:31:10 home kernel: [ 4080.660121]  f52f8800 0000db6b
00000000 00000000 00000004 00000000 00000001 cabe8000
Jul 30 23:31:10 home kernel: [ 4080.660127] Call Trace:
Jul 30 23:31:10 home kernel: [ 4080.660203]  [<f8540aba>] ?
reserve_metadata_bytes.isra.70+0x31a/0x590 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660212]  [<c1094d28>] ?
ktime_get_ts+0xb8/0xe0
Jul 30 23:31:10 home kernel: [ 4080.660220]  [<c15dabd3>] schedule+0x23/0x60
Jul 30 23:31:10 home kernel: [ 4080.660224]  [<c15dac88>] io_schedule+0x78/0xb0
Jul 30 23:31:10 home kernel: [ 4080.660232]  [<c110772d>] sleep_on_page+0xd/0x20
Jul 30 23:31:10 home kernel: [ 4080.660236]  [<c15d9777>]
__wait_on_bit_lock+0x47/0x90
Jul 30 23:31:10 home kernel: [ 4080.660240]  [<c1107720>] ?
__lock_page+0x80/0x80
Jul 30 23:31:10 home kernel: [ 4080.660243]  [<c1107718>] __lock_page+0x78/0x80
Jul 30 23:31:10 home kernel: [ 4080.660250]  [<c1068e00>] ?
autoremove_wake_function+0x50/0x50
Jul 30 23:31:10 home kernel: [ 4080.660254]  [<c110782d>]
find_lock_page+0x5d/0x70
Jul 30 23:31:10 home kernel: [ 4080.660287]  [<f859912d>]
relocate_file_extent_cluster+0x17d/0x3e0 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660310]  [<f8599486>]
relocate_data_extent.isra.47+0xf6/0x120 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660334]  [<f859c695>]
relocate_block_group+0x295/0x5a0 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660358]  [<f859cb32>]
btrfs_relocate_block_group+0x192/0x2e0 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660381]  [<f8576ec9>]
btrfs_relocate_chunk.isra.50+0x59/0x3c0 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660403]  [<f85764ca>] ?
should_balance_chunk.isra.54+0x3a/0x350 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660426]  [<f857351e>] ?
free_extent_buffer+0x2e/0x80 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660448]  [<f857bf19>]
__btrfs_balance+0x389/0x470 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660471]  [<f857c384>]
btrfs_balance+0x384/0x560 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660477]  [<c11457a1>] ?
kmem_cache_alloc_trace+0x111/0x140
Jul 30 23:31:10 home kernel: [ 4080.660500]  [<f858493d>]
btrfs_ioctl_balance+0xed/0x380 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660523]  [<f85864b1>]
btrfs_ioctl+0x561/0x890 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660546]  [<f8585f50>] ?
update_ioctl_balance_args+0x2c0/0x2c0 [btrfs]
Jul 30 23:31:10 home kernel: [ 4080.660554]  [<c116565f>]
do_vfs_ioctl+0x7f/0x2f0
Jul 30 23:31:10 home kernel: [ 4080.660558]  [<c116593f>] sys_ioctl+0x6f/0x80
Jul 30 23:31:10 home kernel: [ 4080.660565]  [<c15e29df>]
sysenter_do_call+0x12/0x28
