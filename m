From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: high CPU usage and low perf
Date: Tue, 27 Sep 2011 10:15:09 +0100
Message-ID: <20110927091509.GA4149@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,


Recently,

a btrfs file system of mine started to behave very poorly with
some btrfs kernel tasks taking 100% of CPU time.

# btrfs fi show /dev/sdb
Label: none  uuid: b3ce8b16-970e-4ba8-b9d2-4c7de270d0f1
        Total devices 3 FS bytes used 4.25TB
        devid    2 size 2.73TB used 1.52TB path /dev/sdc
        devid    1 size 2.70TB used 1.49TB path /dev/sda4
        devid    3 size 2.73TB used 1.52TB path /dev/sdb

Btrfs v0.19-100-g4964d65

FS mounted with compress-force,noatime

(Can't do a "filesystem df" just now, as there's a umount
running, there should be around 33% free).

Kernel 3.0, with patch:
http://www.spinics.net/lists/linux-btrfs/msg11023.html

While the FS is running, I see for instance btrfs-transacti
taking 100% CPU and iostat shows no disk activity. Writing
performance is dreadful (a few kB/s).

sysrq-t gives:

btrfs-transacti R  running task        0   963      2 0x00000000
 ffff880143af7730 ffffffff00000001 ffffffffffffff10 ffff880143af77b0
 ffff8801456da420 ffffffffffffffff 00000000e86aa840 0000000000001000
 00000000ffffffe4 ffff8801462ba800 ffff880109f9b540 000088002a95eba8
Call Trace:
 [<ffffffffa032765e>] ? tree_search_offset+0x18f/0x1b8 [btrfs]
 [<ffffffffa02eb745>] ? btrfs_reserve_extent+0xb0/0x190 [btrfs]
 [<ffffffffa02ebdfc>] ? btrfs_alloc_free_block+0x22e/0x349 [btrfs]
 [<ffffffffa02dea3d>] ? __btrfs_cow_block+0x102/0x31e [btrfs]
 [<ffffffffa02ebdfc>] ? btrfs_alloc_free_block+0x22e/0x349 [btrfs]
 [<ffffffffa02dea3d>] ? __btrfs_cow_block+0x102/0x31e [btrfs]
 [<ffffffffa02dd400>] ? btrfs_set_node_key+0x1a/0x20 [btrfs]
 [<ffffffffa02ded5d>] ? btrfs_cow_block+0x104/0x14e [btrfs]
 [<ffffffffa02e1c34>] ? btrfs_search_slot+0x162/0x4cb [btrfs]
 [<ffffffffa02e2ea3>] ? btrfs_insert_empty_items+0x6a/0xba [btrfs]
 [<ffffffffa02e9bf3>] ? run_clustered_refs+0x370/0x682 [btrfs]
 [<ffffffffa032d201>] ? btrfs_find_ref_cluster+0xd/0x13c [btrfs]
 [<ffffffffa02e9fd6>] ? btrfs_run_delayed_refs+0xd1/0x17c [btrfs]
 [<ffffffffa02f8467>] ? btrfs_commit_transaction+0x38f/0x709 [btrfs]
 [<ffffffff8136f6e6>] ? _raw_spin_lock+0xe/0x10
 [<ffffffffa02f79fe>] ? join_transaction.clone.23+0xc1/0x200 [btrfs]
 [<ffffffff81068ffb>] ? wake_up_bit+0x2a/0x2a
 [<ffffffffa02f28fd>] ? transaction_kthread+0x175/0x22a [btrfs]
 [<ffffffffa02f2788>] ? btrfs_congested_fn+0x86/0x86 [btrfs]
 [<ffffffff81068b2c>] ? kthread+0x82/0x8a
 [<ffffffff81376124>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81068aaa>] ? kthread_worker_fn+0x14c/0x14c
 [<ffffffff81376120>] ? gs_change+0x13/0x13

After a while, with no FS activity, it does calm down though.

umount has already used over 10 minutes of CPU time:
# ps -flC umount
F S UID        PID  PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
4 R root      6045  1853 65  80   0 -  2538 -      09:46 pts/2    00:11:06 umount /backup

sysrq-t gives:

