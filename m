From: Shaohua Li <shaohua.li@intel.com>
Subject: [patch 0/2]btrfs: add two ioctls to do metadata readahead
Date: Wed, 14 Jul 2010 16:02:16 +0800
Message-ID: <1279094536.1528.93.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0msKN+coPHHlNCzNGMaj"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-0msKN+coPHHlNCzNGMaj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,
  We have file readahead to do asyn file read, but has no metadata
readahead. For a list of files, their metadata is stored in fragmented
disk space and metadata read is a sync operation, which impacts the
efficiency of readahead much. The patches try to add meatadata readahead
for btrfs.
  In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
the inode to a fd so we could use existing syscalls (readahead, mincore
or upcoming fincore) to do readahead, but the inode is hidden, there is
no easy way for this from my understanding. So we add two ioctls for
this. One is like readahead syscall, the other is like micore/fincore
syscall.
  Under a harddisk based netbook with Meego, the metadata readahead
reduced about 3.5s boot time from total 16s.

Issues:
1. it appears readahead metadata pages skipped checksum checking. I'm
still working on this.
2. in latest kernel, I got a lockdep warning. It looks not related to
the patches but I only observed it with the patches. The warning looks
like a false warning, as in my debug the spin_lock isn't hold. from my
understanding, all extent_buffer share a lockdep class and in the btree
lookup we might lock several extent_buffer. But I don't know how to fix
it yet.

Thanks,
Shaohua

--=-0msKN+coPHHlNCzNGMaj
Content-Disposition: attachment; filename="log"
Content-Type: text/plain; name="log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[   88.260743] =============================================
[   88.262016] [ INFO: possible recursive locking detected ]
[   88.262669] 2.6.35-rc5-dirty #776
[   88.263298] ---------------------------------------------
[   88.263956] ra/714 is trying to acquire lock:
[   88.264515]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa004b9a4>] btrfs_try_spin_lock+0xa2/0x116 [btrfs]
[   88.264515]
[   88.264515] but task is already holding lock:
[   88.264515]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa004b8f9>] btrfs_clear_lock_blocking+0x20/0x29 [btrfs]
[   88.264515]
[   88.264515] other info that might help us debug this:
[   88.264515] 2 locks held by ra/714:
[   88.264515]  #0:  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff81137e64>] do_lookup+0xac/0x20c
[   88.264515]  #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa004b8f9>] btrfs_clear_lock_blocking+0x20/0x29 [btrfs]
[   88.264515]
[   88.264515] stack backtrace:
[   88.264515] Pid: 714, comm: ra Not tainted 2.6.35-rc5-dirty #776
[   88.264515] Call Trace:
[   88.264515]  [<ffffffff8109afc5>] __lock_acquire+0x153f/0x15d8
[   88.264515]  [<ffffffff81097769>] ? trace_hardirqs_off_caller+0x16/0x99
[   88.264515]  [<ffffffff8106bed9>] ? release_console_sem+0x1b5/0x1e6
[   88.264515]  [<ffffffff8174b3a7>] ? sub_preempt_count+0xe/0xb7
[   88.264515]  [<ffffffff8106c4f2>] ? vprintk+0x37e/0x3c2
[   88.264515]  [<ffffffffa004b9a4>] ? btrfs_try_spin_lock+0xa2/0x116 [btrfs]
[   88.264515]  [<ffffffff8109b1a6>] lock_acquire+0x148/0x18d
[   88.264515]  [<ffffffffa004b9a4>] ? btrfs_try_spin_lock+0xa2/0x116 [btrfs]
[   88.264515]  [<ffffffff81747798>] _raw_spin_lock+0x3b/0x4a
[   88.264515]  [<ffffffffa004b9a4>] ? btrfs_try_spin_lock+0xa2/0x116 [btrfs]
[   88.264515]  [<ffffffffa004b9a4>] btrfs_try_spin_lock+0xa2/0x116 [btrfs]
[   88.264515]  [<ffffffffa000a2f9>] btrfs_search_slot+0x78d/0x921 [btrfs]
[   88.264515]  [<ffffffffa000cd73>] ? __find_space_info+0x0/0xfb [btrfs]
[   88.264515]  [<ffffffffa001a7ff>] btrfs_lookup_inode+0x2f/0x8f [btrfs]
[   88.264515]  [<ffffffffa0028f67>] btrfs_iget+0xc3/0x418 [btrfs]
[   88.264515]  [<ffffffffa002b892>] btrfs_lookup_dentry+0x12f/0x3ff [btrfs]
[   88.264515]  [<ffffffff81141b03>] ? d_alloc+0x181/0x1d4
[   88.264515]  [<ffffffffa002bb78>] btrfs_lookup+0x16/0x2e [btrfs]
[   88.264515]  [<ffffffff81137eb4>] do_lookup+0xfc/0x20c
[   88.264515]  [<ffffffff8113960e>] do_last+0x1a1/0x5c0
[   88.264515]  [<ffffffff8113b6d6>] do_filp_open+0x1d2/0x5ed
[   88.264515]  [<ffffffff8114575f>] ? alloc_fd+0x3b/0x18e
[   88.264515]  [<ffffffff8174b43c>] ? sub_preempt_count+0xa3/0xb7
[   88.264515]  [<ffffffff81748073>] ? _raw_spin_unlock+0x35/0x52
[   88.264515]  [<ffffffff811458a0>] ? alloc_fd+0x17c/0x18e
[   88.264515]  [<ffffffff8112d113>] do_sys_open+0x63/0x116
[   88.264515]  [<ffffffff8112d1f9>] sys_open+0x20/0x22
[   88.264515]  [<ffffffff81031c1b>] system_call_fastpath+0x16/0x1b

--=-0msKN+coPHHlNCzNGMaj--

