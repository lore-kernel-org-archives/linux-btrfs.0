Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36910 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbbDXGeo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 02:34:44 -0400
Received: by igblo3 with SMTP id lo3so7406994igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 23:34:43 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <55394CEE.5030205@fb.com>
References: <1428954759-1304912-1-git-send-email-clm@fb.com>
	<mh8h3f$l3u$1@ger.gmane.org>
	<pan.2015.04.22.16.37.38@googlemail.com>
	<5537D27E.3080609@fb.com>
	<CAL3q7H4ccdcJYKZaH_fYW9EUPCSTa3gDz_fiUjP8TvCUvQtxTQ@mail.gmail.com>
	<5538EB05.7050200@fb.com>
	<CAL3q7H6wUMruqTvKwMqcTXcgJv2fFw1GFN9QxyfE5GKqR-GNew@mail.gmail.com>
	<20150423151704.GA25585@ret.masoncoding.com>
	<CAL3q7H7oOcTZyCkP0NVWzQ3cKdJD=GDnM6+wM83D9_szHCX95g@mail.gmail.com>
	<CAL3q7H6+x7y64rZfRniJVDP8OwbNWCLuAC7M9D9OWY2urTsnWg@mail.gmail.com>
	<55394CEE.5030205@fb.com>
Date: Fri, 24 Apr 2015 07:34:43 +0100
Message-ID: <CAL3q7H7sM9Z4AbyuJUy5A9PkhrfOB=eQq_2ZRu9nRgjOwkVA6w@mail.gmail.com>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during commit
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 8:50 PM, Chris Mason <clm@fb.com> wrote:
> On 04/23/2015 03:43 PM, Filipe David Manana wrote:
>> On Thu, Apr 23, 2015 at 4:48 PM, Filipe David Manana <fdmanana@gmail.com> wrote:
>>> On Thu, Apr 23, 2015 at 4:17 PM, Chris Mason <clm@fb.com> wrote:
>>>> On Thu, Apr 23, 2015 at 02:05:48PM +0100, Filipe David Manana wrote:
>>>>>>> Trying the current integration-4.1 branch, I ran into the following
>>>>>>> during xfstests/btrfs/049:
>>>>>>>
>>>>>>
>>>>>> Ugh, I must not be waiting correctly in one of the inode cache writeout
>>>>>> sections.  But I've run 049 a whole bunch of times without triggering,
>>>>>> can you get this to happen consistently?
>>>>>
>>>>> All the time so far.
>>>>
>>>> I'm testing with this now:
>>>>
>>>> commit 9f433238891b1b243c4f19d3f36eed913b270cbc
>>>> Author: Chris Mason <clm@fb.com>
>>>> Date:   Thu Apr 23 08:02:49 2015 -0700
>>>>
>>>>     Btrfs: fix inode cache writeout
>>>>
>>>>     The code to fix stalls during free spache cache IO wasn't using
>>>>     the correct root when waiting on the IO for inode caches.  This
>>>>     is only a problem when the inode cache is enabled with
>>>>
>>>>     mount -o inode_cache
>>>>
>>>>     This fixes the inode cache writeout to preserve any error values and
>>>>     makes sure not to override the root when inode cache writeout is done.
>>>>
>>>>     Reported-by: Filipe Manana <fdmanana@suse.com>
>>>>     Signed-off-by: Chris Mason <clm@fb.com>
>>>
>>> Thanks, btrfs/049 now passes with that patch applied.
>>> Running the whole xfstests suite now.
>>
>> btrfs/066 also failed once during final fsck with:
>>
>> _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
>> *** fsck.btrfs output ***
>> checking extents
>> checking free space cache
>> There is no free space entry for 21676032-21680128
>> There is no free space entry for 21676032-87031808
>> cache appears valid but isnt 20971520
>
> Josef has a btrfs-progs patch for this.  The kernel will toss the cache.
>  There's a somewhat fundamental race in cache writeout this patch makes
> a little bigger, but it has always been there.
>
> (compare what find_free_extent can do with no trans running vs the
> actual cache writeback)

