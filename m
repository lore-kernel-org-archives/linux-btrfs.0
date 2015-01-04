Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:63844 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbbADU0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 15:26:49 -0500
Received: by mail-la0-f43.google.com with SMTP id s18so17520400lam.16
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 12:26:48 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 4 Jan 2015 15:26:47 -0500
Message-ID: <CALJXSJqF-7KfDJS27ZdYpQWZcr8XOHoFA1LjKJFfXJA2Unnz1w@mail.gmail.com>
Subject: Data recovery after RBD I/O error
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, ceph-users@lists.ceph.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Happy holiday everyone,

TL;DR: Hardware corruption is really bad, if btrfs-restore work,
kernel Btrfs can!

I'm cross-posting this message since the root cause for this problem
is the Ceph RBD device however, my main concern is data loss from a
BTRFS filesystem hosted on this device.

I'm running a file server which is a staging area for rsync backups of
many folders and also a snapshot store which allow me to recover much
faster older files and folders while our backup still is exported to
an EXT4 filesystem using rdiff-backup.

The server is running Debian Wheezy with kernel 3.16 and I already had
corruption on this volume before, I had to copy the whole device and
since we now had a working Ceph cluster, I copied the volume using
«btrfs send» to another BTRFS hosted on a RBD device. The corruption
was not causing any issue for reading however when writing, the volume
would switch read only once upon a time.

First day of new year, I wake up to see the monitoring telling me the
FS on the server has switched to read only. I took a look at dmesg,
and had some I/O errors from the RBD device. I was unable to unmount
it but had full access to the data, so I wanted to reboot to see if
the glitch would dismiss now that I/O errors were gone. After the
reboot, the BTRFS would not mount anymore.


After trying the usual, read only mount, recovery mount, btrfsck
--repair on a snapshot, only btrfs-restore was working. Btrfs-restore
could restore everything but my data was in snapshot, regex was not
working correctly and it didn't restore file attributes
(normal/extended) even with -x, I used btrfs-tools 3.18.

This is what I was getting:
[   31.582823] parent transid verify failed on 308470693888 wanted
91730 found 90755
[   31.584738] parent transid verify failed on 308470693888 wanted
91730 found 90755
[   31.584743] BTRFS: Failed to read block groups: -5

After looking at the code a bit, I did this change to get BTRFS
recovery working and rsync my stuff. I also tried to use btrfs send by
forcing it to use a read/write snapshot since the whole volume is read
only anyway but failed with oopses.

