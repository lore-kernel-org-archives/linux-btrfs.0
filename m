From: cwillu <cwillu@cwillu.com>
Subject: Re: BUG while writing to USB btrfs filesystem
Date: Sun, 30 Jan 2011 19:33:14 -0600
Message-ID: <AANLkTim_+yfC4i21uu65eaEapjwdc6X2yV9bunwXezOx@mail.gmail.com>
References: <AANLkTimjuO=RcVciFCo5MKPnVArvXBLnhs2taS5cOw6f@mail.gmail.com>
	<AANLkTim6a_xv7gf-OHbhtV75eJesCF4gLDB-aHxkM-PX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim6a_xv7gf-OHbhtV75eJesCF4gLDB-aHxkM-PX@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

And again, without the USB devices.

This time was under a vanilla 2.6.38rc2 build, rootfs is a 4-drive
btrfs raid10 connected internally via sata, and no other drives in the
picture.

The btrfs drives are sda5, sdb1, sdc1 and sdd1;  sda1 is /boot, sda2
is swap, sda3 is a 4gb ext4 with a small install for recovery
purposes.

[33159.480523] ------------[ cut here ]------------
[33159.490003] kernel BUG at /home/kernel-ppa/COD/linux/fs/btrfs/inode.c:1629!
[33159.490003] invalid opcode: 0000 [#1] SMP
[33159.490003] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sda/sda3/alignment_offset
[33159.490003] CPU 2
[33159.490003] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat
msdos fat jfs xfs exportfs reiserfs binfmt_misc ppdev ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm snd_seq_midi aes_x86_64 snd_rawmidi snd_seq_midi_event
aes_generic snd_seq snd_timer snd_seq_device dm_crypt snd asus_atk0110
soundcore snd_page_alloc lp parport raid10 raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0
multipath linear btrfs zlib_deflate libcrc32c radeon ttm
drm_kms_helper drm usb_storage usbhid hid uas ahci r8169 i2c_algo_bit
pata_jmicron libahci
[33159.490003]
[33159.490003] Pid: 32327, comm: btrfs-endio-wri Not tainted
2.6.38-020638rc2-generic #201101220905 P5Q3/System Product Name
[33159.490003] RIP: 0010:[<ffffffffa020cab0>]  [<ffffffffa020cab0>]
insert_reserved_file_extent+0x230/0x240 [btrfs]
[33159.490003] RSP: 0000:ffff8801ba199c90  EFLAGS: 00010286
[33159.490003] RAX: 00000000ffffffe4 RBX: ffff880212f51ef0 RCX: ffffffffa01e604f
[33159.490003] RDX: ffff88022c823870 RSI: ffffea00079bc7a8 RDI: 0000000000000206
[33159.490003] RBP: ffff8801ba199d20 R08: ffff8800bfd17cd0 R09: 0000000000000000
[33159.490003] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880212f52058
[33159.490003] R13: ffff88022c823ab0 R14: ffff880212f52058 R15: 0000000000003000
[33159.490003] FS:  0000000000000000(0000) GS:ffff8800bfd00000(0000)
knlGS:0000000000000000
[33159.490003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[33159.490003] CR2: 00007f32c49bad60 CR3: 00000001ba25a000 CR4: 00000000000006e0
[33159.490003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[33159.490003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[33159.490003] Process btrfs-endio-wri (pid: 32327, threadinfo
ffff8801ba198000, task ffff8802145d5b00)
[33159.490003] Stack:
[33159.490003]  00000000ba199cd0 0000000000001000 0000000000001000
000000266f846000
[33159.490003]  ffff88022cbc5540 ffff88022a7b6800 ffff8801fd8923c0
ffff88022a7b6800
[33159.490003]  ffff8801ba199d10 ffffffffa0207f82 0000000000000000
ffff880212f51ef0
[33159.490003] Call Trace:
[33159.490003]  [<ffffffffa0207f82>] ? start_transaction+0x1c2/0x230 [btrfs]
[33159.490003]  [<ffffffffa020d2b9>] btrfs_finish_ordered_io+0x2b9/0x320 [btrfs]
[33159.490003]  [<ffffffffa020d4ea>]
btrfs_writepage_end_io_hook+0x1a/0x20 [btrfs]
[33159.490003]  [<ffffffffa0225f51>] end_bio_extent_writepage+0x51/0x180 [btrfs]
[33159.490003]  [<ffffffff8118cf2d>] bio_endio+0x1d/0x40
[33159.490003]  [<ffffffffa0201998>] end_workqueue_fn+0x68/0xa0 [btrfs]
[33159.490003]  [<ffffffffa023226c>] worker_loop+0xac/0x260 [btrfs]
[33159.490003]  [<ffffffffa02321c0>] ? worker_loop+0x0/0x260 [btrfs]
[33159.490003]  [<ffffffff81085147>] kthread+0x97/0xa0
[33159.490003]  [<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
[33159.490003]  [<ffffffff810850b0>] ? kthread+0x0/0xa0
[33159.490003]  [<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x10
[33159.490003] Code: 89 ef e8 94 95 fd ff 48 83 c4 68 31 c0 5b 41 5c
41 5d 41 5e 41 5f c9 c3 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 1f 80
00 00 00 00 <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
e5 41
[33159.490003] RIP  [<ffffffffa020cab0>]
insert_reserved_file_extent+0x230/0x240 [btrfs]
[33159.490003]  RSP <ffff8801ba199c90>
[33160.625221] ---[ end trace fefff6d61e4f8a7d ]---