There's also one list corruption I didn't get before and happened
while running fsstress (btrfs/078), apparently due to some race:

[25590.799058] ------------[ cut here ]------------
[25590.800204] WARNING: CPU: 3 PID: 7280 at lib/list_debug.c:62
__list_del_entry+0x5a/0x98()
[25590.802101] list_del corruption. next->prev should be
ffff8801a0f74d50, but was a56b6b6b6b6b6b6b
[25590.804236] Modules linked in: btrfs dm_flakey dm_mod
crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
lockd grace fscache sunrpc loop fuse i2c_piix4 i2c_core psmouse
serio_raw evdev parport_pc parport acpi_cpufreq processor button
pcspkr thermal_sys microcode ext4 crc16 jbd2 mbcache sd_mod sg sr_mod
cdrom virtio_scsi ata_generic virtio_pci virtio_ring ata_piix e1000
virtio libata floppy scsi_mod [last unloaded: btrfs]
[25590.818580] CPU: 3 PID: 7280 Comm: fsstress Tainted: G        W
  4.0.0-rc5-btrfs-next-9+ #1
[25590.820597] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[25590.823458]  0000000000000009 ffff8803f031bc08 ffffffff8142fa46
ffffffff8108b6a2
[25590.825081]  ffff8803f031bc58 ffff8803f031bc48 ffffffff81045ea5
0000000000000011
[25590.826568]  ffffffff81245af7 ffff8801a0f74d50 ffff8801a0f74460
ffff880041710df0
[25590.828106] Call Trace:
[25590.828630]  [<ffffffff8142fa46>] dump_stack+0x4f/0x7b
[25590.829706]  [<ffffffff8108b6a2>] ? console_unlock+0x361/0x3ad
[25590.830785]  [<ffffffff81045ea5>] warn_slowpath_common+0xa1/0xbb
[25590.831957]  [<ffffffff81245af7>] ? __list_del_entry+0x5a/0x98
[25590.867473]  [<ffffffff81045f05>] warn_slowpath_fmt+0x46/0x48
[25590.868631]  [<ffffffffa04907e2>] ? btrfs_csum_data+0x16/0x18 [btrfs]
[25590.869524]  [<ffffffff81245af7>] __list_del_entry+0x5a/0x98
[25590.870918]  [<ffffffffa04cff5f>] write_bitmap_entries+0x99/0xbd [btrfs]
[25590.872377]  [<ffffffffa04d0858>] ?
__btrfs_write_out_cache.isra.21+0x20b/0x3a1 [btrfs]
[25590.874079]  [<ffffffffa04d0864>]
__btrfs_write_out_cache.isra.21+0x217/0x3a1 [btrfs]
[25590.875594]  [<ffffffffa04d1269>] ? btrfs_write_out_cache+0x41/0xdc [btrfs]
[25590.877032]  [<ffffffffa04d12bb>] btrfs_write_out_cache+0x93/0xdc [btrfs]
[25590.878406]  [<ffffffffa04888e7>] ?
btrfs_start_dirty_block_groups+0x156/0x29b [btrfs]
[25590.879859]  [<ffffffffa0488977>]
btrfs_start_dirty_block_groups+0x1e6/0x29b [btrfs]
[25590.881360]  [<ffffffffa04970f2>]
btrfs_commit_transaction+0x130/0x9c9 [btrfs]
[25590.882504]  [<ffffffffa0471748>] btrfs_sync_fs+0xe1/0x12d [btrfs]
[25590.883600]  [<ffffffff811569d3>] ? iterate_supers+0x60/0xc4
[25590.884671]  [<ffffffff8117acda>] ? vfs_fsync+0x1e/0x1e
[25590.885640]  [<ffffffff8117acfa>] sync_fs_one_sb+0x20/0x22
[25590.886619]  [<ffffffff811569e9>] iterate_supers+0x76/0xc4
[25590.887586]  [<ffffffff8117af58>] sys_sync+0x55/0x83
[25590.888534]  [<ffffffff81435b32>] system_call_fastpath+0x12/0x17
[25590.889694] ---[ end trace d1235b0201a01949 ]---
[25590.890573] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[25590.891870] Modules linked in: btrfs dm_flakey dm_mod
crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
lockd grace fscache sunrpc loop fuse i2c_piix4 i2c_core psmouse
serio_raw evdev parport_pc parport acpi_cpufreq processor button
pcspkr thermal_sys microcode ext4 crc16 jbd2 mbcache sd_mod sg sr_mod
cdrom virtio_scsi ata_generic virtio_pci virtio_ring ata_piix e1000
virtio libata floppy scsi_mod [last unloaded: btrfs]
[25590.892522] CPU: 3 PID: 7280 Comm: fsstress Tainted: G        W
  4.0.0-rc5-btrfs-next-9+ #1