Patch for recovery
---------------------------------------
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0229c37..aed4062 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2798,7 +2798,8 @@ retry_root_backup:
        ret = btrfs_read_block_groups(extent_root);
        if (ret) {
                printk(KERN_ERR "BTRFS: Failed to read block groups:
%d\n", ret);
-               goto fail_sysfs;
+               if (!btrfs_test_opt(tree_root, RECOVERY))
+                       goto fail_sysfs;
        }
        fs_info->num_tolerated_disk_barrier_failures =
                btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
---------------------------------------
Also: http://pastebin.com/YPY3eMMX


Trace when forcing BTRFS send on my R/O volume with R/W subvolume:
------------[ cut here ]------------
WARNING: CPU: 3 PID: 27883 at fs/btrfs/send.c:5533
btrfs_ioctl_send+0x8c9/0xfa0 [btrfs]()
Modules linked in: btrfs(O) ufs qnx4 hfsplus hfs minix ntfs vfat msdos
fat jfs xfs reiserfs vhost_net vhost macvtap macvlan tun
ip6table_filter ip6_tabl
es ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT cbc
rbd libceph xt_CHECKSUM iptable_mangle libcrc32c xt_tcpudp ip
table_filter ip_tables x_tables parport_pc ppdev lp parport ib_iser
rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi nfsd auth_rpcgss
oid_registry n
fs_acl nfs lockd fscache sunrpc bridge fuse ipmi_devintf 8021q garp
stp mrp llc loop iTCO_wdt iTCO_vendor_support ttm drm_kms_helper
pcspkr drm evdev lpc_ich i2c_algo_bit i2c_core mfd_core i7core_edac
processor edac_core button coretemp tpm_tis tpm dcdbas kvm_intel
acpi_power_meter ipmi_si thermal_sys ipmi_msghandler kvm ext4 crc16
mbcache jbd2 dm_mod raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor ra
Jan  2 18:55:43 CASRV0104 kernel: id6_pq raid1 md_mod sg sd_mod
crc_t10dif crct10dif_common mvsas libsas ehci_pci ehci_hcd bnx2
crc32c_intel libata scsi_transport_sas scsi_mod usbcore usb_common
[last
unloaded: btrfs]
CPU: 3 PID: 27883 Comm: btrfs Tainted: G           O
3.16.0-0.bpo.4-amd64 #1 Debian 3.16.7-ckt2-1~bpo70+1
Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS 1.5.2 10/15/2010
 0000000000000000 ffffffffa0a52557 ffffffff81541f8f 0000000000000000
 ffffffff8106cecc ffff8800ba625a00 ffff8803152da000 00007fffa69f7ab0
 ffff880312f2d1e0 ffff8800ba625a00 ffffffffa0a419c9 0000000000000000
Call Trace:
 [<ffffffff81541f8f>] ? dump_stack+0x41/0x51
 [<ffffffff8106cecc>] ? warn_slowpath_common+0x8c/0xc0
 [<ffffffffa0a419c9>] ? btrfs_ioctl_send+0x8c9/0xfa0 [btrfs]
 [<ffffffff811558b5>] ? __alloc_pages_nodemask+0x165/0xbb0
 [<ffffffff811d2411>] ? dput+0x31/0x1a0
 [<ffffffff811a1162>] ? cache_alloc_refill+0x92/0x2e0
 [<ffffffffa0a0c160>] ? btrfs_ioctl+0x1a50/0x2890 [btrfs]
 [<ffffffff8108bb68>] ? alloc_pid+0x1e8/0x4d0
 [<ffffffff8109bfb2>] ? set_task_cpu+0x82/0x1d0
 [<ffffffff812c7f60>] ? cpumask_next_and+0x30/0x40
 [<ffffffff810a45e7>] ? select_task_rq_fair+0x257/0x720
 [<ffffffff810a73cc>] ? enqueue_task_fair+0x25c/0xb50
 [<ffffffff8101e65d>] ? native_sched_clock+0x2d/0x80
 [<ffffffff8101e6b5>] ? sched_clock+0x5/0x10
 [<ffffffff8109bd25>] ? check_preempt_curr+0x75/0xa0
 [<ffffffff8109efe4>] ? wake_up_new_task+0xf4/0x1b0
 [<ffffffff811cdee6>] ? do_vfs_ioctl+0x86/0x4e0
 [<ffffffff8106c0a8>] ? do_fork+0xe8/0x340
 [<ffffffff811ce3e1>] ? SyS_ioctl+0xa1/0xc0
 [<ffffffff815487d9>] ? stub_clone+0x69/0x90
 [<ffffffff8154846d>] ? system_call_fast_compare_end+0x10/0x15
 [<ffffffff8154846d>] ? system_call_fast_compare_end+0x10/0x15
---[ end trace 55c7d8ef829f1bde ]---

My RBD device seemed to have memory allocation issues here are the logs I got:
------------------------------------
kworker/1:1: page allocation failure: order:1, mode:0x204020
CPU: 1 PID: 18314 Comm: kworker/1:1 Not tainted 3.16-0.bpo.3-amd64 #1
Debian 3.16.5-1~bpo70+1
Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS 1.5.2 10/15/2010
Workqueue: rbd0 rbd_request_workfn [rbd]
 0000000000000000 0000000000000001 ffffffff8154144f 0000000000204020
 ffffffff8115176d 0000000000000001 ffff88043ffefc00 0000000000000002
 0000000000000000 0000000000000002 ffff88043ffefc08 0000000000000000
Call Trace:
 [<ffffffff8154144f>] ? dump_stack+0x41/0x51
 [<ffffffff8115176d>] ? warn_alloc_failed+0xfd/0x160
 [<ffffffff81155e00>] ? __alloc_pages_nodemask+0x920/0xba0
 [<ffffffff8119f9c0>] ? kmem_getpages+0x60/0x110
 [<ffffffff811a1208>] ? fallback_alloc+0x158/0x220
 [<ffffffff811a1b04>] ? kmem_cache_alloc+0x1a4/0x1e0
 [<ffffffffa071d889>] ? ceph_osdc_alloc_request+0x69/0x320 [libceph]
 [<ffffffffa074353b>] ? rbd_osd_req_create.isra.17+0x7b/0x190 [rbd]
 [<ffffffffa0745fc5>] ? rbd_img_request_fill+0x2b5/0x900 [rbd]
 [<ffffffffa071bddd>] ? __send_queued+0x14d/0x1d0 [libceph]
 [<ffffffffa0747475>] ? rbd_request_workfn+0x235/0x350 [rbd]
 [<ffffffff8108788c>] ? process_one_work+0x15c/0x450
 [<ffffffff81088ae2>] ? worker_thread+0x112/0x540
 [<ffffffff810889d0>] ? create_and_start_worker+0x60/0x60
 [<ffffffff8108f491>] ? kthread+0xc1/0xe0
 [<ffffffff8108f3d0>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff8154787c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8108f3d0>] ? flush_kthread_worker+0xb0/0xb0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   9
CPU    2: hi:  186, btch:  31 usd: 156
CPU    3: hi:  186, btch:  31 usd:  19
active_anon:1681936 inactive_anon:218757 isolated_anon:0
 active_file:789119 inactive_file:1073537 isolated_file:0
 unevictable:1207 dirty:14295 writeback:695 unstable:0
 free:70084 slab_reclaimable:230032 slab_unreclaimable:19306
 mapped:6243 shmem:818 pagetables:6275 bounce:0
 free_cma:0
Node 0 DMA free:15900kB min:64kB low:80kB high:96kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2971 16055 16055
Node 0 DMA32 free:152992kB min:12496kB low:15620kB high:18744kB
active_anon:752000kB inactive_anon:221080kB active_file:567256kB
inactive_file:1150320kB unevictable:1288kB isolated(anon):0kB
isolated(file):0kB present:3119716kB managed:3045076kB mlocked:1288kB
dirty:5672kB writeback:1320kB mapped:5196kB shmem:692kB
slab_reclaimable:172048kB slab_unreclaimable:11424kB
kernel_stack:2672kB pagetables:4260kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 13083 13083
Node 0 Normal free:111444kB min:55020kB low:68772kB high:82528kB
active_anon:5975744kB inactive_anon:653948kB active_file:2589220kB
inactive_file:3143828kB unevictable:3540kB isolated(anon):0kB
isolated(file):0kB present:13631488kB managed:13397720kB
mlocked:3540kB dirty:51508kB writeback:1460kB mapped:19776kB
shmem:2580kB slab_reclaimable:748080kB slab_unreclaimable:65800kB
kernel_stack:4240kB pagetables:20840kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB
(U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) =
15900kB
Node 0 DMA32: 37682*4kB (UEM) 0*8kB 0*16kB 0*32kB 1*64kB (R) 1*128kB
(R) 1*256kB (R) 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB = 153224kB
Node 0 Normal: 26808*4kB (UE) 5*8kB (U) 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) = 111368kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
1868030 total pagecache pages
3771 pages in swap cache
Swap cache stats: add 2328376, delete 2324605, find 3959025/4761602
Free swap  = 1280kB
Total swap = 974844kB
4191797 pages RAM
0 pages HighMem/MovableOnly
58442 pages reserved
0 pages hwpoisoned
rbd: rbd0: write 1000 at 4972c30000 result -12
end_request: I/O error, dev rbd0, sector 616128896
kworker/1:1: page allocation failure: order:1, mode:0x204020
CPU: 1 PID: 18314 Comm: kworker/1:1 Not tainted 3.16-0.bpo.3-amd64 #1
Debian 3.16.5-1~bpo70+1
Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS 1.5.2 10/15/2010
Workqueue: rbd0 rbd_request_workfn [rbd]
 0000000000000000 0000000000000001 ffffffff8154144f 0000000000204020
 ffffffff8115176d 0000000000000001 ffff88043ffefc00 0000000000000002
 0000000000000000 0000000000000002 ffff88043ffefc08 0000000000000092
