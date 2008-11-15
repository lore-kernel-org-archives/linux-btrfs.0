From: "Mitch Harder (aka DontPanic)" <mmharder@gmail.com>
Subject: Re: [PATCH] fix free space leak
Date: Sat, 15 Nov 2008 09:33:33 -0600
Message-ID: <89ed0c690811150733p1e3bf05cqff0bac38084f8714@mail.gmail.com>
References: <20081114213332.GD19225@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081114213332.GD19225@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

I tested this patch by compiling OpenOffice on a 3.5 GB partition
using compression.

I am still getting an allocation error at the very end of the build
process when trying to delete the work files once the compilation
completed and installed successfully.

The FETCH_HEAD that I applied the patch to was:
$ cat .git/FETCH_HEAD
a350bf67481b0a0cf52bc0be9171f27e442871a5                branch
'master' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable-standalone

In the dmesg output, please note that the typesconfig segfault is a
documented issue with the open office build process, but doesn't
prevent the build process from successfully completing.

$ dmesg
[ 2318.204899] Btrfs loaded
[ 2378.233013] device fsid 2848aff4aec48eec-803ffacdada2ea82 devid 1
transid 9 /dev/sdc2
[ 2378.233816] btrfs: use compression
[ 4624.807941] typesconfig[14668]: segfault at 0 ip 08048b50 sp
bfb9def0 error 6 in typesconfig[8048000+2000]
[16452.073382] space info full 36
[17087.464215] space info full 1
[39182.628998] allocation failed flags 36, wanted 4096
[39182.629028] space_info has 122880 free, is full
[39182.629339] block group 29360128 has 179699712 bytes, 135962624
used 43737088 pinned 0 reserved
[39182.629343] 0 blocks of free space at or bigger than bytes is
[39182.629346] block group 927858688 has 179699712 bytes, 98021376
used 81678336 pinned 0 reserved
[39182.629349] 0 blocks of free space at or bigger than bytes is
[39182.629351] block group 1826357248 has 179699712 bytes, 64278528
used 115421184 pinned 0 reserved
[39182.629354] 1 blocks of free space at or bigger than bytes is
[39182.629356] block group 2006056960 has 179699712 bytes, 129122304
used 50454528 pinned 0 reserved
[39182.629359] 0 blocks of free space at or bigger than bytes is
[39182.629410] ------------[ cut here ]------------
[39182.629413] kernel BUG at
/var/tmp/portage/sys-fs/btrfs-9998/work/btrfs-9998/extent-tree.c:3085!
[39182.629415] invalid opcode: 0000 [#1]
[39182.629417] Modules linked in: btrfs snd_pcm_oss snd_mixer_oss
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
ipv6 ppdev pcspkr nvidia(P) snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm snd_timer forcedeth snd snd_page_alloc ohci_hcd i2c_nforce2
ssb pcmcia i2c_core parport_pc parport nvidia_agp sr_mod
scsi_wait_scan sl811_hcd uhci_hcd ehci_hcd
[39182.629434]
[39182.629438] Pid: 29182, comm: rm Tainted: P
(2.6.27-sabayon-r10 #1)
[39182.629441] EIP: 0060:[<f8e2f1de>] EFLAGS: 00210257 CPU: 0
[39182.629477] EIP is at __btrfs_reserve_extent+0x2be/0x430 [btrfs]
[39182.629480] EAX: d5e40520 EBX: f64d2780 ECX: e426b4d0 EDX: 00000001
[39182.629483] ESI: d5e40518 EDI: d5e40518 EBP: d5e40520 ESP: ee40f92c
[39182.629485]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[39182.629488] Process rm (pid: 29182, ti=ee40e000 task=e426b4d0
task.ti=ee40e000)
[39182.629490] Stack: f8e6d894 77920000 00000000 0ab60000 00000000
07b24000 00000000 0301e000
[39182.629495]        00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000024
[39182.629499]        00000000 00000000 e2c4b600 e4978028 f4c80000
00000002 00000000 e2c4b600
[39182.629504] Call Trace:
[39182.629507]  [<f8e2f83f>] btrfs_alloc_extent+0x9f/0x140 [btrfs]
[39182.629527]  [<f8e2f9ae>] btrfs_alloc_free_block+0xce/0x110 [btrfs]
[39182.629545]  [<f8e242e9>] __btrfs_cow_block+0x219/0x870 [btrfs]
[39182.629564]  [<f8e39262>] verify_parent_transid+0x62/0x1a0 [btrfs]
[39182.629582]  [<f8e24fec>] btrfs_cow_block+0x13c/0x1e0 [btrfs]
[39182.629600]  [<f8e28190>] btrfs_search_slot+0x1c0/0x7f0 [btrfs]
[39182.629618]  [<f8e2d513>] finish_current_insert+0x523/0x630 [btrfs]
[39182.629636]  [<f8e2c317>] lookup_extent_backref+0x57/0x120 [btrfs]
[39182.629654]  [<f8e30fa2>] __btrfs_update_extent_ref+0x1f2/0x3a0
[btrfs]
[39182.629673]  [<f8e35053>] btrfs_update_ref+0x2b3/0x3c0 [btrfs]
[39182.629692]  [<f8e5a8f9>] copy_extent_buffer+0xa9/0x120 [btrfs]
[39182.629714]  [<f8e24694>] __btrfs_cow_block+0x5c4/0x870 [btrfs]
[39182.629732]  [<f8e39262>] verify_parent_transid+0x62/0x1a0 [btrfs]
[39182.629750]  [<f8e24fec>] btrfs_cow_block+0x13c/0x1e0 [btrfs]
[39182.629768]  [<f8e28190>] btrfs_search_slot+0x1c0/0x7f0 [btrfs]
[39182.629785]  [<f8e5c2b4>] set_extent_buffer_dirty+0xe4/0x160
[btrfs]
[39182.629806]  [<f8e38b40>] btrfs_del_inode_ref+0x70/0x190 [btrfs]
[39182.629825]  [<f8e43b2b>] btrfs_unlink_inode+0xeb/0x2c0 [btrfs]
[39182.629845]  [<c019d4f2>] d_instantiate+0x32/0x50
[39182.629852]  [<f8e3df96>] start_transaction+0xd6/0x100 [btrfs]
[39182.629871]  [<f8e44121>] btrfs_unlink+0xb1/0xf0 [btrfs]
[39182.629891]  [<c0194796>] vfs_unlink+0x156/0x1f0
[39182.629897]  [<c0193625>] __lookup_hash+0xd5/0x120
[39182.629901]  [<c0196196>] do_unlinkat+0x136/0x150
[39182.629905]  [<c01981d4>] vfs_readdir+0x84/0xb0
[39182.629908]  [<c01982a7>] sys_getdents64+0xa7/0xc0
[39182.629911]  [<c010303d>] sysenter_do_call+0x12/0x21
[39182.629916]  =======================
[39182.629917] Code: 89 44 24 04 e8 54 e9 2e c7 89 d8 8b 54 24 68 8b
4c 24 6c e8 c5 bf 03 00 8b 36 8b 06 0f 18 00 90 39 fe 75 90 89 e8 e8
e2 29 30 c7 <0f> 0b eb fe 8b 5c 24 48 8b 74 24 50 8b 83 f4 00 00 00 8b
50 20
[39182.629936] EIP: [<f8e2f1de>] __btrfs_reserve_extent+0x2be/0x430
[btrfs] SS:ESP 0068:ee40f92c
[39182.630112] ---[ end trace 82accd0198c92c27 ]---
[39182.632050] allocation failed flags 36, wanted 4096
[39182.632055] space_info has 122880 free, is full
[39182.632057] block group 29360128 has 179699712 bytes, 135962624
used 43737088 pinned 0 reserved
[39182.632060] 0 blocks of free space at or bigger than bytes is
[39182.632062] block group 927858688 has 179699712 bytes, 98021376
used 81678336 pinned 0 reserved
[39182.632065] 0 blocks of free space at or bigger than bytes is
[39182.632067] block group 1826357248 has 179699712 bytes, 64278528
used 115421184 pinned 0 reserved
[39182.632069] 1 blocks of free space at or bigger than bytes is
[39182.632072] block group 2006056960 has 179699712 bytes, 129122304
used 50454528 pinned 0 reserved
[39182.632074] 0 blocks of free space at or bigger than bytes is
[39182.632124] ------------[ cut here ]------------
[39182.632127] kernel BUG at
/var/tmp/portage/sys-fs/btrfs-9998/work/btrfs-9998/extent-tree.c:3085!
[39182.632130] invalid opcode: 0000 [#2]
[39182.632132] Modules linked in: btrfs snd_pcm_oss snd_mixer_oss
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
ipv6 ppdev pcspkr nvidia(P) snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm snd_timer forcedeth snd snd_page_alloc ohci_hcd i2c_nforce2
ssb pcmcia i2c_core parport_pc parport nvidia_agp sr_mod
scsi_wait_scan sl811_hcd uhci_hcd ehci_hcd
[39182.632149]
[39182.632152] Pid: 29318, comm: rm Tainted: P      D
(2.6.27-sabayon-r10 #1)
[39182.632155] EIP: 0060:[<f8e2f1de>] EFLAGS: 00210257 CPU: 0
[39182.632191] EIP is at __btrfs_reserve_extent+0x2be/0x430 [btrfs]
[39182.632194] EAX: d5e40520 EBX: f64d2780 ECX: ffffffff EDX: 00000001
[39182.632196] ESI: d5e40518 EDI: d5e40518 EBP: d5e40520 ESP: c000dc48
[39182.632199]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[39182.632202] Process rm (pid: 29318, ti=c000c000 task=c1ce6cb0
task.ti=c000c000)
[39182.632204] Stack: f8e6d894 77920000 00000000 0ab60000 00000000
07b24000 00000000 0301e000
[39182.632209]        00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000024
[39182.632213]        00001000 00000000 ea802a00 e4978050 f4c80000
00000005 00000000 ea802a00
[39182.632217] Call Trace:
[39182.632220]  [<f8e2f83f>] btrfs_alloc_extent+0x9f/0x140 [btrfs]
[39182.632239]  [<f8e2f9ae>] btrfs_alloc_free_block+0xce/0x110 [btrfs]
[39182.632258]  [<f8e242e9>] __btrfs_cow_block+0x219/0x870 [btrfs]
[39182.632276]  [<f8e39262>] verify_parent_transid+0x62/0x1a0 [btrfs]
[39182.632295]  [<f8e24fec>] btrfs_cow_block+0x13c/0x1e0 [btrfs]
[39182.632313]  [<f8e28190>] btrfs_search_slot+0x1c0/0x7f0 [btrfs]
[39182.632331]  [<f8e568ac>] map_private_extent_buffer+0x8c/0x140
[btrfs]
[39182.632353]  [<c010325b>] common_interrupt+0x23/0x28
[39182.632360]  [<f8e38a4c>] btrfs_lookup_inode+0x3c/0xc0 [btrfs]
[39182.632379]  [<f8e428a6>] btrfs_update_inode+0x46/0xc0 [btrfs]
[39182.632399]  [<f8e43a1f>] btrfs_dirty_inode+0x3f/0x60 [btrfs]
[39182.632418]  [<c01a8c90>] __mark_inode_dirty+0x30/0x160
[39182.632425]  [<c0197f90>] filldir64+0x0/0xe0
[39182.632429]  [<c019f837>] touch_atime+0xc7/0xf0
[39182.632434]  [<c01981f6>] vfs_readdir+0xa6/0xb0
[39182.632437]  [<c019826f>] sys_getdents64+0x6f/0xc0
[39182.632440]  [<c010303d>] sysenter_do_call+0x12/0x21
[39182.632443]  =======================
[39182.632444] Code: 89 44 24 04 e8 54 e9 2e c7 89 d8 8b 54 24 68 8b
4c 24 6c e8 c5 bf 03 00 8b 36 8b 06 0f 18 00 90 39 fe 75 90 89 e8 e8
e2 29 30 c7 <0f> 0b eb fe 8b 5c 24 48 8b 74 24 50 8b 83 f4 00 00 00 8b
50 20
[39182.632463] EIP: [<f8e2f1de>] __btrfs_reserve_extent+0x2be/0x430
[btrfs] SS:ESP 0068:c000dc48
[39182.632584] ---[ end trace 82accd0198c92c27 ]---

Other Info:
$ df -T
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdc2    btrfs     3510200   1595884   1914316  46% /var/tmp/portage


On Fri, Nov 14, 2008 at 3:33 PM, Josef Bacik <jbacik@redhat.com> wrote:
> Hello,
>
> In my batch delete/update/insert patch I introduced a free space leak.  The
> extent that we do the original search on in free_extents is never pinned, so we
> always update the block saying that it has free space, but the free space never
> actually gets added to the free space tree, since op->del will always be 0 and
> it's never actually added to the pinned extents tree.  This patch fixes this
> problem by making sure we call pin_down_bytes on the pending extent op and set
> op->del to the return value of pin_down_bytes so update_block_group is called
> with the right value.  This seems to fix the case where we were getting ENOSPC
> when there was plenty of space available.  Thank you,
>
> Signed-off-by: Josef Bacik <jbacik@redhat.com>
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6eb56a0..93726ae 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -999,6 +999,14 @@ search:
>                path->slots[0] = extent_slot;
>                bytes_freed = op->num_bytes;
>
> +               mutex_lock(&info->pinned_mutex);
> +               ret = pin_down_bytes(trans, extent_root, op->bytenr,
> +                                    op->num_bytes, op->level >=
> +                                    BTRFS_FIRST_FREE_OBJECTID);
> +               mutex_unlock(&info->pinned_mutex);
> +               BUG_ON(ret < 0);
> +               op->del = ret;
> +
>                /*
>                 * we need to see if we can delete multiple things at once, so
>                 * start looping through the list of extents we are wanting to
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
