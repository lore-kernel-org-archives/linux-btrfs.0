From: David Sterba <dave@jikos.cz>
Subject: Re: Lockdep warning in btrfs_clear_lock_blocking
Date: Tue, 17 May 2011 15:09:29 +0200
Message-ID: <20110517130929.GT12709@twin.jikos.cz>
References: <20110510124447.GP12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110510124447.GP12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

another lockdep warning, very similar to the previous. happened during
xfstests/224

d/

[344121.276299] =============================================
[344121.284642] [ INFO: possible recursive locking detected ]
[344121.286331] 2.6.39-rc7-default+ #22
[344121.286331] ---------------------------------------------
[344121.286331] dd/2159 is trying to acquire lock:
[344121.286331]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0198b3c>] btrfs_try_spin_lock+0x7c/0xa0 [btrfs]
[344121.286331]
[344121.286331] but task is already holding lock:
[344121.286331]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0198ab2>] btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[344121.340024]
[344121.340024] other info that might help us debug this:
[344121.340024] 1 lock held by dd/2159:
[344121.340024]  #0:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0198ab2>] btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[344121.340024]
[344121.340024] stack backtrace:
[344121.340024] Pid: 2159, comm: dd Tainted: G        W   2.6.39-rc7-default+ #22
[344121.340024] Call Trace:
[344121.340024]  [<ffffffff810d14fb>] __lock_acquire+0x159b/0x1de0
[344121.340024]  [<ffffffff810ccc19>] ? trace_hardirqs_off_caller+0x29/0xc0
[344121.340024]  [<ffffffff810bfd1f>] ? local_clock+0x6f/0x80
[344121.340024]  [<ffffffffa0198a86>] ? btrfs_set_lock_blocking+0x26/0x30 [btrfs]
[344121.340024]  [<ffffffff810ccc19>] ? trace_hardirqs_off_caller+0x29/0xc0
[344121.340024]  [<ffffffff810d23bf>] lock_acquire+0x9f/0x130
[344121.340024]  [<ffffffffa0198b3c>] ? btrfs_try_spin_lock+0x7c/0xa0 [btrfs]
[344121.340024]  [<ffffffff81e8be16>] _raw_spin_lock+0x36/0x70
[344121.340024]  [<ffffffffa0198b3c>] ? btrfs_try_spin_lock+0x7c/0xa0 [btrfs]
[344121.340024]  [<ffffffffa0198ab2>] ? btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[344121.340024]  [<ffffffffa0198b3c>] btrfs_try_spin_lock+0x7c/0xa0 [btrfs]
[344121.340024]  [<ffffffffa0147df3>] btrfs_search_slot+0x3c3/0xaa0 [btrfs]
[344121.340024]  [<ffffffff810cccbd>] ? trace_hardirqs_off+0xd/0x10
[344121.340024]  [<ffffffffa015ae1d>] btrfs_lookup_csum+0x6d/0x170 [btrfs]
[344121.340024]  [<ffffffffa015b0d3>] __btrfs_lookup_bio_sums+0x1b3/0x380 [btrfs]
[344121.340024]  [<ffffffff81170cc5>] ? kmem_cache_alloc_trace+0xf5/0x180
[344121.340024]  [<ffffffffa015b314>] btrfs_lookup_bio_sums_dio+0x14/0x20 [btrfs]
[344121.340024]  [<ffffffffa0168e22>] btrfs_submit_direct+0x202/0x640 [btrfs]
[344121.340024]  [<ffffffff810cccbd>] ? trace_hardirqs_off+0xd/0x10
[344121.340024]  [<ffffffff810bfd1f>] ? local_clock+0x6f/0x80
[344121.340024]  [<ffffffff811b3ae2>] dio_bio_submit+0x72/0xc0
[344121.340024]  [<ffffffff811b498e>] __blockdev_direct_IO+0x84e/0xb30
[344121.340024]  [<ffffffffa0167092>] btrfs_direct_IO+0x2e2/0x430 [btrfs]
[344121.340024]  [<ffffffffa0169c20>] ? btrfs_get_extent+0x9c0/0x9c0 [btrfs]
[344121.340024]  [<ffffffffa0168c20>] ? uncompress_inline+0x200/0x200 [btrfs]
[344121.340024]  [<ffffffff810442d5>] ? native_sched_clock+0x15/0x70
[344121.340024]  [<ffffffff81134444>] generic_file_aio_read+0x704/0x7a0
[344121.340024]  [<ffffffff81e8c3cb>] ? _raw_spin_unlock+0x2b/0x40
[344121.340024]  [<ffffffff810442d5>] ? native_sched_clock+0x15/0x70
[344121.340024]  [<ffffffff810cccbd>] ? trace_hardirqs_off+0xd/0x10
[344121.340024]  [<ffffffff8117b1ba>] do_sync_read+0xda/0x120
[344121.340024]  [<ffffffff8117b9ab>] vfs_read+0xcb/0x190
[344121.340024]  [<ffffffff8117bac4>] sys_read+0x54/0xa0
[344121.340024]  [<ffffffff81e94e42>] system_call_fastpath+0x16/0x1b