Call Trace:
 [<ffffffff8154144f>] ? dump_stack+0x41/0x51
 [<ffffffff8115176d>] ? warn_alloc_failed+0xfd/0x160
 [<ffffffff81155e00>] ? __alloc_pages_nodemask+0x920/0xba0
 [<ffffffff8119f9c0>] ? kmem_getpages+0x60/0x110
 [<ffffffff811a1208>] ? fallback_alloc+0x158/0x220
 [<ffffffff811a1b04>] ? kmem_cache_alloc+0x1a4/0x1e0
 [<ffffffffa071d889>] ? ceph_osdc_alloc_request+0x69/0x320 [libceph]
 [<ffffffffa074353b>] ? rbd_osd_req_create.isra.17+0x7b/0x190 [rbd]
 [<ffffffffa0745fc5>] ? rbd_img_request_fill+0x2b5/0x900 [rbd]
 [<ffffffff813b3922>] ? add_timer_randomness+0xd2/0xe0
 [<ffffffffa0747475>] ? rbd_request_workfn+0x235/0x350 [rbd]
 [<ffffffff8108788c>] ? process_one_work+0x15c/0x450
 [<ffffffff81088ae2>] ? worker_thread+0x112/0x540
 [<ffffffff810889d0>] ? create_and_start_worker+0x60/0x60
 [<ffffffff8108f491>] ? kthread+0xc1/0xe0
 [<ffffffff8108f3d0>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff8154787c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8108f3d0>] ? flush_kthread_worker+0xb0/0xb0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  28
