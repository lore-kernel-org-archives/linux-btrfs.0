From: Jordan Windsor <jordanw2@gmail.com>
Subject: Errors in dmesg, no crashes though.
Date: Sat, 25 Feb 2012 09:14:01 +1030
Message-ID: <CACCfv7p=w3j5+K698nms0-T1XJLXg=SWhQQ82jf7yvSUt9nYPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I'm running Ubuntu under KVM, with btrfs on the host where the
Qemu/KVM image is stored, the VM was also running at the time. I was
going to check something unrelated in the dmesg output, as I did that
I noticed some errors in it about btrfs here they are:


[ 4294.431807] btrfs: block rsv returned -28
[ 4294.431811] ------------[ cut here ]------------
[ 4294.431831] WARNING: at fs/btrfs/extent-tree.c:5985
btrfs_alloc_free_block+0x344/0x350 [btrfs]()
[ 4294.431835] Modules linked in: xfs exportfs jfs kvm_intel kvm fuse
btrfs zlib_deflate crc32c libcrc32c ext4 jbd2 mbcache crc16
snd_hda_codec_realtek rc_dib0700_rc5 mt2266 ir_lirc_codec lirc_dev
ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder dvb_usb_dib0700
ir_rc6_decoder dib3000mc dib8000 dib0070 dib7000m dib0090 dib7000p
dibx000_common ir_rc5_decoder ir_nec_decoder usb_storage uas dvb_usb
dvb_core rc_core joydev snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_page_alloc snd_timer ppdev parport_pc nvidia(P) snd soundcore
i2c_i801 serio_raw evdev parport floppy 8139too 8139cp iTCO_wdt
i7core_edac edac_core pcspkr button processor i2c_core
iTCO_vendor_support mii reiserfs aes_x86_64 cryptd aes_generic xts
gf128mul dm_crypt dm_mod usbhid hid sd_mod sr_mod pata_jmicron cdrom
ahci libahci ata_piix uhci_hcd pata_acpi libata scsi_mod ehci_hcd
usbcore usb_common
[ 4294.431967] Pid: 10505, comm: btrfs-endio-wri Tainted: P
O 3.2.7-1-ARCH #1
[ 4294.431969] Call Trace:
[ 4294.431974]  [<ffffffff8106609f>] warn_slowpath_common+0x7f/0xc0
[ 4294.431976]  [<ffffffff810660fa>] warn_slowpath_null+0x1a/0x20
[ 4294.431982]  [<ffffffffa0f95fd4>] btrfs_alloc_free_block+0x344/0x350 [btrfs]
[ 4294.431986]  [<ffffffffa0f84e62>] __btrfs_cow_block+0x122/0x430 [btrfs]
[ 4294.431991]  [<ffffffffa0f85266>] btrfs_cow_block+0xf6/0x250 [btrfs]
[ 4294.431997]  [<ffffffffa0fd42e0>] ?
btrfs_set_lock_blocking_rw+0x50/0xb0 [btrfs]
[ 4294.432002]  [<ffffffffa0f88dde>] btrfs_search_slot+0x18e/0x8a0 [btrfs]
[ 4294.432007]  [<ffffffffa0fe0614>] ? tree_insert+0x84/0x1e0 [btrfs]
[ 4294.432013]  [<ffffffffa0f9a374>] btrfs_lookup_csum+0x74/0x170 [btrfs]
[ 4294.432016]  [<ffffffff81152183>] ? kmem_cache_alloc+0x133/0x160
[ 4294.432022]  [<ffffffffa0f9b3c4>] btrfs_csum_file_blocks+0xb4/0x680 [btrfs]
[ 4294.432029]  [<ffffffffa0faaa99>] ?
insert_reserved_file_extent.constprop.52+0x219/0x270 [btrfs]
[ 4294.432035]  [<ffffffffa0fa8f35>] add_pending_csums.isra.38+0x45/0x60 [btrfs]
[ 4294.432042]  [<ffffffffa0fabdff>]
btrfs_endio_direct_write+0x1ff/0x300 [btrfs]
[ 4294.432045]  [<ffffffff8119bc4d>] bio_endio+0x1d/0x40
[ 4294.432050]  [<ffffffffa0f9e736>] end_workqueue_fn+0x56/0x140 [btrfs]
[ 4294.432056]  [<ffffffffa0fce920>] worker_loop+0x150/0x520 [btrfs]
[ 4294.432059]  [<ffffffff8104d788>] ? __wake_up_common+0x58/0x90
[ 4294.432065]  [<ffffffffa0fce7d0>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 4294.432127]  [<ffffffff8108842c>] kthread+0x8c/0xa0
[ 4294.432131]  [<ffffffff8145f5f4>] kernel_thread_helper+0x4/0x10
[ 4294.432133]  [<ffffffff810883a0>] ? kthread_worker_fn+0x190/0x190
[ 4294.432135]  [<ffffffff8145f5f0>] ? gs_change+0x13/0x13
[ 4294.432136] ---[ end trace 4afe986ec803a741 ]---
[ 4294.432146] btrfs: block rsv returned -28
[ 4294.432147] ------------[ cut here ]------------
[ 4294.432152] WARNING: at fs/btrfs/extent-tree.c:5985
btrfs_alloc_free_block+0x344/0x350 [btrfs]()
[ 4294.432153] Modules linked in: xfs exportfs jfs kvm_intel kvm fuse
btrfs zlib_deflate crc32c libcrc32c ext4 jbd2 mbcache crc16
snd_hda_codec_realtek rc_dib0700_rc5 mt2266 ir_lirc_codec lirc_dev
ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder dvb_usb_dib0700
ir_rc6_decoder dib3000mc dib8000 dib0070 dib7000m dib0090 dib7000p
dibx000_common ir_rc5_decoder ir_nec_decoder usb_storage uas dvb_usb
dvb_core rc_core joydev snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_page_alloc snd_timer ppdev parport_pc nvidia(P) snd soundcore
i2c_i801 serio_raw evdev parport floppy 8139too 8139cp iTCO_wdt
i7core_edac edac_core pcspkr button processor i2c_core
iTCO_vendor_support mii reiserfs aes_x86_64 cryptd aes_generic xts
gf128mul dm_crypt dm_mod usbhid hid sd_mod sr_mod pata_jmicron cdrom
ahci libahci ata_piix uhci_hcd pata_acpi libata scsi_mod ehci_hcd
usbcore usb_common
[ 4294.432186] Pid: 10505, comm: btrfs-endio-wri Tainted: P        W
O 3.2.7-1-ARCH #1
[ 4294.432187] Call Trace:
[ 4294.432189]  [<ffffffff8106609f>] warn_slowpath_common+0x7f/0xc0
[ 4294.432191]  [<ffffffff810660fa>] warn_slowpath_null+0x1a/0x20
[ 4294.432196]  [<ffffffffa0f95fd4>] btrfs_alloc_free_block+0x344/0x350 [btrfs]
[ 4294.432203]  [<ffffffffa0fc5fb0>] ? read_extent_buffer+0xb0/0x190 [btrfs]
[ 4294.432207]  [<ffffffffa0f84e62>] __btrfs_cow_block+0x122/0x430 [btrfs]
[ 4294.432212]  [<ffffffffa0f85266>] btrfs_cow_block+0xf6/0x250 [btrfs]
[ 4294.432217]  [<ffffffffa0fd42e0>] ?
btrfs_set_lock_blocking_rw+0x50/0xb0 [btrfs]
[ 4294.432222]  [<ffffffffa0f88dde>] btrfs_search_slot+0x18e/0x8a0 [btrfs]
[ 4294.432227]  [<ffffffffa0fe0614>] ? tree_insert+0x84/0x1e0 [btrfs]
[ 4294.432293]  [<ffffffffa0f9a374>] btrfs_lookup_csum+0x74/0x170 [btrfs]
[ 4294.432296]  [<ffffffff81152183>] ? kmem_cache_alloc+0x133/0x160
[ 4294.432301]  [<ffffffffa0f9b3c4>] btrfs_csum_file_blocks+0xb4/0x680 [btrfs]
[ 4294.432308]  [<ffffffffa0faaa99>] ?
insert_reserved_file_extent.constprop.52+0x219/0x270 [btrfs]
[ 4294.432315]  [<ffffffffa0fa8f35>] add_pending_csums.isra.38+0x45/0x60 [btrfs]
[ 4294.432321]  [<ffffffffa0fabdff>]
btrfs_endio_direct_write+0x1ff/0x300 [btrfs]
[ 4294.432324]  [<ffffffff8119bc4d>] bio_endio+0x1d/0x40
[ 4294.432329]  [<ffffffffa0f9e736>] end_workqueue_fn+0x56/0x140 [btrfs]
[ 4294.432335]  [<ffffffffa0fce920>] worker_loop+0x150/0x520 [btrfs]
[ 4294.432337]  [<ffffffff8104d788>] ? __wake_up_common+0x58/0x90
[ 4294.432343]  [<ffffffffa0fce7d0>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 4294.432345]  [<ffffffff8108842c>] kthread+0x8c/0xa0
[ 4294.432347]  [<ffffffff8145f5f4>] kernel_thread_helper+0x4/0x10
[ 4294.432349]  [<ffffffff810883a0>] ? kthread_worker_fn+0x190/0x190
[ 4294.432351]  [<ffffffff8145f5f0>] ? gs_change+0x13/0x13
[ 4294.432353] ---[ end trace 4afe986ec803a742 ]---

This didn't cause any crashes or related issues, also unrelated (I
think?) is that I get very low performance (about 5MBps according to
iostat) in a guest under Qemu/KVM.
3.2.7-1-ARCH x86_64 Arch Linux
Thanks.
