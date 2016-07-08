Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33246 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbcGHSVY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 14:21:24 -0400
Date: Fri, 8 Jul 2016 20:21:16 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>
Cc: Gabriel C <nix.or.die@gmail.com>, linux-btrfs@vger.kernel.org,
        quwenruo@cn.fujitsu.com
Subject: Re: A lot warnings in dmesg while running thunderbird
Message-ID: <20160708182116.GA30214@angband.pl>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
 <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
 <b84d72ce-3221-1f0d-7f63-ae02fe0d776b@fb.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
 <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 08, 2016 at 12:02:35PM -0400, Chris Mason wrote:
> On 07/08/2016 11:02 AM, Gabriel C wrote:
> > [btrfs_destroy_inode again]

> Can you please run the attached test program:
> 
> gcc -o short-write short-write.c -lpthread
> ./short-write some-new-file-on-btrfs
> 
> I want to see if you're triggering the same problem we've tried to fix, or
> something else.

Looks like same, 4.6.3:

[239214.345100] ------------[ cut here ]------------
[239214.345122] WARNING: CPU: 0 PID: 28038 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x22b/0x2a0
[239214.345127] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nls_utf8 isofs loop tun usb_storage fuse nvidia(PO)
[239214.345153] CPU: 0 PID: 28038 Comm: short-write Tainted: P           O    4.6.3-x32+ #8
[239214.345158] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[239214.345162]  0000000000000000 ffffffff813819b0 0000000000000000 0000000000000000
[239214.345170]  ffffffff8108ce92 0000000000000000 ffff88010c2d71c8 ffff880222670800
[239214.345177]  0000000000000000 ffff88010c2d71c8 00000000ffffff9c ffffffff812b1e0b
[239214.345183] Call Trace:
[239214.345194]  [<ffffffff813819b0>] ? dump_stack+0x46/0x66
[239214.345202]  [<ffffffff8108ce92>] ? __warn+0xe2/0x100
[239214.345209]  [<ffffffff812b1e0b>] ? btrfs_destroy_inode+0x22b/0x2a0
[239214.345216]  [<ffffffff811b93bc>] ? do_unlinkat+0x12c/0x2f0
[239214.345224]  [<ffffffff8174815f>] ? entry_SYSCALL_64_fastpath+0x17/0x93
[239214.345229] ---[ end trace ae49f2a4ae4a26ea ]---
[239214.404237] ------------[ cut here ]------------
[239214.404258] WARNING: CPU: 5 PID: 28038 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0x63/0x80
[239214.404262] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nls_utf8 isofs loop tun usb_storage fuse nvidia(PO)
[239214.404286] CPU: 5 PID: 28038 Comm: short-write Tainted: P        W  O    4.6.3-x32+ #8
[239214.404291] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[239214.404295]  0000000000000000 ffffffff813819b0 0000000000000000 0000000000000000
[239214.404303]  ffffffff8108ce92 0000000000001000 ffff880229415c00 00000000037ea000
[239214.404309]  ffff8800c2ed7da0 ffff88000dd3d800 0000000000000000 ffffffff81287143
[239214.404315] Call Trace:
[239214.404325]  [<ffffffff813819b0>] ? dump_stack+0x46/0x66
[239214.404333]  [<ffffffff8108ce92>] ? __warn+0xe2/0x100
[239214.404341]  [<ffffffff81287143>] ? btrfs_free_reserved_data_space_noquota+0x63/0x80
[239214.404349]  [<ffffffff812877b1>] ? btrfs_delalloc_release_space+0x31/0x60
[239214.404356]  [<ffffffff812b4301>] ? __btrfs_buffered_write+0x591/0x680
[239214.404364]  [<ffffffff812b7802>] ? btrfs_file_write_iter+0x182/0x550
[239214.404372]  [<ffffffff811a8419>] ? __vfs_write+0xa9/0xe0
[239214.404379]  [<ffffffff811a934c>] ? vfs_write+0xac/0x1a0
[239214.404387]  [<ffffffff811aa8c8>] ? SyS_pwrite64+0x88/0xa0
[239214.404394]  [<ffffffff8174815f>] ? entry_SYSCALL_64_fastpath+0x17/0x93
[239214.404399] ---[ end trace ae49f2a4ae4a26eb ]---

... and sda1 is goes ro.
Single device, noatime,compress=lzo,ssd.

It's somewhat puzzling that back in the day applying 56244ef15 stopped this
reproducer for me, yet somehow it triggers again.

-- 
An imaginary friend squared is a real enemy.
