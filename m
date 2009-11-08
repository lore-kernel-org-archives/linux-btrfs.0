From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: 2.6.32-rc6: kernel BUG at fs/btrfs/volumes.c:1746
Date: Sun, 8 Nov 2009 17:31:12 +0300
Message-ID: <a4423d670911080631k3a5d26b5n852885f02c4d81ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Filesystem was created by 'mkfs.btrfs -d raid0 /dev/sd[ef]".
Kernel is 2.6.32-rc6.

# btrfs-show
Label: none  uuid: be452097-a24c-420e-b47d-c8eb68fe8bce
        Total devices 2 FS bytes used 105.88GB
        devid    2 size 74.54GB used 70.01GB path /dev/sdf
        devid    1 size 74.54GB used 70.03GB path /dev/sde

Btrfs Btrfs v0.19

# btrfs-vol -b /mnt/e
Segmentation fault


WARNING: at fs/btrfs/relocation.c:3588
btrfs_relocate_block_group+0x236/0x340 [btrfs]()
Hardware name:
Modules linked in: btrfs zlib_deflate zlib_inflate hwmon_vid sata_sil
i2c_nforce2
Pid: 32148, comm: btrfs-vol Not tainted 2.6.32-rc6 #4
Call Trace:
 [<c1345267>] ? printk+0x18/0x21
 [<c1029ced>] warn_slowpath_common+0x6d/0xa0
 [<f9b2fc26>] ? btrfs_relocate_block_group+0x236/0x340 [btrfs]
 [<f9b2fc26>] ? btrfs_relocate_block_group+0x236/0x340 [btrfs]
 [<c1029d35>] warn_slowpath_null+0x15/0x20
 [<f9b2fc26>] btrfs_relocate_block_group+0x236/0x340 [btrfs]
 [<f9b189f6>] btrfs_relocate_chunk+0x66/0x540 [btrfs]
 [<f9b0d3dc>] ? unmap_extent_buffer+0xc/0x10 [btrfs]
 [<f9b01ebf>] ? btrfs_item_offset+0xdf/0xf0 [btrfs]
 [<f9b19604>] btrfs_balance+0x294/0x320 [btrfs]
 [<f9b1e081>] btrfs_ioctl+0x361/0xa60 [btrfs]
 [<c106d48b>] ? __alloc_pages_nodemask+0xeb/0x570
 [<c104f89a>] ? print_lock_contention_bug+0x1a/0xe0
 [<c107c14c>] ? handle_mm_fault+0x4fc/0x5b0
 [<f9b1dd20>] ? btrfs_ioctl+0x0/0xa60 [btrfs]
 [<c109d68c>] vfs_ioctl+0x1c/0x70
 [<c109d93a>] do_vfs_ioctl+0x6a/0x5a0
 [<c1347c5d>] ? _spin_unlock+0x1d/0x20
 [<c107be08>] ? handle_mm_fault+0x1b8/0x5b0
 [<c134a0cb>] ? do_page_fault+0x9b/0x370
 [<c134a185>] ? do_page_fault+0x155/0x370
 [<c1040a56>] ? up_read+0x16/0x30
 [<c134a185>] ? do_page_fault+0x155/0x370
 [<c109dea9>] sys_ioctl+0x39/0x60
 [<c1002c58>] sysenter_do_call+0x12/0x36
---[ end trace 020c1edff98b3588 ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:1746!
invalid opcode: 0000 [#1]
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
Modules linked in: btrfs zlib_deflate zlib_inflate hwmon_vid sata_sil
i2c_nforce2

Pid: 32148, comm: btrfs-vol Tainted: G        W  (2.6.32-rc6 #4)
EIP: 0060:[<f9b18ec4>] EFLAGS: 00010282 CPU: 0
EIP is at btrfs_relocate_chunk+0x534/0x540 [btrfs]
EAX: fffffffb EBX: f4214000 ECX: 00000000 EDX: e67a2f50
ESI: 81c00000 EDI: 00000015 EBP: cc53de20 ESP: cc53dd90
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process btrfs-vol (pid: 32148, ti=cc53c000 task=f63b94f0 task.ti=cc53c000)
Stack:
 00000009 00000163 00000011 c24d7120 00000259 f67c49b0 00000000 f67c3120
<0> 81c00000 00000015 00000000 00000100 cc53de10 cc53de0c cc53de08 cc53de04
<0> 00000009 d08f6398 cc53dde0 f9b0d3dc cc53de20 f9b01ebf cc53de10 cc53de0c
Call Trace:
 [<f9b0d3dc>] ? unmap_extent_buffer+0xc/0x10 [btrfs]
 [<f9b01ebf>] ? btrfs_item_offset+0xdf/0xf0 [btrfs]
 [<f9b19604>] ? btrfs_balance+0x294/0x320 [btrfs]
 [<f9b1e081>] ? btrfs_ioctl+0x361/0xa60 [btrfs]
 [<c106d48b>] ? __alloc_pages_nodemask+0xeb/0x570
 [<c104f89a>] ? print_lock_contention_bug+0x1a/0xe0
 [<c107c14c>] ? handle_mm_fault+0x4fc/0x5b0
 [<f9b1dd20>] ? btrfs_ioctl+0x0/0xa60 [btrfs]
 [<c109d68c>] ? vfs_ioctl+0x1c/0x70
 [<c109d93a>] ? do_vfs_ioctl+0x6a/0x5a0
 [<c1347c5d>] ? _spin_unlock+0x1d/0x20
 [<c107be08>] ? handle_mm_fault+0x1b8/0x5b0
 [<c134a0cb>] ? do_page_fault+0x9b/0x370
 [<c134a185>] ? do_page_fault+0x155/0x370
 [<c1040a56>] ? up_read+0x16/0x30
 [<c134a185>] ? do_page_fault+0x155/0x370
 [<c109dea9>] ? sys_ioctl+0x39/0x60
 [<c1002c58>] ? sysenter_do_call+0x12/0x36
Code: 63 fd ff ff 8d 76 00 0f 0b eb fe 8d 74 26 00 0f 0b eb fe 0f 0b
eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f>
0b eb fe 0f 0b eb fe 0f 0b eb fe 55 89 e5 81 ec 88 00 00 00
EIP: [<f9b18ec4>] btrfs_relocate_chunk+0x534/0x540 [btrfs] SS:ESP 0068:cc53dd90
---[ end trace 020c1edff98b3589 ]---
