Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59252 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388224AbeGXKdq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 06:33:46 -0400
Date: Tue, 24 Jul 2018 17:28:03 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH v2 2/2] btrfs: fix missing superblock update in the
 device delete commit transaction
Message-ID: <20180724092803.GG575@fnst.localdomain>
References: <20180703090724.22023-1-anand.jain@oracle.com>
 <20180703090724.22023-2-anand.jain@oracle.com>
 <20180721060113.GC575@fnst.localdomain>
 <4eba0d60-ef13-314e-0725-634a6113331a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4eba0d60-ef13-314e-0725-634a6113331a@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 23, 2018 at 03:52:59PM +0800, Anand Jain wrote:
>
>
>On 07/21/2018 02:01 PM, Lu Fengqi wrote:
>> On Tue, Jul 03, 2018 at 05:07:24PM +0800, Anand Jain wrote:
>> > When a device is deleted, the btrfs_super_block::number_devices is
>> > reduced by 1, but we do that after the commit transaction, so this
>> > change did not made it to the disk and waits for the next commit
>> > transaction whenever it happens.
>> > 
>> > This can be easily demonstrated using the following test case where I
>> > use the btrfs device ready cli to read the disk and report.
>> > 
>> >   mkfs.btrfs -fq -dsingle -msingle $dev1 $dev2
>> >   mount $dev1 /btrfs
>> >   btrfs dev del $dev2 /btrfs
>> >   btrfs dev ready $dev1; echo RESULT=$? <-- 1
>> >    Without this patch RESULT returns 1, indicating not ready!
>> > 
>> >   Testing with a seed device:
>> > 
>> >   mkfs.btrfs -fq $dev1
>> >   btrfstune -S1 $dev1
>> >   mount $dev1 /btrfs
>> >   btrfs dev add -f $dev2 /btrfs
>> >   umount /btrfs
>> >   mount $dev2 /btrfs
>> >   btrfs dev del $dev1 /btrfs
>> >   btrfs dev ready $dev2; echo RESULT=$? <-- 1
>> > 
>> >   Fix this by bringing in the num_devices update with in the
>> >   current commit transaction.
>> >   Also align the local variable declarations in the function
>> >   btrfs_rm_dev_item()
>> >   Delete a todo comment about transient inconsistent state
>> 
>> Hi, Anand
>> 
>> The btrfs/164 failed when I run xfstests with kdave/misc-next.
>
> And the
>> result of git bisect shows this patch may be the cause. Please see the
>> following log and dmesg.
>> 
>> xfstests log:
>> # sudo ./check btrfs/164
>> FSTYP         -- btrfs
>> PLATFORM      -- Linux/x86_64 larch 4.18.0-rc5+
>> MKFS_OPTIONS  -- /dev/vdb2
>> MOUNT_OPTIONS -- /dev/vdb2 /mnt/scratch
>> 
>> btrfs/164 14s ... [failed, exit status 1]
>> 
>> dmesg:
>> [  212.009967] general protection fault: 0000 [#1] SMP PTI
>> [  212.015834] CPU: 1 PID: 5665 Comm: btrfs Tainted: G           O      4.18.0-rc5+ #2
>> [  212.021985] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>> [  212.031137] RIP: 0010:btrfs_update_commit_device_size+0x74/0xd0 [btrfs]
>
>
>Thanks for the report.
>
>
>--------------
>void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
>{
>        struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>        struct btrfs_device *curr, *next;
>
>        if (list_empty(&fs_devices->resized_devices))
>                return;
>
>        mutex_lock(&fs_devices->device_list_mutex);
>        mutex_lock(&fs_info->chunk_mutex);
>        list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
>                                 resized_list) {
>                list_del_init(&curr->resized_list); <----  GPF
>                curr->commit_total_bytes = curr->disk_total_bytes;
>        }
>        mutex_unlock(&fs_info->chunk_mutex);
>        mutex_unlock(&fs_devices->device_list_mutex);
>}
>--------------
>
>
>I can't reproduce the issue. Do you reproduce consistently? and I

