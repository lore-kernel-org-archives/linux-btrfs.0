Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49709 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbcDUFus (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 01:50:48 -0400
Date: Wed, 20 Apr 2016 22:50:39 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Eric Wheeler <btrfs@lists.ewheeler.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Infinite loop/hang in in btrfs_find_space_cluster()
Message-ID: <20160421055039.GA10789@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <alpine.LRH.2.11.1604130646280.26685@mail.ewheeler.net>
 <alpine.LRH.2.11.1604192142320.16630@mail.ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LRH.2.11.1604192142320.16630@mail.ewheeler.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 19, 2016 at 02:51:33PM -0700, Eric Wheeler wrote:
> On Wed, 13 Apr 2016, Eric Wheeler wrote:
> 
> > Hello all,
> > 
> > We just got this backtrace in 4.4.6 on an ARM AM335x (beaglebone 
> > compatible).  The trace looks similar to this one:
> >   http://permalink.gmane.org/gmane.comp.file-systems.btrfs/54734 
> 
> We solved the problem so I thought I would report back in case anyone else 
> runs in to the same issue.  
> 
> This is running on a memory constrained 700mhz ARM (single core) so we had 
> these mount options that worked fine until we went from a single volume to 
> raid1, at which time it hung after the first reboot (or remount?):
>   ssd,ssd_spread,thread_pool=1,noatime,compress-force=lzo,nospace_cache,commit=37
> 
> so we switched to these on the raid1 system:
>   noatime,compress-force=lzo,commit=37
> and it stopped hanging.
> 
> Ultimately my guess is either of thread_pool=1 causing deadlock (no 
> progress), or nospace_cache causing space churn.  
> 
> We used thread_pool=1 which worked for a long time on a single volume.  
> We just added a 2nd volume and went to raid1, so perhaps the minimum 
> thread_pool should be the number of volumes?  I cannot be certain, so FYI 
> in case others run into this.

Thanks for giving us this feedback, I think 'nospace-cache' can be that
cause since 'thread_pool' is really just affecting workqueue part and
suggesting how many works it processes, it's supposed to work with any
sane numbers.

Can you please add back nospace-cache and see if we can get the hang
again?

Thanks,

-liubo

> 
> --
> Eric Wheeler
> 
> 
> 
> 
> 
> 
> but I 
> > don't have nice backtraces on this hardware (maybe hang traces are a 
> > compile option?).
> > 
> > In my case, the system appeared to hang but sysrq functions still worked 
> > and I was able to send a sysrq-(c)rash over serial.  The filesystem was 
> > just formatted in RAID1, and while I cannot access it because this hangs 
> > at boot, there can't be very much data yet.
> > 
> > This looks like the top of the relevant section, full trace below:
> > 
> > [   80.738518] [<bf187910>] (setup_cluster_no_bitmap [btrfs]) from [<bf18b3b8>] (btrfs_find_space_cluster+0x10c/0x1dc [btrfs])
> > 
> > Any help you can offer would be greatly appreciated!
> > 
> > -Eric
> > 
> > [   80.005546] sysrq: SysRq : Trigger a crash
> > [   80.018339] pgd = c0004000
> > [   80.021160] [00000000] *pgd=00000000
> > [   80.024897] Internal error: Oops: 817 [#1] ARM
> > [   80.029531] Modules linked in: btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> >  raid6_pq raid0 multipath linear zram lz4_compress zsmalloc dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot
> >  dm_bufio dm_zero dm_mod raid1 md_mod
> > [   80.054411] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 4.4.6-vr3-00004-g2dfa78e #15
> > [   80.062579] Hardware name: Generic AM33XX (Flattened Device Tree)
> > [   80.069476] Workqueue: btrfs-delalloc btrfs_delalloc_helper [btrfs]
> > [   80.076026] task: cc8344c0 ti: cc858000 task.ti: cc858000
> > [   80.081669] PC is at sysrq_handle_crash+0x28/0x30
> > [   80.086576] LR is at sysrq_handle_crash+0x24/0x30
> > [   80.091484] pc : [<c02936f4>]    lr : [<c02936f0>]    psr: 60000193
> > [   80.091484] sp : cc8599e8  ip : cc8599e8  fp : cc8599fc
> > [   80.103460] r10: cc8ecb80  r9 : c06008ce  r8 : 00000001
> > [   80.108909] r7 : 00000007  r6 : 00000063  r5 : c05d6308  r4 : 00000001
> > [   80.115717] r3 : 00000000  r2 : c05d62c8  r1 : 00000000  r0 : 00000063
> > [   80.122529] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
> > [   80.130063] Control: 10c5387d  Table: 8a42c019  DAC: 00000051
> > [   80.136057] Process kworker/u2:0 (pid: 6, stack limit = 0xcc858210)
> > [   80.142595] Stack: (0xcc8599e8 to 0xcc85a000)
> > [   80.147145] 99e0:                   c02936cc c05e34f4 cc859a24 cc859a00 c0293d00 c02936d8
> > [   80.155683] 9a00: c05b2bc4 cca49010 00000000 00000101 00000002 00000005 cc859a34 cc859a28
> > [   80.164220] 9a20: c0294208 c0293c64 cc859a74 cc859a38 c02ad3fc c02941e4 00000000 00000000
> > [   80.172758] 9a40: 00000001 00000001 00015200 cca22380 cc8ecb90 00000000 00000000 0000009b
> > [   80.181296] 9a60: c06008ce cc8ecb80 cc859aac cc859a78 c006652c c02ad050 c00409f4 c00405e0
> > [   80.189833] 9a80: 00000000 cc8ecb80 cc8ecb90 00000000 00000000 cc804000 cc15ec50 ccd02518
> > [   80.198373] 9aa0: cc859ac4 cc859ab0 c0066668 c00664d4 00022000 cc8ecb80 cc859adc cc859ac8
> > [   80.206912] 9ac0: c00690ec c0066644 0000009b c05de0a0 cc859aec cc859ae0 c0065e58 c006905c
> > [   80.215451] 9ae0: cc859b14 cc859af0 c0065f7c c0065e44 cc859b30 c06342c0 60000013 ffffffff
> > [   80.223990] 9b00: cc859b64 00201000 cc859b2c cc859b18 c00093b8 c0065f34 bf187974 bf18799c
> > [   80.232529] 9b20: cc859bcc cc859b30 c0412e14 c000938c cc15ec50 cc15fba8 00201000 00000000
> > [   80.241066] 9b40: 00005000 00000000 cc859bf8 ca144880 00201000 cc15ec50 ccd02518 cc859bcc
> > [   80.249604] 9b60: cc859b80 cc859b80 bf187974 bf18799c 60000013 ffffffff 00000051 c020aba4
> > [   80.258142] 9b80: 00000000 00000001 00000000 cc859bac cc859bf8 c0203d08 20000013 ccd02518
> > [   80.266680] 9ba0: 00000051 00201000 00000000 00201000 00000000 00201000 00000000 cc859bf8
> > [   80.275218] 9bc0: cc859c2c cc859bd0 bf18b3b8 bf18791c 41c00000 00000000 00201000 00000000
> > [   80.283756] 9be0: 00201000 00000000 00201000 00000000 ccd02518 ccb31200 cc15fbd4 cc15fbd4
> > [   80.292293] 9c00: cce624d0 00001000 00000000 00000000 00000001 ccb31200 00000001 ccd02518
> > [   80.300832] 9c20: cc859cdc cc859c30 bf12c868 bf18b2b8 41c00000 00000000 00001000 00000000
> > [   80.309369] 9c40: 00200000 00000000 00000000 cc13aef0 cc859c8c 00000001 00000002 00000001
> > [   80.317906] 9c60: 00000001 00000001 00000001 cce62570 00000001 ca157800 00001000 00000000
> > [   80.326442] 9c80: cce62500 00000001 bf11e508 bf11da44 00000001 00000000 00001000 00000000
> > [   80.334979] 9ca0: 00000000 00000000 00200000 00000000 00000001 00000011 00000001 cc859daf
> > [   80.343517] 9cc0: 00000001 00001000 00000000 ccdf7000 cc859d4c cc859ce0 bf12cff4 bf12c1f8
> > [   80.352054] 9ce0: 00000000 00000000 41c00000 00000000 cc859daf 00000001 00000011 00000000
> > [   80.360590] 9d00: 00000001 00000000 00001000 00000000 00000000 00000001 00000011 00000000
> > [   80.369127] 9d20: 00000000 00000000 cc859daf 00000001 00000000 cc126350 00000000 ccdf7000
> > [   80.377664] 9d40: cc859dec cc859d50 bf145250 bf12cef4 00001000 00000000 00000000 00000000
> > [   80.386201] 9d60: 41c00000 00000000 cc859daf 00000001 00000001 ca264f80 00000000 00000000
> > [   80.394737] 9d80: cc8e0480 00000000 ccdf7000 cfdc3e60 00000fff 00000000 00001000 00000000
> > [   80.403275] 9da0: 41c00000 00000000 ca40a9a4 0040a980 00000000 a8000000 00000000 00000000
> > [   80.411812] 9dc0: bf15e2a8 00000000 ca2ff980 00000200 ca40a9a4 ca40a980 cc126350 cc126268
> > [   80.420349] 9de0: cc859e94 cc859df0 bf146838 bf1450e0 00000fff 00000000 cc859e4c cc859e50
> > [   80.428887] 9e00: 00000000 00000000 cfdc3e60 00000000 00001000 00000000 00001000 00000002
> > [   80.437423] 9e20: 00001000 00000000 00001000 ccdf7000 ca2ff9a0 cc126258 00000000 00000000
> > [   80.445959] 9e40: ca2ff980 ccdf7000 00001000 00000000 00000000 00000fff 00000000 ca2ff9a8
> > [   80.454496] 9e60: ca2ff980 00000000 cc81c000 00000000 00000000 ca2ff9a8 ca2ff980 00000100
> > [   80.463033] 9e80: cc81c000 ca269340 cc859eb4 cc859e98 bf146cc4 bf146680 ca2ff9c4 ca2ff9a8
> > [   80.471570] 9ea0: ca269344 00000200 cc859edc cc859eb8 bf171f20 bf146c38 cc81c000 ca2ff9b4
> > [   80.480107] 9ec0: cc802c00 cc83c300 00000000 00000000 cc859eec cc859ee0 bf171ff4 bf171dfc
> > [   80.488645] 9ee0: cc859f2c cc859ef0 c00509c0 bf171fec cc81c018 cc802c10 00000001 cc802c00
> > [   80.497181] 9f00: 00000088 cc802c10 00000001 cc81c018 00000088 cc802c00 cc81c000 cc802c00
> > [   80.505719] 9f20: cc859f64 cc859f30 c0050d78 c00508cc cc838b80 cc802c10 c0050c10 00000000
> > [   80.514257] 9f40: cc838b80 cc81c000 c0050c10 00000000 00000000 00000000 cc859fac cc859f68
> > [   80.522794] 9f60: c0055948 c0050c1c ffffffff 00000000 cc838b80 cc81c000 00000000 cc859f7c
> > [   80.531331] 9f80: cc859f7c 00000000 cc859f88 cc859f88 cc838b80 c0055874 00000000 00000000
> > [   80.539869] 9fa0: 00000000 cc859fb0 c00155d8 c0055880 00000000 00000000 00000000 00000000
> > [   80.548406] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > [   80.556944] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 fffff9ff fbfffbff
> > [   80.565472] Backtrace: 
> > [   80.568035] [<c02936cc>] (sysrq_handle_crash) from [<c0293d00>] (__handle_sysrq+0xa8/0x164)
> > [   80.576747]  r4:c05e34f4 r3:c02936cc
> > [   80.580488] [<c0293c58>] (__handle_sysrq) from [<c0294208>] (handle_sysrq+0x30/0x38)
> > [   80.588564]  r8:00000005 r7:00000002 r6:00000101 r5:00000000 r4:cca49010 r3:c05b2bc4
> > [   80.596686] [<c02941d8>] (handle_sysrq) from [<c02ad3fc>] (serial_omap_irq+0x3b8/0x418)
> > [   80.605060] [<c02ad044>] (serial_omap_irq) from [<c006652c>] (handle_irq_event_percpu+0x64/0x170)
> > [   80.614315]  r10:cc8ecb80 r9:c06008ce r8:0000009b r7:00000000 r6:00000000 r5:cc8ecb90
> > [   80.622505]  r4:cca22380
> > [   80.625156] [<c00664c8>] (handle_irq_event_percpu) from [<c0066668>] (handle_irq_event+0x30/0x44)
> > [   80.634410]  r10:ccd02518 r9:cc15ec50 r8:cc804000 r7:00000000 r6:00000000 r5:cc8ecb90
> > [   80.642602]  r4:cc8ecb80
> > [   80.645255] [<c0066638>] (handle_irq_event) from [<c00690ec>] (handle_level_irq+0x9c/0x120)
> > [   80.653965]  r4:cc8ecb80 r3:00022000
> > [   80.657707] [<c0069050>] (handle_level_irq) from [<c0065e58>] (generic_handle_irq+0x20/0x30)
> > [   80.666507]  r5:c05de0a0 r4:0000009b
> > [   80.670250] [<c0065e38>] (generic_handle_irq) from [<c0065f7c>] (__handle_domain_irq+0x54/0xac)
> > [   80.679334] [<c0065f28>] (__handle_domain_irq) from [<c00093b8>] (omap_intc_handle_irq+0x38/0x98)
> > [   80.688588]  r8:00201000 r7:cc859b64 r6:ffffffff r5:60000013 r4:c06342c0 r3:cc859b30
> > [   80.696710] [<c0009380>] (omap_intc_handle_irq) from [<c0412e14>] (__irq_svc+0x54/0x70)
> > [   80.705060] Exception stack(0xcc859b30 to 0xcc859b78)
> > [   80.710331] 9b20:                                     cc15ec50 cc15fba8 00201000 00000000
> > [   80.718868] 9b40: 00005000 00000000 cc859bf8 ca144880 00201000 cc15ec50 ccd02518 cc859bcc
> > [   80.727403] 9b60: cc859b80 cc859b80 bf187974 bf18799c 60000013 ffffffff
> > [   80.734301]  r4:bf18799c r3:bf187974
> > [   80.738518] [<bf187910>] (setup_cluster_no_bitmap [btrfs]) from [<bf18b3b8>] (btrfs_find_space_cluster+0x10c/0x1dc
> >  [btrfs])
> > [   80.750131]  r10:cc859bf8 r9:00000000 r8:00201000 r7:00000000 r6:00201000 r5:00000000
> > [   80.758322]  r4:00201000
> > [   80.761346] [<bf18b2ac>] (btrfs_find_space_cluster [btrfs]) from [<bf12c868>] (find_free_extent+0x67c/0xcfc [btrfs
> > ])
> > [   80.772323]  r10:ccd02518 r9:00000001 r8:ccb31200 r7:00000001 r6:00000000 r5:00000000
> > [   80.780514]  r4:00001000
> > [   80.783528] [<bf12c1ec>] (find_free_extent [btrfs]) from [<bf12cff4>] (btrfs_reserve_extent+0x10c/0x210 [btrfs])
> > [   80.794142]  r10:ccdf7000 r9:00000000 r8:00001000 r7:00000001 r6:cc859daf r5:00000001
> > [   80.802333]  r4:00000011
> > [   80.805350] [<bf12cee8>] (btrfs_reserve_extent [btrfs]) from [<bf145250>] (cow_file_range+0x17c/0x5f0 [btrfs])
> > [   80.815783]  r10:ccdf7000 r9:00000000 r8:cc126350 r7:00000000 r6:00000001 r5:cc859daf
> > [   80.823973]  r4:00000000
> > [   80.826994] [<bf1450d4>] (cow_file_range [btrfs]) from [<bf146838>] (submit_compressed_extents+0x1c4/0x5b8 [btrfs]
> > )
> > [   80.837881]  r10:cc126268 r9:cc126350 r8:ca40a980 r7:ca40a9a4 r6:00000200 r5:ca2ff980
> > [   80.846071]  r4:00000000
> > [   80.849091] [<bf146674>] (submit_compressed_extents [btrfs]) from [<bf146cc4>] (async_cow_submit+0x98/0x9c [btrfs]
> > )
> > [   80.859978]  r10:ca269340 r9:cc81c000 r8:00000100 r7:ca2ff980 r6:ca2ff9a8 r5:00000000
> > [   80.868169]  r4:00000000
> > [   80.871191] [<bf146c2c>] (async_cow_submit [btrfs]) from [<bf171f20>] (normal_work_helper+0x130/0x1d8 [btrfs])
> > [   80.881623]  r7:00000200 r6:ca269344 r5:ca2ff9a8 r4:ca2ff9c4
> > [   80.887924] [<bf171df0>] (normal_work_helper [btrfs]) from [<bf171ff4>] (btrfs_delalloc_helper+0x14/0x18 [btrfs])
> > [   80.898630]  r10:00000000 r8:00000000 r7:cc83c300 r6:cc802c00 r5:ca2ff9b4 r4:cc81c000
> > [   80.907023] [<bf171fe0>] (btrfs_delalloc_helper [btrfs]) from [<c00509c0>] (process_one_work+0x100/0x314)
> > [   80.917010] [<c00508c0>] (process_one_work) from [<c0050d78>] (worker_thread+0x168/0x4c8)
> > [   80.925539]  r10:cc802c00 r9:cc81c000 r8:cc802c00 r7:00000088 r6:cc81c018 r5:00000001
> > [   80.933729]  r4:cc802c10
> > [   80.936385] [<c0050c10>] (worker_thread) from [<c0055948>] (kthread+0xd4/0xf0)
> > [   80.943916]  r10:00000000 r9:00000000 r8:00000000 r7:c0050c10 r6:cc81c000 r5:cc838b80
> > [   80.952105]  r4:00000000
> > [   80.954766] [<c0055874>] (kthread) from [<c00155d8>] (ret_from_fork+0x14/0x3c)
> > [   80.962298]  r7:00000000 r6:00000000 r5:c0055874 r4:cc838b80
> > [   80.968227] Code: e5834000 f57ff04e ebf6357c e3a03000 (e5c34000) 
> > [   80.974592] ---[ end trace 18ae8f27c987efb8 ]---
> > [   80.979408] Kernel panic - not syncing: Fatal exception in interrupt
> > [   80.986039] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
> > 
> > 
> > 
> > --
> > Eric Wheeler
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