[25590.892522] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[25590.892522] task: ffff88040f485bd0 ti: ffff8803f0318000 task.ti:
ffff8803f0318000
[25590.892522] RIP: 0010:[<ffffffffa04cff2c>]  [<ffffffffa04cff2c>]
write_bitmap_entries+0x66/0xbd [btrfs]
[25590.892522] RSP: 0018:ffff8803f031bcc8  EFLAGS: 00010246
[25590.892522] RAX: 0000000000000011 RBX: ffff8801a0f74460 RCX: 0000000000000400
[25590.892522] RDX: ffff8804062e8000 RSI: 6b6b6b6b6b6b6b6b RDI: ffff8804062e8000
[25590.892522] RBP: ffff8803f031bcf8 R08: 0000000000000001 R09: 0000000000000000
[25590.892522] R10: 0000000000000000 R11: ffffffff8165a180 R12: 6b6b6b6b6b6b6b6b
[25590.892522] R13: ffff880041710df0 R14: 6b6b6b6b6b6b6b6b R15: ffff8803f031bd38
[25590.892522] FS:  00007f6a2fd9f700(0000) GS:ffff88043dd80000(0000)
knlGS:0000000000000000
[25590.892522] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[25590.892522] CR2: 00007f6a280d9ad8 CR3: 00000003c65c5000 CR4: 00000000000006e0
[25590.892522] Stack:
[25590.892522]  ffffffffa04d0858 ffff880041710df0 ffff880041710c00
ffff88033ba59c90
[25590.892522]  0000000000000000 ffff8803efb6ff70 ffff8803f031bd78
ffffffffa04d0864
[25590.892522]  ffff88037cae7f40 ffff88033ba599d0 ffff880226cd4000
ffff8803efb6ff00
[25590.892522] Call Trace:
[25590.892522]  [<ffffffffa04d0858>] ?
__btrfs_write_out_cache.isra.21+0x20b/0x3a1 [btrfs]
[25590.892522]  [<ffffffffa04d0864>]
__btrfs_write_out_cache.isra.21+0x217/0x3a1 [btrfs]
[25590.892522]  [<ffffffffa04d1269>] ? btrfs_write_out_cache+0x41/0xdc [btrfs]
[25590.892522]  [<ffffffffa04d12bb>] btrfs_write_out_cache+0x93/0xdc [btrfs]
[25590.892522]  [<ffffffffa04888e7>] ?
btrfs_start_dirty_block_groups+0x156/0x29b [btrfs]
[25590.892522]  [<ffffffffa0488977>]
btrfs_start_dirty_block_groups+0x1e6/0x29b [btrfs]
[25590.892522]  [<ffffffffa04970f2>]
btrfs_commit_transaction+0x130/0x9c9 [btrfs]
[25590.892522]  [<ffffffffa0471748>] btrfs_sync_fs+0xe1/0x12d [btrfs]
[25590.892522]  [<ffffffff811569d3>] ? iterate_supers+0x60/0xc4
[25590.892522]  [<ffffffff8117acda>] ? vfs_fsync+0x1e/0x1e
[25590.892522]  [<ffffffff8117acfa>] sync_fs_one_sb+0x20/0x22
[25590.892522]  [<ffffffff811569e9>] iterate_supers+0x76/0xc4
[25590.892522]  [<ffffffff8117af58>] sys_sync+0x55/0x83
[25590.892522]  [<ffffffff81435b32>] system_call_fastpath+0x12/0x17
[25590.892522] Code: 4c 89 ef 8d 70 ff e8 a4 ec ff ff 41 8b 45 3c 41
39 45 38 7d 5c 31 f6 4c 89 ef e8 a9 f5 ff ff 49 8b 7d 00 4c 89 f6 b9
00 04 00 00 <f3> a5 4c 89 ef 41 8b 45 38 8d 70 ff e8 73 ec ff ff 41 8b
45 3c
[25590.892522] RIP  [<ffffffffa04cff2c>] write_bitmap_entries+0x66/0xbd [btrfs]
[25590.892522]  RSP <ffff8803f031bcc8>
[25590.951443] ---[ end trace d1235b0201a0194a ]---
[25590.958107] BUG: sleeping function called from invalid context at
kernel/locking/rwsem.c:41
[25590.959805] in_atomic(): 1, irqs_disabled(): 0, pid: 7280, name: fsstress
[25590.961219] INFO: lockdep is turned off.
[25590.962095] Preemption disabled at:[<ffffffffa04d0858>]
__btrfs_write_out_cache.isra.21+0x20b/0x3a1 [btrfs]
[25590.964190]
[25590.964675] CPU: 3 PID: 7280 Comm: fsstress Tainted: G      D W
  4.0.0-rc5-btrfs-next-9+ #1
