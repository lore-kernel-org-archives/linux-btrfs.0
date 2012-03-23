From: Jan Engelhardt <jengelh@medozas.de>
Subject: btrfs crash after disk reconnect
Date: Fri, 23 Mar 2012 13:07:27 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1203231303520.2601@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Observed on Linux 3.2.9 after the controller/disk flaked in-out.
(The world still needs a SCSI error decoding tool to tell normal people 
what cmd and res are about.)

[  157.732885] device label srv devid 4 transid 11292 /dev/sdf
[  157.733201] btrfs: disk space caching is enabled
[  172.936515] device label srv devid 4 transid 11292 /dev/sdf
[44106.091461] ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[44106.091470] ata4.01: BMDMA stat 0x64
[44106.091478] ata4.01: failed command: READ DMA EXT
[44106.091492] ata4.01: cmd 25/00:08:a0:ca:72/00:00:4f:00:00/f0 tag 0 dma 4096 in
[44106.091495]          res 51/40:00:a3:ca:72/40:00:4f:00:00/f0 Emask 0x9 (media error)
[44106.091503] ata4.01: status: { DRDY ERR }
[44106.091508] ata4.01: error: { UNC }
[44106.120384] ata4.00: configured for UDMA/133
[44106.128349] ata4.01: configured for UDMA/133
[44106.128374] ata4: EH complete
[44109.364633] ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[44109.364642] ata4.01: BMDMA stat 0x64
[44109.364651] ata4.01: failed command: READ DMA EXT
[44109.364666] ata4.01: cmd 25/00:08:a0:ca:72/00:00:4f:00:00/f0 tag 0 dma 4096 in
[44109.364669]          res 51/40:00:a3:ca:72/40:00:4f:00:00/f0 Emask 0x9 (media error)
[44109.364676] ata4.01: status: { DRDY ERR }
[44109.364682] ata4.01: error: { UNC }
[44109.849346] ata4.00: configured for UDMA/133
[44109.856320] ata4.01: configured for UDMA/133
[44109.856347] ata4: EH complete
[44112.450194] ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[44112.450203] ata4.01: BMDMA stat 0x64
[44112.450211] ata4.01: failed command: READ DMA EXT
[44112.450226] ata4.01: cmd 25/00:08:a0:ca:72/00:00:4f:00:00/f0 tag 0 dma 4096 in
[44112.450229]          res 51/40:00:a3:ca:72/40:00:4f:00:00/f0 Emask 0x9 (media error)
[44112.450236] ata4.01: status: { DRDY ERR }
[44112.450241] ata4.01: error: { UNC }
[44112.488695] ata4.00: configured for UDMA/133
[44112.496417] ata4.01: configured for UDMA/133
[44112.496441] ata4: EH complete
[44115.215066] ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[44115.215074] ata4.01: BMDMA stat 0x64
[44115.215082] ata4.01: failed command: READ DMA EXT
[44115.215097] ata4.01: cmd 25/00:08:a0:ca:72/00:00:4f:00:00/f0 tag 0 dma 4096 in
[44115.215100]          res 51/40:00:a3:ca:72/40:00:4f:00:00/f0 Emask 0x9 (media error)
[44115.215107] ata4.01: status: { DRDY ERR }
[44115.215113] ata4.01: error: { UNC }
[44115.268483] ata4.00: configured for UDMA/133
[44115.276312] ata4.01: configured for UDMA/133
[44115.276340] ata4: EH complete
[44117.869315] ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[44117.869323] ata4.01: BMDMA stat 0x64
[44117.869332] ata4.01: failed command: READ DMA EXT
[44117.869347] ata4.01: cmd 25/00:08:a0:ca:72/00:00:4f:00:00/f0 tag 0 dma 4096 in
[44117.869350]          res 51/40:00:a3:ca:72/40:00:4f:00:00/f0 Emask 0x9 (media error)
[44117.869357] ata4.01: status: { DRDY ERR }
[44117.869363] ata4.01: error: { UNC }
[44118.052386] ata4.00: configured for UDMA/133
[44118.060320] ata4.01: configured for UDMA/133
[44118.060348] ata4: EH complete
[44121.695861] ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[44121.695870] ata4.01: BMDMA stat 0x64
[44121.695878] ata4.01: failed command: READ DMA EXT
[44121.695893] ata4.01: cmd 25/00:08:a0:ca:72/00:00:4f:00:00/f0 tag 0 dma 4096 in
[44121.695896]          res 51/40:00:a3:ca:72/40:00:4f:00:00/f0 Emask 0x9 (media error)
[44121.695903] ata4.01: status: { DRDY ERR }
[44121.695908] ata4.01: error: { UNC }
[44121.736972] ata4.00: configured for UDMA/133
[44121.744314] ata4.01: configured for UDMA/133
[44121.744347] sd 3:0:1:0: [sdf] Unhandled sense code
[44121.744354] sd 3:0:1:0: [sdf]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[44121.744362] sd 3:0:1:0: [sdf]  Sense Key : Medium Error [current] [descriptor]
[44121.744372] Descriptor sense data with sense descriptors (in hex):
[44121.744377]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[44121.744398]         4f 72 ca a3 
[44121.744408] sd 3:0:1:0: [sdf]  Add. Sense: Unrecovered read error - auto reallocate failed
[44121.744419] sd 3:0:1:0: [sdf] CDB: Read(10): 28 00 4f 72 ca a0 00 00 08 00
[44121.744439] end_request: I/O error, dev sdf, sector 1332923043
[44121.744477] ata4: EH complete
[44121.744519] BUG: unable to handle kernel NULL pointer dereference at           (null)
[44121.744556] IP: [<ffffffffa0321715>] ClearPageError+0x5/0x5 [btrfs]
[44121.744666] PGD 37fb6067 PUD 3b504067 PMD 0 
[44121.744692] Oops: 0000 [#1] SMP 
[44121.744707] CPU 2 
[44121.744714] Modules linked in: f71882fg coretemp nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc bonding mperf btrfs zlib_deflate i915 drm_kms_helper drm i2c_algo_bit intel_agp intel_gtt iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek snd_hda_intel snd_hda_codec sg snd_hwdep snd_pcm snd_timer snd soundcore r8169 i2c_i801 agpgart i2c_core pcspkr mii snd_page_alloc rng_core video button autofs4 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid10 raid0 raid1 md_mod uhci_hcd ehci_hcd usbcore usb_common processor thermal_sys hwmon
[44121.744956] 
[44121.744966] Pid: 2569, comm: btrfs-endio-meta-3 Not tainted 3.2.9-jng4-default #1 MICRO-STAR INTERNATIONAL CO.,LTD RX945GC/RX945GC
[44121.745000] RIP: 0010:[<ffffffffa0321715>]  [<ffffffffa0321715>] ClearPageError+0x5/0x5 [btrfs]
[44121.745090] RSP: 0018:ffff880032de9e08  EFLAGS: 00010246
[44121.745104] RAX: 0000000000000000 RBX: 0000013dcc4b5000 RCX: 0000000000000000
[44121.745133] RDX: 0000000000000001 RSI: 0000000013dcc4b5 RDI: 0000000000000000
[44121.745162] RBP: ffff880035156c18 R08: 0000000000000000 R09: 0000000000000037
[44121.745191] R10: 0000000000004003 R11: 0000013dcc4b5000 R12: 0000013dcc4b55ff
[44121.745219] R13: 0000000000000000 R14: ffff880032c46280 R15: ffff880032de9e98
[44121.745249] FS:  0000000000000000(0000) GS:ffff88003f731000(0000) knlGS:0000000000000000
[44121.745290] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[44121.745316] CR2: 0000000000000000 CR3: 000000003bcdb000 CR4: 00000000000006e0
[44121.745345] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[44121.745374] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[44121.745402] Process btrfs-endio-meta-3 (pid: 2569, threadinfo ffff880032de8000, task ffff880032c46280)
[44121.745444] Stack:
[44121.745465]  ffffffffa0325e6f ffff8800307776c0 ffff88001c9f3d78 ffff8800335d3000
[44121.745517]  ffff88001c9f3d78 ffff880032c46280 ffffffffa0307bc0 ffff8800337721c0
[44121.745567]  ffff880032c46280 ffff880032c46280 ffffffffa032ccf5 0000000000000000
[44121.745616] Call Trace:
[44121.745941]  [<ffffffffa0325e6f>] extent_range_uptodate+0x71/0xa1 [btrfs]
[44121.746260]  [<ffffffffa0307bc0>] end_workqueue_fn+0x23/0x67 [btrfs]
[44121.746457]  [<ffffffffa032ccf5>] worker_loop+0x92/0x2ad [btrfs]
[44121.746751]  [<ffffffff81056d59>] kthread+0x76/0x7e
[44121.746787]  [<ffffffff813d2234>] kernel_thread_helper+0x4/0x10
[44121.746817] Code: 5d c3 0f 18 0f c3 f0 ff 07 c3 f0 ff 0f 0f 94 c0 84 c0 0f 95 c0 0f b6 c0 c3 f0 81 07 00 00 10 00 c3 f0 80 0f 02 c3 f0 80 27 fd c3 <48> 8b 07 48 c1 e8 03 83 e0 01 74 00 c3 f0 80 0f 08 c3 f0 80 27 
[44121.747047] RIP  [<ffffffffa0321715>] ClearPageError+0x5/0x5 [btrfs]
[44121.747139]  RSP <ffff880032de9e08>
[44121.747161] CR2: 0000000000000000
[44121.747444] ---[ end trace 2649150eabf37498 ]---

