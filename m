From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [BUG] sleeping function called from atomic context
Date: Fri, 04 May 2012 17:20:16 +0200
Message-ID: <4FA3F3B0.6020902@giantdisaster.de>
References: <4FA3AD0B.7040500@giantdisaster.de> <20120504132536.GA25477@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120504132536.GA25477@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 5/4/2012 3:25 PM, Chris Mason wrote:
> On Fri, May 04, 2012 at 12:18:51PM +0200, Stefan Behrens wrote:
>> Looks like after "btrfs read error corrected" of chunk tree block while
>> reading the chunk tree in open_ctree(), we stay in atomic state (in
>> 3.4-rc5).
> 
> I'm having a hard time reproducing this here.  Do you have lockdep on?
> It might tell us which lock we're leaving around.

Next two tries with lockdep and with a reboot before the mount. For the
first one I was using dd(1) to damage (overwite) one mirror of the chunk
tree and the issue was there immediately. The second time with some
writes to the disk in degraded state and a remount with all disks
afterwards. This time umount was raising the issue.

And as Dave wrote, SLUB checks whether someone is in atomic state and
calls kmem_cache_alloc() with __GFP_WAIT. I see no reason for being in
atomic state at this point, that's the issue.


BUG: sleeping function called from invalid context at mm/slub.c:937
in_atomic(): 1, irqs_disabled(): 0, pid: 3650, name: mount
2 locks held by mount/3650:
 #0:  (&type->s_umount_key#32/1){+.+.+.}, at: [<ffffffff811909c8>]
sget+0x248/0x540
 #1:  (btrfs-fs-03){++++..}, at: [<ffffffffa010ea12>]
btrfs_clear_lock_blocking_rw+0x62/0x160 [btrfs]
Pid: 3650, comm: mount Not tainted 3.3.0+ #58
Call Trace:
 [<ffffffff810af591>] __might_sleep+0xe1/0x110
 [<ffffffff811895bd>] kmem_cache_alloc+0x4d/0x160
 [<ffffffffa00f86bb>] alloc_extent_state+0x2b/0xf0 [btrfs]
 [<ffffffffa00fa8d7>] __set_extent_bit+0x357/0x590 [btrfs]
 [<ffffffff810d594d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffffa00fab7c>] lock_extent_bits+0x6c/0xa0 [btrfs]
 [<ffffffffa00ce964>] verify_parent_transid+0x84/0x160 [btrfs]
 [<ffffffffa00cea86>] btrfs_buffer_uptodate+0x46/0x60 [btrfs]
 [<ffffffffa00b42ad>] read_block_for_search+0x14d/0x3b0 [btrfs]
 [<ffffffffa00b243d>] ? generic_bin_search+0xfd/0x180 [btrfs]
 [<ffffffffa00b9404>] btrfs_search_slot+0x2f4/0x8c0 [btrfs]
 [<ffffffffa00cd2ba>] btrfs_lookup_inode+0x2a/0xa0 [btrfs]
 [<ffffffffa00df81c>] btrfs_iget+0x10c/0x4c0 [btrfs]
 [<ffffffffa00b2190>] btrfs_mount+0x490/0x530 [btrfs]
 [<ffffffff8190b669>] ? mutex_unlock+0x9/0x10
 [<ffffffff81160b19>] ? pcpu_alloc+0x399/0xa00
 [<ffffffff8119061e>] mount_fs+0x3e/0x1a0
 [<ffffffff811ab316>] ? alloc_vfsmnt+0xb6/0x1b0
 [<ffffffff811ac0db>] vfs_kern_mount+0x5b/0xe0
 [<ffffffff811ac96d>] do_kern_mount+0x4d/0x110
 [<ffffffff813dc063>] ? security_capable+0x13/0x20
 [<ffffffff811ae2fd>] do_mount+0x24d/0x7c0
 [<ffffffff8115bee6>] ? memdup_user+0x46/0x90
 [<ffffffff8115bf83>] ? strndup_user+0x53/0x70
 [<ffffffff811ae8fb>] sys_mount+0x8b/0xe0
 [<ffffffff81916262>] system_call_fastpath+0x16/0x1b
