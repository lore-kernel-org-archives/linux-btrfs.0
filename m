Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51976 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2IDR0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2012 13:26:45 -0400
Received: by eaac11 with SMTP id c11so2035219eaa.19
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2012 10:26:43 -0700 (PDT)
Message-ID: <1346779594.24415.17.camel@lapoo.opensvc.com>
Subject: Re: [ANNOUNCE] opensvc btrfs send/receive driver
From: Christophe Varoqui <christophe.varoqui@gmail.com>
Reply-To: christophe.varoqui@opensvc.com
To: linux-btrfs@vger.kernel.org
Date: Tue, 04 Sep 2012 19:26:34 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are the stacks encountered during the opensvc btrfs send/receive
development.

The system is a debian squeeze amd64 in a kvm over debian squeeze amd64.
The disks handed to btrfs are logical volumes passed to the kvm as vdb
and vdc. The vm kernel is 3.6rc3 and btrfs-progs are at git commit
043a63924c9831ac52ce38f0365b9bfd628fb6a3 (Thu, 9 Aug 2012). 


For the 2 first stacks below, the btrfs volume was formatted using
"mkfs.btrfs -L data /dev/vdb /dev/vdc". This format gave me the most
stable system.



Sep  4 09:02:15 deb1 kernel: [290899.676202] ------------[ cut here
]------------
Sep  4 09:02:15 deb1 kernel: [290899.676261] WARNING: at
fs/btrfs/extent_io.c:4674 map_private_extent_buffer+0x83/0xc9 [btrfs]()
Sep  4 09:02:15 deb1 kernel: [290899.676271] Hardware name: Bochs
Sep  4 09:02:15 deb1 kernel: [290899.676274] Modules linked in: btrfs
zlib_deflate crc32c libcrc32c sha1_generic hmac drbd lru_cache cn
binfmt_misc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext2 loop tpm_tis
joydev processor snd_pcm snd_timer snd soundcore snd_page_alloc tpm
virtio_balloon hid_generic i2c_piix4 tpm_bios i2c_core evdev thermal_sys
pcspkr microcode psmouse serio_raw button usbhid hid ext3 jbd mbcache
dm_mod ide_cd_mod cdrom ata_generic ata_piix libata scsi_mod virtio_blk
virtio_net floppy uhci_hcd ehci_hcd piix ide_core usbcore usb_common
virtio_pci virtio_ring virtio
Sep  4 09:02:15 deb1 kernel: [290899.676500] Pid: 16675, comm: btrfs Not
tainted 3.6.0-rc3 #1
Sep  4 09:02:15 deb1 kernel: [290899.676502] Call Trace:
Sep  4 09:02:15 deb1 kernel: [290899.676532]  [<ffffffff8103ed20>] ?
warn_slowpath_common+0x78/0x8c
Sep  4 09:02:15 deb1 kernel: [290899.676547]  [<ffffffffa044aaca>] ?
map_private_extent_buffer+0x83/0xc9 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676598]  [<ffffffffa0448763>] ?
btrfs_get_token_64+0x79/0xca [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676614]  [<ffffffffa047f74a>] ?
process_extent+0xb9/0xb25 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676625]  [<ffffffffa047eb77>] ?
send_utimes+0x149/0x15b [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676636]  [<ffffffffa0432136>] ?
btrfs_buffer_uptodate+0x57/0x57 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676647]  [<ffffffffa0434577>] ?
T.1226+0x82/0x106 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676657]  [<ffffffffa0480969>] ?
changed_cb+0x7b3/0x7ca [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676665]  [<ffffffffa0419295>] ?
btrfs_item_key_to_cpu+0x10/0x2d [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676673]  [<ffffffffa0419873>] ?
tree_advance+0x127/0x168 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676685]  [<ffffffffa044882b>] ?
btrfs_get_token_32+0x77/0xca [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676698]  [<ffffffffa044b2b1>] ?
memcmp_extent_buffer+0xc5/0xe4 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676707]  [<ffffffffa0421fe1>] ?
btrfs_compare_trees+0x61c/0x7ab [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676717]  [<ffffffffa04801b6>] ?
process_extent+0xb25/0xb25 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676727]  [<ffffffffa047c585>] ?
write_buf+0x51/0x84 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676737]  [<ffffffffa0480f47>] ?
btrfs_ioctl_send+0x5c7/0x8f1 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676753]  [<ffffffff81101b00>] ?
kmem_cache_shrink+0x122/0x19c
Sep  4 09:02:15 deb1 kernel: [290899.676766]  [<ffffffffa045e37d>] ?
btrfs_ioctl+0x120a/0x1331 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.676770]  [<ffffffff81100920>] ?
__kmalloc+0xf0/0x100
Sep  4 09:02:15 deb1 kernel: [290899.676783]  [<ffffffff81014ba4>] ?
sched_clock+0x5/0x8
Sep  4 09:02:15 deb1 kernel: [290899.676794]  [<ffffffff81069013>] ?
sched_clock_local+0x13/0x76
Sep  4 09:02:15 deb1 kernel: [290899.676798]  [<ffffffff8106cb52>] ?
enqueue_task_fair+0x127/0x270
Sep  4 09:02:15 deb1 kernel: [290899.676809]  [<ffffffff81114f2c>] ?
do_vfs_ioctl+0x44b/0x490
Sep  4 09:02:15 deb1 kernel: [290899.676812]  [<ffffffff8103e78a>] ?
do_fork+0x190/0x256
Sep  4 09:02:15 deb1 kernel: [290899.676814]  [<ffffffff81114fbc>] ?
sys_ioctl+0x4b/0x6f
Sep  4 09:02:15 deb1 kernel: [290899.676830]  [<ffffffff8135ed03>] ?
stub_clone+0x13/0x20
Sep  4 09:02:15 deb1 kernel: [290899.676833]  [<ffffffff8135e9f9>] ?
system_call_fastpath+0x16/0x1b
Sep  4 09:02:15 deb1 kernel: [290899.676834] ---[ end trace
ed6ba08da487db8e ]---



