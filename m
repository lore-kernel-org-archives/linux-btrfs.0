Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34055 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934582AbbDWMp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 08:45:58 -0400
Received: by iget9 with SMTP id t9so9449161ige.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 05:45:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5537D27E.3080609@fb.com>
References: <1428954759-1304912-1-git-send-email-clm@fb.com>
	<mh8h3f$l3u$1@ger.gmane.org>
	<pan.2015.04.22.16.37.38@googlemail.com>
	<5537D27E.3080609@fb.com>
Date: Thu, 23 Apr 2015 13:45:57 +0100
Message-ID: <CAL3q7H4ccdcJYKZaH_fYW9EUPCSTa3gDz_fiUjP8TvCUvQtxTQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during commit
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 22, 2015 at 5:55 PM, Chris Mason <clm@fb.com> wrote:
> On 04/22/2015 12:37 PM, Holger Hoffstätte wrote:
>> On Wed, 22 Apr 2015 18:09:18 +0200, Lutz Vieweg wrote:
>>
>>> On 04/13/2015 09:52 PM, Chris Mason wrote:
>>>> Large filesystems with lots of block groups can suffer long stalls during
>>>> commit while we create and send down all of the block group caches.  The
>>>> more blocks groups dirtied in a transaction, the longer these stalls can be.
>>>> Some workloads average 10 seconds per commit, but see peak times much higher.
>>>
>>> Since we see this problem very frequently on some shared development servers,
>>> I will try to install this ASAP.
>>>
>>> Meanwhile, can anybody already tell success stories about successfully removing
>>> lags by this patch?
>>
>> Works fine, but make sure to get the followup patch [1] as well while you're
>> at it. I've observed that my (bandwidth-throttled) backups now cause shorter,
>> nicely spaced-out blips of activity instead of longer ones when the writeback
>> kicks in.
>>
>> -h
>>
>> [1] https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration-4.1&id=c1e31ffc317e4c28d242b1d961c9c6fe673c0377
>>
>
> Great to hear.  I recommend just using my for-linus-4.1 branch, since it
> has all the good things  in one place.

Trying the current integration-4.1 branch, I ran into the following
during xfstests/btrfs/049:

