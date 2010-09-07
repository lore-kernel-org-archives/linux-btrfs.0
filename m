From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Btrfs troubles
Date: Tue, 07 Sep 2010 12:41:49 +0300
Message-ID: <4C8608DD.4090305@gmail.com>
References: <i64k40$ur1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i64k40$ur1$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

  Hello, I have these messages from a two not full (111GB of 2TB and 
452GB of 2TB free) filesystems.
Eventually the filesystem mounts, but I am unable to create new files, 
even when i delete data.
Most files are 1.45GB.

[root@linuxserver ~]# btrfs filesystem df /storage/WD20_1
Data: total=1.81TB, used=1.71TB
Metadata: total=2.63GB, used=2.43GB
System: total=12.00MB, used=204.00KB

[root@linuxserver ~]# btrfsck /dev/sdb1
found 1878986375168 bytes used err is 0
total csum bytes: 1832396384
total tree bytes: 2612477952
total fs tree bytes: 22331392
btree space waste bytes: 595037490
file data blocks allocated: 1922007609344
  referenced 1876364451840
Btrfs Btrfs v0.19

[root@linuxserver ~]# btrfs filesystem df /storage/WD20_2
Data: total=1.81TB, used=1.37TB
Metadata: total=2.51GB, used=2.47GB
System: total=12.00MB, used=204.00KB

  [root@linuxserver ~]# btrfsck /dev/sda1
found 1512592834560 bytes used err is 0
total csum bytes: 1474551008
total tree bytes: 2652602368
total fs tree bytes: 301985792
btree space waste bytes: 599008365
file data blocks allocated: 1510591008768
  referenced 1607206682624
Btrfs Btrfs v0.19




------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 
btrfs_block_rsv_check+0x15e/0x190 [btrfs]()
Hardware name: GA-MA785G-UD3H
Modules linked in: btrfs zlib_deflate crc32c libcrc32c ipv6 ext2 usbhid 
hid usb_storage snd_hda_codec_atihdmi radeon snd_hda_intel snd_hda_codec 
ttm ohci_hcd drm_kms_helper ehci_hcd drm i2c_algo_bit snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_hwdep snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc 
usbcore shpchp pcspkr serio_raw r8169 evdev i2c_piix4 pci_hotplug 
processor thermal edac_core k10temp button edac_mce_amd i2c_core mii sg 
wmi rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sd_mod pata_acpi 
ahci libahci pata_atiixp libata scsi_mod
Pid: 12735, comm: ls Not tainted 2.6.35-ARCH #1
Call Trace:
  [<ffffffff8105288a>] warn_slowpath_common+0x7a/0xb0
  [<ffffffff810528d5>] warn_slowpath_null+0x15/0x20
  [<ffffffffa07f8c9e>] btrfs_block_rsv_check+0x15e/0x190 [btrfs]
  [<ffffffffa080976a>] __btrfs_end_transaction+0x19a/0x220 [btrfs]
  [<ffffffffa080980b>] btrfs_end_transaction+0xb/0x10 [btrfs]
  [<ffffffffa081342b>] btrfs_dirty_inode+0x8b/0x120 [btrfs]
  [<ffffffff81145a86>] __mark_inode_dirty+0x36/0x170
  [<ffffffff81139c0d>] touch_atime+0x12d/0x170
  [<ffffffff81134330>] ? filldir+0x0/0xd0
  [<ffffffff81134586>] vfs_readdir+0xc6/0xd0
  [<ffffffff81134670>] sys_getdents+0x80/0xe0
  [<ffffffff81373765>] ? page_fault+0x25/0x30
  [<ffffffff81009e82>] system_call_fastpath+0x16/0x1b
---[ end trace a296d77e7bd54918 ]---
block_rsv size 872415232 reserved 206303232 freed 0 0
INFO: task ls:12735 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ls            D 0000000000000000     0 12735  11939 0x00000000
  ffff88004aa5fd58 0000000000000082 ffff880001894fa8 0000000000000000
  0000000000014f40 0000000000014f40 ffff88004aa5ffd8 ffff88004aa5ffd8
  ffff88004aa5ffd8 ffff880057c5ef00 ffff88004aa5ffd8 0000000000014f40