parent transid verify failed on 29798400 wanted 30 found 27
parent transid verify failed on 29798400 wanted 30 found 27
btrfs read error corrected: ino 1 off 29798400 (dev /dev/sdw sector 41816)
parent transid verify failed on 30085120 wanted 30 found 27
parent transid verify failed on 30085120 wanted 30 found 27
btrfs read error corrected: ino 1 off 30085120 (dev /dev/sdw sector 42376)
parent transid verify failed on 30867456 wanted 30 found 27
parent transid verify failed on 30867456 wanted 30 found 27
btrfs read error corrected: ino 1 off 30867456 (dev /dev/sdw sector 43904)

(gdb) info line *btrfs_clear_lock_blocking_rw+0x62
Line 95 of "/root/git/btrfs/arch/x86/include/asm/atomic.h"
   starts at address 0x64a12 <btrfs_clear_lock_blocking_rw+98>
   and ends at 0x64a19 <btrfs_clear_lock_blocking_rw+105>.
That's inside the definition of atomic_inc(). Doesn't make sense.
static inline void atomic_inc(atomic_t *v)
{
        asm volatile(LOCK_PREFIX "incl %0"
                     : "+m" (v->counter));
}

(gdb) info line *sget+0x248
Line 173 of "fs/super.c" starts at address 0xffffffff811909c8 <sget+584>
   and ends at 0xffffffff811909dd <sget+605>.
That's in the middle of alloc_super(). Looks messy. Not helpful.
                mutex_init(&s->s_vfs_rename_mutex);


Then I was retrying once more:

btrfs: disk space caching is enabled
Btrfs detected SSD devices, enabling SSD mode
BUG: sleeping function called from invalid context at mm/slub.c:937
in_atomic(): 1, irqs_disabled(): 0, pid: 3626, name: umount
6 locks held by umount/3626:
 #0:  (&type->s_umount_key#33){+++++.}, at: [<ffffffff8119113d>]
deactivate_super+0x3d/0x60
 #1:  (&fs_info->reloc_mutex){+.+...}, at: [<ffffffffa00d724a>]
btrfs_commit_transaction+0x50a/0xaa0 [btrfs]
 #2:  (&fs_info->tree_log_mutex){+.+...}, at: [<ffffffffa00d72c4>]
btrfs_commit_transaction+0x584/0xaa0 [btrfs]
 #3:  (&head_ref->mutex){+.+...}, at: [<ffffffffa011d153>]
btrfs_delayed_ref_lock+0x43/0x130 [btrfs]
 #4:  (btrfs-extent-02){++++..}, at: [<ffffffffa010ea9f>]
btrfs_clear_lock_blocking_rw+0xef/0x160 [btrfs]
 #5:  (btrfs-extent-01){++++..}, at: [<ffffffffa010ea9f>]
