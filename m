From: David Sterba <dave@jikos.cz>
Subject: Lockdep warning during snapshot deletion in 3.2-rc7+
Date: Thu, 5 Jan 2012 17:18:33 +0100
Message-ID: <20120105161833.GO7322@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I saw the following lockep message in syslog, with v3.2-rc7-83-g115e8e7

[ 9612.860677] btrfs: unlinked 1 orphans
<about 50 times repeated>
[ 8241.264764] btrfs: truncated 1 orphans
<interleaved with about 10 such messages>
[ 9758.530822] ======================================================
[ 9758.532018] [ INFO: possible circular locking dependency detected ]
[ 9758.532018] 3.2.0-rc7-default+ #94
[ 9758.544811] -------------------------------------------------------
[ 9758.544811] btrfs/13767 is trying to acquire lock:
[ 9758.544811]  (&fs_info->subvol_sem){++++..}, at: [<ffffffffa0065d8c>] btrfs_ioctl_snap_destroy+0x20c/0x4c0 [btrfs]
[ 9758.544811]
[ 9758.544811] but task is already holding lock:
[ 9758.544811]  (&sb->s_type->i_mutex_key#16){+.+.+.}, at: [<ffffffffa0065d62>] btrfs_ioctl_snap_destroy+0x1e2/0x4c0 [btrfs]
[ 9758.544811]
[ 9758.544811] which lock already depends on the new lock.
[ 9758.544811]
[ 9758.544811]
[ 9758.544811] the existing dependency chain (in reverse order) is:
[ 9758.544811]
[ 9758.544811] -> #1 (&sb->s_type->i_mutex_key#16){+.+.+.}:
[ 9758.544811]        [<ffffffff810915d4>] lock_acquire+0x94/0x130
[ 9758.544811]        [<ffffffff8187c387>] mutex_lock_nested+0x77/0x380
[ 9758.544811]        [<ffffffffa0042da7>] btrfs_orphan_cleanup+0x2a7/0x4e0 [btrfs]
[ 9758.544811]        [<ffffffffa0066956>] btrfs_mksubvol+0x306/0x360 [btrfs]
[ 9758.544811]        [<ffffffffa0066ab0>] btrfs_ioctl_snap_create_transid+0x100/0x160 [btrfs]
[ 9758.544811]        [<ffffffffa0066c8d>] btrfs_ioctl_snap_create_v2.clone.0+0xfd/0x110 [btrfs]
[ 9758.544811]        [<ffffffffa0068598>] btrfs_ioctl+0x588/0x1080 [btrfs]
[ 9758.544811]        [<ffffffff8114d5d8>] do_vfs_ioctl+0x98/0x560
[ 9758.544811]        [<ffffffff8114daef>] sys_ioctl+0x4f/0x80
[ 9758.544811]        [<ffffffff81887ac2>] system_call_fastpath+0x16/0x1b
[ 9758.544811]
[ 9758.544811] -> #0 (&fs_info->subvol_sem){++++..}:
[ 9758.544811]        [<ffffffff810909a6>] __lock_acquire+0x18f6/0x1e90
[ 9758.544811]        [<ffffffff810915d4>] lock_acquire+0x94/0x130
[ 9758.544811]        [<ffffffff8187d6fc>] down_write+0x5c/0xb0
[ 9758.544811]        [<ffffffffa0065d8c>] btrfs_ioctl_snap_destroy+0x20c/0x4c0 [btrfs]
[ 9758.544811]        [<ffffffffa0068466>] btrfs_ioctl+0x456/0x1080 [btrfs]
[ 9758.544811]        [<ffffffff8114d5d8>] do_vfs_ioctl+0x98/0x560
[ 9758.544811]        [<ffffffff8114daef>] sys_ioctl+0x4f/0x80
[ 9758.544811]        [<ffffffff81887ac2>] system_call_fastpath+0x16/0x1b
[ 9758.544811]
[ 9758.544811] other info that might help us debug this:
[ 9758.544811]
[ 9758.544811]  Possible unsafe locking scenario:
[ 9758.544811]
[ 9758.544811]        CPU0                    CPU1
[ 9758.544811]        ----                    ----
[ 9758.544811]   lock(&sb->s_type->i_mutex_key);
[ 9758.544811]                                lock(&fs_info->subvol_sem);
[ 9758.544811]                                lock(&sb->s_type->i_mutex_key);
[ 9758.544811]   lock(&fs_info->subvol_sem);
[ 9758.544811]
[ 9758.544811]  *** DEADLOCK ***
[ 9758.544811]
[ 9758.544811] 2 locks held by btrfs/13767:
[ 9758.544811]  #0:  (&sb->s_type->i_mutex_key#16/1){+.+.+.}, at: [<ffffffffa0065c70>] btrfs_ioctl_snap_destroy+0xf0/0x4c0 [btrfs]
[ 9758.544811]  #1:  (&sb->s_type->i_mutex_key#16){+.+.+.}, at: [<ffffffffa0065d62>] btrfs_ioctl_snap_destroy+0x1e2/0x4c0 [btrfs]
[ 9758.544811]
[ 9758.544811] stack backtrace:
[ 9758.544811] Pid: 13767, comm: btrfs Not tainted 3.2.0-rc7-default+ #94
[ 9758.544811] Call Trace:
[ 9758.544811]  [<ffffffff8108dbf0>] print_circular_bug+0x210/0x2f0
[ 9758.544811]  [<ffffffff810909a6>] __lock_acquire+0x18f6/0x1e90
[ 9758.544811]  [<ffffffff8108bb5d>] ? lock_release_holdtime+0x3d/0x1c0
[ 9758.544811]  [<ffffffff81009c65>] ? native_sched_clock+0x15/0x80
[ 9758.544811]  [<ffffffffa0065d8c>] ? btrfs_ioctl_snap_destroy+0x20c/0x4c0 [btrfs]
[ 9758.544811]  [<ffffffff810915d4>] lock_acquire+0x94/0x130
[ 9758.544811]  [<ffffffffa0065d8c>] ? btrfs_ioctl_snap_destroy+0x20c/0x4c0 [btrfs]
[ 9758.544811]  [<ffffffff81152a61>] ? d_invalidate+0x81/0xa0
[ 9758.544811]  [<ffffffff8187d6fc>] down_write+0x5c/0xb0
[ 9758.544811]  [<ffffffffa0065d8c>] ? btrfs_ioctl_snap_destroy+0x20c/0x4c0 [btrfs]
[ 9758.544811]  [<ffffffffa0065d8c>] btrfs_ioctl_snap_destroy+0x20c/0x4c0 [btrfs]
[ 9758.544811]  [<ffffffffa0068466>] btrfs_ioctl+0x456/0x1080 [btrfs]
[ 9758.544811]  [<ffffffff818832c0>] ? do_page_fault+0x2d0/0x580
[ 9758.544811]  [<ffffffff8107e5df>] ? local_clock+0x6f/0x80
[ 9758.544811]  [<ffffffff8114d5d8>] do_vfs_ioctl+0x98/0x560
[ 9758.544811]  [<ffffffff8187f7d9>] ? retint_swapgs+0x13/0x1b
[ 9758.544811]  [<ffffffff8114daef>] sys_ioctl+0x4f/0x80
[ 9758.544811]  [<ffffffff81887ac2>] system_call_fastpath+0x16/0x1b


there were about 2000 snapshots created during subtrans-tester (as described
here http://www.spinics.net/lists/linux-btrfs/msg13931.html / a)
and deleted in parallel
(command: btrfs subvol list .|awk '{print $7}'|parallel --jobs 16 btrfs subvol del)

There were a blocked processes for a few minutes but then finished and
all snapshots were deleted, no process left blocked

root     14706  0.0  0.0   8488   644 pts/1    D+   16:02   0:00 btrfs subvol del snap924
root     14707  0.0  0.0   8488   644 pts/1    D+   16:02   0:00 btrfs subvol del snap925
root     14710  0.0  0.0   8488   644 pts/1    D+   16:02   0:00 btrfs subvol del snap928
root     14711  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap929
root     14712  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap930
root     14713  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap931
root     14714  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap932
root     14715  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap933
root     14716  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap934
root     14718  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap935
root     14719  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap936
root     14720  0.0  0.0   8484   540 pts/1    D+   16:02   0:00 btrfs subvol del snap937
root     14721  0.0  0.0   8484   540 pts/1    D+   16:02   0:00 btrfs subvol del snap938
root     14722  0.0  0.0   8484   536 pts/1    D+   16:02   0:00 btrfs subvol del snap939

so it may be a false alert after all.


david
