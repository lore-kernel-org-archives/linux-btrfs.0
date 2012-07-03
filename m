Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37521 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab2GCDzg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 23:55:36 -0400
Received: by wgbdr13 with SMTP id dr13so5845638wgb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 20:55:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120702133446.GD6185@localhost.localdomain>
References: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
	<20120702133446.GD6185@localhost.localdomain>
Date: Tue, 3 Jul 2012 11:55:34 +0800
Message-ID: <CAMVG2ssdmtCLYX22kAx0_7Ga8FMM1MQNTCUYpXAV9VAdrO1yYQ@mail.gmail.com>
Subject: Re: Please hammer my for-linus branch
From: Daniel J Blueman <daniel@quora.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "Chris L. Mason" <clmason@fusionio.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>,
        Liu Bo <liubo2009@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2 July 2012 21:34, Josef Bacik <jbacik@fusionio.com> wrote:
> On Sun, Jul 01, 2012 at 09:35:01PM -0600, Daniel J Blueman wrote:
>> > Hi everyone,
>> >
>> > I've got a nice set of fixes from Josef, Jan, Ilya and others in my
>> > for-linus branch:
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>> >
>> > Some of the changes are fixes for the tree logging code, so I ran some
>> > extra crash runs against them Friday night.
>> >
>> > I ended up with a new crash in the tree log directory deletion replay
>> > code, so I didn't send out the pull request to Linus.
>> >
>> > It isn't clear yet if the new crash is because I was testing differently
>> > or if it is a regression.  I'm nailing it down this weekend, but please
>> > give my for-linus a shot.
>>
>> With this branch (3.4.0), my test has consistently been hitting the
>> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID) in
>> insert_inline_extent_backref [1]. This is followed by a string of
>> other issues [2] and a hard lockup, so I used netconsole to collect
>> this.
>>
>> I'm preparing my btrfs test for xfstests integration, but can slip you
>> it if interested. It hits this case in ~30s.
>>
>
> Can you apply this and capture the output, I have a feeling I know what this is.
> Thanks,
>
> Josef
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5775dc4..917ea70 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1766,7 +1766,13 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
>                                            bytenr, num_bytes, parent,
>                                            root_objectid, owner, offset, 1);
>         if (ret == 0) {
> -               BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
> +               if (owner < BTRFS_FIRST_FREE_OBJECTID) {
> +                       printk(KERN_ERR "bad inline extent, bytenr=%Lu, "
> +                              "num_bytes=%Lu, parent=%Lu, root=%Lu, owner=%Lu"
> +                              ", offset=%Lu\n", bytenr, num_bytes, parent,
> +                              root_objectid, owner, offset);
> +                       BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
> +               }
>                 update_inline_extent_backref(trans, root, path, iref,
>                                              refs_to_add, extent_op);
>         } else if (ret == -ENOENT) {

Bo's additional condition 'root_objectid == BTRFS_TREE_LOG_OBJECTID'
seemed to hold it off.

Here is the debug you asked for [1]. After we've determined the right
fix for this issue, I'll post the other issues I was seeing.

Thanks!
  Daniel

--- [1]

device fsid c5cf90d4-0301-4877-8f34-e8e82fe6ab0a devid 1 transid 3 /dev/ram3
device fsid c5cf90d4-0301-4877-8f34-e8e82fe6ab0a devid 2 transid 3 /dev/ram0
device fsid c5cf90d4-0301-4877-8f34-e8e82fe6ab0a devid 1 transid 4 /dev/ram3
btrfs: allowing degraded mounts
btrfs: force zlib compression
btrfs: disabling disk space caching
btrfs: enabling auto defrag
btrfs: enabling auto recovery
btrfs: no dev_stats entry found for device /dev/ram0 (devid 2) (OK on
first mount after mkfs)
btrfs: no dev_stats entry found for device /dev/ram3 (devid 1) (OK on
first mount after mkfs)
btrfs: relocating block group 512425984 flags 20
btrfs: found 2 extents
btrfs: relocating block group 190382080 flags 9
btrfs: found 4756 extents
btrfs: found 4756 extents
bad inline extent, bytenr=36909056, num_bytes=4096, parent=0, root=5,
owner=0, offset=0
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1774!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC CPU 0

Modules linked in:
 brd dm_crypt dm_mod kvm_intel kvm uvcvideo videobuf2_core videodev
videobuf2_vmalloc videobuf2_memops coretemp microcode iwlwifi
netconsole btrfs i915 cfbcopyarea cfbimgblt cfbfillrect video

Pid: 8055, comm: btrfs-endio-wri Not tainted 3.4.0-debug+ #5 Dell Inc.
Latitude E5420/0H5TG2

RIP: 0010:[<ffffffffa009685b>] [<ffffffffa009685b>]
insert_inline_extent_backref+0x11b/0x120 [btrfs]
RSP: 0018:ffff880200415a40  EFLAGS: 00010282
RAX: 000000000000006d RBX: ffff88020e99c1b0 RCX: 0000000000000000
RDX: ffffffff8103cde5 RSI: 0000000000000001 RDI: ffffffff8103d170
RBP: ffff880200415ac0 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88020e7f7000
R13: ffff88020ef80e60 R14: 0000000000000000 R15: 0000000000001000
FS:  0000000000000000(0000) GS:ffff88022ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f6916262000 CR3: 0000000221e24000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-endio-wri (pid: 8055, threadinfo ffff880200414000, task
ffff880222029ee0)
Stack:
 0000000000000000 0000000000000005 0000000000000000 0000000000000000
 ffff880200000001 ffffffffa0089be5 ffff880200415aa0 0000000002333000
 ffff8801f6f15000 0000000000000ea1 ffff8801f6f15000 ffff88020e99c1b0

Call Trace:
 [<ffffffffa0089be5>] ? btrfs_alloc_path+0x15/0x20 [btrfs]
 [<ffffffffa00968fa>] __btrfs_inc_extent_ref+0x9a/0x1f0 [btrfs]
 [<ffffffffa0098097>] run_delayed_tree_ref+0x167/0x190 [btrfs]
 [<ffffffffa009bf1e>] run_one_delayed_ref+0xde/0xf0 [btrfs]
 [<ffffffffa009c00d>] run_clustered_refs+0xdd/0x370 [btrfs]
 [<ffffffffa009c3e9>] btrfs_run_delayed_refs+0x149/0x340 [btrfs]
 [<ffffffffa00adcb7>] __btrfs_end_transaction+0xa7/0x360 [btrfs]
 [<ffffffffa00adfd0>] btrfs_end_transaction+0x10/0x20 [btrfs]
 [<ffffffffa00b4985>] btrfs_finish_ordered_io+0x185/0x3b0 [btrfs]
 [<ffffffff81095bad>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa00b4bc0>] finish_ordered_fn+0x10/0x20 [btrfs]
 [<ffffffffa00de6d6>] worker_loop+0x86/0x330 [btrfs]
 [<ffffffffa00de650>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
 [<ffffffff8105e2ee>] kthread+0x8e/0xa0
 [<ffffffff815b9314>] kernel_thread_helper+0x4/0x10
 [<ffffffff81069a77>] ? finish_task_switch+0x77/0x100
 [<ffffffff815b754b>] ? _raw_spin_unlock_irq+0x2b/0x50
 [<ffffffff815b79d9>] ? retint_restore_args+0xe/0xe
 [<ffffffff8105e260>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815b9310>] ? gs_change+0xb/0xb
Code:
c0 eb a4 48 8b 45 20 4c 89 f1 48 c7 c7 58 d4 10 a0 4c 8b 4d 18 4c 89
fa 4c 8b 45 10 48 8b 75 b8 48 89 04 24 31 c0 e8 32 b3 50 e1
f>0b 0f 1f 00 55 48 89 e5 48 83 c4 80 48 89 5d d8 4c 89 65 e0
RIP [<ffffffffa009685b>] insert_inline_extent_backref+0x11b/0x120 [btrfs]
RSP <ffff880200415a40>
-- 
Daniel J Blueman
