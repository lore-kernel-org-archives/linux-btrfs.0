Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i2.italiaonline.it ([212.48.25.204]:47587 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751860AbbHSRTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 13:19:41 -0400
Reply-To: kreijack@inwind.it
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [BUG][v4.2-rc7] Problem replacing a "missing" disk for a
 raid5-degraded filesystem
Message-ID: <55D4B8B8.3000806@libero.it>
Date: Wed, 19 Aug 2015 19:11:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

playing with raid5 and "btrfs replace" I found a BUG. Basically it seems that if I try to replace a "missing" disk of a "degraded" filesystem I got a kernel BUG. This is reproducible at 100% for me.

To simulate the disk removal, I started qemu and I used the command "drive_del drive-virtio-disk1". Doing so, the "removed" disk (vdj) is still present on the system, but it returns an I/O error:


$ sudo cat /dev/vdj 
cat: /dev/vdj: Input/output error

Note, if I removed the disk but I don't "unmount" and-then "mount -o degraded" the filesystem, the replace works fine.


Below the step to reproduce kernel bug.
BR
G.Baroncelli

ghigo@emulato:~$ ./btrfs --version	
btrfs-progs v4.1.2
ghigo@emulato:~$ uname -a
Linux emulato.virtual 4.2.0-rc7 #207 SMP Tue Aug 18 15:34:31 CEST 2015 x86_64 GNU/Linux

$ sudo ./mkfs.btrfs -f -M -d raid5 -m raid5 /dev/vd[efj]
SMALL VOLUME: forcing mixed metadata/data groups
btrfs-progs v4.0
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               af4f8af5-66cb-4e46-b2fe-3d332f44eefe
Node size:          4096
Sector size:        4096
Filesystem size:    150.00GiB
Block group profiles:
  Data+Metadata:    RAID5             2.01GiB
  System:           RAID5            20.00MiB
SSD detected:       no
Incompat features:  mixed-bg, extref, raid56, skinny-metadata
Number of devices:  3
Devices:
   ID        SIZE  PATH
    1    50.00GiB  /dev/vde
    2    50.00GiB  /dev/vdf
    3    50.00GiB  /dev/vdj

$ sudo mount /dev/vde /mnt/btrfs1/
$ sudo cp -rfva /lib/modules/4.2.0-rc7/ /mnt/btrfs1/

During the copy I disconnected the disk /dev/vdj doing a
	(qemu) drive_del drive-virtio-disk1
in qemu monitor.

$ sudo umount /mnt/btrfs1/                         # <-- without these the bug
$ sudo mount -o degraded /dev/vde /mnt/btrfs1/     # <-- doesn't happen: the replace 
                                                   # <-- command works fine

$ sudo ./btrfs replace start -rf 3 /dev/vdd /mnt/btrfs1/

And then I got:

[  206.685533] BTRFS: dev_replace from <missing disk> (devid 3) to /dev/vdd started

[  206.691996] BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
[  206.714714] IP: [<ffffffff8128bbb1>] bio_add_page+0x11/0x90
[  206.716173] PGD bada0067 PUD bada1067 PMD 0 
[  206.717503] Oops: 0000 [#1] SMP 
[  206.718532] Modules linked in: acpi_cpufreq processor thermal_sys cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc 9p 9pnet fscache dm_mod md_mod ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor raid6_pq sr_mod cdrom sd_mod virtio_blk virtio_net ata_generic ata_piix floppy virtio_pci virtio_ring virtio libata scsi_mod
[  206.727897] CPU: 1 PID: 1938 Comm: btrfs Not tainted 4.2.0-rc7 #207
[  206.728727] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[  206.729960] task: ffff8800b96e3400 ti: ffff8800b95e0000 task.ti: ffff8800b95e0000
[  206.731012] RIP: 0010:[<ffffffff8128bbb1>]  [<ffffffff8128bbb1>] bio_add_page+0x11/0x90
[  206.732179] RSP: 0018:ffff8800b95e37f8  EFLAGS: 00010292
[  206.732905] RAX: 0000000000000000 RBX: ffff8800a08c4e00 RCX: 0000000000000000
[  206.733842] RDX: 0000000000001000 RSI: ffffea0002eb1f80 RDI: ffff88007f0f4aa8
[  206.734750] RBP: ffff8800b7e21218 R08: ffffffff817298e8 R09: 0000000000000000
[  206.735660] R10: 0000000000000800 R11: 0000000000000000 R12: ffff8800b7e21220
[  206.736615] R13: ffff8800bb155280 R14: ffff88007f1ae8c0 R15: ffff8800b7e21000
[  206.737579] FS:  00007f1dbe4388c0(0000) GS:ffff8800bfb00000(0000) knlGS:0000000000000000
[  206.738713] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  206.739495] CR2: 0000000000000098 CR3: 00000000a060f000 CR4: 00000000000006e0
[  206.740420] Stack:
[  206.740793]  ffffffff00000000 ffffffffa01d8639 0000000000000050 ffff8800b95e3838
[  206.742076]  0000000000000000 ffff8800b96e3400 0000000000000000 ffffffff811951cc
[  206.761559]  0000000000c00000 0000000000000000 ffff8800bab7a800 ffff8800bb155280
[  206.763839] Call Trace:
[  206.764666]  [<ffffffffa01d8639>] ? scrub_add_page_to_rd_bio+0xa9/0x280 [btrfs]
[  206.766592]  [<ffffffff811951cc>] ? alloc_pages_current+0x8c/0xf0
[  206.768076]  [<ffffffffa01dada6>] ? scrub_pages+0x1f6/0x280 [btrfs]
[  206.769611]  [<ffffffffa01dba07>] ? scrub_stripe+0x807/0x1020 [btrfs]
[  206.771164]  [<ffffffff81153bfc>] ? __alloc_pages_nodemask+0x19c/0x9e0
[  206.772674]  [<ffffffffa01dc324>] ? scrub_chunk.isra.19+0x104/0x120 [btrfs]
[  206.773607]  [<ffffffffa01dc574>] ? scrub_enumerate_chunks+0x234/0x470 [btrfs]
[  206.774648]  [<ffffffffa01db190>] ? scrub_setup_ctx.isra.18+0x210/0x280 [btrfs]
[  206.775700]  [<ffffffffa01dde93>] ? btrfs_scrub_dev+0x1b3/0x500 [btrfs]
[  206.776625]  [<ffffffffa01823f1>] ? btrfs_commit_transaction+0x9b1/0xa90 [btrfs]
[  206.777716]  [<ffffffffa0182567>] ? start_transaction+0x97/0x580 [btrfs]
[  206.778590]  [<ffffffffa01f085c>] ? btrfs_dev_replace_start+0x33c/0x3a0 [btrfs]
[  206.779640]  [<ffffffffa01b8ef3>] ? btrfs_ioctl+0x1b33/0x26f0 [btrfs]
[  206.780489]  [<ffffffff81176bdf>] ? do_set_pte+0xcf/0x100
[  206.781246]  [<ffffffff8114babd>] ? filemap_map_pages+0x20d/0x220
[  206.782050]  [<ffffffff810621d8>] ? pte_alloc_one+0x28/0x40
[  206.782798]  [<ffffffff811794b4>] ? handle_mm_fault+0xfc4/0x15f0
[  206.783593]  [<ffffffff811bb4ce>] ? cp_new_stat+0x13e/0x160
[  206.784338]  [<ffffffff811c8c6f>] ? do_vfs_ioctl+0x28f/0x470
[  206.785204]  [<ffffffff811c8ec4>] ? SyS_ioctl+0x74/0x80
[  206.786016]  [<ffffffff815388b2>] ? entry_SYSCALL_64_fastpath+0x16/0x75
[  206.786986] Code: 83 c4 08 c3 48 83 c4 08 e9 9d fd ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 83 ec 08 48 8b 47 08 4c 8b 57 20 <48> 8b 80 98 00 00 00 4c 8b 88 80 03 00 00 41 8b 81 fc 06 00 00 
[  206.808060] RIP  [<ffffffff8128bbb1>] bio_add_page+0x11/0x90
[  206.808969]  RSP <ffff8800b95e37f8>
[  206.809516] CR2: 0000000000000098
[  206.810046] ---[ end trace 4a9d0280b5ca1f36 ]---



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
