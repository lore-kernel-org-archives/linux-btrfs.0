From: Sander <sander@humilis.net>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:2733
Date: Fri, 30 Mar 2012 22:44:05 +0200
Message-ID: <20120330204405.GA2632@panda>
References: <20120329105235.GA1198@panda>
 <20120329135324.GA1899@zambezi.lan>
 <20120329151422.GC29741@panda>
 <20120329154154.GA3891@zambezi.lan>
 <20120330174956.GA770@panda>
 <20120330195251.GA1928@zambezi.lan>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120330195251.GA1928@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Ilya Dryomov wrote (ao):
> On Fri, Mar 30, 2012 at 07:49:56PM +0200, Sander wrote:
> Thanks. btrfs-debug-tree confirms that you've got a balance item on
> media.

> > > > > After that mount it back and see if there is "btrfs: continuing
> > > > > balance" line in dmesg (and if btrfs-balance kthread shows up)?
> > 
> > There is no such line in dmesg, and currently no btrfs-balance kthread
> > is running. I've pulled Chris Masons for-linus and booted with the
> > resulting kernel.
> 
> And given the above it's weird. We are failing to locate the item
> during mount for some reason and I would like to find out why. So if
> you are up for running debugging patches (really just compiling btrfs
> module and sending me dmesg output) I would appreciate that.

Sure, please send me patches.

In the mean time, I got these (not related I guess, but it's the first
time it mentions btrfs, and I wonder where gzip is from):