[25590.966441] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[25590.969050]  0000000000001c70 ffff8803f031ba28 ffffffff8142fa46
ffffffff8108b6a2
[25590.971014]  0000000000000000 ffff8803f031ba58 ffffffff8106674b
00007ffffffff000
[25590.973141]  ffffffff817d1e02 0000000000000029 0000000000000000
ffff8803f031ba88
[25590.975044] Call Trace:
[25590.975635]  [<ffffffff8142fa46>] dump_stack+0x4f/0x7b
[25590.976733]  [<ffffffff8108b6a2>] ? console_unlock+0x361/0x3ad
[25590.977956]  [<ffffffff8106674b>] ___might_sleep+0x1b9/0x1c1
[25590.979252]  [<ffffffff810667f3>] __might_sleep+0xa0/0xa8
[25590.989557]  [<ffffffff81433ce9>] down_read+0x21/0x50
[25590.990930]  [<ffffffff810528fb>] exit_signals+0x26/0x11a
[25590.992152]  [<ffffffff810603d0>] ? blocking_notifier_call_chain+0x14/0x16
[25591.002069]  [<ffffffff8104727e>] do_exit+0x128/0x9cb
[25591.002719]  [<ffffffff8107b024>] ? arch_local_irq_save+0x9/0xc
[25591.003542]  [<ffffffff8108c36d>] ? kmsg_dump+0xd2/0xf8
[25591.004677]  [<ffffffff8108c38a>] ? kmsg_dump+0xef/0xf8
[25591.005763]  [<ffffffff8100594c>] oops_end+0xa6/0xae
[25591.006797]  [<ffffffff81005dd1>] die+0x5a/0x63
[25591.007760]  [<ffffffff81002dc0>] do_general_protection+0x97/0x142
[25591.009032]  [<ffffffff81437812>] general_protection+0x22/0x30
[25591.010245]  [<ffffffffa04cff2c>] ? write_bitmap_entries+0x66/0xbd [btrfs]
[25591.012880]  [<ffffffffa04cff5f>] ? write_bitmap_entries+0x99/0xbd [btrfs]
[25591.013686]  [<ffffffffa04d0858>] ?
__btrfs_write_out_cache.isra.21+0x20b/0x3a1 [btrfs]
[25591.014709]  [<ffffffffa04d0864>]
__btrfs_write_out_cache.isra.21+0x217/0x3a1 [btrfs]
[25591.016398]  [<ffffffffa04d1269>] ? btrfs_write_out_cache+0x41/0xdc [btrfs]
[25591.017207]  [<ffffffffa04d12bb>] btrfs_write_out_cache+0x93/0xdc [btrfs]
[25591.018002]  [<ffffffffa04888e7>] ?
btrfs_start_dirty_block_groups+0x156/0x29b [btrfs]
[25591.019000]  [<ffffffffa0488977>]
btrfs_start_dirty_block_groups+0x1e6/0x29b [btrfs]
[25591.019980]  [<ffffffffa04970f2>]
btrfs_commit_transaction+0x130/0x9c9 [btrfs]
[25591.020944]  [<ffffffffa0471748>] btrfs_sync_fs+0xe1/0x12d [btrfs]
[25591.021679]  [<ffffffff811569d3>] ? iterate_supers+0x60/0xc4
[25591.022693]  [<ffffffff8117acda>] ? vfs_fsync+0x1e/0x1e
[25591.023767]  [<ffffffff8117acfa>] sync_fs_one_sb+0x20/0x22
[25591.024931]  [<ffffffff811569e9>] iterate_supers+0x76/0xc4
[25591.026050]  [<ffffffff8117af58>] sys_sync+0x55/0x83
[25591.027084]  [<ffffffff81435b32>] system_call_fastpath+0x12/0x17
(....)