Sorry I've taken so long to reply.

There are four virtual machines with the different storage backend here.
And I can reproduce this issue consistently on the virtual machines (with
HDD or qcow2 file in HDD), however, I can't reproduce on the virtual machine
(with SSD or qcow2 file in SSD). So this may depend on the disk IO speed.

>wonder if your workspace contains the latest changes from
>kdave/misc-next? Because last weeks kdave/misc had some issues.
>Can you please give a try?

I used the latest kdave/misc-next branch on July 21, 2018, when I send
the previous mail. Just as David replied to Nikolay's thread, the current
latest kdave/misc-next still has the same problem.

In addition, this case will not fail when I enable KASAN. But the something
found in dmesg may help you to investigate. I attached them below.

-- 
Thanks,
Lu

log:
# sudo ./check btrfs/164
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 localhost 4.18.0-rc6+
MKFS_OPTIONS  -- /dev/vdc1
MOUNT_OPTIONS -- /dev/vdc1 /mnt/scratch

btrfs/164 15s ... _check_dmesg: something found in dmesg (see /home/luke/workspace/xfstests-dev/results//btrfs/164.dmesg)

Ran: btrfs/164
Failures: btrfs/164
Failed 1 of 1 tests

dmesg(KASAN enabled):
  444.636617] ==================================================================
[  444.639206] BUG: KASAN: use-after-free in btrfs_update_commit_device_size+0x124/0x2c0 [btrfs]
[  444.641234] Read of size 8 at addr ffff8801542ad1d0 by task btrfs/4575

