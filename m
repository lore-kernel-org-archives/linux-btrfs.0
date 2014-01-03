Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49674 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaACTvc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 14:51:32 -0500
MIME-Version: 1.0
In-Reply-To: <20140102053101.GA29352@localhost>
References: <20140102053101.GA29352@localhost>
Date: Fri, 3 Jan 2014 11:51:31 -0800
Message-ID: <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
From: Muthu Kumar <muthu.lkml@gmail.com>
To: fengguang.wu@intel.com
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like Kent missed the btrfs endio in the original commit. How
about this patch:

---------

In btrfs_end_bio, call bio_endio_nodec on the restored bio so the
bi_remaining is accounted for correctly.

Reported-by: fengguang.wu@intel.com
Cc: Kent Overstreet <kmo@daterainc.com>
CC: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
--------

 fs/btrfs/volumes.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2130de..edfed52 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5316,7 +5316,11 @@ static void btrfs_end_bio(struct bio *bio, int err)
                }
                kfree(bbio);

-               bio_endio(bio, err);
+                /*
+                 * Call endio_nodec on the restored bio so the bi_remaining is
+                 * accounted for correctly
+                 */
+               bio_endio_nodec(bio, err);
        } else if (!is_orig_bio) {
                bio_put(bio);
        }

On Wed, Jan 1, 2014 at 9:31 PM,  <fengguang.wu@intel.com> wrote:
> Greetings,
>
> We hit the below bug when doing write tests to btrfs.
> Other filesystems (ext4, xfs) works fine. 2 full dmesgs are attached.
>
> 196d38bccfcfa32faed8c561868336fdfa0fe8e4 is the first bad commit
> commit 196d38bccfcfa32faed8c561868336fdfa0fe8e4
> Author:     Kent Overstreet <kmo@daterainc.com>
> AuthorDate: Sat Nov 23 18:34:15 2013 -0800
> Commit:     Kent Overstreet <kmo@daterainc.com>
> CommitDate: Sat Nov 23 22:33:56 2013 -0800
>
>     block: Generic bio chaining
>
>     This adds a generic mechanism for chaining bio completions. This is
>     going to be used for a bio_split() replacement, and it turns out to be
>     very useful in a fair amount of driver code - a fair number of drivers
>     were implementing this in their own roundabout ways, often painfully.
>
>     Note that this means it's no longer to call bio_endio() more than once
>     on the same bio! This can cause problems for drivers that save/restore
>     bi_end_io. Arguably they shouldn't be saving/restoring bi_end_io at all
>     - in all but the simplest cases they'd be better off just cloning the
>     bio, and immutable biovecs is making bio cloning cheaper. But for now,
>     we add a bio_endio_nodec() for these cases.
>
>     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
>     Cc: Jens Axboe <axboe@kernel.dk>
>
>  drivers/md/bcache/io.c       |  2 +-
>  drivers/md/dm-cache-target.c |  6 ++++
>  drivers/md/dm-snap.c         |  1 +
>  drivers/md/dm-thin.c         |  8 +++--
>  drivers/md/dm-verity.c       |  2 +-
>  fs/bio-integrity.c           |  2 +-
>  fs/bio.c                     | 76 ++++++++++++++++++++++++++++++++++++++++----
>  include/linux/bio.h          |  2 ++
>  include/linux/blk_types.h    |  2 ++
>  9 files changed, 90 insertions(+), 11 deletions(-)
>
> [   35.466413] random: nonblocking pool is initialized
> [  196.918039] ------------[ cut here ]------------
> [  196.919770] kernel BUG at fs/bio.c:1748!
> [  196.921505] invalid opcode: 0000 [#1] SMP
> [  196.921788] Modules linked in: microcode processor
> [  196.921788] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc6-01897-g2b48961 #1
> [  196.921788] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  196.921788] task: ffff8804094acad0 ti: ffff8804094e8000 task.ti: ffff8804094e8000
> [  196.921788] RIP: 0010:[<ffffffff811ef01e>]  [<ffffffff811ef01e>] bio_endio+0x1e/0x6a
> [  196.921788] RSP: 0018:ffff88041fc83da8  EFLAGS: 00010046
> [  196.921788] RAX: 0000000000000000 RBX: 00000000fffffffb RCX: 00000001802a0002
> [  196.921788] RDX: 00000001802a0003 RSI: 0000000000000000 RDI: ffff8800299ff9e8
> [  196.921788] RBP: ffff88041fc83dc0 R08: ffffea00096cc980 R09: ffff8804097f5100
> [  196.921788] R10: ffffea000aeb8280 R11: ffffffff8143841e R12: ffff88025b326780
> [  196.921788] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000003000
> [  196.921788] FS:  0000000000000000(0000) GS:ffff88041fc80000(0000) knlGS:0000000000000000
> [  196.921788] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  196.921788] CR2: 00007f16e7a1948f CR3: 000000007f85e000 CR4: 00000000000006e0
> [  196.921788] Stack:
> [  196.921788]  ffff8800299ff9e8 ffff8800299ff9e8 ffff88025b326780 ffff88041fc83de8
> [  196.921788]  ffffffff81438429 00000000fffffffb ffff8803d36e6c00 0000000000000000
> [  196.921788]  ffff88041fc83e10 ffffffff811ef063 ffff8802bae0a1e8 ffff8802bae0a1e8
> [  196.921788] Call Trace:
> [  196.921788]  <IRQ>
> [  196.921788]  [<ffffffff81438429>] btrfs_end_bio+0x116/0x11d
> [  196.921788]  [<ffffffff811ef063>] bio_endio+0x63/0x6a
> [  196.921788]  [<ffffffff814cb712>] blk_mq_complete_request+0x89/0xfe
> [  196.921788]  [<ffffffff814cb79d>] __blk_mq_end_io+0x16/0x18
> [  196.921788]  [<ffffffff814cb7bf>] blk_mq_end_io+0x20/0xb1
> [  196.921788]  [<ffffffff815a1ba9>] virtblk_done+0xa4/0xf6
> [  196.921788]  [<ffffffff8155c463>] vring_interrupt+0x7c/0x8a
> [  196.921788]  [<ffffffff81107427>] handle_irq_event_percpu+0x4a/0x1bc
> [  196.921788]  [<ffffffff811075de>] handle_irq_event+0x45/0x61
> [  196.921788]  [<ffffffff81109f40>] handle_edge_irq+0xd9/0xfb
> [  196.921788]  [<ffffffff81039f56>] handle_irq+0x21/0x2a
> [  196.921788]  [<ffffffff81a0c3fd>] do_IRQ+0x4d/0xb4
> [  196.921788]  [<ffffffff81a034f2>] common_interrupt+0x72/0x72
> [  196.921788]  <EOI>
> [  196.921788]  [<ffffffff81065bfa>] ? native_safe_halt+0x6/0x8
> [  196.921788]  [<ffffffff8103f5d8>] default_idle+0x38/0xc1
> [  196.921788]  [<ffffffff8103fd04>] arch_cpu_idle+0x18/0x28
> [  196.921788]  [<ffffffff81106b6b>] cpu_startup_entry+0x178/0x269
> [  196.921788]  [<ffffffff81116954>] ? clockevents_register_device+0x112/0x117
> [  196.921788]  [<ffffffff8105ba60>] start_secondary+0x277/0x279
> [  196.921788] Code: ff ff eb bb 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 53 53 bb fb ff ff ff 48 85 ff 74 4c 8b 47 44 85 c0 7f 02 <0f> 0b 85 f6 74 07 f0 80 67 10 fe eb 09 48 8b 47 10 a8 01 0f 44
> [  196.921788] RIP  [<ffffffff811ef01e>] bio_endio+0x1e/0x6a
> [  196.921788]  RSP <ffff88041fc83da8>
> [  196.921788] ---[ end trace 0ec0fc28f7931a30 ]---
> [  196.921788] Kernel panic - not syncing: Fatal exception in interrupt
> [  196.921788] Rebooting in 10 seconds..
>
> Thanks,
> Fengguang
>