>
> -chris
>
>> Checking filesystem on /dev/sdc
>> UUID: f7785aa7-d5ba-479d-a211-7c31039dc9b1
>> found 11911316 bytes used err is -22
>> total csum bytes: 7656
>> total tree bytes: 454656
>> total fs tree bytes: 376832
>> total extent tree bytes: 36864
>> btree space waste bytes: 122959
>> file data blocks allocated: 42893312
>>  referenced 31158272
>>
>> (it failed like that 1 out of 4 runs)
>>
>>
>>>
>>>>
>>>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>>>> index 5a4f5d1..8cd797f 100644
>>>> --- a/fs/btrfs/free-space-cache.c
>>>> +++ b/fs/btrfs/free-space-cache.c
>>>> @@ -1149,7 +1149,8 @@ int btrfs_wait_cache_io(struct btrfs_root *root,
>>>>         if (!inode)
>>>>                 return 0;
>>>>
>>>> -       root = root->fs_info->tree_root;
>>>> +       if (block_group)
>>>> +               root = root->fs_info->tree_root;
>>>>
>>>>         /* Flush the dirty pages in the cache file. */
>>>>         ret = flush_dirty_cache(inode);
>>>> @@ -3465,9 +3466,12 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>>>>         if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>>>>                 return 0;
>>>>
>>>> +       memset(&io_ctl, 0, sizeof(io_ctl));
>>>>         ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
>>>> -                                     trans, path, 0) ||
>>>> -               btrfs_wait_cache_io(root, trans, NULL, &io_ctl, path, 0);
>>>> +                                     trans, path, 0);
>>>> +       if (!ret)
>>>> +               ret = btrfs_wait_cache_io(root, trans, NULL, &io_ctl, path, 0);
>>>> +
>>>>         if (ret) {
>>>>                 btrfs_delalloc_release_metadata(inode, inode->i_size);
>>>>  #ifdef DEBUG
>>>
>>>
>>>
>>> --
>>> Filipe David Manana,
>>>
>>> "Reasonable men adapt themselves to the world.
>>>  Unreasonable men adapt the world to themselves.
>>>  That's why all progress depends on unreasonable men."
>>
>>
>>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
