From: Dave Chinner <david@fromorbit.com>
Subject: [BUG 3.0-rc1] oops during file removal, severe lock contention
Date: Thu, 2 Jun 2011 11:11:39 +1000
Message-ID: <20110602011139.GP561@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Folks,

Running on 3.0-rc1 on an 8p/4G RAM VM with a 16TB filesystem (12
disk DM stripe) a 50 million inode 8-way fsmark creation workload
via:

$ /usr/bin/time ./fs_mark -D 10000 -S0 -n 100000 -s 0 -L 63 \
> -d /mnt/scratch/0 -d /mnt/scratch/1 \
> -d /mnt/scratch/2 -d /mnt/scratch/3 \
> -d /mnt/scratch/4 -d /mnt/scratch/5 \
> -d /mnt/scratch/6 -d /mnt/scratch/7

followed by an 8-way rm -rf on the result via:

$ for i in /mnt/scratch/*; do /usr/bin/time rm -rf $i 2>&1 & done

resulted in this oops:

[ 2671.052861] device fsid 84f7a99b2f193c6-c3228aae4c5a2f8a devid 1 transid 7 /dev/vda
[ 8626.879250] BUG: unable to handle kernel paging request at ffff880120000000
[ 8626.880020] IP: [<ffffffff81659a43>] chksum_update+0x23/0x50
[ 8626.880020] PGD 1ef2063 PUD 11fffa067 PMD 0
[ 8626.880020] Oops: 0000 [#1] SMP
[ 8626.880020] CPU 5
[ 8626.880020] Modules linked in:
[ 8626.880020]
[ 8626.880020] Pid: 3326, comm: btrfs-transacti Not tainted 3.0.0-rc1-dgc+ #1272 Bochs Bochs
[ 8626.880020] RIP: 0010:[<ffffffff81659a43>]  [<ffffffff81659a43>] chksum_update+0x23/0x50
[ 8626.880020] RSP: 0018:ffff88010fba7a30  EFLAGS: 00010283
[ 8626.880020] RAX: 000000002dda3ac0 RBX: ffff88010fba7a50 RCX: ffff880120000001
[ 8626.880020] RDX: 000000000000009d RSI: ffff880120000000 RDI: ffff88010fba7a50
[ 8626.880020] RBP: ffff88010fba7a30 R08: ffff880217846000 R09: 0000000000001025
[ 8626.880020] R10: ffff88011affe0c0 R11: dead000000200200 R12: ffff88010fba7bd0
[ 8626.880020] R13: ffff880117846025 R14: 0000000000000000 R15: 0000000000000001
[ 8626.880020] FS:  0000000000000000(0000) GS:ffff88011fd40000(0000) knlGS:0000000000000000
[ 8626.880020] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8626.880020] CR2: ffff880120000000 CR3: 0000000001ef1000 CR4: 00000000000006e0
[ 8626.880020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8626.880020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8626.880020] Process btrfs-transacti (pid: 3326, threadinfo ffff88010fba6000, task ffff88011affe0c0)
[ 8626.880020] Stack:
[ 8626.880020]  ffff88010fba7a40 ffffffff81651688 ffff88010fba7a90 ffffffff81688967
[ 8626.880020]  ffff880119b065c0 0000000800000000 ffff8801ffffffff 0000005005818de0
[ 8626.880020]  ffff88010fba7bd0 ffff880105818de0 ffff88010fba7aa0 ffff8800cc6c63a0
[ 8626.880020] Call Trace:
[ 8626.880020]  [<ffffffff81651688>] crypto_shash_update+0x18/0x30
[ 8626.880020]  [<ffffffff81688967>] crc32c+0x47/0x60
[ 8626.880020]  [<ffffffff8159d5e2>] btrfs_csum_data+0x12/0x20
[ 8626.880020]  [<ffffffff815df671>] __btrfs_write_out_cache+0x601/0xc70
[ 8626.880020]  [<ffffffff815abdc6>] ? __btrfs_prealloc_file_range+0x196/0x220
[ 8626.880020]  [<ffffffff81aff90e>] ? _raw_spin_lock+0xe/0x20
[ 8626.880020]  [<ffffffff815dfd42>] btrfs_write_out_ino_cache+0x62/0xb0
[ 8626.880020]  [<ffffffff8159b33e>] btrfs_save_ino_cache+0x11e/0x210
[ 8626.880020]  [<ffffffff815a291d>] commit_fs_roots+0xad/0x180
[ 8626.880020]  [<ffffffff81afe77e>] ? mutex_lock+0x1e/0x50
[ 8626.880020]  [<ffffffff8158056a>] ? btrfs_free_path+0x2a/0x40
[ 8626.880020]  [<ffffffff815a3855>] btrfs_commit_transaction+0x375/0x7b0
[ 8626.880020]  [<ffffffff810a40e0>] ? wake_up_bit+0x40/0x40
[ 8626.880020]  [<ffffffff8159cf63>] transaction_kthread+0x293/0x2b0
[ 8626.880020]  [<ffffffff8159ccd0>] ? btrfs_bio_wq_end_io+0x90/0x90
[ 8626.880020]  [<ffffffff810a3b96>] kthread+0x96/0xa0
[ 8626.880020]  [<ffffffff81b08724>] kernel_thread_helper+0x4/0x10
[ 8626.880020]  [<ffffffff810a3b00>] ? kthread_worker_fn+0x190/0x190
[ 8626.880020]  [<ffffffff81b08720>] ? gs_change+0x13/0x13
[ 8626.880020] Code: ea ff ff ff c9 c3 66 90 55 48 89 e5 66 66 66 66 90 8b 47 10 85 d2 74 2d 48 8d 4e 01 44 8d 42 ff 4e 8d 04 01 eb 05 66 90 48 ff c1 <0f> b6 16 48 89
[ 8626.880020] RIP  [<ffffffff81659a43>] chksum_update+0x23/0x50
[ 8626.880020]  RSP <ffff88010fba7a30>
[ 8626.880020] CR2: ffff880120000000
[ 8626.880020] ---[ end trace dad2f8b74a28cc71 ]---

Also, there is massive lock contention while running these workloads.
perf top shows this for the create after about 5m inodes have been
created:

           samples  pcnt function                      DSO
             _______ _____ _____________________________ _________________

            20626.00 25.6% __ticket_spin_lock            [kernel.kallsyms]
             5148.00  6.4% _raw_spin_unlock_irqrestore   [kernel.kallsyms]
             3769.00  4.7% test_range_bit                [kernel.kallsyms]
             2239.00  2.8% chksum_update                 [kernel.kallsyms]
             2143.00  2.7% finish_task_switch            [kernel.kallsyms]
             1912.00  2.4% inode_tree_add                [kernel.kallsyms]
             1825.00  2.3% radix_tree_lookup             [kernel.kallsyms]
             1449.00  1.8% generic_bin_search            [kernel.kallsyms]
             1205.00  1.5% btrfs_search_slot             [kernel.kallsyms]
             1198.00  1.5% btrfs_tree_lock               [kernel.kallsyms]
             1104.00  1.4% mutex_spin_on_owner           [kernel.kallsyms]
             1023.00  1.3% kmem_cache_alloc              [kernel.kallsyms]
             1016.00  1.3% map_private_extent_buffer     [kernel.kallsyms]
              931.00  1.2% verify_parent_transid         [kernel.kallsyms]
              895.00  1.1% find_extent_buffer            [kernel.kallsyms]
              785.00  1.0% kmem_cache_free               [kernel.kallsyms]
              778.00  1.0% memmove                       [kernel.kallsyms]
              745.00  0.9% __d_lookup_rcu                [kernel.kallsyms]
              697.00  0.9% mark_page_accessed            [kernel.kallsyms]
              638.00  0.8% btrfs_try_spin_lock           [kernel.kallsyms]
              600.00  0.7% map_extent_buffer             [kernel.kallsyms]
              570.00  0.7% btrfs_item_offset             [kernel.kallsyms]
              539.00  0.7% __memcpy                      [kernel.kallsyms]
              507.00  0.6% __ticket_spin_unlock          [kernel.kallsyms]
              500.00  0.6% link_path_walk                [kernel.kallsyms]
              457.00  0.6% __do_softirq                  [kernel.kallsyms]
              442.00  0.5% __d_lookup                    [kernel.kallsyms]
              438.00  0.5% free_extent_buffer            [kernel.kallsyms]
              430.00  0.5% block_group_cache_tree_search [kernel.kallsyms]
              428.00  0.5% pvclock_clocksource_read      [kernel.kallsyms]

By 10 million inodes:

            25928.00 32.0% __ticket_spin_lock            [kernel.kallsyms]
             3715.00  4.6% test_range_bit                [kernel.kallsyms]
             3681.00  4.5% _raw_spin_unlock_irqrestore   [kernel.kallsyms]

And it kept getting worse all the way to 50m inodes where
__ticket_spin_lock was taking ~60% of the CPU time. While the
unlinking was running, I was seeing similar levels of lock
contention. 

FYI, performance on this create workload my test box is roughly 45k
creates/s for btrfs, 75k creates/s for ext4 and 110k create/s for
XFS. btrfs is without doubt being slowed down by the lock contention
problems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