Sep  4 09:02:15 deb1 kernel: [290899.677093] general protection fault:
0000 [#1] SMP 
Sep  4 09:02:15 deb1 kernel: [290899.677429] Modules linked in: btrfs
zlib_deflate crc32c libcrc32c sha1_generic hmac drbd lru_cache cn
binfmt_misc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext2 loop tpm_tis
joydev processor snd_pcm snd_timer snd soundcore snd_page_alloc tpm
virtio_balloon hid_generic i2c_piix4 tpm_bios i2c_core evdev thermal_sys
pcspkr microcode psmouse serio_raw button usbhid hid ext3 jbd mbcache
dm_mod ide_cd_mod cdrom ata_generic ata_piix libata scsi_mod virtio_blk
virtio_net floppy uhci_hcd ehci_hcd piix ide_core usbcore usb_common
virtio_pci virtio_ring virtio
Sep  4 09:02:15 deb1 kernel: [290899.682063] CPU 1 
Sep  4 09:02:15 deb1 kernel: [290899.682150] Pid: 16675, comm: btrfs
Tainted: G        W    3.6.0-rc3 #1 Bochs Bochs
Sep  4 09:02:15 deb1 kernel: [290899.683170] RIP:
0010:[<ffffffffa044afc9>]  [<ffffffffa044afc9>] read_extent_buffer
+0xc3/0xd8 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.683832] RSP: 0018:ffff88000b1159a8
EFLAGS: 00010206
Sep  4 09:02:15 deb1 kernel: [290899.684284] RAX: 0000000000000008 RBX:
ffff8800146e0c18 RCX: 0000000000000008
Sep  4 09:02:15 deb1 kernel: [290899.684954] RDX: 0000000000000010 RSI:
0005080000000005 RDI: ffff88000b1159d8
Sep  4 09:02:15 deb1 kernel: [290899.685592] RBP: ffff88000b1159d8 R08:
ffff880000000000 R09: 0000160000000000
Sep  4 09:02:15 deb1 kernel: [290899.686233] R10: 0000000000001000 R11:
0000000000000000 R12: 0000000000000000
Sep  4 09:02:15 deb1 kernel: [290899.686824] R13: 000000000000100d R14:
0000000000000001 R15: 0000000000000fd8
Sep  4 09:02:15 deb1 kernel: [290899.687453] FS:  00007fbf03462740(0000)
GS:ffff88001fc80000(0000) knlGS:0000000000000000
Sep  4 09:02:15 deb1 kernel: [290899.688173] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Sep  4 09:02:15 deb1 kernel: [290899.688711] CR2: 00007fbf0284cfb8 CR3:
000000001dd37000 CR4: 00000000000006e0
Sep  4 09:02:15 deb1 kernel: [290899.689346] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Sep  4 09:02:15 deb1 kernel: [290899.689932] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Sep  4 09:02:15 deb1 kernel: [290899.690560] Process btrfs (pid: 16675,
threadinfo ffff88000b114000, task ffff88001d364420)
Sep  4 09:02:15 deb1 kernel: [290899.691221] Stack:
Sep  4 09:02:15 deb1 kernel: [290899.691524]  0000000000000000
ffff8800146e0c18 0000000000000fd8 000000000000002d
Sep  4 09:02:15 deb1 kernel: [290899.692423]  0000000000001005
ffffffffa044877a 0000000000001000 0000000000001000
Sep  4 09:02:15 deb1 kernel: [290899.693211]  0000000000001000
ffff88001d30e000 ffff8800108bc800 ffff88001d964510
Sep  4 09:02:15 deb1 kernel: [290899.694175] Call Trace:
Sep  4 09:02:15 deb1 kernel: [290899.694503]  [<ffffffffa044877a>] ?
btrfs_get_token_64+0x90/0xca [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.694976]  [<ffffffffa047f74a>] ?
process_extent+0xb9/0xb25 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.695367]  [<ffffffffa047eb77>] ?
send_utimes+0x149/0x15b [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.695796]  [<ffffffffa0432136>] ?
btrfs_buffer_uptodate+0x57/0x57 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.696258]  [<ffffffffa0434577>] ?
T.1226+0x82/0x106 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.696711]  [<ffffffffa0480969>] ?
changed_cb+0x7b3/0x7ca [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.697196]  [<ffffffffa0419295>] ?
btrfs_item_key_to_cpu+0x10/0x2d [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.697571]  [<ffffffffa0419873>] ?
tree_advance+0x127/0x168 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.698063]  [<ffffffffa044882b>] ?
btrfs_get_token_32+0x77/0xca [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.698437]  [<ffffffffa044b2b1>] ?
memcmp_extent_buffer+0xc5/0xe4 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.698814]  [<ffffffffa0421fe1>] ?
btrfs_compare_trees+0x61c/0x7ab [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.699239]  [<ffffffffa04801b6>] ?
process_extent+0xb25/0xb25 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.699621]  [<ffffffffa047c585>] ?
write_buf+0x51/0x84 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.699969]  [<ffffffffa0480f47>] ?
btrfs_ioctl_send+0x5c7/0x8f1 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.700474]  [<ffffffff81101b00>] ?
kmem_cache_shrink+0x122/0x19c
Sep  4 09:02:15 deb1 kernel: [290899.701009]  [<ffffffffa045e37d>] ?
btrfs_ioctl+0x120a/0x1331 [btrfs]
Sep  4 09:02:15 deb1 kernel: [290899.701450]  [<ffffffff81100920>] ?
__kmalloc+0xf0/0x100
Sep  4 09:02:15 deb1 kernel: [290899.701791]  [<ffffffff81014ba4>] ?
sched_clock+0x5/0x8
Sep  4 09:02:15 deb1 kernel: [290899.702147]  [<ffffffff81069013>] ?
sched_clock_local+0x13/0x76
Sep  4 09:02:15 deb1 kernel: [290899.702582]  [<ffffffff8106cb52>] ?
enqueue_task_fair+0x127/0x270
Sep  4 09:02:15 deb1 kernel: [290899.703061]  [<ffffffff81114f2c>] ?
do_vfs_ioctl+0x44b/0x490
Sep  4 09:02:15 deb1 kernel: [290899.703437]  [<ffffffff8103e78a>] ?
do_fork+0x190/0x256
Sep  4 09:02:15 deb1 kernel: [290899.703766]  [<ffffffff81114fbc>] ?
sys_ioctl+0x4b/0x6f
Sep  4 09:02:15 deb1 kernel: [290899.704141]  [<ffffffff8135ed03>] ?
stub_clone+0x13/0x20
Sep  4 09:02:15 deb1 kernel: [290899.704643]  [<ffffffff8135e9f9>] ?
system_call_fastpath+0x16/0x1b
Sep  4 09:02:15 deb1 kernel: [290899.704995] Code: 4c 39 e0 48 8b 34 11
49 0f 47 c4 48 83 c2 08 49 29 c4 49 8d 0c 31 48 c1 f9 06 48 c1 e1 0c 4a
8d 34 01 48 89 c1 48 01 fe 48 89 ef <f3> a4 48 89 fd 31 ff 4d 85 e4 75
bc 5b 5d 41 5c 41 5d 41 5e c3 
Sep  4 09:02:15 deb1 kernel: [290899.707024]  RSP <ffff88000b1159a8>
Sep  4 09:02:15 deb1 kernel: [290899.707723] ---[ end trace
ed6ba08da487db90 ]---



