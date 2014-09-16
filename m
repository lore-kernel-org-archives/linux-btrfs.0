Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:37680 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaIPQvQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 12:51:16 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XTvyE-0004ih-VB
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 12:51:15 -0400
Message-ID: <54186A82.7070801@intellasoft.net>
Date: Tue, 16 Sep 2014 12:51:14 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance enospc
References: <54186A4B.60902@intellasoft.net>
In-Reply-To: <54186A4B.60902@intellasoft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Playing around with this filesystem I hot-removed a device from the
array and put in a replacement.

Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 2 FS bytes used 7.43GiB
         devid    1 size 9.31GiB used 8.90GiB path /dev/sdc6
         devid    3 size 9.31GiB used 8.90GiB path
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa

<removed /dev/sdc>

Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 2 FS bytes used 7.43GiB
         devid    3 size 9.31GiB used 8.90GiB path
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
         *** Some devices missing

cartman {~} root# btrfs device add /dev/sdi6 /
cartman {~} root# btrfs fi show
Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 3 FS bytes used 7.43GiB
         devid    3 size 9.31GiB used 8.90GiB path
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
         devid    4 size 10.00GiB used 0.00 path /dev/sdi6
         *** Some devices missing

cartman {~} root# btrfs filesystem balance start /


Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2411,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2412,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2413,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2414,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2415,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2416,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2417,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2418,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2419,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2420,
rd 0, flush 38, corrupt 137167, gen 25
Sep 16 12:47:14 localhost kernel: BTRFS: lost page write due to I/O
error on /dev/sdc6
Sep 16 12:47:14 localhost kernel: BTRFS: lost page write due to I/O
error on /dev/sdc6
Sep 16 12:47:14 localhost kernel: BTRFS info (device sdd6): found 59023
extents
Sep 16 12:47:14 localhost kernel: use_block_rsv: 4 callbacks suppressed
Sep 16 12:47:14 localhost kernel: ------------[ cut here ]------------
Sep 16 12:47:14 localhost kernel: WARNING: CPU: 1 PID: 5109 at
fs/btrfs/extent-tree.c:7273 btrfs_alloc_free_block+0x455/0x4a0()
Sep 16 12:47:14 localhost kernel: BTRFS: block rsv returned -28
Sep 16 12:47:14 localhost kernel: Modules linked in:
Sep 16 12:47:14 localhost kernel: CPU: 1 PID: 5109 Comm: tail Tainted: G
        W     3.16.1 #2
Sep 16 12:47:14 localhost kernel: Hardware name: Gigabyte Technology
Co., Ltd. GA-MA74GM-S2/GA-MA74GM-S2, BIOS F1 04/17/2008
Sep 16 12:47:14 localhost kernel: 0000000000000000 ffffffff819e3610
ffffffff817e4409 ffff88005a9eba68
Sep 16 12:47:14 localhost kernel: ffffffff8106f6f2 ffff8800379fe980
ffff880073a70000 0000000000001000
Sep 16 12:47:14 localhost kernel: ffff88001fc635a0 ffff8800747b6000
ffffffff8106f7d5 ffffffff819f5978
Sep 16 12:47:14 localhost kernel: Call Trace:
Sep 16 12:47:14 localhost kernel: [<ffffffff817e4409>] ?
dump_stack+0x49/0x6a
Sep 16 12:47:14 localhost kernel: [<ffffffff8106f6f2>] ?
warn_slowpath_common+0x82/0xb0
Sep 16 12:47:14 localhost kernel: [<ffffffff8106f7d5>] ?
warn_slowpath_fmt+0x45/0x50
Sep 16 12:47:14 localhost kernel: [<ffffffff8135f074>] ?
___ratelimit+0x94/0x100
Sep 16 12:47:14 localhost kernel: [<ffffffff81296625>] ?
btrfs_alloc_free_block+0x455/0x4a0
Sep 16 12:47:14 localhost kernel: [<ffffffff810992b7>] ?
set_next_entity+0x37/0x80
Sep 16 12:47:14 localhost kernel: [<ffffffff812ca111>] ?
read_extent_buffer+0xb1/0x110
Sep 16 12:47:14 localhost kernel: [<ffffffff81091de9>] ?
finish_task_switch+0x49/0xe0
Sep 16 12:47:14 localhost kernel: [<ffffffff81280d9f>] ?
btrfs_copy_root+0xef/0x2a0
Sep 16 12:47:14 localhost kernel: [<ffffffff812f1853>] ?
create_reloc_root+0x1e3/0x2a0
Sep 16 12:47:14 localhost kernel: [<ffffffff812f7848>] ?
btrfs_init_reloc_root+0xb8/0xd0
Sep 16 12:47:14 localhost kernel: [<ffffffff812a708f>] ?
record_root_in_trans+0xaf/0x110
Sep 16 12:47:14 localhost kernel: [<ffffffff812a8496>] ?
btrfs_record_root_in_trans+0x46/0x80
Sep 16 12:47:14 localhost kernel: [<ffffffff812a98fc>] ?
start_transaction+0x8c/0x4f0
Sep 16 12:47:14 localhost kernel: [<ffffffff812b1168>] ?
btrfs_dirty_inode+0x58/0xe0
Sep 16 12:47:14 localhost kernel: [<ffffffff8113b382>] ?
touch_atime+0x152/0x160
Sep 16 12:47:14 localhost kernel: [<ffffffff810e3eb5>] ?
generic_file_read_iter+0x545/0x5a0
Sep 16 12:47:14 localhost kernel: [<ffffffff810a1d49>] ?
remove_wait_queue+0x19/0x60
Sep 16 12:47:14 localhost kernel: [<ffffffff810a1bc4>] ?
prepare_to_wait+0x24/0x90
Sep 16 12:47:14 localhost kernel: [<ffffffff81122493>] ?
new_sync_read+0x73/0xa0
Sep 16 12:47:14 localhost kernel: [<ffffffff811230ae>] ? vfs_read+0x9e/0x170
Sep 16 12:47:14 localhost kernel: [<ffffffff8112332f>] ? SyS_read+0x4f/0xd0
Sep 16 12:47:14 localhost kernel: [<ffffffff817eae12>] ?
system_call_fastpath+0x16/0x1b
Sep 16 12:47:14 localhost kernel: ---[ end trace 0662903316baa365 ]---
Sep 16 12:47:14 localhost kernel: BTRFS: lost page write due to I/O
error on /dev/sdc6
Sep 16 12:47:14 localhost kernel: BTRFS: lost page write due to I/O
error on /dev/sdc6
Sep 16 12:47:14 localhost kernel: BTRFS: lost page write due to I/O
error on /dev/sdc6



On 09/16/14 12:37, Duncan wrote:
> Mark Murawski posted on Mon, 15 Sep 2014 22:23:47 -0400 as excerpted:
>
>> I wish i could follow your procedure, but this wasn't an ext conversion.
>>
>> I made this with mkfs for btrfs with kernel circa 3.8ish
>
> Good.  That possible corner-case is eliminated. then.  I had seen nothing
> indicating it might apply, but better to find that out now than to spend
> days tearing hair out trying to trace it down, only to discover it's that
> one already known corner-case!  =:^)
>