[ 1702.295711] run fstests btrfs/049 at 2015-04-23 13:25:22
[ 1703.704334] device-mapper: uevent: version 1.0.3
[ 1703.707590] device-mapper: ioctl: 4.30.0-ioctl (2014-12-22)
initialised: dm-devel@redhat.com
[ 1704.081385] BTRFS: device fsid b5fe6a65-1a70-4a74-9d27-ba7032df51f7
devid 1 transid 3 /dev/sdc
[ 1704.662570] BTRFS info (device dm-0): turning on discard
[ 1704.663981] BTRFS info (device dm-0): enabling inode map caching
[ 1704.665929] BTRFS info (device dm-0): disk space caching is enabled
[ 1704.667451] BTRFS: has skinny extents
[ 1704.692617] BTRFS: creating UUID tree
[ 1704.883424] ------------[ cut here ]------------
[ 1704.884487] WARNING: CPU: 2 PID: 3645 at
fs/btrfs/free-space-cache.c:1234
__btrfs_write_out_cache.isra.21+0x75/0x3a1 [btrfs]()
[ 1704.886519] Modules linked in: dm_flakey dm_mod crc32c_generic
btrfs xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs lockd
grace fscache sunrpc loop fuse i2c_piix4 i2c_core psmouse acpi_cpufreq
processor thermal_sys parport_pc parport pcspkr serio_raw microcode
evdev button ext4 crc16 jbd2 mbcache sd_mod sg sr_mod cdrom
virtio_scsi ata_generic floppy virtio_pci virtio_ring virtio e1000
ata_piix libata scsi_mod
[ 1704.897327] CPU: 2 PID: 3645 Comm: xfs_io Not tainted
4.0.0-rc5-btrfs-next-8+ #1
[ 1704.898875] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[ 1704.902507]  0000000000000009 ffff8801be5b7b58 ffffffff8142bd70
ffff88043dd0f2d0
[ 1704.904381]  0000000000000000 ffff8801be5b7b98 ffffffff810463e6
ffff8801be5b7b88
[ 1704.906377]  ffffffffa03ad57b ffff8801be5b7c38 0000000000000000
ffff880231948c90
[ 1704.908786] Call Trace:
[ 1704.909428]  [<ffffffff8142bd70>] dump_stack+0x4c/0x65
[ 1704.911249]  [<ffffffff810463e6>] warn_slowpath_common+0xa1/0xbb
[ 1704.912700]  [<ffffffffa03ad57b>] ?
__btrfs_write_out_cache.isra.21+0x75/0x3a1 [btrfs]
[ 1704.914342]  [<ffffffff810464a3>] warn_slowpath_null+0x1a/0x1c
[ 1704.915383]  [<ffffffffa03ad57b>]
__btrfs_write_out_cache.isra.21+0x75/0x3a1 [btrfs]
[ 1704.916890]  [<ffffffffa03b00d8>] btrfs_write_out_ino_cache+0x52/0x97 [btrfs]
[ 1704.918173]  [<ffffffff814311fb>] ? _raw_spin_unlock+0x28/0x33
[ 1704.919208]  [<ffffffffa035fbe0>] ?
btrfs_free_reserved_data_space+0x84/0x8c [btrfs]
[ 1704.920706]  [<ffffffffa036b447>] btrfs_save_ino_cache+0x275/0x2dc [btrfs]
[ 1704.922486]  [<ffffffffa03ded17>] commit_fs_roots.isra.13+0xaa/0x137 [btrfs]
[ 1704.924211]  [<ffffffff8107d0da>] ? trace_hardirqs_on+0xd/0xf
[ 1704.925634]  [<ffffffffa037429f>] ?
btrfs_commit_transaction+0x4bb/0x9d3 [btrfs]
[ 1704.927459]  [<ffffffff814311fb>] ? _raw_spin_unlock+0x28/0x33
[ 1704.928709]  [<ffffffffa03742ae>]
btrfs_commit_transaction+0x4ca/0x9d3 [btrfs]
[ 1704.930205]  [<ffffffff8107d0da>] ? trace_hardirqs_on+0xd/0xf
[ 1704.931314]  [<ffffffffa038656c>] btrfs_sync_file+0x307/0x367 [btrfs]
[ 1704.932584]  [<ffffffff81178e69>] vfs_fsync_range+0x95/0xa4
[ 1704.933550]  [<ffffffff81432651>] ? retint_swapgs+0xe/0x44
[ 1704.934615]  [<ffffffff81178e94>] vfs_fsync+0x1c/0x1e
[ 1704.935590]  [<ffffffff81179010>] do_fsync+0x34/0x4e
[ 1704.936609]  [<ffffffff81179238>] SyS_fsync+0x10/0x14
[ 1704.937614]  [<ffffffff81431a72>] system_call_fastpath+0x12/0x17
[ 1704.938693] ---[ end trace 543759e9dc39d3b9 ]---
[ 1704.942149] BTRFS: assertion failed:
BTRFS_I(inode)->outstanding_extents >= num_extents, file:
fs/btrfs/extent-tree.c, line: 5266
[ 1704.944085] ------------[ cut here ]------------
[ 1704.945073] kernel BUG at fs/btrfs/ctree.h:4057!
[ 1704.945912] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 1704.946932] Modules linked in: dm_flakey dm_mod crc32c_generic
btrfs xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs lockd
grace fscache sunrpc loop fuse i2c_piix4 i2c_core psmouse acpi_cpufreq
processor thermal_sys parport_pc parport pcspkr serio_raw microcode
evdev button ext4 crc16 jbd2 mbcache sd_mod sg sr_mod cdrom
virtio_scsi ata_generic floppy virtio_pci virtio_ring virtio e1000
ata_piix libata scsi_mod
[ 1704.948065] CPU: 2 PID: 3645 Comm: xfs_io Tainted: G        W
4.0.0-rc5-btrfs-next-8+ #1
[ 1704.948065] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[ 1704.948065] task: ffff8801c878c250 ti: ffff8801be5b4000 task.ti:
ffff8801be5b4000
[ 1704.948065] RIP: 0010:[<ffffffffa035a448>]  [<ffffffffa035a448>]
assfail.constprop.68+0x1e/0x20 [btrfs]
[ 1704.948065] RSP: 0018:ffff8801be5b7bc8  EFLAGS: 00010246
[ 1704.948065] RAX: 0000000000000075 RBX: 0000000000009000 RCX: ffffffff8107a4cc
[ 1704.948065] RDX: 0000000000009e85 RSI: ffffffff8143127f RDI: ffffffff8107d0da
[ 1704.948065] RBP: ffff8801be5b7bc8 R08: 0000000000000001 R09: 0000000000000000
[ 1704.948065] R10: 0000000000000000 R11: ffffffff8165a140 R12: ffff8802b3aed000
[ 1704.948065] R13: ffff8801e4f90f40 R14: 0000000000000000 R15: ffff880231948c90
[ 1704.948065] FS:  00007f3640959700(0000) GS:ffff88043dd00000(0000)
knlGS:0000000000000000
[ 1704.948065] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1704.948065] CR2: 00007f3640961000 CR3: 00000002531e1000 CR4: 00000000000006e0
[ 1704.948065] Stack:
[ 1704.948065]  ffff8801be5b7bd8 ffffffffa035a487 ffff8801be5b7c28
ffffffffa0360851
[ 1704.948065]  ffff8801c66e3f60 ffff880231948948 ffff880231948980
ffff8802b3aed000
[ 1704.948065]  ffff880231948c90 ffff8801e4f90f40 ffff8801c66e3f60
0000000000009000
[ 1704.948065] Call Trace:
[ 1704.948065]  [<ffffffffa035a487>] drop_outstanding_extent+0x3d/0x6d [btrfs]
[ 1704.948065]  [<ffffffffa0360851>]
btrfs_delalloc_release_metadata+0x54/0xe6 [btrfs]
[ 1704.948065]  [<ffffffffa03b0108>] btrfs_write_out_ino_cache+0x82/0x97 [btrfs]
[ 1704.948065]  [<ffffffffa036b447>] btrfs_save_ino_cache+0x275/0x2dc [btrfs]
[ 1704.948065]  [<ffffffffa03ded17>] commit_fs_roots.isra.13+0xaa/0x137 [btrfs]
[ 1704.948065]  [<ffffffff8107d0da>] ? trace_hardirqs_on+0xd/0xf
[ 1704.948065]  [<ffffffffa037429f>] ?
btrfs_commit_transaction+0x4bb/0x9d3 [btrfs]
[ 1704.948065]  [<ffffffff814311fb>] ? _raw_spin_unlock+0x28/0x33
[ 1704.948065]  [<ffffffffa03742ae>]
btrfs_commit_transaction+0x4ca/0x9d3 [btrfs]
[ 1704.948065]  [<ffffffff8107d0da>] ? trace_hardirqs_on+0xd/0xf
[ 1704.948065]  [<ffffffffa038656c>] btrfs_sync_file+0x307/0x367 [btrfs]
[ 1704.948065]  [<ffffffff81178e69>] vfs_fsync_range+0x95/0xa4
[ 1704.948065]  [<ffffffff81432651>] ? retint_swapgs+0xe/0x44
[ 1704.948065]  [<ffffffff81178e94>] vfs_fsync+0x1c/0x1e
[ 1704.948065]  [<ffffffff81179010>] do_fsync+0x34/0x4e
[ 1704.948065]  [<ffffffff81179238>] SyS_fsync+0x10/0x14
[ 1704.948065]  [<ffffffff81431a72>] system_call_fastpath+0x12/0x17
[ 1704.948065] Code: 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 89 f1
48 c7 c2 12 9c 3e a0 48 89 fe 31 c0 48 c7 c7 1e 9d 3e a0 48 89 e5 e8
f1 09 0d e1 <0f> 0b 0f 1f 44 00 00 48 81 c6 ff ff ff 07 55 48 c1 ee 1b
85 f6
[ 1704.948065] RIP  [<ffffffffa035a448>] assfail.constprop.68+0x1e/0x20 [btrfs]
[ 1704.948065]  RSP <ffff8801be5b7bc8>
[ 1705.018483] ---[ end trace 543759e9dc39d3ba ]---
[ 1705.020564] BUG: sleeping function called from invalid context at
kernel/locking/rwsem.c:41
[ 1705.022182] in_atomic(): 1, irqs_disabled(): 0, pid: 3645, name: xfs_io
[ 1705.023403] INFO: lockdep is turned off.
[ 1705.024248] CPU: 2 PID: 3645 Comm: xfs_io Tainted: G      D W
4.0.0-rc5-btrfs-next-8+ #1
[ 1705.026809] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[ 1705.029167]  ffff8801c878c250 ffff8801be5b7848 ffffffff8142bd70
000000000000a1e3
[ 1705.031709]  0000000000000e3d ffff8801be5b7868 ffffffff8106542b
ffffffff817d0e77
[ 1705.033609]  0000000000000029 ffff8801be5b7898 ffffffff810654d0
00007ffffffff000
[ 1705.035596] Call Trace:
[ 1705.036273]  [<ffffffff8142bd70>] dump_stack+0x4c/0x65
[ 1705.037398]  [<ffffffff8106542b>] ___might_sleep+0x148/0x14d
[ 1705.038573]  [<ffffffff810654d0>] __might_sleep+0xa0/0xa8
[ 1705.039697]  [<ffffffff8142fd6b>] down_read+0x21/0x55
[ 1705.040836]  [<ffffffff81052c4d>] exit_signals+0x26/0x11a
[ 1705.042024]  [<ffffffff810606e9>] ? blocking_notifier_call_chain+0x14/0x16
[ 1705.044102]  [<ffffffff8104779c>] do_exit+0x128/0x9c4
[ 1705.045213]  [<ffffffff8107adff>] ? arch_local_irq_save+0x9/0xc
[ 1705.046470]  [<ffffffff8108c05b>] ? kmsg_dump+0xec/0xfc
[ 1705.047544]  [<ffffffff81005754>] oops_end+0xa6/0xae
[ 1705.048629]  [<ffffffff81005bcb>] die+0x5a/0x63
[ 1705.049516]  [<ffffffff81002aee>] do_trap+0x6b/0x124
[ 1705.050490]  [<ffffffff81002cbc>] do_error_trap+0xc6/0xd8
[ 1705.051587]  [<ffffffffa035a448>] ? assfail.constprop.68+0x1e/0x20 [btrfs]
[ 1705.052721]  [<ffffffff8107d0da>] ? trace_hardirqs_on+0xd/0xf
[ 1705.054805]  [<ffffffff810e4efb>] ? time_hardirqs_off+0x15/0x28
[ 1705.055914]  [<ffffffff8123720a>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1705.057244]  [<ffffffff8107b06a>] ? trace_hardirqs_off_caller+0x4c/0xb9
[ 1705.058692]  [<ffffffff8123720a>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1705.060732]  [<ffffffff810035e3>] do_invalid_op+0x20/0x22
[ 1705.061962]  [<ffffffff81433428>] invalid_op+0x18/0x20
[ 1705.063117]  [<ffffffff8107a4cc>] ? up+0x39/0x3e
[ 1705.064205]  [<ffffffff8143127f>] ? _raw_spin_unlock_irqrestore+0x3f/0x4d
[ 1705.065659]  [<ffffffff8107d0da>] ? trace_hardirqs_on+0xd/0xf
[ 1705.066621]  [<ffffffffa035a448>] ? assfail.constprop.68+0x1e/0x20 [btrfs]
[ 1705.067904]  [<ffffffffa035a448>] ? assfail.constprop.68+0x1e/0x20 [btrfs]
[ 1705.069456]  [<ffffffffa035a487>] drop_outstanding_extent+0x3d/0x6d [btrfs]
[ 1705.070862]  [<ffffffffa0360851>]
btrfs_delalloc_release_metadata+0x54/0xe6 [btrfs]
[ 1705.072372]  [<ffffffffa03b0108>] btrfs_write_out_ino_cache+0x82/0x97 [btrfs]
[ 1705.073821]  [<ffffffffa036b447>] btrfs_save_ino_cache+0x275/0x2dc [btrfs]
[ 1705.075150]  [<ffffffffa03ded17>] commit_fs_roots.isra.13+0xaa/0x137 [btrfs]
[ 1705.076593]  [<ffffffff8107d0da>] ? trace_hardirqs_on+0xd/0xf
[ 1705.077830]  [<ffffffffa037429f>] ?
btrfs_commit_transaction+0x4bb/0x9d3 [btrfs]
[ 1705.079381]  [<ffffffff814311fb>] ? _raw_spin_unlock+0x28/0x33
[ 1705.080588]  [<ffffffffa03742ae>]
btrfs_commit_transaction+0x4ca/0x9d3 [btrfs]
[ 1705.082148]  [<ffffffff8107d0da>] ? trace_hardirqs_on+0xd/0xf
[ 1705.083298]  [<ffffffffa038656c>] btrfs_sync_file+0x307/0x367 [btrfs]
[ 1705.084667]  [<ffffffff81178e69>] vfs_fsync_range+0x95/0xa4
[ 1705.086187]  [<ffffffff81432651>] ? retint_swapgs+0xe/0x44
[ 1705.087289]  [<ffffffff81178e94>] vfs_fsync+0x1c/0x1e
[ 1705.088389]  [<ffffffff81179010>] do_fsync+0x34/0x4e
[ 1705.089438]  [<ffffffff81179238>] SyS_fsync+0x10/0x14
[ 1705.092118]  [<ffffffff81431a72>] system_call_fastpath+0x12/0x17
[ 1705.093373] note: xfs_io[3645] exited with preempt_count 1
[ 1946.983579] kmemleak: 1 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)
[ 2566.080608] kmemleak: 1 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)


>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