[  444.645210] CPU: 0 PID: 4575 Comm: btrfs Not tainted 4.18.0-rc6+ #4
[  444.647150] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  444.649351] Call Trace:
[  444.650715]  dump_stack+0xd1/0x16c
[  444.652201]  ? dump_stack_print_info.cold.1+0x2f/0x2f
[  444.653924]  ? kmsg_dump_rewind_nolock+0x59/0x59
[  444.655637]  ? btrfs_update_commit_device_size+0x124/0x2c0 [btrfs]
[  444.657492]  print_address_description+0x6c/0x23c
[  444.659257]  ? btrfs_update_commit_device_size+0x124/0x2c0 [btrfs]
[  444.661083]  kasan_report.cold.6+0x241/0x2fd
[  444.662759]  btrfs_update_commit_device_size+0x124/0x2c0 [btrfs]
[  444.664598]  ? btrfs_destroy_dev_replace_tgtdev+0x1f0/0x1f0 [btrfs]
[  444.666573]  ? btrfs_wait_block_group_reservations+0x280/0x280 [btrfs]
[  444.668441]  ? _raw_spin_unlock+0x24/0x30
[  444.670091]  ? btrfs_first_delayed_node+0xbd/0x100 [btrfs]
[  444.672007]  ? btrfs_reloc_post_snapshot+0x8d0/0x8d0 [btrfs]
[  444.673941]  ? kmem_cache_free+0x2a8/0x320
[  444.675692]  ? __btrfs_run_delayed_items+0x213/0x250 [btrfs]
[  444.677600]  btrfs_commit_transaction+0xce1/0x1540 [btrfs]
[  444.679539]  ? btrfs_apply_pending_changes+0x80/0x80 [btrfs]
[  444.681363]  ? rcu_is_watching+0x98/0xe0
[  444.683032]  ? check_chain_key+0x13b/0x200
[  444.684649]  ? check_flags.part.42+0x210/0x210
[  444.686406]  ? do_raw_spin_unlock+0x157/0x1e0
[  444.688034]  ? do_raw_spin_trylock+0x120/0x120
[  444.689647]  ? do_raw_spin_trylock+0xa0/0x120
[  444.691271]  ? mark_lock+0x116/0xb60
[  444.692742]  ? _raw_spin_unlock_irqrestore+0x43/0x50
[  444.694471]  ? depot_save_stack+0x288/0x470
[  444.696018]  ? save_stack+0x8c/0xb0
[  444.697448]  ? __kasan_slab_free+0x12e/0x180
[  444.699023]  ? kfree+0xf0/0x2f0
[  444.700447]  ? free_fs_devices+0x1e4/0x240 [btrfs]
[  444.702288]  ? btrfs_rm_device+0xbbd/0xc70 [btrfs]
[  444.703983]  ? btrfs_ioctl+0x4f7f/0x5470 [btrfs]
[  444.705558]  ? do_vfs_ioctl+0x134/0xac0
[  444.707081]  ? ksys_ioctl+0x60/0x90
[  444.708419]  ? __x64_sys_ioctl+0x3d/0x50
[  444.709828]  ? do_syscall_64+0x16b/0xc30
[  444.711292]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  444.712846]  ? do_raw_spin_trylock+0x120/0x120
[  444.714321]  ? do_raw_spin_trylock+0xa0/0x120
[  444.715791]  ? mark_held_locks+0x92/0xb0
[  444.717183]  ? _raw_spin_unlock_irqrestore+0x43/0x50
[  444.718701]  ? trace_hardirqs_on_caller+0x18c/0x280
[  444.720240]  ? quarantine_put+0xb7/0x150
[  444.721585]  ? __kasan_slab_free+0x143/0x180
[  444.723060]  ? free_fs_devices+0x1e4/0x240 [btrfs]
[  444.724453]  ? kfree+0xf0/0x2f0
[  444.725685]  ? free_fs_devices+0x1e4/0x240 [btrfs]
[  444.727129]  ? __blkdev_put+0x2f8/0x400
[  444.728430]  ? btrfs_free_device+0x50/0x50 [btrfs]
[  444.729872]  ? bd_set_size+0x170/0x170
[  444.731190]  btrfs_rm_device+0xbc6/0xc70 [btrfs]
[  444.733412]  ? btrfs_scratch_superblocks+0x170/0x170 [btrfs]
[  444.735040]  ? check_chain_key+0x13b/0x200
[  444.736394]  ? check_flags.part.42+0x210/0x210
[  444.737738]  ? ___might_sleep+0x184/0x250
[  444.739078]  ? cpu_extra_stat_show+0x10/0x10
[  444.740449]  ? _copy_from_user+0x7d/0xb0
[  444.741759]  btrfs_ioctl+0x4f7f/0x5470 [btrfs]
[  444.743188]  ? mark_lock+0x116/0xb60
[  444.744426]  ? print_usage_bug+0xf0/0xf0
[  444.745760]  ? cyc2ns_read_begin.part.1+0x67/0x90
[  444.747225]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[  444.748844]  ? alloc_set_pte+0x495/0x560
[  444.750221]  ? reacquire_held_locks+0xa8/0x1d0
[  444.751612]  ? alloc_set_pte+0x495/0x560
[  444.752933]  ? cyc2ns_read_begin.part.1+0x67/0x90
[  444.754386]  ? native_sched_clock+0xa9/0x130
[  444.755773]  ? cyc2ns_read_end+0x10/0x10
[  444.757055]  ? check_flags.part.42+0x210/0x210
[  444.758457]  ? check_chain_key+0x13b/0x200
[  444.759812]  ? __lock_acquire+0x779/0x2a10
[  444.761175]  ? lock_release+0x8a0/0x8a0
[  444.763263]  ? find_get_entries_tag+0x800/0x800
[  444.764711]  ? check_chain_key+0x13b/0x200
[  444.766088]  ? check_chain_key+0x13b/0x200
[  444.767395]  ? __lock_acquire+0x779/0x2a10
[  444.768718]  ? cyc2ns_read_begin.part.1+0x67/0x90
[  444.770209]  ? native_sched_clock+0xa9/0x130
[  444.771541]  ? cyc2ns_read_end+0x10/0x10
[  444.772840]  ? lock_release+0x8a0/0x8a0
[  444.774159]  ? check_chain_key+0x13b/0x200
[  444.775485]  ? check_flags.part.42+0x210/0x210
[  444.776852]  ? do_raw_spin_unlock+0x157/0x1e0
[  444.778232]  ? do_raw_spin_trylock+0x120/0x120
[  444.779595]  ? cyc2ns_read_begin.part.1+0x67/0x90
[  444.780946]  ? native_sched_clock+0xa9/0x130
[  444.782319]  ? cyc2ns_read_end+0x10/0x10
[  444.783596]  ? _raw_spin_unlock+0x24/0x30
[  444.784875]  ? check_chain_key+0x13b/0x200
[  444.786205]  ? check_flags.part.42+0x210/0x210
[  444.787512]  ? do_vfs_ioctl+0x134/0xac0
[  444.788791]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[  444.790438]  do_vfs_ioctl+0x134/0xac0
[  444.791758]  ? native_sched_clock+0xa9/0x130
[  444.793248]  ? ioctl_preallocate+0x180/0x180
[  444.794629]  ? ktime_get_coarse_real_ts64+0x140/0x190
[  444.796134]  ? __fget_light+0x198/0x220
[  444.797368]  ? fget_raw+0x10/0x10
[  444.798634]  ? ktime_mono_to_any+0x170/0x170
[  444.800044]  ? __audit_syscall_entry+0x22d/0x2a0
[  444.801455]  ksys_ioctl+0x60/0x90
[  444.802741]  __x64_sys_ioctl+0x3d/0x50
[  444.803965]  do_syscall_64+0x16b/0xc30
[  444.805173]  ? syscall_return_slowpath+0x610/0x610
[  444.806651]  ? handle_mm_fault+0x3da/0x590
[  444.807919]  ? rcu_note_context_switch+0x4e0/0x4e0
[  444.809343]  ? vmacache_find+0xbc/0x110
[  444.810615]  ? vmacache_update+0x68/0x80
[  444.811869]  ? up_read+0x3b/0x90
[  444.813094]  ? __do_page_fault+0x432/0x6d0
[  444.814406]  ? bad_area_access_error+0xf0/0xf0
[  444.815807]  ? lockdep_sys_exit+0x16/0x31
[  444.817050]  ? syscall_return_slowpath+0x18d/0x610
[  444.818445]  ? do_page_fault+0xa9/0x420
[  444.819753]  ? __do_page_fault+0x6d0/0x6d0
[  444.821001]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[  444.823102]  ? prepare_exit_to_usermode+0x23e/0x310
[  444.824555]  ? lockdep_sys_exit+0x16/0x31
[  444.825872]  ? prepare_exit_to_usermode+0x119/0x310
[  444.827361]  ? tracehook_report_syscall_exit+0x180/0x180
[  444.828806]  ? mark_held_locks+0x23/0xb0
[  444.830215]  ? retint_user+0x18/0x18
[  444.831436]  ? page_fault+0x8/0x30
[  444.832692]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  444.834107]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  444.835591] RIP: 0033:0x7f2626a8f667
[  444.836885] Code: 00 00 90 48 8b 05 e9 67 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b9 67 2c 00 f7 d8 64 89 01 48
[  444.842256] RSP: 002b:00007ffc4470ed58 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[  444.844204] RAX: ffffffffffffffda RBX: 00007ffc44710f20 RCX: 00007f2626a8f667
[  444.846120] RDX: 00007ffc4470fd80 RSI: 000000005000943a RDI: 0000000000000003
[  444.847938] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  444.849817] R10: fffffffffffff807 R11: 0000000000000202 R12: 00007ffc44710f20
[  444.851761] R13: 0000000000000000 R14: 0000000000000003 R15: 00007ffc44710f28

