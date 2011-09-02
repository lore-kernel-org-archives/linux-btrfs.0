From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [BUG] umount command doesn't end forever
Date: Fri, 02 Sep 2011 17:33:57 +0900
Message-ID: <4E6094F5.8000506@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In current for-linus branch, I encountered the problem that the
umount command doesn't end forever.

=================================

# mount
...
/dev/sdc9 on /test9 type btrfs (rw,space_cache,compress=lzo,autodefrag)
# umount /test9


crash> ps | grep umount
  13107   6558   0  ffff8801257296c0  UN   0.0  105132    672  umount
crash> bt 13107
PID: 13107  TASK: ffff8801257296c0  CPU: 0   COMMAND: "umount"
 #0 [ffff88016bb4fce8] schedule at ffffffff813a0c76
 #1 [ffff88016bb4fd90] close_ctree at ffffffffa0386b3c [btrfs]
 #2 [ffff88016bb4fe00] btrfs_put_super at ffffffffa036bc0c [btrfs]
 #3 [ffff88016bb4fe20] generic_shutdown_super at ffffffff8111260e
 #4 [ffff88016bb4fe50] kill_anon_super at ffffffff811126fb
 #5 [ffff88016bb4fe70] deactivate_locked_super at ffffffff81112c9b
 #6 [ffff88016bb4fe90] deactivate_super at ffffffff81113673
 #7 [ffff88016bb4feb0] mntput_no_expire at ffffffff81128973
 #8 [ffff88016bb4fee0] sys_umount at ffffffff811294ee
 #9 [ffff88016bb4ff80] system_call_fastpath at ffffffff813a9182
    RIP: 00007fd8f08cb5d7  RSP: 00007fffe85dea40  RFLAGS: 00010246
    RAX: 00000000000000a6  RBX: ffffffff813a9182  RCX: 0000000000000006
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 00007fd8f17a9b90
    RBP: 00007fd8f17a9b70   R8: 0000000000000005   R9: 0000000000000000
    R10: 00007fffe85df220  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000000  R14: 00007fffe85df688  R15: 00007fd8f17a9c00
    ORIG_RAX: 00000000000000a6  CS: 0033  SS: 002b
crash> ps | grep clean
...
   6610      2   1  ffff8801945ac440  UN   0.0       0      0  [btrfs-cleaner]
crash> bt  6610
PID: 6610   TASK: ffff8801945ac440  CPU: 1   COMMAND: "btrfs-cleaner"
 #0 [ffff880194565958] schedule at ffffffff813a0c76
 #1 [ffff880194565a00] rwsem_down_failed_common at ffffffff813a2453
 #2 [ffff880194565a60] rwsem_down_read_failed at ffffffff813a24ac
 #3 [ffff880194565a70] call_rwsem_down_read_failed at ffffffff811c60d4
 #4 [ffff880194565ad8] writeback_inodes_sb_nr_if_idle at ffffffff8112ee46
 #5 [ffff880194565b08] reserve_metadata_bytes at ffffffffa03772d9 [btrfs]
 #6 [ffff880194565c08] btrfs_delalloc_reserve_metadata at ffffffffa0378196 [btrfs]
 #7 [ffff880194565c58] btrfs_delalloc_reserve_space at ffffffffa037c2ed [btrfs]
 #8 [ffff880194565c88] btrfs_defrag_file at ffffffffa03ad400 [btrfs]
 #9 [ffff880194565dc8] btrfs_run_defrag_inodes at ffffffffa0397125 [btrfs]
#10 [ffff880194565e68] cleaner_kthread at ffffffffa0384844 [btrfs]
#11 [ffff880194565ee8] kthread at ffffffff810608ac
#12 [ffff880194565f48] kernel_thread_helper at ffffffff813aa2a4

=================================

umount acquires down_write(&s->s_umount) by deactivate_super() and
waits for the end of btrfs-cleaner.
But, btrfs-cleaner stops because of the acquisition waiting of
down_read(&sb->s_umount) by writeback_inodes_sb_nr_if_idle().
So, the deadlock has happened, I think.

 -Tsutomu

