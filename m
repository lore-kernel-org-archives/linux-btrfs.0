From: cwillu <cwillu@cwillu.com>
Subject: Re: BUG while writing to USB btrfs filesystem
Date: Sun, 30 Jan 2011 23:18:24 -0600
Message-ID: <AANLkTin2_on1iwzq78ZzYqzuuA14w-tvHvWMqenrgT=1@mail.gmail.com>
References: <AANLkTimjuO=RcVciFCo5MKPnVArvXBLnhs2taS5cOw6f@mail.gmail.com>
	<AANLkTim6a_xv7gf-OHbhtV75eJesCF4gLDB-aHxkM-PX@mail.gmail.com>
	<AANLkTim_+yfC4i21uu65eaEapjwdc6X2yV9bunwXezOx@mail.gmail.com>
	<4D46250D.2090403@csamuel.org>
	<AANLkTinFq=EfJDU6EUTGN6J9rP2aw849o+KvGV_C-L4G@mail.gmail.com>
	<4D462DE7.7050502@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D462DE7.7050502@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Another one, with the process running on a btrfs chroot instead of tmpfs:


[12350.410412] ------------[ cut here ]------------
[12350.420001] kernel BUG at /home/kernel-ppa/COD/linux/fs/btrfs/inode.c:1759!
[12350.420001] invalid opcode: 0000 [#1] SMP
[12350.420001] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sda/sda3/alignment_offset
[12350.420001] CPU 3
[12350.420001] Modules linked in: binfmt_misc ppdev ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp aes_x86_64 snd_hda_codec_realtek aes_generic dm_crypt
snd_hda_intel snd_hda_codec lp snd_hwdep snd_pcm snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
asus_atk0110 snd soundcore snd_page_alloc parport raid10 raid456
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx raid1 raid0 multipath linear btrfs zlib_deflate libcrc32c
radeon ttm drm_kms_helper drm usbhid usb_storage hid uas ahci
i2c_algo_bit r8169 libahci pata_jmicron
[12350.420001]
[12350.420001] Pid: 8030, comm: btrfs-endio-wri Not tainted
2.6.38-020638rc2-generic #201101220905 P5Q3/System Product Name
[12350.420001] RIP: 0010:[<ffffffffa021a22d>]  [<ffffffffa021a22d>]
btrfs_finish_ordered_io+0x22d/0x320 [btrfs]
[12350.420001] RSP: 0000:ffff8801fc841d30  EFLAGS: 00010286
[12350.420001] RAX: 00000000ffffffe4 RBX: ffff8801fd4ec030 RCX: ffffffffa01f304f
[12350.420001] RDX: ffff88022ca37c60 RSI: ffffea00079c3c08 RDI: 0000000000000206
[12350.420001] RBP: ffff8801fc841da0 R08: ffff8800bfd97cd0 R09: ffff8801fc841b50
[12350.420001] R10: 0000000000000001 R11: 0000000000000024 R12: ffff8801fd4ec198
[12350.420001] R13: ffff88022b15d800 R14: 0000000000000000 R15: ffff880227c46b00
[12350.420001] FS:  0000000000000000(0000) GS:ffff8800bfd80000(0000)
knlGS:0000000000000000
[12350.420001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12350.420001] CR2: 00007f4b565810c8 CR3: 00000001fbdb5000 CR4: 00000000000006e0
[12350.420001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12350.420001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12350.420001] Process btrfs-endio-wri (pid: 8030, threadinfo
ffff8801fc840000, task ffff8802007dc440)
[12350.420001] Stack:
[12350.420001]  0000000000001000 ffffffff00000000 ffffffff00000000
ffff880200000000
[12350.420001]  0000000000000001 ffff8801fc841db0 0000000000570000
0000000000000000
[12350.420001]  ffff880204f13600 ffffea000541e840 ffff8800a85eb7f0
000000000001e000
[12350.420001] Call Trace:
[12350.420001]  [<ffffffffa021a4ea>]
btrfs_writepage_end_io_hook+0x1a/0x20 [btrfs]
[12350.420001]  [<ffffffffa0232f51>] end_bio_extent_writepage+0x51/0x180 [btrfs]
[12350.420001]  [<ffffffff8118cf2d>] bio_endio+0x1d/0x40
[12350.420001]  [<ffffffffa020e998>] end_workqueue_fn+0x68/0xa0 [btrfs]
[12350.420001]  [<ffffffffa023f26c>] worker_loop+0xac/0x260 [btrfs]
[12350.420001]  [<ffffffffa023f1c0>] ? worker_loop+0x0/0x260 [btrfs]
[12350.420001]  [<ffffffff81085147>] kthread+0x97/0xa0
[12350.420001]  [<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
[12350.420001]  [<ffffffff810850b0>] ? kthread+0x0/0xa0
[12350.420001]  [<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x10
[12350.420001] Code: 48 40 e8 b7 cf ff ff 48 8b 55 d0 31 f6 4c 89 e7
e8 b9 67 01 00 4c 89 e2 4c 89 ee 4c 89 ff e8 bb ea ff ff 85 c0 0f 84
d5 fe ff ff <0f> 0b eb fe be 01 00 00 00 4c 89 ef e8 d2 ad ff ff 49 89
c7 e9
[12350.420001] RIP  [<ffffffffa021a22d>]
btrfs_finish_ordered_io+0x22d/0x320 [btrfs]
[12350.420001]  RSP <ffff8801fc841d30>
[12351.594605] ---[ end trace f06f9985fbc265cd ]---