[  444.855000] Allocated by task 4534:
[  444.856353]  kasan_kmalloc+0xbf/0xe0
[  444.857700]  kmem_cache_alloc_trace+0x141/0x350
[  444.859314]  btrfs_alloc_device+0xe8/0x4d0 [btrfs]
[  444.860867]  close_fs_devices.part.44+0x282/0x4d0 [btrfs]
[  444.862597]  btrfs_close_devices+0x53/0xf0 [btrfs]
[  444.864138]  btrfs_mount_root+0xb2c/0xe80 [btrfs]
[  444.865637]  mount_fs+0x5c/0x1a3
[  444.867064]  vfs_kern_mount.part.38+0xa8/0x260
[  444.868569]  btrfs_mount+0x352/0x1170 [btrfs]
[  444.870127]  mount_fs+0x5c/0x1a3
[  444.871471]  vfs_kern_mount.part.38+0xa8/0x260
[  444.873018]  do_mount+0x36a/0x16b0
[  444.874425]  ksys_mount+0xba/0xd0
[  444.875852]  __x64_sys_mount+0x62/0x70
[  444.877252]  do_syscall_64+0x16b/0xc30
[  444.878682]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[  444.881439] Freed by task 4575:
[  444.883336]  __kasan_slab_free+0x12e/0x180
[  444.884812]  kfree+0xf0/0x2f0
[  444.886153]  rcu_process_callbacks+0x9d9/0x1ae0
[  444.887633]  __do_softirq+0x1cf/0x788

