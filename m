From: David Sterba <dave@jikos.cz>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2260!
Date: Fri, 10 Jun 2011 02:22:08 +0200
Message-ID: <20110610002208.GQ12709@twin.jikos.cz>
References: <m3tyccay9y.fsf@jhcloos.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: James Cloos <cloos@jhcloos.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3tyccay9y.fsf@jhcloos.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, May 30, 2011 at 01:33:21PM -0400, James Cloos wrote:
> The BUG_ON() call is from:
> 
>         if (!BTRFS_I(inode)->orphan_meta_reserved) {
>                 BTRFS_I(inode)->orphan_meta_reserved = 1;
>                 reserve = 1;
>         }
> /* *ELIDED* */
>         /* grab metadata reservation from transaction handle */
>         if (reserve) {
>                 ret = btrfs_orphan_reserve_metadata(trans, inode);
>                 BUG_ON(ret);

ret == -ENOSPC

>         }
> 
> and I cannot umount(8) that fs since this.  It claims to be in use.

system is in undefined state after hitting a BUG_ON, there may be locked
spinlocks/mutexes, held references, etc, causing hangs eg. during sync.

> A du(1) gets stuck but remains interuptable and quits cleanly when
> signaled.

one can have a look at /proc/<pid>/stack where the process is stuck, and
what locks are being held, probably with TASK_INTERRUPTIBLE. but this
will not help anyhow.


> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/inode.c:2260!
> invalid opcode: 0000 [#1] PREEMPT SMP 
> CPU 1 
> Modules linked in: k10temp
> 
> Pid: 1343, comm: g-common Not tainted 2.6.39-07159-gf23a5e1 #57 MSI MS-7642/890GXM-G65 (MS-7642)  
> RIP: 0010:[<ffffffff8124144d>]  [<ffffffff8124144d>] btrfs_orphan_add+0xfa/0x13c
> RSP: 0018:ffff88001a51bdd8  EFLAGS: 00010286
> RAX: 00000000ffffffe4 RBX: ffff8802fb8e9000 RCX: ffff8802bd624530
       ^^^^^^^^^^^^^^^^
confirmed, -ENOSPC == -28


david
