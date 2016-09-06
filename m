Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46610 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754429AbcIFVwB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 17:52:01 -0400
Date: Tue, 6 Sep 2016 14:51:51 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
Message-ID: <20160906215151.GB31641@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <fe9b1bde-9069-b75f-eb53-83b729cde711@suse.com>
 <1472844934-32343-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H5oCqgd9im-2AZA=zsOv+SCObon2f5wECA7hr58MNXTGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5oCqgd9im-2AZA=zsOv+SCObon2f5wECA7hr58MNXTGw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

On Mon, Sep 05, 2016 at 04:28:09PM +0100, Filipe Manana wrote:
> On Fri, Sep 2, 2016 at 8:35 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > This can only happen with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y.
> >
> > Commit 1ba98d0 ("Btrfs: detect corruption when non-root leaf has zero item")
> > assumes that a leaf is its root when leaf->bytenr == btrfs_root_bytenr(root),
> > however, we should not use btrfs_root_bytenr(root) since it's mainly got
> > updated during committing transaction.  So the check can fail when doing
> > COW on this leaf while it is a root.
> >
> > This changes to use "if (leaf == btrfs_root_node(root))" instead, just like
> > how we check whether leaf is a root in __btrfs_cow_block().
> >
> > Reported-by: Jeff Mahoney <jeffm@suse.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Hi Bo,
> 
> Even with this patch applied against latest branch for-linus-4.8, at
> least on a build with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y,
> the issue still happens for me when running fsstress with balance in parallel:

Thanks for the report.

This panic shows that we can have non-root btree leaf with 0 nritems during
split_leaf(), but a btrfs_search_slot which calls split_leaf() like this is
inserting an item, and while we set @right's nritems to 0, we also assign @disk_key
associated with @right in the parent node, so I think we're actually having
 nritem 0 temporarily and we can remove this btrfs_mark_buffer_dirty() like the
following quick patch.

Thanks,

-liubo

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d1c56c9..5e5ceb5 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4341,7 +4341,11 @@ again:
 			if (path->slots[1] == 0)
 				fixup_low_keys(fs_info, path, &disk_key, 1);
 		}
-		btrfs_mark_buffer_dirty(right);
+		/*
+		 * We create a new leaf 'right' for the required ins_len and
+		 * we'll do btrfs_mark_buffer_dirty() on this leaf after copying
+		 * the content of ins_len to 'right'.
+		 */
 		return ret;
 	}
 