[  444.890150] The buggy address belongs to the object at ffff8801542ad0a8
                which belongs to the cache kmalloc-1024 of size 1024
[  444.893597] The buggy address is located 296 bytes inside of
                1024-byte region [ffff8801542ad0a8, ffff8801542ad4a8)
[  444.897004] The buggy address belongs to the page:
[  444.898486] page:ffffea000550aa00 count:1 mapcount:0 mapping:ffff88015a40ea40 index:0xffff8801542a8568 compound_mapcount: 0
[  444.901682] flags: 0x8000000000008100(slab|head)
[  444.903299] raw: 8000000000008100 ffffea00055c3e08 ffffea00055a3e08 ffff88015a40ea40
[  444.905207] raw: ffff8801542a8568 0000000000170014 00000001ffffffff 0000000000000000
[  444.907218] page dumped because: kasan: bad access detected

[  444.910036] Memory state around the buggy address:
[  444.911771]  ffff8801542ad080: fc fc fc fc fc fb fb fb fb fb fb fb fb fb fb fb
[  444.913922]  ffff8801542ad100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  444.915898] >ffff8801542ad180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  444.917769]                                                  ^
[  444.919606]  ffff8801542ad200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  444.921517]  ffff8801542ad280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  444.923485] ==================================================================
[  444.925350] Disabling lock debugging due to kernel taint


