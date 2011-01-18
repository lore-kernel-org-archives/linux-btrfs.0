From: cwillu <cwillu@cwillu.com>
Subject: BUG while writing to USB btrfs filesystem
Date: Tue, 18 Jan 2011 16:28:51 -0600
Message-ID: <AANLkTimjuO=RcVciFCo5MKPnVArvXBLnhs2taS5cOw6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While untar'ing an image to an sd card via a reader, I got the
following bug.  The system also has a btrfs root, and a whole swath of
processes went into uninterruptable sleep.  I was able to poke around
via ssh and sysrq, and already had netconsole set up to capture the
bug.

Root fs is on /dev/sdi1, and /dev/sdj2 is the card reader which was
the target of the untar.

[29571.448889] sd 11:0:0:0: [sdj] Assuming drive cache: write through
[29571.451153]  sdj: unknown partition table
[29572.047390] sd 11:0:0:0: [sdj] Assuming drive cache: write through
[29572.048149]  sdj: sdj1 sdj2
[29602.642175] device fsid 5648f85292725e76-72190c37da5211b6 devid 1
transid 7 /dev/sdj2
[29602.643256] btrfs: use spread ssd allocation scheme
[36852.550219] sd 11:0:0:0: [sdj] Assuming drive cache: write through
[36852.552958]  sdj: unknown partition table
[36852.571770] ------------[ cut here ]------------
[36852.580008] kernel BUG at fs/btrfs/inode.c:1629!
[36852.580008] invalid opcode: 0000 [#1] SMP [36852.580008] invalid
opcode: 0000 [#1] SMP
[36852.580008] last sysfs file:
/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/uevent
[36852.580008] CPU 2
[36852.580008] Modules linked in: netconsole configfs nls_cp437 vfat
fat binfmt_misc ppdev configfs ipt_MASQUERADE iptable_nat
nls_iso8859_1 nf_nat nf_conntrack_ipv4 nls_cp437 nf_defrag_ipv4
ipt_REJECT aes_generic snd_rawmidi snd_rawmidi snd_seq_midi_event
snd_seq snd_timer snd_seq_device asus_atk0110 lp snd soundcore
snd_page_alloc shpchp parport raid10 raid456 snd_page_alloc async_pq
async_xor xor async_memcpy shpchp async_raid6_recov parport raid6_pq
async_tx raid10 raid1 raid0 multipath linear raid456 btrfs
zlib_deflate async_pq async_xor xor async_memcpy async_raid6_recov
raid6_pq async_tx raid1 raid0 multipath linear btrfs zlib_deflate
lzo_compress crc32c libcrc32c radeon ttm lzo_compress ohci1394
drm_kms_helper crc32c usb_storage ieee1394 r8169 libcrc32c drm
i2c_algo_bit mii radeon pata_jmicron ahci libahci intel_agp ttm
ohci1394 drm_kms_helper usb_storage ieee1394 r8169 drm i2c_algo_bit
mii pata_jmicron ahci libahci intel_agp

[36852.580008]
[36852.580008] Pid: 437, comm: btrfs-endio-wri Not tainted
2.6.36-btrfs2 #1 P5Q3/System Product Name
[36852.580008] RIP: 0010:[<ffffffffa0224120>] [<ffffffffa0224120>]
T.1224+0x220/0x230 [btrfs]
[36852.580008] RSP: 0000:ffff880231c7dc30  EFLAGS: 00010286
[36852.580008] RAX: 00000000ffffffe4 RBX: ffff88023363a7e0 RCX: ffff88023363ad80
[36852.580008] RDX: 0000000000000000 RSI: ffffea0007b3dcb0 RDI: 0000000000000206
[36852.580008] RBP: ffff880231c7dcc0 R08: 0000000000000005 R09: 00000000ffffffe4
[36852.940017] R10: 0000000000000000 R11: 6db6db6db6db6db7 R12: ffff88022ec8ea80
[36852.940017] R13: 000000000e19a000 R14: ffff88023173c000 R15: ffff8802335fe900
[36852.940017] FS:  0000000000000000(0000) GS:ffff880001f00000(0000)
knlGS:0000000000000000
[36852.940017] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[36852.940017] CR2: 00000000017ed2d8 CR3: 00000001d42ac000 CR4: 00000000000006e0
[36852.940017] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[36852.940017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[36852.940017] Process btrfs-endio-wri (pid: 437, threadinfo
ffff880231c7c000, task ffff880232738000)
[36852.940017] Stack:
[36852.940017]  000000000e19a000 0000000000001000 000000494189e000
0000000000001000
[36852.940017] <0> ffff880231c7dc70 ffffffff81582fde ffff8802335fe900
ffff88023173c000
[36852.940017] <0> ffff880231c7dcb0 ffffffffa0220e1c 000000000e19a000
ffff88022ec8ea80

[36853.210013] Call Trace:
[36853.210013]  [<ffffffff81582fde>] ? mutex_lock+0x1e/0x50
[36853.210013]  [<ffffffffa0220e1c>] ? start_transaction+0x1cc/0x270 [btrfs]
[36853.210013]  [<ffffffffa022495b>] btrfs_finish_ordered_io+0x2eb/0x330 [btrfs]
[36853.210013]  [<ffffffff81103157>] ? mempool_free_slab+0x17/0x20
[36853.210013]  [<ffffffffa02249ba>]
btrfs_writepage_end_io_hook+0x1a/0x20 [btrfs]
[36853.210013]  [<ffffffffa024217b>]
end_bio_extent_writepage+0x13b/0x180 [btrfs]
[36853.210013]  [<ffffffff815828bb>] ? schedule_timeout+0x19b/0x300
[36853.210013]  [<ffffffff8118212d>] bio_endio+0x1d/0x40
[36853.210013]  [<ffffffffa021a1b4>] end_workqueue_fn+0xf4/0x130 [btrfs]
[36853.210013]  [<ffffffffa024d1cc>] worker_loop+0x15c/0x640 [btrfs]
[36853.210013]  [<ffffffffa024d070>] ? worker_loop+0x0/0x640 [btrfs]
[36853.210013]  [<ffffffff81080bf6>] kthread+0x96/0xa0
[36853.210013]  [<ffffffff8100bea4>] kernel_thread_helper+0x4/0x10
[36853.210013]  [<ffffffff81080b60>] ? kthread+0x0/0xa0
[36853.210013]  [<ffffffff8100bea0>] ? kernel_thread_helper+0x0/0x10
[36853.210013] Code: 68 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 0f 0b
eb fe 66 0f 1f 84 00 00 00 00 00 0f 0b eb fe 0f 1f 40 00 0f 0b eb fe
0f 1f 40 00 <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
e5 41
[36853.210013] RIP  [<ffffffffa0224120>] T.1224+0x220/0x230 [btrfs]
[36853.690010]  RSP <ffff880231c7dc30>
[36853.877226] ---[ end trace 101a91b31ae9f3ff ]---