> 
> [  366.998044] BTRFS: device fsid 69759b3a-96ae-467d-aa63-364144e73a28
> devid 1 transid 3 /dev/sdc
> [  367.023652] BTRFS info (device sdc): turning on discard
> [  367.025036] BTRFS info (device sdc): disk space caching is enabled
> [  367.026360] BTRFS info (device sdc): has skinny extents
> [  367.069415] BTRFS info (device sdc): creating UUID tree
> [  367.133704] BTRFS info (device sdc): relocating block group 29360128 flags 36
> [  367.142196] BTRFS info (device sdc): found 2 extents
> [  367.147932] BTRFS info (device sdc): relocating block group 20971520 flags 34
> [  367.157947] BTRFS info (device sdc): found 1 extents
> [  367.162649] BTRFS info (device sdc): relocating block group 12582912 flags 1
> [  367.182872] BTRFS info (device sdc): found 1 extents
> [  367.189932] BTRFS info (device sdc): found 1 extents
> [  367.200983] BTRFS info (device sdc): relocating block group
> 1270874112 flags 1
> [  367.235862] BTRFS critical (device sdc): corrupt leaf, non-root
> leaf's nritems is 0: block=1103937536,root=5, slot=0
> [  367.238223] BTRFS info (device sdc): leaf 1103937536 total ptrs 0
> free space 3995
> [  367.239371] BTRFS: assertion failed: 0, file: fs/btrfs/disk-io.c, line: 4059
> [  367.240321] ------------[ cut here ]------------
> [  367.241245] kernel BUG at fs/btrfs/ctree.h:3367!
> [  367.241961] invalid opcode: 0000 [#1] PREEMPT SMP
> [  367.242685] Modules linked in: btrfs crc32c_generic xor raid6_pq
> acpi_cpufreq tpm_tis tpm sg i2c_piix4 i2c_core psmouse ppdev processor
> evdev parport_pc parport serio_raw pcspkr button loop autofs4 ext4
> crc16 jbd2 mbcache sr_mod cdrom sd_mod ata_generic virtio_scsi
> ata_piix libata virtio_pci virtio_ring e1000 virtio scsi_mod floppy
> [last unloaded: btrfs]
> [  367.244302] CPU: 11 PID: 3451 Comm: fdm-stress Not tainted
> 4.7.0-rc6-btrfs-next-34+ #1
> [  367.244302] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
> [  367.244302] task: ffff880183ef8bc0 ti: ffff880183fe0000 task.ti:
> ffff880183fe0000
> [  367.244302] RIP: 0010:[<ffffffffa04601d5>]  [<ffffffffa04601d5>]
> assfail.constprop.42+0x1c/0x1e [btrfs]
> [  367.244302] RSP: 0018:ffff880183fe3c78  EFLAGS: 00010296
> [  367.244302] RAX: 0000000000000040 RBX: ffff880222a66ab0 RCX: 0000000000000001
> [  367.244302] RDX: ffffffff810a0a23 RSI: ffffffff814a82cb RDI: 00000000ffffffff
> [  367.244302] RBP: ffff880183fe3c78 R08: 0000000000000001 R09: 0000000000000000
> [  367.244302] R10: ffff880183fe3b70 R11: ffffffff82f3650d R12: ffff880183e8e000
> [  367.244302] R13: ffff8800b3e7d000 R14: 0000000000000a59 R15: 0000000000000017
> [  367.244302] FS:  00007f0b85310700(0000) GS:ffff88023f4c0000(0000)
> knlGS:0000000000000000
> [  367.244302] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  367.244302] CR2: 00007f0b7800ea28 CR3: 000000022da9b000 CR4: 00000000000006e0
> [  367.244302] Stack:
> [  367.244302]  ffff880183fe3ca0 ffffffffa03e51e3 0000000000000023
> ffff880222a66ab0
> [  367.244302]  ffff880183885bb8 ffff880183fe3d38 ffffffffa03c9540
> 0000000083fe3d08
> [  367.244302]  ffff8800b3e7d2d8 0000000000001000 ffff880183fe3e7f
> ffff880183ff8000
> [  367.244302] Call Trace:
> [  367.244302]  [<ffffffffa03e51e3>] btrfs_mark_buffer_dirty+0xdf/0xe5 [btrfs]
> [  367.244302]  [<ffffffffa03c9540>] split_leaf+0x47c/0x566 [btrfs]
> [  367.244302]  [<ffffffffa03c9c09>] btrfs_search_slot+0x5df/0x755 [btrfs]
> [  367.244302]  [<ffffffff8116daf7>] ? slab_post_alloc_hook+0x42/0x52
> [  367.244302]  [<ffffffffa03caf5a>] btrfs_insert_empty_items+0x5d/0xa6 [btrfs]
> [  367.244302]  [<ffffffffa03f783b>] btrfs_symlink+0x17f/0x34f [btrfs]
> [  367.244302]  [<ffffffff8118bcf5>] vfs_symlink+0x51/0x6e
> [  367.244302]  [<ffffffff8118fc4c>] SYSC_symlinkat+0x6d/0xb2
> [  367.244302]  [<ffffffff8100101a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
> [  367.244302]  [<ffffffff811904b6>] SyS_symlink+0x16/0x18
> [  367.244302]  [<ffffffff814a88e5>] entry_SYSCALL_64_fastpath+0x18/0xa8
> [  367.244302]  [<ffffffff81102507>] ? time_hardirqs_off+0x9/0x14
> [  367.244302]  [<ffffffff8108f019>] ? trace_hardirqs_off_caller+0x1f/0xaa
> [  367.244302] Code: 89 83 88 00 00 00 31 c0 5b 41 5c 41 5d 5d c3 55
> 89 f1 48 c7 c2 14 8b 46 a0 48 89 fe 48 c7 c7 27 8c 46 a0 48 89 e5 e8
> e5 2f cc e0 <0f> 0b 55 89 f1 48 c7 c2 03 a2 46 a0 48 89 fe 48 c7 c7 dc
> a3 46
> [  367.244302] RIP  [<ffffffffa04601d5>] assfail.constprop.42+0x1c/0x1e [btrfs]
> [  367.244302]  RSP <ffff880183fe3c78>
> [  367.289039] ---[ end trace a3e4ce9819ed383b ]---
> 
> 
> thanks
> 
> > ---
> >  fs/btrfs/disk-io.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 9367c31..b401e6d 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -572,13 +572,17 @@ static noinline int check_leaf(struct btrfs_root *root,
> >                  * open_ctree() some roots has not yet been set up.
> >                  */
> >                 if (!IS_ERR_OR_NULL(check_root)) {
> > +                       struct extent_buffer *eb;
> > +
> > +                       eb = btrfs_root_node(check_root);
> >                         /* if leaf is the root, then it's fine */
> > -                       if (leaf->start !=
> > -                           btrfs_root_bytenr(&check_root->root_item)) {
> > +                       if (leaf != eb) {
> >                                 CORRUPT("non-root leaf's nritems is 0",
> > -                                       leaf, root, 0);
> > +                                       leaf, check_root, 0);
> > +                               free_extent_buffer(eb);
> >                                 return -EIO;
> >                         }
> > +                       free_extent_buffer(eb);
> >                 }
> >                 return 0;
> >         }
> > --
> > 2.5.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "People will forget what you said,
>  people will forget what you did,
>  but people will never forget how you made them feel."
