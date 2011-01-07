From: Drunkard Zhang <gongfan193@gmail.com>
Subject: 2.6.37: Bug on btrfs while umount
Date: Fri, 7 Jan 2011 09:25:37 +0800
Message-ID: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Remote terminal hung while umount, here's dmesg:

[50010.838804] ------------[ cut here ]------------
[50010.838931] kernel BUG at fs/btrfs/inode.c:1616!
[50010.839053] invalid opcode: 0000 [#1] PREEMPT SMP
[50010.839185] last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
[50010.839307] CPU 0
[50010.839313] Modules linked in: ipt_addrtype btrfs k10temp
[50010.839541]
[50010.839653] Pid: 1681, comm: btrfs-endio-wri Not tainted 2.6.37 #1
3CESL /3CESL
[50010.839667] RIP: 0010:[<ffffffffa0027d9a>]  [<ffffffffa0027d9a>]
insert_reserved_file_extent+0x8d/0x212 [btrfs]
[50010.839667] RSP: 0018:ffff8807efaa9c40  EFLAGS: 00010286
[50010.839667] RAX: 00000000ffffffe4 RBX: ffff8807f73f37f0 RCX: ffffffffa0012555
[50010.839667] RDX: 0000000000000000 RSI: ffffea001bc124c0 RDI: ffff8807ee148cf0
[50010.839667] RBP: ffff8807efaa9cd0 R08: ffff8807efaa9b00 R09: ffff8807efaa99b0
[50010.839667] R10: ffff8807ee0a8090 R11: 0000000000000090 R12: ffff8807ee0a9040
[50010.839667] R13: ffff8807ee0a8000 R14: ffff8807ee148cf0 R15: 0000000400000000
[50010.839667] FS:  00007f9b5c4e3700(0000) GS:ffff8800c7c00000(0000)
knlGS:0000000000000000
[50010.839667] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[50010.839667] CR2: 0000000002076f80 CR3: 00000007efaaa000 CR4: 00000000000006f0
[50010.839667] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[50010.839667] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[50010.839667] Process btrfs-endio-wri (pid: 1681, threadinfo
ffff8807efaa8000, task ffff8807ef1e72c0)
[50010.839667] Stack:
[50010.839667]  00000000000fffff 0000000000100000 0000000000100000
0000000001100000
[50010.839667]  ffff8807ee0a9040 ffff8807f6d02000 ffff8807c36002d0
ffff8807ee0a9040
[50010.839667]  ffff8807efaa9cc0 ffffffffa0027821 ffff8807efaa9d18
ffff8807f73f37f0
[50010.839667] Call Trace:
[50010.839667]  [<ffffffffa0027821>] ? start_transaction+0x1a1/0x1d0 [btrfs]
[50010.839667]  [<ffffffffa002b65d>] btrfs_finish_ordered_io+0x1fa/0x2d4 [btrfs]
[50010.839667]  [<ffffffffa002b750>]
btrfs_writepage_end_io_hook+0x19/0x1b [btrfs]
[50010.839667]  [<ffffffffa00429a1>] end_bio_extent_writepage+0xa5/0x15b [btrfs]
[50010.839667]  [<ffffffff8111734d>] bio_endio+0x2c/0x2e
[50010.839667]  [<ffffffffa0023ad5>] end_workqueue_fn+0x10e/0x11a [btrfs]
[50010.839667]  [<ffffffffa004a876>] worker_loop+0x19c/0x4db [btrfs]
[50010.839667]  [<ffffffffa004a6da>] ? worker_loop+0x0/0x4db [btrfs]
[50010.839667]  [<ffffffff81057779>] kthread+0x81/0x89
[50010.839667]  [<ffffffff81003914>] kernel_thread_helper+0x4/0x10
[50010.839667]  [<ffffffff810576f8>] ? kthread+0x0/0x89
[50010.839667]  [<ffffffff81003910>] ? kernel_thread_helper+0x0/0x10
[50010.839667] Code: 80 88 88 00 00 00 08 4c 8d 45 c0 45 31 c9 48 8b
8d 78 ff ff ff 48 8b 7d 90 4c 89 fa 4c 89 f6 4c 01 f9 e8 81 c2 00 00
85 c0 74 04 <0f> 0b eb fe 49 8b 46 50 48 8b 75 98 4c 8d 45 cc 48 8b 7d
90 48
[50010.839667] RIP  [<ffffffffa0027d9a>]
insert_reserved_file_extent+0x8d/0x212 [btrfs]
[50010.839667]  RSP <ffff8807efaa9c40>
[50010.849041] ---[ end trace c5fabb63a425946d ]---

Related info:
squid75 ~ # uname -a
Linux squid75 2.6.37 #1 SMP PREEMPT Thu Jan 6 00:56:39 CST 2011 x86_64
Quad-Core AMD Opteron(tm) Processor 2356 AuthenticAMD GNU/Linux
squid75 ~ # sdparm -i /dev/sd[bc]
    /dev/sdb: ATA       INTEL SSDSA2M080  2CV1
Device identification VPD page:
  Addressed logical unit:
    designator type: vendor specific [0x0],  code set: ASCII
 00     43 56 50 4f 30 33 39 32  30 33 50 52 30 38 30 4a    CVPO039203PR080J
 10     47 4e 20 20                                         GN
    designator type: T10 vendor identification,  code set: ASCII
      vendor id: ATA
      vendor specific: INTEL SSDSA2M080G2GC
CVPO039203PR080JGN
    /dev/sdc: ATA       INTEL SSDSA2M080  2CV1
Device identification VPD page:
  Addressed logical unit:
    designator type: vendor specific [0x0],  code set: ASCII
 00     43 56 50 4f 30 33 39 33  30 31 4a 53 30 38 30 4a    CVPO039301JS080J
 10     47 4e 20 20                                         GN
    designator type: T10 vendor identification,  code set: ASCII
      vendor id: ATA
      vendor specific: INTEL SSDSA2M080G2GC
CVPO039301JS080JGN
squid75 ~ # hdparm -i /dev/sd[bc]
/dev/sdb:
 Model=INTEL SSDSA2M080G2GC, FwRev=2CV102HD, SerialNo=CVPO039203PR080JGN
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=0
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=2
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=156301488
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: ATA/ATAPI-7 T13 1532D revision 1:  ATA/ATAPI-2,3,4,5,6,7
 * signifies the current active mode

/dev/sdc:
 Model=INTEL SSDSA2M080G2GC, FwRev=2CV102HD, SerialNo=CVPO039301JS080JGN
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=0
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=2
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=156301488
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: ATA/ATAPI-7 T13 1532D revision 1:  ATA/ATAPI-2,3,4,5,6,7
 * signifies the current active mode
[striped useless blank lines]

Here's `df` while hung up:
/dev/sdb1             9.9G  5.6G  3.8G  60% /mnt/b
/dev/sdc1              75G  2.1M   73G   1% /mnt/c

below is regular `df`:
/dev/sdb1              75G  2.1M   73G   1% /mnt/b
/dev/sdc1              75G  2.1M   73G   1% /mnt/c

The kernel is static compiled except some mods. I can not reproduce it any more.