[515954.295050] umount          R  running task        0  6045   1853 0x00000000
[515954.295050]  ffff88011131c600 ffffffff00000001 ffffffff811cb1ee ffff88012c2fd598
[515954.295050]  ffff8801456da420 0000000000001000 0000000000008800 ffff8801456da420
[515954.295050]  ffff88012c2fd578 ffffffffa0327d96 ffff880111bebb60 0000000000001000
[515954.295050] Call Trace:
[515954.295050]  [<ffffffffa032765e>] ? tree_search_offset+0x18f/0x1b8 [btrfs]
[515954.295050]  [<ffffffff8103ce8e>] ? need_resched+0x23/0x2d
[515954.295050]  [<ffffffff81103ccd>] ? kmem_cache_alloc+0x94/0x105
[515954.295050]  [<ffffffffa0329ff7>] ? btrfs_find_space_cluster+0xce/0x189 [btrfs]
[515954.295050]  [<ffffffffa02eaaa0>] ? find_free_extent.clone.64+0x549/0x8c7 [btrfs]
[515954.295050]  [<ffffffffa032765e>] ? tree_search_offset+0x18f/0x1b8 [btrfs]
[515954.295050]  [<ffffffffa02eb745>] ? btrfs_reserve_extent+0xb0/0x190 [btrfs]
[515954.295050]  [<ffffffffa02ebdfc>] ? btrfs_alloc_free_block+0x22e/0x349 [btrfs]
[515954.295050]  [<ffffffffa02dea3d>] ? __btrfs_cow_block+0x102/0x31e [btrfs]
[515954.295050]  [<ffffffffa02ebdfc>] ? btrfs_alloc_free_block+0x22e/0x349 [btrfs]
[515954.295050]  [<ffffffffa02dea3d>] ? __btrfs_cow_block+0x102/0x31e [btrfs]
[515954.295050]  [<ffffffffa02e5312>] ? lookup_inline_extent_backref+0xa5/0x328 [btrfs]
[515954.295050]  [<ffffffffa02e76ef>] ? __btrfs_free_extent+0xc3/0x55b [btrfs]
[515954.295050]  [<ffffffff8110480f>] ? kfree+0x72/0x7b
[515954.295050]  [<ffffffffa032d19d>] ? btrfs_delayed_ref_lock+0x4a/0xa1 [btrfs]
[515954.295050]  [<ffffffffa02e9ebb>] ? run_clustered_refs+0x638/0x682 [btrfs]
[515954.295050]  [<ffffffffa032d200>] ? btrfs_find_ref_cluster+0xc/0x13c [btrfs]
[515954.295050]  [<ffffffffa02e9fd6>] ? btrfs_run_delayed_refs+0xd1/0x17c [btrfs]
[515954.295050]  [<ffffffffa02f710d>] ? commit_cowonly_roots+0x78/0x18f [btrfs]
[515954.295050]  [<ffffffff8103ce8e>] ? need_resched+0x23/0x2d
[515954.295050]  [<ffffffff8103cea6>] ? should_resched+0xe/0x2e
[515954.295050]  [<ffffffffa02f84d7>] ? btrfs_commit_transaction+0x3ff/0x709 [btrfs]
[515954.295050]  [<ffffffff8136f6e6>] ? _raw_spin_lock+0xe/0x10
[515954.295050]  [<ffffffffa02f7b07>] ? join_transaction.clone.23+0x1ca/0x200 [btrfs]
[515954.295050]  [<ffffffff81068ffb>] ? wake_up_bit+0x2a/0x2a
[515954.295050]  [<ffffffffa02dc45b>] ? btrfs_sync_fs+0x9f/0xa7 [btrfs]
[515954.295050]  [<ffffffff81135ba8>] ? __sync_filesystem+0x66/0x7a
[515954.295050]  [<ffffffff81135c20>] ? sync_filesystem+0x4c/0x50
[515954.295050]  [<ffffffff811151d8>] ? generic_shutdown_super+0x38/0xf6
[515954.295050]  [<ffffffff81115316>] ? kill_anon_super+0x16/0x50
[515954.295050]  [<ffffffff81115540>] ? deactivate_locked_super+0x26/0x4b
[515954.295050]  [<ffffffff81115d5d>] ? deactivate_super+0x3a/0x3e
[515954.295050]  [<ffffffff8112b368>] ? mntput_no_expire+0xd0/0xd5
[515954.295050]  [<ffffffff8112c06f>] ? sys_umount+0x2ee/0x31c
[515954.295050]  [<ffffffff81375002>] ? system_call_fastpath+0x16/0x1b

Last time it happened, I hard rebooted the system, and it was
fine for a while. This time, I'll try and let umount finish.

Would anybody know what is happening and how to get out of it?

Thanks.
Stephane