CPU    1: hi:  186, btch:  31 usd:   9
CPU    2: hi:  186, btch:  31 usd: 158
CPU    3: hi:  186, btch:  31 usd:  15
active_anon:1681936 inactive_anon:218757 isolated_anon:0
 active_file:789119 inactive_file:1073620 isolated_file:0
 unevictable:1207 dirty:14441 writeback:695 unstable:0
 free:70009 slab_reclaimable:230032 slab_unreclaimable:19306
 mapped:6243 shmem:818 pagetables:6275 bounce:0
 free_cma:0
Node 0 DMA free:15900kB min:64kB low:80kB high:96kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2971 16055 16055
Node 0 DMA32 free:152992kB min:12496kB low:15620kB high:18744kB
active_anon:752000kB inactive_anon:221080kB active_file:567256kB
inactive_file:1150320kB unevictable:1288kB isolated(anon):0kB
isolated(file):0kB present:3119716kB managed:3045076kB mlocked:1288kB
dirty:5672kB writeback:1320kB mapped:5196kB shmem:692kB
slab_reclaimable:172048kB slab_unreclaimable:11424kB
kernel_stack:2672kB pagetables:4260kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 13083 13083
Node 0 Normal free:111340kB min:55020kB low:68772kB high:82528kB
active_anon:5975744kB inactive_anon:653948kB active_file:2589220kB
inactive_file:3143904kB unevictable:3540kB isolated(anon):0kB
isolated(file):0kB present:13631488kB managed:13397720kB
mlocked:3540kB dirty:52092kB writeback:1460kB mapped:19776kB
shmem:2580kB slab_reclaimable:748080kB slab_unreclaimable:65800kB
kernel_stack:4240kB pagetables:20840kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
...
rbd: rbd0: write 2000 at 4952c76000 result -12
end_request: I/O error, dev rbd0, sector 615080880
rbd: rbd0: write 1000 at 4952c79000 result -12
rbd: rbd0: write 6000 at 4952c7c000 result -12
rbd: rbd0: write 2000 at 4952c83000 result -12
rbd: rbd0: write 2000 at 4952c87000 result -12
rbd: rbd0: write 1000 at 4952c8a000 result -12
rbd: rbd0: write 1000 at 4972c70000 result -12
rbd: rbd0: write 1000 at 4972c72000 result -12
rbd: rbd0: write 2000 at 4972c76000 result -12
rbd: rbd0: write 1000 at 4972c79000 result -12
rbd: rbd0: write 6000 at 4972c7c000 result -12
rbd: rbd0: write 2000 at 4972c83000 result -12
rbd: rbd0: write 2000 at 4972c87000 result -12
rbd: rbd0: write 1000 at 4972c8a000 result -12
rbd: rbd0: write 2000 at 4952c8d000 result -12
rbd: rbd0: write 2000 at 4952c91000 result -12
rbd: rbd0: write 2000 at 4952c94000 result -12
rbd: rbd0: write 1000 at 4952c97000 result -12
rbd: rbd0: write 3000 at 4952c99000 result -12
rbd: rbd0: write 1000 at 4952c9e000 result -12
rbd: rbd0: write 2000 at 4952ca0000 result -12
rbd: rbd0: write 2000 at 4952ca3000 result -12
rbd: rbd0: write 2000 at 4972c8d000 result -12
rbd: rbd0: write 2000 at 4972c91000 result -12
rbd: rbd0: write 2000 at 4972c94000 result -12
rbd: rbd0: write 1000 at 4972c97000 result -12
rbd: rbd0: write 3000 at 4972c99000 result -12
rbd: rbd0: write 1000 at 4972c9e000 result -12
rbd: rbd0: write 2000 at 4972ca0000 result -12
rbd: rbd0: write 2000 at 4972ca3000 result -12
rbd: rbd0: write 3000 at 4952ca7000 result -12
rbd: rbd0: write 3000 at 4972ca7000 result -12
BTRFS: error (device rbd0) in btrfs_commit_transaction:1882: errno=-5
IO failure (Error while writing out transaction)
BTRFS info (device rbd0): forced readonly
BTRFS warning (device rbd0): Skipping commit of aborted transaction.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5047 at
/build/linux-LrLd2z/linux-3.16.5/fs/btrfs/super.c:259
__btrfs_abort_transaction+0x5f/0x140 [btrfs]()
BTRFS: Transaction aborted (error -5)
Modules linked in: dm_snapshot dm_bufio vhost_net vhost macvtap
macvlan tun ip6table_filter ip6_tables ebtable_nat ebtables
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat cbc nf_conntrack_ipv4
rbd nf_defrag_ipv4 libceph xt_state nf_conntrack libcrc32c ipt_REJECT
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables
parport_pc ppdev lp parport ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad
ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc bridge
fuse ipmi_devintf 8021q garp stp mrp llc loop ttm drm_kms_helper drm
coretemp i7core_edac i2c_algo_bit iTCO_wdt iTCO_vendor_support
edac_core ipmi_si lpc_ich i2c_core kvm_intel pcspkr tpm_tis kvm evdev
tpm mfd_core dcdbas ipmi_msghandler processor button acpi_power_meter
thermal_sys ext4 crc16 mbcache jbd2 btrfs dm_mod raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq raid1 md_mod sg sd_mod crc_t10dif crc
Jan  1 14:04:57 CASRV0104 kernel: t10dif_common mvsas libsas ehci_pci
ehci_hcd crc32c_intel bnx2 libata scsi_transport_sas scsi_mod usbcore
usb_common
CPU: 1 PID: 5047 Comm: btrfs-transacti Not tainted 3.16-0.bpo.3-amd64
#1 Debian 3.16.5-1~bpo70+1
Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS 1.5.2 10/15/2010
 0000000000000000 ffffffffa0279a28 ffffffff8154144f ffff88033cb73cf8
 ffffffff8106ce5c 00000000fffffffb ffff88042ba7b000 ffff8801039f2980
 0000000000000623 ffffffffa0276060 ffffffff8106cf4a ffffffffa0279b08
