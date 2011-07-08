From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Fri, 8 Jul 2011 17:11:03 +0100
Message-ID: <20110708161103.GD4284@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110708154123.GA17886@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110708154123.GA17886@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-08 16:41:23 +0100, Stephane Chazelas:
> 2011-07-08 11:06:08 -0400, Chris Mason:
> [...]
> > So the invalidate opcode in btrfs-fixup-0 is the big problem.  We're
> > either failing to write because we weren't able to allocate memory (and
> > not dealing with it properly) or there is a bigger problem.
> > 
> > Does the btrfs-fixup-0 oops come before or after the ooms?
> 
> Hi Chris, thanks for looking into this.
> 
> It comes long before. Hours before there's any problem. So it
> seems unrelated.

Though every time I had the issue, there had been such an
"invalid opcode" before. But also, I only had both the "invalid
opcode" and memory issue when doing that rsync onto external
hard drive.

> > Please send along any oops output during the run.  Only the first
> > (earliest) oops matters.
> 
> There's always only  one in between two reboots. I've sent two
> already, but here they  are:
[...]

I dug up the traces for before I switched to debian (thinking
getting a newer kernel would improve matters) in case it helps:

Jun  4 18:12:58  ------------[ cut here ]------------
Jun  4 18:12:58  kernel BUG at /build/buildd/linux-2.6.38/fs/btrfs/inode.c:1555!
Jun  4 18:12:58  invalid opcode: 0000 [#2] SMP
Jun  4 18:12:58  last sysfs file: /sys/devices/virtual/block/dm-2/dm/name
Jun  4 18:12:58  CPU 0
Jun  4 18:12:58  Modules linked in: sha256_generic cryptd aes_x86_64 aes_generic dm_crypt psmouse serio_raw xgifb(C+) i3200_edac edac_core nbd btrfs zlib_deflate libcrc32c xenbus_probe_frontend ums_cypress usb_storage uas e1000e ahci libahci
Jun  4 18:12:58 
Jun  4 18:12:58  Pid: 416, comm: btrfs-fixup-0 Tainted: G      D  C  2.6.38-7-server #35-Ubuntu empty empty/Tyan Tank GT20 B5211
Jun  4 18:12:58  RIP: 0010:[<ffffffffa0099765>]  [<ffffffffa0099765>] btrfs_writepage_fixup_worker+0x145/0x150 [btrfs]
Jun  4 18:12:58  RSP: 0018:ffff88003cfddde0  EFLAGS: 00010246
Jun  4 18:12:58  RAX: 0000000000000000 RBX: ffffea000004ca88 RCX: 0000000000000000
Jun  4 18:12:58  RDX: ffff88003cfddd98 RSI: ffffffffffffffff RDI: ffff8800152088b0
Jun  4 18:12:58  RBP: ffff88003cfdde30 R08: ffffe8ffffc09988 R09: ffff88003cfddd98
Jun  4 18:12:58  R10: 0000000000000000 R11: 0000000000000000 R12: 00000000010ec000
Jun  4 18:12:58  R13: ffff880015208988 R14: 0000000000000000 R15: 00000000010ecfff
Jun  4 18:12:58  FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
Jun  4 18:12:58  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  4 18:12:58  CR2: 0000000000e73fe8 CR3: 0000000030fcc000 CR4: 00000000000006f0
Jun  4 18:12:58  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  4 18:12:58  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  4 18:12:58  Process btrfs-fixup-0 (pid: 416, threadinfo ffff88003cfdc000, task ffff880036912dc0)
Jun  4 18:12:58  Stack:
Jun  4 18:12:58   ffff880039c4e120 ffff880015208820 ffff88003cfdde90 ffff880032da4b80
Jun  4 18:12:58   ffff88003cfdde30 ffff88003ce915a0 ffff88003cfdde90 ffff88003cfdde80
Jun  4 18:12:58   ffff880036912dc0 ffff88003ce915f0 ffff88003cfddee0 ffffffffa00c34f4
Jun  4 18:12:58  Call Trace:
Jun  4 18:12:58   [<ffffffffa00c34f4>] worker_loop+0xa4/0x3a0 [btrfs]
Jun  4 18:12:58   [<ffffffffa00c3450>] ? worker_loop+0x0/0x3a0 [btrfs]
Jun  4 18:12:58   [<ffffffff81087116>] kthread+0x96/0xa0
Jun  4 18:12:58   [<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
Jun  4 18:12:58   [<ffffffff81087080>] ? kthread+0x0/0xa0
Jun  4 18:12:58   [<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
Jun  4 18:12:58  Code: 1f 80 00 00 00 00 48 8b 7d b8 48 8d 4d c8 41 b8 50 00 00 00 4c 89 fa 4c 89 e6 e8 37 d1 01 00 eb b6 48 89 df e8 8d 1a 07 e1 eb 9a <0f> 0b 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 41 55
Jun  4 18:12:58  RIP  [<ffffffffa0099765>] btrfs_writepage_fixup_worker+0x145/0x150 [btrfs]
Jun  4 18:12:58   RSP <ffff88003cfddde0>
Jun  4 18:12:58  ---[ end trace e5cf15794ff3ebdb ]---

And:

Jun  5 00:58:10  BUG: Bad page state in process rsync  pfn:1bfdf
Jun  5 00:58:10  page:ffffea000061f8c8 count:0 mapcount:0 mapping:          (null) index:0x2300
Jun  5 00:58:10  page flags: 0x100000000000010(dirty)
Jun  5 00:58:10  Pid: 1584, comm: rsync Tainted: G      D  C  2.6.38-7-server #35-Ubuntu
Jun  5 00:58:10  Call Trace:
Jun  5 00:58:10   [<ffffffff8111250b>] ? dump_page+0x9b/0xd0
Jun  5 00:58:10   [<ffffffff8111260c>] ? bad_page+0xcc/0x120
Jun  5 00:58:10   [<ffffffff81112905>] ? prep_new_page+0x1a5/0x1b0
Jun  5 00:58:10   [<ffffffff815d755e>] ? _raw_spin_lock+0xe/0x20
Jun  5 00:58:10   [<ffffffffa00b7391>] ? test_range_bit+0x111/0x150 [btrfs]
Jun  5 00:58:10   [<ffffffff81112b74>] ? get_page_from_freelist+0x264/0x650
Jun  5 00:58:10   [<ffffffffa0073cce>] ? generic_bin_search.clone.42+0x19e/0x200 [btrfs]
Jun  5 00:58:10   [<ffffffff81113778>] ? __alloc_pages_nodemask+0x118/0x830
Jun  5 00:58:10   [<ffffffffa0073cce>] ? generic_bin_search.clone.42+0x19e/0x200 [btrfs]
Jun  5 00:58:10   [<ffffffff815d755e>] ? _raw_spin_lock+0xe/0x20
Jun  5 00:58:10   [<ffffffff811541d2>] ? get_partial_node+0x92/0xb0
Jun  5 00:58:10   [<ffffffffa00d45bd>] ? btrfs_submit_compressed_read+0x15d/0x4e0 [btrfs]
Jun  5 00:58:10   [<ffffffff81149325>] ? alloc_pages_current+0xa5/0x110
Jun  5 00:58:10   [<ffffffffa00d4625>] ? btrfs_submit_compressed_read+0x1c5/0x4e0 [btrfs]
Jun  5 00:58:10   [<ffffffffa0097e81>] ? btrfs_submit_bio_hook+0x151/0x160 [btrfs]
Jun  5 00:58:10   [<ffffffffa009a118>] ? btrfs_get_extent+0x528/0x8e0 [btrfs]
Jun  5 00:58:10   [<ffffffffa00b4bfa>] ? submit_one_bio+0x6a/0xa0 [btrfs]
Jun  5 00:58:10   [<ffffffffa00b7a12>] ? submit_extent_page.clone.24+0x112/0x1b0 [btrfs]
Jun  5 00:58:10   [<ffffffffa00b7f96>] ? __extent_read_full_page+0x496/0x650 [btrfs]
Jun  5 00:58:10   [<ffffffffa00b7420>] ? end_bio_extent_readpage+0x0/0x250 [btrfs]
Jun  5 00:58:10   [<ffffffffa0099bf0>] ? btrfs_get_extent+0x0/0x8e0 [btrfs]
Jun  5 00:58:10   [<ffffffffa00b8e72>] ? extent_readpages+0xc2/0x100 [btrfs]
Jun  5 00:58:10   [<ffffffffa0099bf0>] ? btrfs_get_extent+0x0/0x8e0 [btrfs]
Jun  5 00:58:10   [<ffffffffa0098c0f>] ? btrfs_readpages+0x1f/0x30 [btrfs]
Jun  5 00:58:10   [<ffffffff811168bb>] ? __do_page_cache_readahead+0x14b/0x220
Jun  5 00:58:10   [<ffffffff81116cf1>] ? ra_submit+0x21/0x30
Jun  5 00:58:10   [<ffffffff81116e15>] ? ondemand_readahead+0x115/0x230
Jun  5 00:58:10   [<ffffffff8110afd4>] ? file_read_actor+0xd4/0x170
Jun  5 00:58:10   [<ffffffff81117021>] ? page_cache_sync_readahead+0x31/0x50
Jun  5 00:58:10   [<ffffffff8110c3be>] ? do_generic_file_read.clone.23+0x2be/0x450
Jun  5 00:58:10   [<ffffffff8110d00a>] ? generic_file_aio_read+0x1ca/0x240
Jun  5 00:58:10   [<ffffffff81164b52>] ? do_sync_read+0xd2/0x110
Jun  5 00:58:10   [<ffffffff81278ea3>] ? security_file_permission+0x93/0xb0
Jun  5 00:58:10   [<ffffffff81164e71>] ? rw_verify_area+0x61/0xf0
Jun  5 00:58:10   [<ffffffff81165333>] ? vfs_read+0xc3/0x180
Jun  5 00:58:10   [<ffffffff81165441>] ? sys_read+0x51/0x90
Jun  5 00:58:10   [<ffffffff8100bfc2>] ? system_call_fastpath+0x16/0x1b

Then first oom kill at 07:33

That "bad page state" is the only occurrence. With that same
kernel, I had the "invalid opcode" + "oom kill" before that
without that "bad page state".

-- 
Stephane
