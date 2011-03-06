From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Mon, 07 Mar 2011 08:25:47 +0900
Message-ID: <4D7417FB.2020205@jp.fujitsu.com>
References: <4D6F2FE0.8020508@cn.fujitsu.com> <20110305160122.2d02f86f.kitayama@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: miaox@cn.fujitsu.com, Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110305160122.2d02f86f.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/03/05 16:01), Itaru Kitayama wrote:
> Hi Miao,
> 
> The V3 patch on top of the next-rc fails to pass an xfstests test 13.
> In the btrfs link path, we need to reserve one more metadata in the
> trans_block_rsv for the delayed inode update (if needed) to complete.

Miao's patch (http://marc.info/?l=linux-btrfs&m=129802068318176&w=2)
fixed this problem, maybe.

Thanks,
Itoh

> 
> Here's the log from the test:
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/delayed-inode.c:1565!
> invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/module/floppy/initstate
> CPU 1 
> Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput snd_ens1371 gameport snd_rawmidi ]
> 
> Pid: 6948, comm: fsstress Tainted: G      D W   2.6.36-preempt+ #72 440BX Desktop Reference Platform/VMware Virtual Platform
> RIP: 0010:[<ffffffff8120de65>]  [<ffffffff8120de65>] btrfs_delayed_update_inode+0xfd/0x101
> RSP: 0018:ffff88003b073d68  EFLAGS: 00010286
> RAX: 00000000ffffffe4 RBX: ffff88002a876e48 RCX: ffff88004f3702a0
> RDX: 00000000000003b9 RSI: 0000000000000001 RDI: ffff88003b072000
> RBP: ffff88003b073da8 R08: 0000000000018000 R09: 0000000000000000
> R10: ffff88004f3703f0 R11: 09f911029d74e35b R12: ffff88006861cb90
> R13: ffff88002ec91c18 R14: 0000000000018000 R15: ffff88002a876ea0
> FS:  00007fcad4905720(0000) GS:ffff880005000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f46eb380000 CR3: 00000000708b4000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process fsstress (pid: 6948, threadinfo ffff88003b072000, task ffff88004f324710)
> Stack:
>  ffff88003b073d88 ffff88004f3702a0 0000000000000000 ffff88002ec91c18
> <0> ffff88006861cb90 ffff880036783c18 0000000000000000 ffff88006fcaf000
> <0> ffff88003b073dc8 ffffffff811d8489 ffff88002ec91c18 ffff88006861cb90
> Call Trace:
>  [<ffffffff811d8489>] btrfs_update_inode+0x17/0x44
>  [<ffffffff811da3e0>] btrfs_link+0xff/0x17a
>  [<ffffffff8112300d>] vfs_link+0xda/0x144
>  [<ffffffff811257ac>] sys_linkat+0xc4/0x121
>  [<ffffffff81118925>] ? fsnotify_modify+0x66/0x6e
>  [<ffffffff811190f8>] ? vfs_write+0xd2/0x10a
>  [<ffffffff81125827>] sys_link+0x1e/0x20
>  [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
> Code: f0 ff 40 60 eb 02 eb fe 4c 89 ff e8 7d 29 2b 00 31 f6 48 89 df e8 31 fb ff ff 31 c0 48 83 c4 18 5b 41 5c 41 5d 41 5e  
> RIP  [<ffffffff8120de65>] btrfs_delayed_update_inode+0xfd/0x101
>  RSP <ffff88003b073d68>
> ---[ end trace 38596ade53c80d11 ]---
> 

