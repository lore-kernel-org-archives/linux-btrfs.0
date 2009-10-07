From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/file.c:528 on Linux 2.6.31.1
Date: Wed, 7 Oct 2009 11:25:57 -0400
Message-ID: <20091007152557.GG3757@think>
References: <fbd9d3990910070334j2080a579p25c42d23dbee08c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Stefan Hajnoczi <stefanha@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <fbd9d3990910070334j2080a579p25c42d23dbee08c0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 07, 2009 at 11:34:54AM +0100, Stefan Hajnoczi wrote:
> I am testing btrfs on Linux 2.6.31.1 and am repeatedly hitting the
> following issue in the btrfs-endio-wri thread:
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/file.c:528!
> invalid opcode: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/block/dm-0/range
> Pid: 10093, comm: btrfs-endio-wri Not tainted 2.6.31.1 #1 OptiPlex 755
> RIP: 0010:[<ffffffffa03552d5>]  [<ffffffffa03552d5>]
> btrfs_drop_extents+0x6d5/0x907 [btrfs]
> RSP: 0018:ffff88006cf6dc10  EFLAGS: 00010282
> RAX: 00000000ffffffef RBX: 0000000223338fff RCX: 00000000000006d5
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000100000001
> RBP: 0000000000000000 R08: ffff880069c2ab50 R09: ffff880069c2ab50
> R10: 0000000000000004 R11: 0000000000000021 R12: ffff88003d5d6490
> R13: ffff880069c2ab50 R14: 000000013231c000 R15: ffff880020e6bc18
> FS:  0000000000000000(0000) GS:ffff880001ba6000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000009f6c60 CR3: 000000006b977000 CR4: 00000000000026f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
> Process btrfs-endio-wri (pid: 10093, threadinfo ffff88006cf6c000, task
> ffff88006cd267b0)
> Stack:
>  0000000000001d8d 00000001264ef000 fffffffffffffff6 0000000132320000
> <0> 0000000132320000 000000013231c000 ffff880020e6bd98 ffff88006cdae000
> <0> ffff8800454ff8e0 0101ffff00000003 0000000223339000 0000000223339000
> Call Trace:
>  [<ffffffffa034c254>] ? insert_reserved_file_extent+0xa4/0x24c [btrfs]
>  [<ffffffffa03620a4>] ? lock_extent+0x38/0x80 [btrfs]
>  [<ffffffffa03505bf>] ? btrfs_finish_ordered_io+0x184/0x23d [btrfs]
>  [<ffffffffa036422c>] ? end_bio_extent_writepage+0x9b/0x186 [btrfs]
>  [<ffffffffa036b6bb>] ? worker_loop+0x5f/0x1ec [btrfs]
>  [<ffffffffa036b65c>] ? worker_loop+0x0/0x1ec [btrfs]
>  [<ffffffff81056d4a>] ? kthread+0x8b/0x95
>  [<ffffffff8100cb5a>] ? child_rip+0xa/0x20
>  [<ffffffff81056cbf>] ? kthread+0x0/0x95
>  [<ffffffff8100cb50>] ? child_rip+0x0/0x20
> Code: 00 00 00 35 00 00 00 41 b9 01 00 00 00 4c 8d 84 24 fc 00 00 00
> 4c 89 ea 48 8b 74 24 38 48 8b 7c 24 40 e8 a5 4c fe ff 85 c0 74 04 <0f>
> 0b eb fe 49 8b 6d 00 49 63 75 40 48 89 ef 48 6b f6 19 48 83
> RIP  [<ffffffffa03552d5>] btrfs_drop_extents+0x6d5/0x907 [btrfs]
>  RSP <ffff88006cf6dc10>
> ---[ end trace 5dd7bea4ce87888f ]---
> 
> Specifics of my setup:
> 1. The filesystem is used exclusively over NFS.
> 2. The filesystem contains only a few files, most are large (~9 GB).
> 3. I use bcp(1) to make copy-on-write copies of the large files.
> 4. The filesystem is 40 GB and currently 15 GB (37%) are in use.
> 5. The filesystem is on an LVM volume.
> 
> Any idea what is going on here and whether this is already fixed?

This oops means that we're trying to insert an extent that already
exists.  I think it is related to the bug in the file clone ioctl that
Sage recently fixed.  The fix is in the master branch of the
btrfs-unstable tree.

So, I'd say step one is to make a backup of this data.

Are you able to figure out which of the files is being written at the
time of the oops?  If not we can easily add a message to help nail it
down.

Either way, I'd copy the file that is triggering the problem to a new
file and delete the old one.

-chris