Call Trace:
 [<ffffffff8154144f>] ? dump_stack+0x41/0x51
 [<ffffffff8106ce5c>] ? warn_slowpath_common+0x8c/0xc0
 [<ffffffff8106cf4a>] ? warn_slowpath_fmt+0x4a/0x50
 [<ffffffff8153e312>] ? printk+0x54/0x59
 [<ffffffffa01cce0f>] ? __btrfs_abort_transaction+0x5f/0x140 [btrfs]
 [<ffffffffa01fac9f>] ? cleanup_transaction+0x6f/0x2b0 [btrfs]
 [<ffffffff810b0080>] ? __wake_up_sync+0x20/0x20
 [<ffffffffa01fbd51>] ? btrfs_commit_transaction+0x741/0xa10 [btrfs]
 [<ffffffffa01f9655>] ? transaction_kthread+0x1d5/0x250 [btrfs]
 [<ffffffffa01f9480>] ? open_ctree+0x1f20/0x1f20 [btrfs]
 [<ffffffff8108f491>] ? kthread+0xc1/0xe0
 [<ffffffff8108f3d0>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff8154787c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8108f3d0>] ? flush_kthread_worker+0xb0/0xb0
---[ end trace 5a9d5a0c208ce55b ]---
BTRFS: error (device rbd0) in cleanup_transaction:1571: errno=-5 IO failure
BTRFS info (device rbd0): delayed_refs has NO entry
------------------------------------
Also: http://pastebin.com/HYKdeYLJ