The stacks below were produced with a btrfs formatted using "-m raid1 -d
raid1". These options induced more hangs.

Aug 29 00:38:53 deb1 kernel: [280841.951480] ------------[ cut here
]------------
Aug 29 00:38:53 deb1 kernel: [280841.952428] invalid opcode: 0000 [#1]
SMP 
Aug 29 00:38:53 deb1 kernel: [280841.952896] Modules linked in: btrfs
zlib_deflate crc32c libcrc32c sha1_generic hmac drbd lru_cache cn
binfmt_misc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext2 loop joydev
hid_generic usbhid hid tpm_tis tpm i2c_piix4 snd_pcm snd_timer snd
soundcore snd_page_alloc i2c_core tpm_bios virtio_balloon microcode
evdev pcspkr psmouse serio_raw button processor thermal_sys ext3 jbd
mbcache dm_mod virtio_net virtio_blk ide_cd_mod cdrom ata_generic
ata_piix libata scsi_mod uhci_hcd ehci_hcd virtio_pci virtio_ring virtio
floppy usbcore usb_common piix ide_core
Aug 29 00:38:53 deb1 kernel: [280841.954761] CPU 3 
Aug 29 00:38:53 deb1 kernel: [280841.954761] Pid: 31687, comm:
btrfs-endio-2 Not tainted 3.6.0-rc3 #1 Bochs Bochs
Aug 29 00:38:53 deb1 kernel: [280841.954761] RIP:
0010:[<ffffffffa041a8f8>]  [<ffffffffa041a8f8>] __btrfs_map_block
+0x5c/0x50c [btrfs]
Aug 29 00:38:53 deb1 kernel: [280841.954761] RSP: 0018:ffff88001cd77ca0
EFLAGS: 00010282
Aug 29 00:38:53 deb1 kernel: [280841.954761] RAX: 000000000000001e RBX:
ffff88001742c120 RCX: 00000000174a174a
Aug 29 00:38:53 deb1 kernel: [280841.954761] RDX: ffffffff81752768 RSI:
0000000000000046 RDI: 0000000000000246
Aug 29 00:38:53 deb1 kernel: [280841.954761] RBP: ffff88001cd77d58 R08:
0000000000000000 R09: 000000000000001e
Aug 29 00:38:53 deb1 kernel: [280841.954761] R10: 0000000000000005 R11:
ffff88001f80c000 R12: 0000000000000002
Aug 29 00:38:53 deb1 kernel: [280841.954761] R13: 0000000000000000 R14:
0000000000000000 R15: ffff8800178bc000
Aug 29 00:38:53 deb1 kernel: [280841.954761] FS:  0000000000000000(0000)
GS:ffff88001fd80000(0000) knlGS:0000000000000000
Aug 29 00:38:53 deb1 kernel: [280841.954761] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Aug 29 00:38:53 deb1 kernel: [280841.954761] CR2: 00007f226ad89fb8 CR3:
000000001d1ff000 CR4: 00000000000006e0
Aug 29 00:38:53 deb1 kernel: [280841.954761] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Aug 29 00:38:53 deb1 kernel: [280841.954761] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Aug 29 00:38:53 deb1 kernel: [280841.954761] Process btrfs-endio-2 (pid:
31687, threadinfo ffff88001cd76000, task ffff880017579470)
Aug 29 00:38:53 deb1 kernel: [280841.954761] Stack:
Aug 29 00:38:53 deb1 kernel: [280841.954761]  ffff88000bc0b000
ffffffff8135679d ffff880000000028 ffff88001cd77d10
Aug 29 00:38:53 deb1 kernel: [280841.954761]  ffff88001cd77cd0
000000008106c3ba 0000000000000206 0000000100000107
Aug 29 00:38:53 deb1 kernel: [280841.954761]  0000000000000000
000000000b0b7da9 00000000f150b07d ffffffff816081c0
Aug 29 00:38:53 deb1 kernel: [280841.954761] Call Trace:
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffff8135679d>] ?
printk+0x4c/0x51
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffffa040085e>] ?
btrfs_readpage_end_io_hook+0x198/0x1d6 [btrfs]
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffffa041adf8>] ?
btrfs_find_device_for_logical+0x46/0x7f [btrfs]
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffffa04006c6>] ?
btrfs_update_inode_item+0xd2/0xd2 [btrfs]
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffffa04157c8>] ?
end_bio_extent_readpage+0x16b/0x76f [btrfs]
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffff8104be65>] ?
lock_timer_base+0x49/0x49
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffff810fe008>] ?
virt_to_head_page+0x9/0x2c
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffffa041d9c6>] ?
worker_loop+0x18c/0x4fe [btrfs]
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffffa041d83a>] ?
btrfs_queue_worker+0x260/0x260 [btrfs]
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffffa041d83a>] ?
btrfs_queue_worker+0x260/0x260 [btrfs]
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffff8105a439>] ?
kthread+0x81/0x89
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffff8135fa84>] ?
kernel_thread_helper+0x4/0x10
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffff8105a3b8>] ?
kthread_freezable_should_stop+0x53/0x53
Aug 29 00:38:53 deb1 kernel: [280841.954761]  [<ffffffff8135fa80>] ?
gs_change+0x13/0x13
Aug 29 00:38:53 deb1 kernel: [280841.954761] Code: 89 f6 48 89 df e8 f5
2a ff ff 48 89 c6 f0 ff 43 08 48 85 c0 75 19 48 8b 55 00 4c 89 f6 48 c7
c7 5f 09 45 a0 31 c0 e8 59 be f3 e0 <0f> 0b eb fe 48 8b 40 18 4c 39 f0
77 0d 48 8b 4e 20 48 8d 14 01 
Aug 29 00:38:53 deb1 kernel: [280841.954761]  RSP <ffff88001cd77ca0>
Aug 29 00:38:53 deb1 kernel: [280841.975783] ---[ end trace
5a6edb6702f23b71 ]---