btrfs_clear_lock_blocking_rw+0xef/0x160 [btrfs]
Pid: 3626, comm: umount Not tainted 3.3.0+ #58
Call Trace:
 [<ffffffff810af591>] __might_sleep+0xe1/0x110
 [<ffffffff811895bd>] kmem_cache_alloc+0x4d/0x160
 [<ffffffffa00f86bb>] alloc_extent_state+0x2b/0xf0 [btrfs]
 [<ffffffffa00fa8d7>] __set_extent_bit+0x357/0x590 [btrfs]
 [<ffffffff810d594d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffffa00fab7c>] lock_extent_bits+0x6c/0xa0 [btrfs]
 [<ffffffffa00ce964>] verify_parent_transid+0x84/0x160 [btrfs]
 [<ffffffffa00cea86>] btrfs_buffer_uptodate+0x46/0x60 [btrfs]
 [<ffffffffa00b42ad>] read_block_for_search+0x14d/0x3b0 [btrfs]
 [<ffffffffa00b243d>] ? generic_bin_search+0xfd/0x180 [btrfs]
 [<ffffffffa00b9404>] btrfs_search_slot+0x2f4/0x8c0 [btrfs]
 [<ffffffff810db9fd>] ? lock_release_non_nested+0x19d/0x390
 [<ffffffffa00c61c9>] ? run_clustered_refs+0xd9/0xa00 [btrfs]
 [<ffffffffa00ba464>] btrfs_insert_empty_items+0x84/0xe0 [btrfs]
 [<ffffffff8118964d>] ? kmem_cache_alloc+0xdd/0x160
 [<ffffffffa00c64c5>] run_clustered_refs+0x3d5/0xa00 [btrfs]
 [<ffffffffa00c6b8f>] ? btrfs_run_delayed_refs+0x9f/0x4e0 [btrfs]
 [<ffffffffa00c6b8f>] ? btrfs_run_delayed_refs+0x9f/0x4e0 [btrfs]
 [<ffffffffa00c6c6c>] btrfs_run_delayed_refs+0x17c/0x4e0 [btrfs]
 [<ffffffffa00f8a92>] ? release_extent_buffer+0x32/0xb0 [btrfs]
 [<ffffffff8190e716>] ? _raw_spin_unlock+0x26/0x40
 [<ffffffffa00f8a92>] ? release_extent_buffer+0x32/0xb0 [btrfs]
 [<ffffffffa00d6231>] commit_cowonly_roots+0xa1/0x1e0 [btrfs]
 [<ffffffffa00d731b>] btrfs_commit_transaction+0x5db/0xaa0 [btrfs]
 [<ffffffffa00d7b88>] ? start_transaction+0x88/0x330 [btrfs]
 [<ffffffff810a3ab0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa00b0661>] btrfs_sync_fs+0x61/0xe0 [btrfs]
 [<ffffffff811bb81e>] __sync_filesystem+0x5e/0x90
 [<ffffffff811bb923>] sync_filesystem+0x43/0x60
 [<ffffffff8118fd86>] generic_shutdown_super+0x36/0xf0
 [<ffffffff8118fed1>] kill_anon_super+0x11/0x20
 [<ffffffffa00b1c85>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119113d>] ? deactivate_super+0x3d/0x60
 [<ffffffff811903c5>] deactivate_locked_super+0x45/0x70
 [<ffffffff81191145>] deactivate_super+0x45/0x60
 [<ffffffff811ac4a2>] mntput_no_expire+0xd2/0x120
 [<ffffffff811acaa6>] sys_umount+0x76/0x3c0
 [<ffffffff81916262>] system_call_fastpath+0x16/0x1b
parent transid verify failed on 64811008 wanted 39 found 8
parent transid verify failed on 64811008 wanted 39 found 8
btrfs read error corrected: ino 1 off 64811008 (dev /dev/sdw sector 110200)
parent transid verify failed on 36839424 wanted 42 found 8
parent transid verify failed on 36839424 wanted 42 found 8
btrfs read error corrected: ino 1 off 36839424 (dev /dev/sdw sector 55568)
parent transid verify failed on 38449152 wanted 40 found 8
parent transid verify failed on 38449152 wanted 40 found 8
btrfs read error corrected: ino 1 off 38449152 (dev /dev/sdw sector 58712)
parent transid verify failed on 73908224 wanted 39 found 8
parent transid verify failed on 73908224 wanted 39 found 8
btrfs read error corrected: ino 1 off 73908224 (dev /dev/sdw sector 127968)
parent transid verify failed on 38780928 wanted 40 found 8
parent transid verify failed on 38780928 wanted 40 found 8
btrfs read error corrected: ino 1 off 38780928 (dev /dev/sdw sector 59360)
btrfs read error corrected: ino 1 off 38793216 (dev /dev/sdw sector 59384)
btrfs read error corrected: ino 1 off 69025792 (dev /dev/sdw sector 118432)
btrfs read error corrected: ino 1 off 69033984 (dev /dev/sdw sector 118448)
btrfs read error corrected: ino 1 off 38440960 (dev /dev/sdw sector 58696)
btrfs read error corrected: ino 1 off 38940672 (dev /dev/sdw sector 59672)
btrfs read error corrected: ino 1 off 42262528 (dev /dev/sdw sector 66160)
btrfs read error corrected: ino 1 off 73924608 (dev /dev/sdw sector 128000)
btrfs bad tree block start 2742074651274362994 202395648
btrfs read error corrected: ino 1 off 202395648 (dev /dev/sdw sector 378920)
btrfs read error corrected: ino 1 off 69042176 (dev /dev/sdw sector 118464)
