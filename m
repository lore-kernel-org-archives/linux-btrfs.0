Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbaDIVWT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 17:22:19 -0400
Message-ID: <5345BA08.1090403@suse.com>
Date: Wed, 09 Apr 2014 17:22:16 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix lockdep warning with reclaim lock inversion
References: <5333184E.3090609@suse.com> <CAL3q7H7KY+RgtcOqjLLdpF-Sxy=o6U_3hziWDEu5TGpgE9NDNA@mail.gmail.com>
In-Reply-To: <CAL3q7H7KY+RgtcOqjLLdpF-Sxy=o6U_3hziWDEu5TGpgE9NDNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/9/14, 12:05 PM, Filipe David Manana wrote:
> On Wed, Mar 26, 2014 at 6:11 PM, Jeff Mahoney <jeffm@suse.com>
> wrote:
>> When encountering memory pressure, testers have run into the
>> following lockdep warning. It was caused by __link_block_group
>> calling kobject_add with the groups_sem held. kobject_add calls
>> kvasprintf with GFP_KERNEL, which gets us into reclaim context.
>> The kobject doesn't actually need to be added under the lock --
>> it just needs to ensure that it's only added for the first block
>> group to be linked.
>> 
>> ========================================================= [ INFO:
>> possible irq lock inversion dependency detected ] 
>> 3.14.0-rc8-default #1 Not tainted 
>> --------------------------------------------------------- 
>> kswapd0/169 just changed the state of lock: 
>> (&delayed_node->mutex){+.+.-.}, at: [<ffffffffa018baea>]
>> __btrfs_release_delayed_node+0x3a/0x200 [btrfs] but this lock
>> took another, RECLAIM_FS-unsafe lock in the past: 
>> (&found->groups_sem){+++++.}
>> 
>> and interrupts could create inverse lock ordering between them.
>> 
>> other info that might help us debug this: Possible interrupt
>> unsafe locking scenario: CPU0                    CPU1 ----
>> ---- lock(&found->groups_sem); local_irq_disable(); 
>> lock(&delayed_node->mutex); lock(&found->groups_sem); 
>> <Interrupt> lock(&delayed_node->mutex);
>> 
>> *** DEADLOCK *** 2 locks held by kswapd0/169: #0:
>> (shrinker_rwsem){++++..}, at: [<ffffffff81159e8a>]
>> shrink_slab+0x3a/0x160 #1:  (&type->s_umount_key#27){++++..}, at:
>> [<ffffffff811bac6f>] grab_super_passive+0x3f/0x90
>> 
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> 
> Hi Jeff,
> 
> The same kind of problem happens when deleting the kobj. See the
> trace below, thanks.


Thanks, Filipe. I have an updated patch I'll post in a minute.

- -Jeff