Aug 30 01:37:53 deb1 kernel: [10043.780751] btrfs csum failed ino 257
off 0 csum 1212590769 private 4063890949
Aug 30 01:37:53 deb1 kernel: [10043.781274] ------------[ cut here
]------------
Aug 30 01:37:53 deb1 kernel: [10043.781950] invalid opcode: 0000 [#1]
SMP 
Aug 30 01:37:53 deb1 kernel: [10043.782271] Modules linked in: btrfs
zlib_deflate crc32c libcrc32c sha1_generic hmac drbd lru_cache cn
binfmt_misc ib_
iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi ext2 loop i2c_piix4 i2c_core
evdev snd_pcm 
snd_timer snd soundcore snd_page_alloc tpm_tis tpm tpm_bios button
psmouse joydev serio_raw pcspkr hid_generic virtio_balloon microcode
processor ther
mal_sys usbhid hid ext3 jbd mbcache dm_mod virtio_net ide_cd_mod cdrom
ata_generic ata_piix virtio_blk libata scsi_mod floppy uhci_hcd ehci_hcd
usbcor
e usb_common virtio_pci virtio_ring virtio piix ide_core
Aug 30 01:37:53 deb1 kernel: [10043.784710] CPU 1 
Aug 30 01:37:53 deb1 kernel: [10043.784710] Pid: 3337, comm:
btrfs-endio-6 Not tainted 3.6.0-rc3 #1 Bochs Bochs
Aug 30 01:37:53 deb1 kernel: [10043.784710] RIP:
0010:[<ffffffffa04298f8>]  [<ffffffffa04298f8>] __btrfs_map_block
+0x5c/0x50c [btrfs]
Aug 30 01:37:53 deb1 kernel: [10043.784710] RSP: 0018:ffff880017673ca0
EFLAGS: 00010282
Aug 30 01:37:53 deb1 kernel: [10043.784710] RAX: 000000000000001e RBX:
ffff88001e65c120 RCX: 000000000b910b91
Aug 30 01:37:53 deb1 kernel: [10043.784710] RDX: ffffffff81752768 RSI:
0000000000000046 RDI: 0000000000000246
Aug 30 01:37:53 deb1 kernel: [10043.784710] RBP: ffff880017673d58 R08:
0000000000000000 R09: 000000000000001e
Aug 30 01:37:53 deb1 kernel: [10043.784710] R10: 0000000000000005 R11:
ffff88001f80c000 R12: 0000000000000002
Aug 30 01:37:53 deb1 kernel: [10043.784710] R13: 0000000000000000 R14:
0000000000000000 R15: ffff88001e4fd0c0
Aug 30 01:37:53 deb1 kernel: [10043.784710] FS:  0000000000000000(0000)
GS:ffff88001fc80000(0000) knlGS:0000000000000000
Aug 30 01:37:53 deb1 kernel: [10043.784710] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Aug 30 01:37:53 deb1 kernel: [10043.784710] CR2: 00007f8a5b185fb8 CR3:
00000000174ae000 CR4: 00000000000006e0
Aug 30 01:37:53 deb1 kernel: [10043.784710] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Aug 30 01:37:53 deb1 kernel: [10043.784710] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Aug 30 01:37:53 deb1 kernel: [10043.784710] Process btrfs-endio-6 (pid:
3337, threadinfo ffff880017672000, task ffff88001771d1c0)
Aug 30 01:37:53 deb1 kernel: [10043.784710] Stack:
Aug 30 01:37:53 deb1 kernel: [10043.784710]  ffff88001d2aa000
ffffffff8135679d ffff880000000028 ffff880017673d10
Aug 30 01:37:53 deb1 kernel: [10043.784710]  ffff880017673cd0
000000001fd93840 0000000000000206 0000000100000101
Aug 30 01:37:53 deb1 kernel: [10043.784710]  0000000000000000
000000004846aab1 00000000f23a0e05 ffffffff816081c0
Aug 30 01:37:53 deb1 kernel: [10043.784710] Call Trace:
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffff8135679d>] ?
printk+0x4c/0x51
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffffa040f85e>] ?
btrfs_readpage_end_io_hook+0x198/0x1d6 [btrfs]
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffffa0429df8>] ?
btrfs_find_device_for_logical+0x46/0x7f [btrfs]
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffffa040f6c6>] ?
btrfs_update_inode_item+0xd2/0xd2 [btrfs]
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffffa04247c8>] ?
end_bio_extent_readpage+0x16b/0x76f [btrfs]
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffff8104be65>] ?
lock_timer_base+0x49/0x49
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffff810fe008>] ?
virt_to_head_page+0x9/0x2c
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffffa042c9c6>] ?
worker_loop+0x18c/0x4fe [btrfs]
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffffa042c83a>] ?
btrfs_queue_worker+0x260/0x260 [btrfs]
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffffa042c83a>] ?
btrfs_queue_worker+0x260/0x260 [btrfs]
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffff8105a439>] ?
kthread+0x81/0x89
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffff8135fa84>] ?
kernel_thread_helper+0x4/0x10
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffff8105a3b8>] ?
kthread_freezable_should_stop+0x53/0x53
Aug 30 01:37:53 deb1 kernel: [10043.784710]  [<ffffffff8135fa80>] ?
gs_change+0x13/0x13
Aug 30 01:37:53 deb1 kernel: [10043.784710] Code: 89 f6 48 89 df e8 f5
2a ff ff 48 89 c6 f0 ff 43 08 48 85 c0 75 19 48 8b 55 00 4c 89 f6 48 c7
c7 5f f9 45 a0 31 c0 e8 59 ce f2 e0 <0f> 0b eb fe 48 8b 40 18 4c 39 f0
77 0d 48 8b 4e 20 48 8d 14 01 
Aug 30 01:37:53 deb1 kernel: [10043.784710]  RSP <ffff880017673ca0>
Aug 30 01:37:53 deb1 kernel: [10043.803491] ---[ end trace
2e9f1f508c6bb6dc ]---



Regards,
Christophe Varoqui
OpenSVC