[10013.866973] kworker/0:2: page allocation failure: order:3, mode:0x20
[10013.866973] [<c000ff5b>] (unwind_backtrace+0x1/0x8a) from [<c00601f3>] (warn_alloc_failed+0x9f/0xc4)
[10013.881286] [<c00601f3>] (warn_alloc_failed+0x9f/0xc4) from [<c0061ed7>] (__alloc_pages_nodemask+0x3e3/0x410)
[10013.883270] [<c0061ed7>] (__alloc_pages_nodemask+0x3e3/0x410) from [<c007b57b>] (cache_alloc_refill+0x1ab/0x364)
[10013.893646] [<c007b57b>] (cache_alloc_refill+0x1ab/0x364) from [<c007b78d>] (__kmalloc+0x59/0x84)
[10013.893646] [<c007b78d>] (__kmalloc+0x59/0x84) from [<c02e0bcd>] (__alloc_skb+0x37/0xb2)
[10013.922058] [<c02e0bcd>] (__alloc_skb+0x37/0xb2) from [<c02e1033>] (__netdev_alloc_skb+0x15/0x2e)
[10013.922058] [<c02e1033>] (__netdev_alloc_skb+0x15/0x2e) from [<c0243839>] (rx_submit+0x15/0x130)
[10013.931365] [<c0243839>] (rx_submit+0x15/0x130) from [<c0248187>] (usb_hcd_giveback_urb+0x3f/0x74)
[10013.931365] [<c0248187>] (usb_hcd_giveback_urb+0x3f/0x74) from [<c0250739>] (ehci_urb_done+0x5f/0x68)
[10013.931365] [<c0250739>] (ehci_urb_done+0x5f/0x68) from [<c0252497>] (qh_completions+0x6f/0x2b8)
[10013.968780] [<c0252497>] (qh_completions+0x6f/0x2b8) from [<c0252ca5>] (ehci_work+0x65/0x5d8)
[10013.968780] [<c0252ca5>] (ehci_work+0x65/0x5d8) from [<c0253635>] (ehci_irq+0x171/0x198)
[10013.986175] [<c0253635>] (ehci_irq+0x171/0x198) from [<c0247c47>] (usb_hcd_irq+0x1f/0x3a)
[10013.986175] [<c0247c47>] (usb_hcd_irq+0x1f/0x3a) from [<c0057165>] (handle_irq_event_percpu+0x19/0xd4)
[10013.986175] [<c0057165>] (handle_irq_event_percpu+0x19/0xd4) from [<c0057249>] (handle_irq_event+0x29/0x3c)
[10013.986175] [<c0057249>] (handle_irq_event+0x29/0x3c) from [<c0058c5d>] (handle_fasteoi_irq+0x81/0xb4)
[10013.986175] [<c0058c5d>] (handle_fasteoi_irq+0x81/0xb4) from [<c0056dcf>] (generic_handle_irq+0x13/0x1c)
[10014.024444] [<c0056dcf>] (generic_handle_irq+0x13/0x1c) from [<c000cc97>] (handle_IRQ+0x4b/0x7c)
[10014.024444] [<c000cc97>] (handle_IRQ+0x4b/0x7c) from [<c00084b1>] (gic_handle_irq+0x4d/0x68)
[10014.052398] [<c00084b1>] (gic_handle_irq+0x4d/0x68) from [<c000bfdb>] (__irq_svc+0x3b/0x60)
[10014.052398] Exception stack(0xedf73f00 to 0xedf73f48)
[10014.052398] 3f00: ef002a64 ef00a440 00000000 ee097b40 ef000140 ef002a40 00000000 c1a40d08
[10014.052398] 3f20: 00000000 c1a40d08 c1a404bc 00000000 00000020 edf73f48 c0421079 c042107a
[10014.052398] 3f40: 60000033 ffffffff
[10014.083526] [<c000bfdb>] (__irq_svc+0x3b/0x60) from [<c042107a>] (_raw_spin_unlock_irq+0x8/0xa)
[10014.083526] [<c042107a>] (_raw_spin_unlock_irq+0x8/0xa) from [<c007b297>] (cache_reap+0x5b/0xb8)
[10014.083526] [<c007b297>] (cache_reap+0x5b/0xb8) from [<c002f827>] (process_one_work+0x155/0x22e)
[10014.083526] [<c002f827>] (process_one_work+0x155/0x22e) from [<c002fc3b>] (worker_thread+0x127/0x1e8)
[10014.083526] [<c002fc3b>] (worker_thread+0x127/0x1e8) from [<c0032059>] (kthread+0x4d/0x60)
[10014.133026] [<c0032059>] (kthread+0x4d/0x60) from [<c000cd39>] (kernel_thread_exit+0x1/0x6)
[10014.133026] Mem-info:
[10014.133026] Normal per-cpu:
[10014.133026] CPU    0: hi:  186, btch:  31 usd: 156
[10014.133026] CPU    1: hi:  186, btch:  31 usd: 168
[10014.152069] active_anon:19949 inactive_anon:506 isolated_anon:0
[10014.152069]  active_file:52991 inactive_file:52991 isolated_file:0
[10014.157104]  unevictable:469 dirty:2108 writeback:0 unstable:0
[10014.157104]  free:3283 slab_reclaimable:51064 slab_unreclaimable:5690
[10014.157104]  mapped:2477 shmem:522 pagetables:569 bounce:0
[10014.188293] Normal free:13132kB min:3512kB low:4388kB high:5268kB active_anon:79796kB inactive_anon:2024kB active_file:211964kB inactive_file:211964kB unevictable:1876kB isolated(anon):0kB isolated(file):0kB present:771136kB mlocked:0kB dirty:8432kB writeback:0kB mapped:9908kB shmem:2088kB slab_reclaimable:204256kB slab_unreclaimable:22760kB kernel_stack:1608kB pagetables:2276kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[10014.188293] lowmem_reserve[]: 0 0
[10014.188293] Normal: 2383*4kB 278*8kB 34*16kB 26*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 13132kB
[10014.188293] 107008 total pagecache pages
[10014.188293] 0 pages in swap cache
[10014.188293] Swap cache stats: add 0, delete 0, find 0/0
[10014.253112] Free swap  = 0kB
[10014.261566] Total swap = 0kB
[10014.261566] 194560 pages of RAM
[10014.311492] 5438 free pages
[10014.314422] 3772 reserved pages
[10014.314422] 56747 slab pages
[10014.320709] 125870 pages shared
[10014.320709] 0 pages swap cached
[10015.815917] gzip: page allocation failure: order:3, mode:0x20
[10015.819396] [<c000ff5b>] (unwind_backtrace+0x1/0x8a) from [<c00601f3>] (warn_alloc_failed+0x9f/0xc4)
[10015.828765] [<c00601f3>] (warn_alloc_failed+0x9f/0xc4) from [<c0061ed7>] (__alloc_pages_nodemask+0x3e3/0x410)
[10015.828765] [<c0061ed7>] (__alloc_pages_nodemask+0x3e3/0x410) from [<c007b57b>] (cache_alloc_refill+0x1ab/0x364)
[10015.828765] [<c007b57b>] (cache_alloc_refill+0x1ab/0x364) from [<c007b78d>] (__kmalloc+0x59/0x84)
[10015.828765] [<c007b78d>] (__kmalloc+0x59/0x84) from [<c02e0bcd>] (__alloc_skb+0x37/0xb2)
[10015.861938] [<c02e0bcd>] (__alloc_skb+0x37/0xb2) from [<c02e1033>] (__netdev_alloc_skb+0x15/0x2e)
[10015.879699] [<c02e1033>] (__netdev_alloc_skb+0x15/0x2e) from [<c0243839>] (rx_submit+0x15/0x130)
[10015.879699] [<c0243839>] (rx_submit+0x15/0x130) from [<c0248187>] (usb_hcd_giveback_urb+0x3f/0x74)
[10015.879699] [<c0248187>] (usb_hcd_giveback_urb+0x3f/0x74) from [<c0250739>] (ehci_urb_done+0x5f/0x68)
[10015.898284] [<c0250739>] (ehci_urb_done+0x5f/0x68) from [<c0252497>] (qh_completions+0x6f/0x2b8)
[10015.898284] [<c0252497>] (qh_completions+0x6f/0x2b8) from [<c0252ca5>] (ehci_work+0x65/0x5d8)
[10015.921264] [<c0252ca5>] (ehci_work+0x65/0x5d8) from [<c0253635>] (ehci_irq+0x171/0x198)
[10015.921264] [<c0253635>] (ehci_irq+0x171/0x198) from [<c0247c47>] (usb_hcd_irq+0x1f/0x3a)
[10015.921264] [<c0247c47>] (usb_hcd_irq+0x1f/0x3a) from [<c0057165>] (handle_irq_event_percpu+0x19/0xd4)
[10015.921264] [<c0057165>] (handle_irq_event_percpu+0x19/0xd4) from [<c0057249>] (handle_irq_event+0x29/0x3c)
[10015.963043] [<c0057249>] (handle_irq_event+0x29/0x3c) from [<c0058c5d>] (handle_fasteoi_irq+0x81/0xb4)
[10015.972778] [<c0058c5d>] (handle_fasteoi_irq+0x81/0xb4) from [<c0056dcf>] (generic_handle_irq+0x13/0x1c)
[10015.980377] [<c0056dcf>] (generic_handle_irq+0x13/0x1c) from [<c000cc97>] (handle_IRQ+0x4b/0x7c)
[10015.991333] [<c000cc97>] (handle_IRQ+0x4b/0x7c) from [<c00084b1>] (gic_handle_irq+0x4d/0x68)
[10015.999176] [<c00084b1>] (gic_handle_irq+0x4d/0x68) from [<c000c1a9>] (__irq_usr+0x49/0x60)
[10015.999176] Exception stack(0xd0199fb0 to 0xd0199ff8)
[10015.999176] 9fa0:                                     3a3a6574 000000ad ddf4c516 b6ca0a00
[10016.023315] 9fc0: 00418228 00002123 00000090 69757320 000000c6 0000035e 00000382 00002863
[10016.023315] 9fe0: 0000039a bea05758 b6c9b4ff b6c9734e 20000030 ffffffff
[10016.023315] Mem-info:
[10016.023315] Normal per-cpu:
[10016.044067] CPU    0: hi:  186, btch:  31 usd:  61
[10016.044067] CPU    1: hi:  186, btch:  31 usd: 168
[10016.054107] active_anon:20000 inactive_anon:506 isolated_anon:0
[10016.054107]  active_file:52586 inactive_file:52629 isolated_file:0
[10016.054107]  unevictable:469 dirty:2368 writeback:0 unstable:0
[10016.054107]  free:4114 slab_reclaimable:51010 slab_unreclaimable:5708
[10016.054138]  mapped:2477 shmem:522 pagetables:569 bounce:0
[10016.054138] Normal free:16456kB min:3512kB low:4388kB high:5268kB active_anon:80000kB inactive_anon:2024kB active_file:210344kB inactive_file:210516kB unevictable:1876kB isolated(anon):0kB isolated(file):0kB present:771136kB mlocked:0kB dirty:9472kB writeback:0kB mapped:9908kB shmem:2088kB slab_reclaimable:204040kB slab_unreclaimable:22832kB kernel_stack:1608kB pagetables:2276kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:28 all_unreclaimable? no
[10016.054138] lowmem_reserve[]: 0 0
[10016.054138] Normal: 2708*4kB 527*8kB 36*16kB 24*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 16456kB
[10016.054138] 106265 total pagecache pages
[10016.054138] 0 pages in swap cache
[10016.146759] Swap cache stats: add 0, delete 0, find 0/0
[10016.155670] Free swap  = 0kB
[10016.155670] Total swap = 0kB
[10016.155670] 194560 pages of RAM
[10016.208190] 6178 free pages
[10016.211120] 3772 reserved pages
[10016.211120] 56705 slab pages
[10016.217407] 125775 pages shared
[10016.217407] 0 pages swap cached
[10016.250671] gzip: page allocation failure: order:3, mode:0x20
[10016.256744] [<c000ff5b>] (unwind_backtrace+0x1/0x8a) from [<c00601f3>] (warn_alloc_failed+0x9f/0xc4)
[10016.256744] [<c00601f3>] (warn_alloc_failed+0x9f/0xc4) from [<c0061ed7>] (__alloc_pages_nodemask+0x3e3/0x410)
[10016.256744] [<c0061ed7>] (__alloc_pages_nodemask+0x3e3/0x410) from [<c007b57b>] (cache_alloc_refill+0x1ab/0x364)
[10016.256744] [<c007b57b>] (cache_alloc_refill+0x1ab/0x364) from [<c007b78d>] (__kmalloc+0x59/0x84)
[10016.296630] [<c007b78d>] (__kmalloc+0x59/0x84) from [<c02e0bcd>] (__alloc_skb+0x37/0xb2)
[10016.296630] [<c02e0bcd>] (__alloc_skb+0x37/0xb2) from [<c02e1033>] (__netdev_alloc_skb+0x15/0x2e)
[10016.305114] [<c02e1033>] (__netdev_alloc_skb+0x15/0x2e) from [<c0243839>] (rx_submit+0x15/0x130)
[10016.323608] [<c0243839>] (rx_submit+0x15/0x130) from [<c0248187>] (usb_hcd_giveback_urb+0x3f/0x74)
[10016.323608] [<c0248187>] (usb_hcd_giveback_urb+0x3f/0x74) from [<c0250739>] (ehci_urb_done+0x5f/0x68)
[10016.323608] [<c0250739>] (ehci_urb_done+0x5f/0x68) from [<c0252497>] (qh_completions+0x6f/0x2b8)
[10016.342926] [<c0252497>] (qh_completions+0x6f/0x2b8) from [<c0252ca5>] (ehci_work+0x65/0x5d8)
[10016.360748] [<c0252ca5>] (ehci_work+0x65/0x5d8) from [<c0253635>] (ehci_irq+0x171/0x198)
[10016.360748] [<c0253635>] (ehci_irq+0x171/0x198) from [<c0247c47>] (usb_hcd_irq+0x1f/0x3a)
[10016.369232] [<c0247c47>] (usb_hcd_irq+0x1f/0x3a) from [<c0057165>] (handle_irq_event_percpu+0x19/0xd4)
[10016.377807] [<c0057165>] (handle_irq_event_percpu+0x19/0xd4) from [<c0057249>] (handle_irq_event+0x29/0x3c)
[10016.377807] [<c0057249>] (handle_irq_event+0x29/0x3c) from [<c0058c5d>] (handle_fasteoi_irq+0x81/0xb4)
[10016.377807] [<c0058c5d>] (handle_fasteoi_irq+0x81/0xb4) from [<c0056dcf>] (generic_handle_irq+0x13/0x1c)
[10016.417419] [<c0056dcf>] (generic_handle_irq+0x13/0x1c) from [<c000cc97>] (handle_IRQ+0x4b/0x7c)
[10016.426605] [<c000cc97>] (handle_IRQ+0x4b/0x7c) from [<c00084b1>] (gic_handle_irq+0x4d/0x68)
[10016.426605] [<c00084b1>] (gic_handle_irq+0x4d/0x68) from [<c000bfdb>] (__irq_svc+0x3b/0x60)
[10016.426605] Exception stack(0xd0199df0 to 0xd0199e38)
[10016.449462] 9de0:                                     e2867a40 d0199e78 0008e000 00000000
[10016.449462] 9e00: c51e6468 00000000 c51e64e0 e2867a40 d0199ec8 00000000 00000000 00001000
[10016.449462] 9e20: 0000011e d0199e38 c012bb6f c012b692 20000033 ffffffff
[10016.473510] [<c000bfdb>] (__irq_svc+0x3b/0x60) from [<c012b692>] (__btrfs_buffered_write+0x0/0x1fa)
[10016.473510] [<c012b692>] (__btrfs_buffered_write+0x0/0x1fa) from [<e2867a40>] (0xe2867a40)
[10016.491607] Mem-info:
[10016.493988] Normal per-cpu:
[10016.493988] CPU    0: hi:  186, btch:  31 usd:  89
[10016.496917] CPU    1: hi:  186, btch:  31 usd: 178
[10016.496917] active_anon:20003 inactive_anon:506 isolated_anon:0
[10016.496917]  active_file:52431 inactive_file:52447 isolated_file:0
[10016.506958]  unevictable:469 dirty:2407 writeback:0 unstable:0
[10016.506958]  free:4407 slab_reclaimable:51012 slab_unreclaimable:5742
[10016.506958]  mapped:2483 shmem:522 pagetables:575 bounce:0
[10016.538146] Normal free:17628kB min:3512kB low:4388kB high:5268kB active_anon:80012kB inactive_anon:2024kB active_file:209724kB inactive_file:209788kB unevictable:1876kB isolated(anon):0kB isolated(file):0kB present:771136kB mlocked:0kB dirty:9628kB writeback:0kB mapped:9932kB shmem:2088kB slab_reclaimable:204048kB slab_unreclaimable:22968kB kernel_stack:1616kB pagetables:2300kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[10016.580474] lowmem_reserve[]: 0 0
[10016.580474] Normal: 2777*4kB 585*8kB 71*16kB 22*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 17628kB
[10016.580474] 105882 total pagecache pages
[10016.580474] 0 pages in swap cache
[10016.602966] Swap cache stats: add 0, delete 0, find 0/0
[10016.602966] Free swap  = 0kB
[10016.608428] Total swap = 0kB
[10016.655364] 194560 pages of RAM
[10016.661163] 6509 free pages
[10016.663208] 3772 reserved pages
[10016.667358] 56740 slab pages
[10016.667358] 125714 pages shared
[10016.671020] 0 pages swap cached


-- 
Humilis IT Services and Solutions
http://www.humilis.net