> [23510.196996] BTRFS: device fsid
> 6b4518c2-60e8-4990-8c6e-fb15054b1e46 devid 1 transid 4 /dev/sdd 
> [23510.203212] BTRFS info (device sdd): disk space caching is
> enabled [23510.203214] BTRFS: flagging fs with big metadata
> feature [23510.227365] BTRFS: creating UUID tree [23661.587069] 
> [23661.587073]
> ========================================================= 
> [23661.587074] [ INFO: possible irq lock inversion dependency
> detected ] [23661.587076] 3.13.0-fdm-btrfs-next-24+ #7 Not tainted 
> [23661.587077]
> --------------------------------------------------------- 
> [23661.587078] kswapd0/42 just changed the state of lock: 
> [23661.587079]  (&delayed_node->mutex){+.+.-.}, at: 
> [<ffffffffa036d73c>] __btrfs_release_delayed_node+0x4c/0x1f0
> [btrfs] [23661.587095] but this lock took another,
> RECLAIM_FS-unsafe lock in the past: [23661.587096]
> (sysfs_mutex){+.+.+.} [23661.587096] [23661.587096] and interrupts
> could create inverse lock ordering between them. [23661.587096] 
> [23661.587098] [23661.587098] other info that might help us debug
> this: [23661.587099] Chain exists of: [23661.587099]
> &delayed_node->mutex --> &found->groups_sem --> sysfs_mutex 
> [23661.587099] [23661.587102]  Possible interrupt unsafe locking
> scenario: [23661.587102] [23661.587103]        CPU0
> CPU1 [23661.587103]        ----                    ---- 
> [23661.587104]   lock(sysfs_mutex); [23661.587105]
> local_irq_disable(); [23661.587106]
> lock(&delayed_node->mutex); [23661.587107]
> lock(&found->groups_sem); [23661.587108]   <Interrupt> 
> [23661.587109]     lock(&delayed_node->mutex); [23661.587110] 
> [23661.587110]  *** DEADLOCK *** [23661.587110] [23661.587111] 2
> locks held by kswapd0/42: [23661.587112]  #0:
> (shrinker_rwsem){++++..}, at: [<ffffffff8114d0ec>]
> shrink_slab+0x3c/0x3a0 [23661.587117]  #1:
> (&type->s_umount_key#31){+++++.}, at: [<ffffffff811a43d4>]
> grab_super_passive+0x44/0x90 [23661.587122] [23661.587122] the
> shortest dependencies between 2nd lock and 1st lock: [23661.587126]
> -> (sysfs_mutex){+.+.+.} ops: 12918522 { [23661.587129]
> HARDIRQ-ON-W at: [23661.587130]
> [<ffffffff81099900>] __lock_acquire+0x670/0x1e40 [23661.587133]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587134]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587137]
> [<ffffffff8121f1b6>] sysfs_mount+0x166/0x210 [23661.587140]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587142]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587144]
> [<ffffffff811c2509>] kern_mount_data+0x19/0x30 [23661.587145]
> [<ffffffff81f16082>] sysfs_init+0x55/0xb5 [23661.587148]
> [<ffffffff81f13435>] mnt_init+0xcd/0x1d8 [23661.587149]
> [<ffffffff81f130d7>] vfs_caches_init+0x99/0x11c [23661.587151]
> [<ffffffff81eebe1e>] start_kernel+0x3ab/0x40c [23661.587154]
> [<ffffffff81eeb579>] x86_64_start_reservations+0x2a/0x2c 
> [23661.587155]                         [<ffffffff81eeb672>] 
> x86_64_start_kernel+0xf7/0xfb [23661.587157]      SOFTIRQ-ON-W at: 
> [23661.587158]                         [<ffffffff8109993c>] 
> __lock_acquire+0x6ac/0x1e40 [23661.587160]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587162]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587164]
> [<ffffffff8121f1b6>] sysfs_mount+0x166/0x210 [23661.587166]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587167]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587169]
> [<ffffffff811c2509>] kern_mount_data+0x19/0x30 [23661.587171]
> [<ffffffff81f16082>] sysfs_init+0x55/0xb5 [23661.587173]
> [<ffffffff81f13435>] mnt_init+0xcd/0x1d8 [23661.587174]
> [<ffffffff81f130d7>] vfs_caches_init+0x99/0x11c [23661.587175]
> [<ffffffff81eebe1e>] start_kernel+0x3ab/0x40c [23661.587177]
> [<ffffffff81eeb579>] x86_64_start_reservations+0x2a/0x2c 
> [23661.587178]                         [<ffffffff81eeb672>] 
> x86_64_start_kernel+0xf7/0xfb [23661.587180]      RECLAIM_FS-ON-W
> at: [23661.587181]                            [<ffffffff8109c039>] 
> mark_held_locks+0xb9/0x140 [23661.587183]
> [<ffffffff8109c7c5>] lockdep_trace_alloc+0x65/0xd0 [23661.587185]
> [<ffffffff8118e7e3>] kmem_cache_alloc+0x33/0x1e0 [23661.587187]
> [<ffffffff811bcc51>] alloc_inode+0x61/0xa0 [23661.587190]
> [<ffffffff811be178>] iget_locked+0xd8/0x1d0 [23661.587192]
> [<ffffffff8121b54a>] sysfs_get_inode+0x1a/0x170 [23661.587193]
> [<ffffffff8121f1c5>] sysfs_mount+0x175/0x210 [23661.587195]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587196]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587198]
> [<ffffffff811c4d49>] do_mount+0x259/0xb70 [23661.587199]
> [<ffffffff811c594e>] SyS_mount+0x8e/0xe0 [23661.587201]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587204]
> INITIAL USE at: [23661.587204]
> [<ffffffff810995bd>] __lock_acquire+0x32d/0x1e40 [23661.587206]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587207]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587209]
> [<ffffffff8121f1b6>] sysfs_mount+0x166/0x210 [23661.587211]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587212]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587213]
> [<ffffffff811c2509>] kern_mount_data+0x19/0x30 [23661.587215]
> [<ffffffff81f16082>] sysfs_init+0x55/0xb5 [23661.587216]
> [<ffffffff81f13435>] mnt_init+0xcd/0x1d8 [23661.587217]
> [<ffffffff81f130d7>] vfs_caches_init+0x99/0x11c [23661.587218]
> [<ffffffff81eebe1e>] start_kernel+0x3ab/0x40c [23661.587220]
> [<ffffffff81eeb579>] x86_64_start_reservations+0x2a/0x2c 
> [23661.587221]                        [<ffffffff81eeb672>] 
> x86_64_start_kernel+0xf7/0xfb [23661.587222]    } [23661.587223]
> ... key      at: [<ffffffff81c79918>] sysfs_mutex+0x78/0xc0 
> [23661.587226]    ... acquired at: [23661.587227]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587228]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587230]
> [<ffffffff8121defe>] sysfs_addrm_start+0x1e/0x20 [23661.587232]
> [<ffffffff8121e59a>] sysfs_remove+0x1a/0x40 [23661.587233]
> [<ffffffff8121e6c3>] sysfs_remove_dir+0x53/0x80 [23661.587234]
> [<ffffffff81361d11>] kobject_del+0x21/0x50 [23661.587237]
> [<ffffffffa030b060>] btrfs_remove_block_group+0x420/0x540 [btrfs] 
> [23661.587246]    [<ffffffffa034087b>] 
> btrfs_relocate_chunk.isra.61+0x60b/0x760 [btrfs] [23661.587254]
> [<ffffffffa034497f>] btrfs_balance+0x86f/0xfd0 [btrfs] 
> [23661.587262]    [<ffffffffa034cb45>]
> btrfs_ioctl_balance+0x1c5/0x530 [btrfs] [23661.587269]
> [<ffffffffa034fcfc>] btrfs_ioctl+0x68c/0x28a0 [btrfs] 
> [23661.587276]    [<ffffffff811b4938>] do_vfs_ioctl+0x88/0x570 
> [23661.587278]    [<ffffffff811b4eb1>] SyS_ioctl+0x91/0xb0 
> [23661.587279]    [<ffffffff81703212>]
> system_call_fastpath+0x16/0x1b [23661.587281] [23661.587282]  ->
> (&found->groups_sem){++++..} ops: 897759 { [23661.587284]
> HARDIRQ-ON-W at: [23661.587285]
> [<ffffffff81099900>] __lock_acquire+0x670/0x1e40 [23661.587287]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587288]
> [<ffffffff816f8a81>] down_write+0x61/0xc0 [23661.587290]
> [<ffffffffa0306004>] __link_block_group+0x44/0x100 [btrfs] 
> [23661.587295]                       [<ffffffffa0309bf6>] 
> btrfs_read_block_groups+0x306/0x650 [btrfs] [23661.587301]
> [<ffffffffa0318376>] open_ctree+0x1676/0x2070 [btrfs] 
> [23661.587308]                       [<ffffffffa02ede54>] 
> btrfs_mount+0x6b4/0x910 [btrfs] [23661.587312]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587313]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587315]
> [<ffffffff811c4d49>] do_mount+0x259/0xb70 [23661.587316]
> [<ffffffff811c594e>] SyS_mount+0x8e/0xe0 [23661.587318]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587320]
> HARDIRQ-ON-R at: [23661.587320]
> [<ffffffff810997bd>] __lock_acquire+0x52d/0x1e40 [23661.587322]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587323]
> [<ffffffff816f8b31>] down_read+0x51/0xa0 [23661.587325]
> [<ffffffffa0314098>] 
> btrfs_calc_num_tolerated_disk_barrier_failures+0x118/0x1e0 [btrfs] 
> [23661.587331]                       [<ffffffffa0318386>] 
> open_ctree+0x1686/0x2070 [btrfs] [23661.587337]
> [<ffffffffa02ede54>] btrfs_mount+0x6b4/0x910 [btrfs] [23661.587341]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587342]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587344]
> [<ffffffff811c4d49>] do_mount+0x259/0xb70 [23661.587345]
> [<ffffffff811c594e>] SyS_mount+0x8e/0xe0 [23661.587346]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587348]
> SOFTIRQ-ON-W at: [23661.587349]
> [<ffffffff8109993c>] __lock_acquire+0x6ac/0x1e40 [23661.587350]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587352]
> [<ffffffff816f8a81>] down_write+0x61/0xc0 [23661.587353]
> [<ffffffffa0306004>] __link_block_group+0x44/0x100 [btrfs] 
> [23661.587359]                       [<ffffffffa0309bf6>] 
> btrfs_read_block_groups+0x306/0x650 [btrfs] [23661.587364]
> [<ffffffffa0318376>] open_ctree+0x1676/0x2070 [btrfs] 
> [23661.587370]                       [<ffffffffa02ede54>] 
> btrfs_mount+0x6b4/0x910 [btrfs] [23661.587374]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587375]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587376]
> [<ffffffff811c4d49>] do_mount+0x259/0xb70 [23661.587378]
> [<ffffffff811c594e>] SyS_mount+0x8e/0xe0 [23661.587379]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587381]
> SOFTIRQ-ON-R at: [23661.587382]
> [<ffffffff8109993c>] __lock_acquire+0x6ac/0x1e40 [23661.587383]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587384]
> [<ffffffff816f8b31>] down_read+0x51/0xa0 [23661.587386]
> [<ffffffffa0314098>] 
> btrfs_calc_num_tolerated_disk_barrier_failures+0x118/0x1e0 [btrfs] 
> [23661.587392]                       [<ffffffffa0318386>] 
> open_ctree+0x1686/0x2070 [btrfs] [23661.587397]
> [<ffffffffa02ede54>] btrfs_mount+0x6b4/0x910 [btrfs] [23661.587401]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587402]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587404]
> [<ffffffff811c4d49>] do_mount+0x259/0xb70 [23661.587405]
> [<ffffffff811c594e>] SyS_mount+0x8e/0xe0 [23661.587406]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587408]
> INITIAL USE at: [23661.587409]
> [<ffffffff810995bd>] __lock_acquire+0x32d/0x1e40 [23661.587410]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587412]
> [<ffffffff816f8a81>] down_write+0x61/0xc0 [23661.587413]
> [<ffffffffa0306004>] __link_block_group+0x44/0x100 [btrfs] 
> [23661.587418]                      [<ffffffffa0309bf6>] 
> btrfs_read_block_groups+0x306/0x650 [btrfs] [23661.587424]
> [<ffffffffa0318376>] open_ctree+0x1676/0x2070 [btrfs] 
> [23661.587429]                      [<ffffffffa02ede54>] 
> btrfs_mount+0x6b4/0x910 [btrfs] [23661.587433]
> [<ffffffff811a4d53>] mount_fs+0x43/0x1b0 [23661.587435]
> [<ffffffff811c2403>] vfs_kern_mount+0x73/0x160 [23661.587436]
> [<ffffffff811c4d49>] do_mount+0x259/0xb70 [23661.587437]
> [<ffffffff811c594e>] SyS_mount+0x8e/0xe0 [23661.587439]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587441]
> } [23661.587441]   ... key      at: [<ffffffffa03b5ab8>] 
> __key.40358+0x0/0xfffffffffffe2548 [btrfs] [23661.587447]   ...
> acquired at: [23661.587448]    [<ffffffff8109b6e5>]
> lock_acquire+0x85/0x110 [23661.587449]    [<ffffffff816f8b31>]
> down_read+0x51/0xa0 [23661.587451]    [<ffffffffa0306891>]
> find_free_extent+0x7d1/0xc30 [btrfs] [23661.587456]
> [<ffffffffa0306d98>] btrfs_reserve_extent+0xa8/0x140 [btrfs] 
> [23661.587461]    [<ffffffffa0308236>]
> btrfs_alloc_free_block+0xe6/0x460 [btrfs] [23661.587467]
> [<ffffffffa02f6d30>] split_leaf+0x1b0/0x770 [btrfs] [23661.587471]
> [<ffffffffa02f7f23>] btrfs_search_slot+0x963/0x9e0 [btrfs] 
> [23661.587476]    [<ffffffffa02f9658>] 
> btrfs_insert_empty_items+0x78/0xd0 [btrfs] [23661.587481]
> [<ffffffffa036db37>] btrfs_insert_delayed_items+0x87/0x420 [btrfs] 
> [23661.587489]    [<ffffffffa036e8c2>] 
> btrfs_async_run_delayed_root+0xf2/0x200 [btrfs] [23661.587496]
> [<ffffffffa0349fc7>] normal_work_helper+0x137/0x2c0 [btrfs] 
> [23661.587503]    [<ffffffff810681f5>]
> process_one_work+0x1f5/0x530 [23661.587505]    [<ffffffff810689dc>]
> worker_thread+0x11c/0x370 [23661.587506]    [<ffffffff810703c6>]
> kthread+0xf6/0x110 [23661.587508]    [<ffffffff8170316c>]
> ret_from_fork+0x7c/0xb0 [23661.587510] [23661.587510] ->
> (&delayed_node->mutex){+.+.-.} ops: 5556073 { [23661.587513]
> HARDIRQ-ON-W at: [23661.587514]
> [<ffffffff81099900>] __lock_acquire+0x670/0x1e40 [23661.587515]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587516]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587518]
> [<ffffffffa036f7bf>] btrfs_delayed_update_inode+0x4f/0x500 [btrfs] 
> [23661.587525]                     [<ffffffffa0321107>] 
> btrfs_update_inode+0x67/0xf0 [btrfs] [23661.587532]
> [<ffffffffa03293a2>] btrfs_mkdir+0x182/0x1e0 [btrfs] [23661.587539]
> [<ffffffff811b03ca>] vfs_mkdir+0xca/0x170 [23661.587541]
> [<ffffffff811b2a8b>] SyS_mkdir+0xab/0xf0 [23661.587542]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587544]
> SOFTIRQ-ON-W at: [23661.587544]
> [<ffffffff8109993c>] __lock_acquire+0x6ac/0x1e40 [23661.587546]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587547]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587549]
> [<ffffffffa036f7bf>] btrfs_delayed_update_inode+0x4f/0x500 [btrfs] 
> [23661.587556]                     [<ffffffffa0321107>] 
> btrfs_update_inode+0x67/0xf0 [btrfs] [23661.587562]
> [<ffffffffa03293a2>] btrfs_mkdir+0x182/0x1e0 [btrfs] [23661.587568]
> [<ffffffff811b03ca>] vfs_mkdir+0xca/0x170 [23661.587570]
> [<ffffffff811b2a8b>] SyS_mkdir+0xab/0xf0 [23661.587571]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587573]
> IN-RECLAIM_FS-W at: [23661.587574]
> [<ffffffff81099838>] __lock_acquire+0x5a8/0x1e40 [23661.587575]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587577]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587578]
> [<ffffffffa036d73c>] __btrfs_release_delayed_node+0x4c/0x1f0
> [btrfs] [23661.587585]                        [<ffffffffa036ed04>] 
> btrfs_remove_delayed_node+0x24/0x30 [btrfs] [23661.587592]
> [<ffffffffa032650d>] btrfs_evict_inode+0x1cd/0x520 [btrfs] 
> [23661.587599]                        [<ffffffff811bdd17>]
> evict+0xa7/0x1a0 [23661.587601]
> [<ffffffff811bde4e>] dispose_list+0x3e/0x60 [23661.587602]
> [<ffffffff811bed3c>] prune_icache_sb+0x4c/0x60 [23661.587604]
> [<ffffffff811a4641>] super_cache_scan+0x111/0x170 [23661.587605]
> [<ffffffff8114d28a>] shrink_slab+0x1da/0x3a0 [23661.587608]
> [<ffffffff81150905>] balance_pgdat+0x3d5/0x5e0 [23661.587609]
> [<ffffffff81150cba>] kswapd+0x1aa/0x4a0 [23661.587610]
> [<ffffffff810703c6>] kthread+0xf6/0x110 [23661.587611]
> [<ffffffff8170316c>] ret_from_fork+0x7c/0xb0 [23661.587613]
> INITIAL USE at: [23661.587614]
> [<ffffffff810995bd>] __lock_acquire+0x32d/0x1e40 [23661.587615]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587617]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587618]
> [<ffffffffa036f7bf>] btrfs_delayed_update_inode+0x4f/0x500 [btrfs] 
> [23661.587625]                    [<ffffffffa0321107>] 
> btrfs_update_inode+0x67/0xf0 [btrfs] [23661.587631]
> [<ffffffffa03293a2>] btrfs_mkdir+0x182/0x1e0 [btrfs] [23661.587638]
> [<ffffffff811b03ca>] vfs_mkdir+0xca/0x170 [23661.587640]
> [<ffffffff811b2a8b>] SyS_mkdir+0xab/0xf0 [23661.587641]
> [<ffffffff81703212>] system_call_fastpath+0x16/0x1b [23661.587643]
> } [23661.587643]  ... key      at: [<ffffffffa03b9a88>] 
> __key.35650+0x0/0xfffffffffffde578 [btrfs] [23661.587649]  ...
> acquired at: [23661.587649]    [<ffffffff810988f6>]
> check_usage_forwards+0x146/0x150 [23661.587651]
> [<ffffffff81099156>] mark_lock+0x186/0x2c0 [23661.587652]
> [<ffffffff81099838>] __lock_acquire+0x5a8/0x1e40 [23661.587653]
> [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 [23661.587655]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587656]
> [<ffffffffa036d73c>] __btrfs_release_delayed_node+0x4c/0x1f0
> [btrfs] [23661.587663]    [<ffffffffa036ed04>] 
> btrfs_remove_delayed_node+0x24/0x30 [btrfs] [23661.587670]
> [<ffffffffa032650d>] btrfs_evict_inode+0x1cd/0x520 [btrfs] 
> [23661.587676]    [<ffffffff811bdd17>] evict+0xa7/0x1a0 
> [23661.587678]    [<ffffffff811bde4e>] dispose_list+0x3e/0x60 
> [23661.587679]    [<ffffffff811bed3c>] prune_icache_sb+0x4c/0x60 
> [23661.587681]    [<ffffffff811a4641>]
> super_cache_scan+0x111/0x170 [23661.587682]    [<ffffffff8114d28a>]
> shrink_slab+0x1da/0x3a0 [23661.587684]    [<ffffffff81150905>]
> balance_pgdat+0x3d5/0x5e0 [23661.587685]    [<ffffffff81150cba>]
> kswapd+0x1aa/0x4a0 [23661.587686]    [<ffffffff810703c6>]
> kthread+0xf6/0x110 [23661.587687]    [<ffffffff8170316c>]
> ret_from_fork+0x7c/0xb0 [23661.587689] [23661.587690] 
> [23661.587690] stack backtrace: [23661.587692] CPU: 1 PID: 42 Comm:
> kswapd0 Not tainted 3.13.0-fdm-btrfs-next-24+ #7 [23661.587693]
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011 [23661.587694]
> ffffffff825db980 ffff8801f5e176a8 ffffffff816f1da6 
> 0000000000000007 [23661.587696]  ffffffff825db980 ffff8801f5e176f8
> ffffffff816ed6b8 ffffffff825db980 [23661.587698]  ffff880213f2ac40
> ffff8801f5e1770c 0000000000000000 ffff880213f2ac40 [23661.587700]
> Call Trace: [23661.587702]  [<ffffffff816f1da6>]
> dump_stack+0x4e/0x68 [23661.587705]  [<ffffffff816ed6b8>]
> print_irq_inversion_bug.part.38+0x1b0/0x1bf [23661.587706]
> [<ffffffff810988f6>] check_usage_forwards+0x146/0x150 
> [23661.587708]  [<ffffffff810987b0>] ?
> check_usage_backwards+0x150/0x150 [23661.587710]
> [<ffffffff81099156>] mark_lock+0x186/0x2c0 [23661.587711]
> [<ffffffff81099838>] __lock_acquire+0x5a8/0x1e40 [23661.587713]
> [<ffffffff81095b87>] ? __bfs+0x157/0x250 [23661.587714]
> [<ffffffff8109631b>] ? 
> add_lock_to_list.isra.26.constprop.42+0x7b/0xc0 [23661.587716]
> [<ffffffff8109a5ed>] ? __lock_acquire+0x135d/0x1e40 [23661.587718]
> [<ffffffff816fa94f>] ? _raw_spin_unlock_irqrestore+0x3f/0x70 
> [23661.587719]  [<ffffffff8109b6e5>] lock_acquire+0x85/0x110 
> [23661.587726]  [<ffffffffa036d73c>] ? 
> __btrfs_release_delayed_node+0x4c/0x1f0 [btrfs] [23661.587729]
> [<ffffffff816f7f36>] mutex_lock_nested+0x76/0x390 [23661.587735]
> [<ffffffffa036d73c>] ? __btrfs_release_delayed_node+0x4c/0x1f0
> [btrfs] [23661.587737]  [<ffffffff81095d08>] ?
> trace_hardirqs_off_caller+0x28/0xd0 [23661.587744]
> [<ffffffffa036d73c>] ? __btrfs_release_delayed_node+0x4c/0x1f0
> [btrfs] [23661.587747]  [<ffffffff81082dff>] ?
> local_clock+0x4f/0x60 [23661.587754]  [<ffffffffa036d73c>] 
> __btrfs_release_delayed_node+0x4c/0x1f0 [btrfs] [23661.587761]
> [<ffffffffa036ed04>] btrfs_remove_delayed_node+0x24/0x30 [btrfs] 
> [23661.587767]  [<ffffffffa032650d>] btrfs_evict_inode+0x1cd/0x520
> [btrfs] [23661.587769]  [<ffffffff816fa9ab>] ?
> _raw_spin_unlock+0x2b/0x40 [23661.587771]  [<ffffffff811bdd17>]
> evict+0xa7/0x1a0 [23661.587773]  [<ffffffff811bde4e>]
> dispose_list+0x3e/0x60 [23661.587775]  [<ffffffff811bed3c>]
> prune_icache_sb+0x4c/0x60 [23661.587776]  [<ffffffff811a4641>]
> super_cache_scan+0x111/0x170 [23661.587778]  [<ffffffff8114d28a>]
> shrink_slab+0x1da/0x3a0 [23661.587780]  [<ffffffff81150905>]
> balance_pgdat+0x3d5/0x5e0 [23661.587782]  [<ffffffff81150cba>]
> kswapd+0x1aa/0x4a0 [23661.587784]  [<ffffffff8108e8e0>] ?
> bit_waitqueue+0xc0/0xc0 [23661.587785]  [<ffffffff81150b10>] ?
> balance_pgdat+0x5e0/0x5e0 [23661.587787]  [<ffffffff810703c6>]
> kthread+0xf6/0x110 [23661.587788]  [<ffffffff810702d0>] ?
> kthread_create_on_node+0x250/0x250 [23661.587790]
> [<ffffffff8170316c>] ret_from_fork+0x7c/0xb0 [23661.587792]
> [<ffffffff810702d0>] ? kthread_create_on_node+0x250/0x250
> 
> 
> 
>> --- fs/btrfs/extent-tree.c |   10 +++++++--- 1 file changed, 7
>> insertions(+), 3 deletions(-)
>> 
>> --- a/fs/btrfs/extent-tree.c +++ b/fs/btrfs/extent-tree.c @@
>> -8343,9 +8343,15 @@ static void __link_block_group(struct bt 
>> struct btrfs_block_group_cache *cache) { int index =
>> get_block_group_index(cache); +       bool first = false;
>> 
>> down_write(&space_info->groups_sem); -       if
>> (list_empty(&space_info->block_groups[index])) { +       if
>> (list_empty(&space_info->block_groups[index])) +
>> first = true; +       list_add_tail(&cache->list,
>> &space_info->block_groups[index]); +
>> up_write(&space_info->groups_sem); + +       if (first) { struct
>> kobject *kobj = &space_info->block_group_kobjs[index]; int ret;
>> 
>> @@ -8357,8 +8363,6 @@ static void __link_block_group(struct bt 
>> kobject_put(&space_info->kobj); } } -
>> list_add_tail(&cache->list, &space_info->block_groups[index]); -
>> up_write(&space_info->groups_sem); }
>> 
>> static struct btrfs_block_group_cache *
>> 
>> 
>> -- Jeff Mahoney SUSE Labs -- To unsubscribe from this list: send
>> the line "unsubscribe linux-btrfs" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
> 
> 
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJTRboIAAoJEB57S2MheeWy0U0P/1nMgFth1JGNSDKjibLiOExu
hfsQdaFHeJqtXvwwWsVaz11kEylMRIDCbhHNEYP6sfjRL95LneVJ2LJEXWYQN4a0
i66jfMQsx8H8Qo5NBPAci2El6G03WZrOgZMpyRyJI4i/w28P0mKwse9km7aoLHev
emQm6OvuCO4b+IL6NxUh+4pXiQ+P9R/UMmYhJ5S7fglF1FVGY4mRO9ZCEGOgJfcr
D+UpnrD2KJxSn3FmWlWcX9P/hyrWh5LJOYNz3ZvcCjx/Soe0QW4uk+0gKjHHRpjo
kt6XHncBCuQaAv31axzNZ+C19QlcttUXwAXvasBHZ64JiEyCJ7tg02drkusQwGLN
sjO/4JNu87Zk/N1nmNvSc1DmwuLkRQYFIEyeMiD6hNv9GQi1eJMn/00bNZlq/1bC
h9ED3s1u/ruzEAaBYmjGtboiRH9V/pvNJ7lg+p4THy3mjmUYnsqKTE9dURArPhzA
3q+rgtxDgnOIXowgjmqvwyPWYW9FEgRDQfhNUAoz/2yKMXhp4wPjuLezkdUJ47Tn
0zBPCaJmzW9NeCSsddzdmwN8WVCQh90SwWhTyAzy5czDPJFE0wgHpMX/kHejSrqz
svQnSwXruyyOY5dsOvCzLBSNfFJpbY+LqBmX3V6bCiUmf8duM9N1zWLJe7QQVkbg
TWE7CIMt2Vh+KLRsTDNy
=34Is
-----END PGP SIGNATURE-----