>
>Also I found another issue - if the device being deleted is a seed
>device as in btrfs/164, we don't have to call
>btrfs_update_commit_device_size() as because we don't write its super.
>But this isn't related to this commit nor the GPF that you saw.
>
>Thanks, Anand
>
>
>
>> [  212.036659] Code: ef e8 60 cc 72 e1 49 8b 96 08 01 00 00 48 8b 0a 48 8d 82 d8 fe ff ff 48 8d b1 d8 fe ff ff 49 39 d4 74 47 48 8b b8 30 01 00 00 <48> 89 79 08 48 89 0f 48 89 90 28 01 00 00 48 89 90 30 01 00 00 48
>> [  212.052862] RSP: 0018:ffffc90000c3bbc0 EFLAGS: 00010202
>> [  212.057537] RAX: ffff88004d45ea88 RBX: ffff88005f246820 RCX: 6b6b6b6b6b6b6b6b
>> [  212.066491] RDX: ffff88004d45ebb0 RSI: 6b6b6b6b6b6b6a43 RDI: 6b6b6b6b6b6b6b6b
>> [  212.072735] RBP: ffffc90000c3bbe0 R08: 0000000000000000 R09: 0000000000000001
>> [  212.078961] R10: ffffc90000c3bbb0 R11: ffffffff82ea2800 R12: ffff88005f2468d0
>> [  212.084967] R13: ffff880066e4c910 R14: ffff88005f2467c8 R15: ffff880066e4d138
>> [  212.093457] FS:  00007fca3f6e08c0(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
>> [  212.099305] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  212.103643] CR2: 00007fdd21385f88 CR3: 0000000075c4e000 CR4: 00000000000006e0
>> [  212.108514] Call Trace:
>> [  212.110829]  btrfs_commit_transaction+0x525/0x980 [btrfs]
>> [  212.114745]  btrfs_rm_device+0x527/0x560 [btrfs]
>> [  212.118082]  btrfs_ioctl+0x2e99/0x31e0 [btrfs]
>> [  212.123417]  ? __lock_acquire+0x396/0x1910
>> [  212.126360]  ? __might_fault+0x3e/0x90
>> [  212.128924]  ? __might_fault+0x85/0x90
>> [  212.131398]  ? _copy_to_user+0x65/0x80
>> [  212.133870]  ? cp_new_stat+0x120/0x150
>> [  212.136354]  ? native_sched_clock+0x3e/0xa0
>> [  212.138825]  do_vfs_ioctl+0xa9/0x6c0
>> [  212.141175]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
>> [  212.144476]  ? do_vfs_ioctl+0xa9/0x6c0
>> [  212.146889]  ? trace_hardirqs_on+0xd/0x10
>> [  212.149210]  ksys_ioctl+0x67/0x90
>> [  212.151499]  __x64_sys_ioctl+0x1a/0x20
>> [  212.154064]  do_syscall_64+0x6d/0x690
>> [  212.156146]  ? trace_hardirqs_off_thunk+0x1a/0x1c
>> [  212.158720]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  212.161363] RIP: 0033:0x7fca3e4c1667
>> [  212.163437] Code: 00 00 90 48 8b 05 e9 67 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b9 67 2c 00 f7 d8 64 89 01 48
>> [  212.172921] RSP: 002b:00007ffffaf1ba08 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
>> [  212.176599] RAX: ffffffffffffffda RBX: 00007ffffaf1dbd0 RCX: 00007fca3e4c1667
>> [  212.179912] RDX: 00007ffffaf1ca30 RSI: 000000005000943a RDI: 0000000000000003
>> [  212.184742] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>> [  212.188250] R10: fffffffffffff807 R11: 0000000000000202 R12: 00007ffffaf1dbd0
>> [  212.191810] R13: 0000000000000000 R14: 0000000000000003 R15: 00007ffffaf1dbd8
>> [  212.195309] Modules linked in: btrfs(O) xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs virtio_scsi [last unloaded: xor]
>> [  212.201294] ---[ end trace d9007c0cfa00d04e ]---
>> [  212.203760] RIP: 0010:btrfs_update_commit_device_size+0x74/0xd0 [btrfs]
>> [  212.207008] Code: ef e8 60 cc 72 e1 49 8b 96 08 01 00 00 48 8b 0a 48 8d 82 d8 fe ff ff 48 8d b1 d8 fe ff ff 49 39 d4 74 47 48 8b b8 30 01 00 00 <48> 89 79 08 48 89 0f 48 89 90 28 01 00 00 48 89 90 30 01 00 00 48
>> [  212.221356] RSP: 0018:ffffc90000c3bbc0 EFLAGS: 00010202
>> [  212.224982] RAX: ffff88004d45ea88 RBX: ffff88005f246820 RCX: 6b6b6b6b6b6b6b6b
>> [  212.229116] RDX: ffff88004d45ebb0 RSI: 6b6b6b6b6b6b6a43 RDI: 6b6b6b6b6b6b6b6b
>> [  212.233170] RBP: ffffc90000c3bbe0 R08: 0000000000000000 R09: 0000000000000001
>> [  212.237057] R10: ffffc90000c3bbb0 R11: ffffffff82ea2800 R12: ffff88005f2468d0
>> [  212.240578] R13: ffff880066e4c910 R14: ffff88005f2467c8 R15: ffff880066e4d138
>> [  212.244531] FS:  00007fca3f6e08c0(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
>> [  212.249183] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  212.252270] CR2: 00007fdd21385f88 CR3: 0000000075c4e000 CR4: 00000000000006e0
>> [  513.015417] kworker/dying (7) used greatest stack depth: 10056 bytes left
>> 
>
>


