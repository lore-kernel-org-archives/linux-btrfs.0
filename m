Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37439 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbcC3FEX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 01:04:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1al8Ik-0004DA-Gd
	for linux-btrfs@vger.kernel.org; Wed, 30 Mar 2016 07:04:18 +0200
Received: from 2.67.66.148.dsl.dyn.mana.pf ([148.66.67.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 07:04:18 +0200
Received: from jd.girard by 2.67.66.148.dsl.dyn.mana.pf with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 07:04:18 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: btrfs: page allocation failure
Date: Tue, 29 Mar 2016 19:04:10 -1000
Message-ID: <ndfmob$ed5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I just started to use send / receive for backups to another drive.
That's a great feature, but unfortunately I'm getting page allocation
failure, see below.

My backup script does something like this for 11 sub-volumes:
  btrfs subvolume snapshot -r vol /snaps
  btrfs fi sync /snaps
  btrfs send -p /snaps/vol_old /snaps/vol | btrfs receive -v /mnt/backup
  btrfs fi sync /mnt/backup
  btrfs subvolume delete -c /snaps/vol_old
  mv /snaps/vol /snaps/vol_old
  btrfs subvolume delete -c /backup/vol_old
  btrfs subvolume snapshot -r :backup/vol \
      /backup/vol_$(date +'%Y%m%d')
  btrfs fi sync /backup
  mv /backup/vol /backup/vol_old

This is on a up-to-date Fedora 23 system, with kernel
4.4.6-300.fc23.x86_64, and btrfs-progs v4.4.1 (recompiled on the
system). The system is mostly idle when the error happens. The backup
file system seems clean: btrfs check or scrub report no errors.

[ 3734.651439] btrfs: page allocation failure: order:4, mode:0x2404040
[ 3734.651447] CPU: 2 PID: 7577 Comm: btrfs Not tainted
4.4.6-300.fc23.x86_64 #1
[ 3734.651449] Hardware name:                  /DZ68DB, BIOS
DBZ6810H.86A.0014.2011.0413.1049 04/13/2011
[ 3734.651452]  0000000000000286 0000000063f642d6 ffff8801000938a8
ffffffff813b542e
[ 3734.651456]  0000000002404040 0000000000000000 ffff880100093938
ffffffff811b2f8a
[ 3734.651460]  0000000100000040 00000000000938d0 0000000063f642d6
0000000000000004
[ 3734.651463] Call Trace:
[ 3734.651473]  [<ffffffff813b542e>] dump_stack+0x63/0x85
[ 3734.651477]  [<ffffffff811b2f8a>] warn_alloc_failed+0xfa/0x160
[ 3734.651481]  [<ffffffff811b6e61>] __alloc_pages_nodemask+0x361/0xbc0
[ 3734.651487]  [<ffffffff812029cc>] alloc_pages_current+0x8c/0x110
[ 3734.651491]  [<ffffffff811b5159>] alloc_kmem_pages+0x19/0x90
[ 3734.651494]  [<ffffffff811d2efe>] kmalloc_order_trace+0x2e/0xe0
[ 3734.651498]  [<ffffffff8120e6d2>] __kmalloc+0x232/0x260
[ 3734.651501]  [<ffffffff8120ceca>] ? kmem_cache_alloc+0x1da/0x200
[ 3734.651526]  [<ffffffffa0652f12>] ? btrfs_compare_trees+0x72/0x760
[btrfs]
[ 3734.651543]  [<ffffffffa0652f2f>] btrfs_compare_trees+0x8f/0x760 [btrfs]
[ 3734.651565]  [<ffffffffa06e5fe0>] ?
finish_inode_if_needed+0xac0/0xac0 [btrfs]
[ 3734.651586]  [<ffffffffa06df017>] ? write_buf+0x67/0xa0 [btrfs]
[ 3734.651605]  [<ffffffffa06e7a17>] btrfs_ioctl_send+0xf67/0x11e0 [btrfs]
[ 3734.651626]  [<ffffffffa06aea52>] btrfs_ioctl+0x2a2/0x2e60 [btrfs]
[ 3734.651632]  [<ffffffff810d4c0c>] ? __enqueue_entity+0x6c/0x70
[ 3734.651634]  [<ffffffff810dabc2>] ? enqueue_entity+0x3a2/0xc90
[ 3734.651638]  [<ffffffff813b5191>] ? cpumask_next_and+0x31/0x50
[ 3734.651641]  [<ffffffff810db559>] ? enqueue_task_fair+0xa9/0x8f0
[ 3734.651646]  [<ffffffff81020cb9>] ? sched_clock+0x9/0x10
[ 3734.651651]  [<ffffffff8133fc9c>] ? selinux_file_ioctl+0x10c/0x1c0
[ 3734.651655]  [<ffffffff81241248>] do_vfs_ioctl+0x298/0x480
[ 3734.651659]  [<ffffffff81148c2b>] ? __audit_syscall_entry+0xab/0xf0
[ 3734.651663]  [<ffffffff81337553>] ? security_file_ioctl+0x43/0x60
[ 3734.651667]  [<ffffffff812414a9>] SyS_ioctl+0x79/0x90
[ 3734.651671]  [<ffffffff817a04ee>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 3734.651673] Mem-Info:
[ 3734.651679] active_anon:30295 inactive_anon:45198 isolated_anon:0
                active_file:225694 inactive_file:1633697 isolated_file:0
                unevictable:0 dirty:98 writeback:0 unstable:0
                slab_reclaimable:24545 slab_unreclaimable:13822
                mapped:19138 shmem:9157 pagetables:6002 bounce:0
                free:17464 free_pcp:25 free_cma:0
[ 3734.651684] Node 0 DMA free:15344kB min:20kB low:24kB high:28kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB
managed:15360kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:16kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[ 3734.651692] lowmem_reserve[]: 0 3397 7874 7874
[ 3734.651697] Node 0 DMA32 free:32532kB min:4864kB low:6080kB
high:7296kB active_anon:63528kB inactive_anon:83976kB
active_file:393052kB inactive_file:2798152kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:3561300kB
managed:3481560kB mlocked:0kB dirty:4kB writeback:0kB mapped:33688kB
shmem:15268kB slab_reclaimable:40496kB slab_unreclaimable:21768kB
kernel_stack:2992kB pagetables:12068kB unstable:0kB bounce:0kB
free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[ 3734.651704] lowmem_reserve[]: 0 0 4476 4476
[ 3734.651708] Node 0 Normal free:21980kB min:6408kB low:8008kB
high:9612kB active_anon:57652kB inactive_anon:96816kB
active_file:509724kB inactive_file:3736636kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:4716544kB
managed:4584088kB mlocked:0kB dirty:388kB writeback:0kB mapped:42864kB
shmem:21360kB slab_reclaimable:57668kB slab_unreclaimable:33520kB
kernel_stack:4288kB pagetables:11940kB unstable:0kB bounce:0kB
free_pcp:100kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[ 3734.651715] lowmem_reserve[]: 0 0 0 0
[ 3734.651718] Node 0 DMA: 0*4kB 0*8kB 1*16kB (E) 1*32kB (E) 1*64kB (E)
1*128kB (E) 1*256kB (E) 1*512kB (E) 2*1024kB (UE) 2*2048kB (ME) 2*4096kB
(M) = 15344kB
[ 3734.651735] Node 0 DMA32: 780*4kB (UME) 3701*8kB (UM) 5*16kB (UM)
1*32kB (M) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
32840kB
[ 3734.651747] Node 0 Normal: 374*4kB (UME) 2557*8kB (UM) 4*16kB (UM)
1*32kB (U) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
22048kB
[ 3734.651761] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=2048kB
[ 3734.651762] 1868684 total pagecache pages
[ 3734.651764] 155 pages in swap cache
[ 3734.651766] Swap cache stats: add 46224, delete 46069, find 762/1478
[ 3734.651768] Free swap  = 4015912kB
[ 3734.651769] Total swap = 4194300kB
[ 3734.651771] 2073457 pages RAM
[ 3734.651772] 0 pages HighMem/MovableOnly
[ 3734.651774] 53205 pages reserved
[ 3734.651775] 0 pages cma reserved
[ 3734.651776] 0 pages hwpoisoned


What should I do to avoid this?


Thanks,
-- 
Jean-Denis Girard

SysNux                  Systèmes Linux en Polynésie française
http://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.5