Call Trace:
  [<ffffffffa0808654>] wait_current_trans.clone.19+0x84/0xe0 [btrfs]
  [<ffffffff810718d0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffffa08098ef>] start_transaction+0xdf/0x250 [btrfs]
  [<ffffffffa0809aae>] btrfs_start_transaction+0xe/0x10 [btrfs]
  [<ffffffffa0813438>] btrfs_dirty_inode+0x98/0x120 [btrfs]
  [<ffffffff81145a86>] __mark_inode_dirty+0x36/0x170
  [<ffffffff81139c0d>] touch_atime+0x12d/0x170
  [<ffffffff81134330>] ? filldir+0x0/0xd0
  [<ffffffff81134586>] vfs_readdir+0xc6/0xd0
  [<ffffffff81134670>] sys_getdents+0x80/0xe0
  [<ffffffff81373765>] ? page_fault+0x25/0x30
  [<ffffffff81009e82>] system_call_fastpath+0x16/0x1b
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 
btrfs_block_rsv_check+0x15e/0x190 [btrfs]()
Hardware name: GA-MA785G-UD3H
Modules linked in: btrfs zlib_deflate crc32c libcrc32c ipv6 ext2 usbhid 
hid usb_storage snd_hda_codec_atihdmi radeon snd_hda_intel snd_hda_codec 
ttm ohci_hcd drm_kms_helper ehci_hcd drm i2c_algo_bit snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_hwdep snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc 
usbcore shpchp pcspkr serio_raw r8169 evdev i2c_piix4 pci_hotplug 
processor thermal edac_core k10temp button edac_mce_amd i2c_core mii sg 
wmi rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sd_mod pata_acpi 
ahci libahci pata_atiixp libata scsi_mod
Pid: 12726, comm: btrfs-transacti Tainted: G        W   2.6.35-ARCH #1
Call Trace:
  [<ffffffff8105288a>] warn_slowpath_common+0x7a/0xb0
  [<ffffffff810528d5>] warn_slowpath_null+0x15/0x20
  [<ffffffffa07f8c9e>] btrfs_block_rsv_check+0x15e/0x190 [btrfs]
  [<ffffffffa080976a>] __btrfs_end_transaction+0x19a/0x220 [btrfs]
  [<ffffffffa080980b>] btrfs_end_transaction+0xb/0x10 [btrfs]
  [<ffffffffa080948e>] btrfs_commit_transaction+0x62e/0x770 [btrfs]
  [<ffffffff81371739>] ? mutex_unlock+0x9/0x10
  [<ffffffffa08099d3>] ? start_transaction+0x1c3/0x250 [btrfs]
  [<ffffffff810718d0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffffa0803373>] transaction_kthread+0x273/0x290 [btrfs]
  [<ffffffffa0803100>] ? transaction_kthread+0x0/0x290 [btrfs]
  [<ffffffff8107133e>] kthread+0x8e/0xa0
  [<ffffffff8100aca4>] kernel_thread_helper+0x4/0x10
  [<ffffffff810712b0>] ? kthread+0x0/0xa0
  [<ffffffff8100aca0>] ? kernel_thread_helper+0x0/0x10
---[ end trace a296d77e7bd54919 ]---
block_rsv size 872415232 reserved 206303232 freed 0 0
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 
btrfs_block_rsv_check+0x15e/0x190 [btrfs]()
Hardware name: GA-MA785G-UD3H
Modules linked in: btrfs zlib_deflate crc32c libcrc32c ipv6 ext2 usbhid 
hid usb_storage snd_hda_codec_atihdmi radeon snd_hda_intel snd_hda_codec 
ttm ohci_hcd drm_kms_helper ehci_hcd drm i2c_algo_bit snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_hwdep snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc 
usbcore shpchp pcspkr serio_raw r8169 evdev i2c_piix4 pci_hotplug 
processor thermal edac_core k10temp button edac_mce_amd i2c_core mii sg 
wmi rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sd_mod pata_acpi 
ahci libahci pata_atiixp libata scsi_mod
Pid: 12735, comm: ls Tainted: G        W   2.6.35-ARCH #1
Call Trace:
  [<ffffffff8105288a>] warn_slowpath_common+0x7a/0xb0
  [<ffffffff810528d5>] warn_slowpath_null+0x15/0x20
  [<ffffffffa07f8c9e>] btrfs_block_rsv_check+0x15e/0x190 [btrfs]
  [<ffffffffa080976a>] __btrfs_end_transaction+0x19a/0x220 [btrfs]
  [<ffffffffa080980b>] btrfs_end_transaction+0xb/0x10 [btrfs]
  [<ffffffffa0809a4e>] start_transaction+0x23e/0x250 [btrfs]
  [<ffffffffa0809aae>] btrfs_start_transaction+0xe/0x10 [btrfs]
  [<ffffffffa0813438>] btrfs_dirty_inode+0x98/0x120 [btrfs]
  [<ffffffff81145a86>] __mark_inode_dirty+0x36/0x170
  [<ffffffff81139c0d>] touch_atime+0x12d/0x170
  [<ffffffff81134330>] ? filldir+0x0/0xd0
  [<ffffffff81134586>] vfs_readdir+0xc6/0xd0
  [<ffffffff81134670>] sys_getdents+0x80/0xe0
  [<ffffffff81373765>] ? page_fault+0x25/0x30
  [<ffffffff81009e82>] system_call_fastpath+0x16/0x1b
---[ end trace a296d77e7bd5491a ]---
block_rsv size 872415232 reserved 206303232 freed 0 0
btrfs: fail to dirty  inode 256 error -28







