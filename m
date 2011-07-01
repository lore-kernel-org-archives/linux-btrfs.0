From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: [3.0.0rc5] invalid opcode
Date: Fri, 1 Jul 2011 20:38:58 +0100
Message-ID: <20110701193858.GB8352@yahoo.fr>
References: <20110701174436.GA8352@yahoo.fr>
 <4E0E1B08.4000404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0E1B08.4000404@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-01 15:07:52 -0400, Josef Bacik:
> On 07/01/2011 01:44 PM, Stephane Chazelas wrote:
[...]
> > [ 8203.192146] kernel BUG at /media/data/mattems/src/linux-2.6-3.0.0~rc5/debian/build/source_amd64_none/fs/btrfs/inode.c:1583!
> > [ 8203.192210] invalid opcode: 0000 [#1] SMP
[...]
> > [ 8203.193219] Process btrfs-fixup-0 (pid: 747, threadinfo ffff8801483fe000, task ffff88014672efa0)
[...]
> > [ 8203.193538]  [<ffffffffa01669fa>] ? worker_loop+0x186/0x4a1 [btrfs]
> > [ 8203.193579]  [<ffffffff813369ca>] ? schedule+0x5ed/0x61a
> > [ 8203.193624]  [<ffffffffa0166874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
> > [ 8203.193673]  [<ffffffffa0166874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
> > [ 8203.193714]  [<ffffffff8105faed>] ? kthread+0x7a/0x82
> > [ 8203.193750]  [<ffffffff8133e524>] ? kernel_thread_helper+0x4/0x10
> > [ 8203.193788]  [<ffffffff8105fa73>] ? kthread_worker_fn+0x147/0x147
> > [ 8203.193825]  [<ffffffff8133e520>] ? gs_change+0x13/0x13
> > [ 8203.193859] Code: 41 b8 50 00 00 00 4c 89 f1 e8 d5 3b 01 00 48 89 df e8 fb ac f6 e0 ba 01 00 00 00 4c 89 ee 4c 89 e7 e8 ce 05 01 00 e9 4e ff ff ff <0f> 0b eb fe 48 8b 3c 24 41 b8 50 00 00 00 4c 89 f1 4c 89 fa 48
> > [ 8203.194087] RIP  [<ffffffffa014b0f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
> > [ 8203.194160]  RSP <ffff8801483ffde0>
> > [ 8203.194907] ---[ end trace 9744d33381de3d04 ]---
> > 
> > Should I be worried?
> > 
> 
> A little, can you reproduce it?  Thanks,
[...]

Well no. I have no idea what triggered it. It was in the middle
of doing an rsync from one compressed btrfs fs on 3 HDs (1
partition and 2 HDs) onto a btrfs FS on one LUKS device
(compressed as well). That rsync is still happily ongoing and
the server looks fine. Nothing else happening.

What's btrfs-fixup meant to do?

Cheers,
Stephane
