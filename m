Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24441 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbcCTXbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 19:31:11 -0400
From: "James Johnston" <johnstonj.public@codenest.com>
To: <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing device in RAID-1
Date: Sun, 20 Mar 2016 23:31:05 -0000
Message-ID: <000c01d18300$93b757c0$bb260740$@codenest.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm testing a btrfs configuration in VirtualBox before I put it on real
hardware and I'm running into a problem where the kernel dies from a BUG_ON
assertion when I test hot-removing a mirror drive in a RAID-1.  Since this
apparently defeats the whole point of having RAID-1, this is rather
concerning.

If there's anything needed to help diagnose this issue, I'm happy to assist:
the issue is very reproducible such that I can make it happen in a VM any
time I want.

The kernel log and stack trace is at the end of this message; first, here's my
system information:

$ uname -a
Linux ubuntutest 4.5.0-040500-generic #201603140130 SMP Mon Mar 14 05:32:22 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

This is Ubuntu 15.10 that has been updated to the lastest packages as of
3/20/2016, and then the mainline kernel 4.5 package installed from
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.5-wily/ - but the problem
also occurs on the regular non-mainline Ubuntu kernel (4.2).

It is running on a VirtualBox 5.0.16 VM with 5 virtual drives.  The system
boots with EFI and the first two drives are partitioned with GPT to mirror the
operating system, and the remaining 3 are currently unused with no partition
tables (eventually to be used for data).

$ lsblk
NAME                   MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                      8:0    0   12G  0 disk
├─sda1                   8:1    0   94M  0 part  /boot/efi
└─sda2                   8:2    0 11.9G  0 part
  ├─VG-System0Boot     252:2    0  336M  0 lvm
  └─VG-System0Root     252:3    0  5.6G  0 lvm
    └─System0RootCrypt 252:5    0  5.6G  0 crypt
sdb                      8:16   0   12G  0 disk
├─sdb1                   8:17   0   94M  0 part  /boot/efi-mirror
└─sdb2                   8:18   0 11.9G  0 part
  ├─VG-System1Boot     252:0    0  336M  0 lvm   /boot
  └─VG-System1Root     252:1    0  5.6G  0 lvm
    └─System1RootCrypt 252:4    0  5.6G  0 crypt /home
sdc                      8:32   0    4G  0 disk
sdd                      8:48   0    4G  0 disk
sde                      8:64   0    4G  0 disk
loop0                    7:0    0  512M  0 loop  [SWAP]

sd?1 and sd?1 are FAT32 EFI system partitions; we can disregard them (as well
as any FAT file system messages that show up in dmesg).  sd?2 are LVM physical
volumes.  In the volume group, we have four logical volumes, two per drive:
RAID-1 is done by btrfs, not by LVM.  Two volumes are used by btrfs for
RAID-1 mirror of /boot directory.  And two volumes are used for btrfs RAID-1
root file system, with dm-crypt inbetween.

$ pvdisplay -m
  --- Physical volume ---
  PV Name               /dev/sdb2
  VG Name               VG
  PV Size               11.91 GiB / not usable 4.98 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              3047
  Free PE               1529
  Allocated PE          1518
  PV UUID               ehrrHN-KuL5-XQeG-p5sJ-2o24-GGZi-T3ciUV

  --- Physical Segments ---
  Physical extent 0 to 83:
    Logical volume      /dev/VG/System1Boot
    Logical extents     0 to 83
  Physical extent 84 to 1517:
    Logical volume      /dev/VG/System1Root
    Logical extents     0 to 1433
  Physical extent 1518 to 3046:
    FREE

  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               VG
  PV Size               11.91 GiB / not usable 4.98 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              3047
  Free PE               1529
  Allocated PE          1518
  PV UUID               0CXFeH-Vgha-LNVi-Q0Qa-0Srf-8von-wzFtZI

  --- Physical Segments ---
  Physical extent 0 to 83:
    Logical volume      /dev/VG/System0Boot
    Logical extents     0 to 83
  Physical extent 84 to 1517:
    Logical volume      /dev/VG/System0Root
    Logical extents     0 to 1433
  Physical extent 1518 to 3046:
    FREE

$ btrfs fi show
Label: 'SystemRoot'  uuid: 5c756382-8dc5-4afe-ac87-a604e9e7a9a2
        Total devices 2 FS bytes used 1.53GiB
        devid    2 size 5.60GiB used 2.53GiB path /dev/mapper/System1RootCrypt
        devid    3 size 5.60GiB used 2.53GiB path /dev/mapper/System0RootCrypt

Label: 'SystemBoot'  uuid: 49e3db9d-00d4-460a-8de9-19352882b669
        Total devices 2 FS bytes used 132.86MiB
        devid    2 size 336.00MiB used 272.00MiB path /dev/mapper/VG-System1Boot
        devid    3 size 336.00MiB used 272.00MiB path /dev/mapper/VG-System0Boot

btrfs-progs v4.0

$ btrfs fi df /
Data, RAID1: total=2.00GiB, used=1.43GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=512.00MiB, used=93.92MiB
GlobalReserve, single: total=32.00MiB, used=0.00B

$ btrfs fi df /boot
System, RAID1: total=32.00MiB, used=4.00KiB
Data+Metadata, RAID1: total=240.00MiB, used=132.85MiB
GlobalReserve, single: total=4.00MiB, used=0.00B

$ btrfs --version
btrfs-progs v4.0

Finally, we test hot removal of a drive to test RAID-1.  While the virtual
machine is running, I remove /dev/sdb from the virtual machine's configuration.
The following results; it was captured by outputting console to a serial port.
At the end, the VM is catatonic and requires reset by the hypervisor.  The log
below begins at the moment /dev/sdb is removed.  (Note the virtual machine has
4 logical CPUs.)

Notice some time elapses between device removal and death.  During this time,
I generally do nothing on the VM; if it continues to run, then running some
commands (any commands) generally brings a quick death.

[  114.698054] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
[  114.748533] ata2: irq_stat 0x80400040, connection status changed
[  114.761577] ata2: SError: { PHYRdyChg DevExch }
[  126.141141] FAT-fs (sdb1): FAT read failed (blocknr 32)
[  126.189324] FAT-fs (sdb1): unable to read boot sector to mark fs as dirty
[  127.079276] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
[  127.159986] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
[  127.207230] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
[  147.190475] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
[  147.295380] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
[  152.026461] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 5, rd 1, flush 0, corrupt 0, gen 0
[  152.044030] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 6, rd 1, flush 0, corrupt 0, gen 0
[  152.051605] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 6, rd 2, flush 0, corrupt 0, gen 0
[  152.100914] ------------[ cut here ]------------
[  152.112207] kernel BUG at /home/kernel/COD/linux/fs/btrfs/volumes.c:5519!
[  152.138473] invalid opcode: 0000 [#1] SMP 
[  152.139217] Modules linked in: nls_iso8859_1 ppdev input_leds serio_raw snd_intel8x0 snd_ac97_codec ac97_bus joydev snd_pcm snd_timer parport_pc 8250_fintek parport mac_hid snd soundcore i2c_piix4 autofs4 btrfs xor raid6_pq drbg ansi_cprng algif_skcipher af_alg dm_crypt hid_generic usbhid hid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd psmouse ahci libahci fjes video e1000
[  152.212229] CPU: 0 PID: 46 Comm: kworker/u2:2 Not tainted 4.5.0-040500-generic #201603140130
[  152.294596] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  152.348313] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  152.364740] task: ffff880195bb0000 ti: ffff8800dd5c8000 task.ti: ffff8800dd5c8000
[  152.473362] RIP: 0010:[<ffffffffc01bafc2>]  [<ffffffffc01bafc2>] __btrfs_map_block+0xe22/0x11a0 [btrfs]
[  152.474652] RSP: 0018:ffff8800dd5cba80  EFLAGS: 00010286
[  152.475379] RAX: 0000000000003cbd RBX: 0000000000000002 RCX: 0000000000000002
[  152.484573] RDX: 0000000000000000 RSI: 0000000000008000 RDI: ffff880035c44840
[  152.535322] RBP: ffff8800dd5cbb68 R08: 0000000719800000 R09: 0000000095bcb3c0
[  152.538617] R10: 0000000000010000 R11: 000000003cbe0000 R12: 0000000095bcb3bf
[  152.540555] R13: 0000000000008000 R14: ffff8800dd5cbbb0 R15: 0000000000010000
[  152.542465] FS:  0000000000000000(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
[  152.544245] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  152.545256] CR2: 0000560ad29f7ce0 CR3: 00000000dc7f3000 CR4: 00000000000406f0
[  152.546477] Stack:
[  152.547035]  0000000000001000 000000005d45f103 ffff8800df66c4d0 0000000000000078
[  152.549113]  0000000000000001 ffffffffc01ab36d 0000000000000000 0000000000003cbe
[  152.550927]  0000000000003cbd ffff8800d7a56ee0 ffffffff00000000 0000000000000000
[  152.552420] Call Trace:
[  152.552891]  [<ffffffffc01ab36d>] ? release_extent_buffer+0x2d/0xd0 [btrfs]
[  152.554127]  [<ffffffffc01bb8b8>] btrfs_map_bio+0x88/0x350 [btrfs]
[  152.569540]  [<ffffffffc01d8c58>] btrfs_submit_compressed_read+0x468/0x4b0 [btrfs]
[  152.622305]  [<ffffffffc018f9a1>] btrfs_submit_bio_hook+0x1a1/0x1b0 [btrfs]
[  152.692825]  [<ffffffffc01ae4dc>] ? btrfs_create_repair_bio+0xdc/0x100 [btrfs]
[  152.711502]  [<ffffffffc01ae9c6>] end_bio_extent_readpage+0x4c6/0x5c0 [btrfs]
[  152.717379]  [<ffffffffc01ae500>] ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[  152.718370]  [<ffffffff813a8d6f>] bio_endio+0x3f/0x60
[  152.719085]  [<ffffffffc0183a2c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  152.728238]  [<ffffffffc01c01da>] btrfs_scrubparity_helper+0xca/0x2e0 [btrfs]
[  152.729212]  [<ffffffff810f7672>] ? sync_cmos_clock+0x132/0x170
[  152.732303]  [<ffffffffc01c04de>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  152.734530]  [<ffffffff81099f45>] process_one_work+0x165/0x480
[  152.735317]  [<ffffffff8109a2ab>] worker_thread+0x4b/0x500
[  152.738439]  [<ffffffff8109a260>] ? process_one_work+0x480/0x480
[  152.739268]  [<ffffffff810a04e8>] kthread+0xd8/0xf0
[  152.740067]  [<ffffffff810a0410>] ? kthread_create_on_node+0x1a0/0x1a0
[  152.740950]  [<ffffffff8182398f>] ret_from_fork+0x3f/0x70
[  152.741685]  [<ffffffff810a0410>] ? kthread_create_on_node+0x1a0/0x1a0
[  152.742566] Code: 00 00 00 c7 45 88 01 00 00 00 89 45 9c 48 8b 45 b8 4c 8b 9d 40 ff ff ff 4c 8b 95 38 ff ff ff 48 89 85 58 ff ff ff e9 ee f3 ff ff <0f> 0b bb f4 ff ff ff e9 b7 fa ff ff be 74 16 00 00 48 c7 c7 70 
[  152.755159] RIP  [<ffffffffc01bafc2>] __btrfs_map_block+0xe22/0x11a0 [btrfs]
[  152.756265]  RSP <ffff8800dd5cba80>
[  152.756806] ---[ end trace f0effd96a2361108 ]---
[  152.759909] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 6, rd 3, flush 0, corrupt 0, gen 0
[  152.766234] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 6, rd 4, flush 0, corrupt 0, gen 0
[  152.774070] BTRFS info (device dm-4): csum failed ino 150476 extent 3524329472 csum 3222776219 wanted 1686207000 mirror 0
[  152.775666] ------------[ cut here ]------------
[  152.776306] kernel BUG at /home/kernel/COD/linux/fs/btrfs/volumes.c:5519!
[  152.777192] invalid opcode: 0000 [#2] SMP 
[  152.783270] Modules linked in: nls_iso8859_1 ppdev input_leds serio_raw snd_intel8x0 snd_ac97_codec ac97_bus joydev snd_pcm snd_timer parport_pc 8250_fintek parport mac_hid snd soundcore i2c_piix4 autofs4 btrfs xor raid6_pq drbg ansi_cprng algif_skcipher af_alg dm_crypt hid_generic usbhid hid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd psmouse ahci libahci fjes video e1000
[  152.849251] CPU: 0 PID: 172 Comm: kworker/u2:4 Tainted: G      D         4.5.0-040500-generic #201603140130
[  152.853933] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  152.859128] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  152.903039] task: ffff88003616e3c0 ti: ffff880036178000 task.ti: ffff880036178000
[  152.904497] RIP: 0010:[<ffffffffc01bafc2>]  [<ffffffffc01bafc2>] __btrfs_map_block+0xe22/0x11a0 [btrfs]
[  152.943011] RSP: 0018:ffff88003617ba80  EFLAGS: 00010282
[  152.949550] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000002
[  152.955583] RDX: 0000000000000000 RSI: 0000000000002000 RDI: ffff880035c44840
[  152.974324] RBP: ffff88003617bb68 R08: 0000000719800000 R09: 0000000095bcba00
[  152.990001] R10: 0000000000010000 R11: 0000000000010000 R12: 0000000095bcb9ff
[  153.020464] R13: 000000000000e000 R14: ffff88003617bbb0 R15: 0000000000010000
[  153.050557] FS:  0000000000000000(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
[  153.075468] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  153.080961] CR2: 00007f5b8b848030 CR3: 00000000d7839000 CR4: 00000000000406f0
[  153.095842] Stack:
[  153.099691]  0000000000001000 00000000cb386810 ffff8800df66c4d0 0000000000000004
[  153.100781]  0000000000000001 ffffffffc01ab36d 0000000000000000 0000000000000001
[  153.110827]  0000000000000000 ffff8800d7a56ee0 ffffffff00000000 0000000000000000
[  153.111922] Call Trace:
[  153.148382]  [<ffffffffc01ab36d>] ? release_extent_buffer+0x2d/0xd0 [btrfs]
[  153.199107]  [<ffffffffc01bb8b8>] btrfs_map_bio+0x88/0x350 [btrfs]
[  153.217409]  [<ffffffffc01d8b1c>] btrfs_submit_compressed_read+0x32c/0x4b0 [btrfs]
[  153.316423]  [<ffffffffc018f9a1>] btrfs_submit_bio_hook+0x1a1/0x1b0 [btrfs]
[  153.327503]  [<ffffffffc01ae4dc>] ? btrfs_create_repair_bio+0xdc/0x100 [btrfs]
[  153.363841]  [<ffffffffc01ae9c6>] end_bio_extent_readpage+0x4c6/0x5c0 [btrfs]
[  153.365253]  [<ffffffffc01ae500>] ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[  153.366376]  [<ffffffff813a8d6f>] bio_endio+0x3f/0x60
[  153.367091]  [<ffffffffc0183a2c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  153.367968]  [<ffffffffc01c01da>] btrfs_scrubparity_helper+0xca/0x2e0 [btrfs]
[  153.392224]  [<ffffffffc01c04de>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  153.411466]  [<ffffffff81099f45>] process_one_work+0x165/0x480
[  153.480327]  [<ffffffff8109a2ab>] worker_thread+0x4b/0x500
[  153.481087]  [<ffffffff8109a260>] ? process_one_work+0x480/0x480
[  153.488953]  [<ffffffff810a04e8>] kthread+0xd8/0xf0
[  153.507902]  [<ffffffff810a0410>] ? kthread_create_on_node+0x1a0/0x1a0
[  153.544476]  [<ffffffff8182398f>] ret_from_fork+0x3f/0x70
[  153.606516]  [<ffffffff810a0410>] ? kthread_create_on_node+0x1a0/0x1a0
[  153.687526] Code: 00 00 00 c7 45 88 01 00 00 00 89 45 9c 48 8b 45 b8 4c 8b 9d 40 ff ff ff 4c 8b 95 38 ff ff ff 48 89 85 58 ff ff ff e9 ee f3 ff ff <0f> 0b bb f4 ff ff ff e9 b7 fa ff ff be 74 16 00 00 48 c7 c7 70 
[  153.722699] RIP  [<ffffffffc01bafc2>] __btrfs_map_block+0xe22/0x11a0 [btrfs]
[  153.724609]  RSP <ffff88003617ba80>
[  153.725621] ---[ end trace f0effd96a2361109 ]---
[  153.728225] BTRFS error (device dm-4): bdev /dev/mapper/System1RootCrypt errs: wr 6, rd 5, flush 0, corrupt 0, gen 0
[  153.731365] BTRFS info (device dm-4): csum failed ino 150476 extent 3524698112 csum 89763106 wanted 943540449 mirror 0
[  153.767289] ------------[ cut here ]------------
[  153.808509] kernel BUG at /home/kernel/COD/linux/fs/btrfs/volumes.c:5519!
[  153.821542] invalid opcode: 0000 [#3] SMP 
[  153.824183] Modules linked in: nls_iso8859_1 ppdev input_leds serio_raw snd_intel8x0 snd_ac97_codec ac97_bus joydev snd_pcm snd_timer parport_pc 8250_fintek parport mac_hid snd soundcore i2c_piix4 autofs4 btrfs xor raid6_pq drbg ansi_cprng algif_skcipher af_alg dm_crypt hid_generic usbhid hid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd psmouse ahci libahci fjes video e1000
[  153.863382] CPU: 0 PID: 175 Comm: kworker/u2:6 Tainted: G      D         4.5.0-040500-generic #201603140130
[  153.868216] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  153.887043] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  153.895216] task: ffff880036133900 ti: ffff880036184000 task.ti: ffff880036184000
[  153.902598] RIP: 0010:[<ffffffffc01bafc2>]  [<ffffffffc01bafc2>] __btrfs_map_block+0xe22/0x11a0 [btrfs]
[  153.904294] RSP: 0018:ffff880036187a80  EFLAGS: 00010286
[  153.905249] RAX: 0000000000000006 RBX: 0000000000000002 RCX: 0000000000000002
[  153.906478] RDX: 0000000000000000 RSI: 0000000000006000 RDI: ffff880035c44840
[  153.924761] RBP: ffff880036187b68 R08: 0000000719800000 R09: 0000000095bcb780
[  153.925751] R10: 0000000000010000 R11: 0000000000070000 R12: 0000000095bcb77f
[  153.928786] R13: 000000000000a000 R14: ffff880036187bb0 R15: 0000000000010000
[  153.932852] FS:  0000000000000000(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
[  153.933946] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  153.934716] CR2: 00007f5b8b84d052 CR3: 00000000dc7f3000 CR4: 00000000000406f0
[  153.935674] Stack:
[  153.938728]  0000000000001000 000000005f1e32db ffff8800df66c4d0 0000000000000010
[  153.946769]  0000000000000001 ffffffffc01ab36d 0000000000000000 0000000000000007
[  153.956242]  0000000000000006 ffff8800d7a56ee0 ffffffff00000000 0000000000000000
[  153.991716] Call Trace:
[  154.001544]  [<ffffffffc01ab36d>] ? release_extent_buffer+0x2d/0xd0 [btrfs]
[  154.057097]  [<ffffffffc01bb8b8>] btrfs_map_bio+0x88/0x350 [btrfs]
[  154.057943]  [<ffffffffc01d8c58>] btrfs_submit_compressed_read+0x468/0x4b0 [btrfs]
[  154.067076]  [<ffffffffc018f9a1>] btrfs_submit_bio_hook+0x1a1/0x1b0 [btrfs]
[  154.077229]  [<ffffffffc01ae4dc>] ? btrfs_create_repair_bio+0xdc/0x100 [btrfs]
[  154.078258]  [<ffffffffc01ae9c6>] end_bio_extent_readpage+0x4c6/0x5c0 [btrfs]
[  154.079266]  [<ffffffffc01ae500>] ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[  154.095744]  [<ffffffff813a8d6f>] bio_endio+0x3f/0x60
[  154.096457]  [<ffffffffc0183a2c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  154.098794]  [<ffffffffc01c01da>] btrfs_scrubparity_helper+0xca/0x2e0 [btrfs]
[  154.105678]  [<ffffffffc01c04de>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  154.106593]  [<ffffffff81099f45>] process_one_work+0x165/0x480
[  154.107394]  [<ffffffff8109a2ab>] worker_thread+0x4b/0x500
[  154.117588]  [<ffffffff8109a260>] ? process_one_work+0x480/0x480
[  154.118407]  [<ffffffff8109a260>] ? process_one_work+0x480/0x480
[  154.119234]  [<ffffffff810a04e8>] kthread+0xd8/0xf0
[  154.122999]  [<ffffffff810a0410>] ? kthread_create_on_node+0x1a0/0x1a0
[  154.123891]  [<ffffffff8182398f>] ret_from_fork+0x3f/0x70
[  154.124661]  [<ffffffff810a0410>] ? kthread_create_on_node+0x1a0/0x1a0
[  154.125587] Code: 00 00 00 c7 45 88 01 00 00 00 89 45 9c 48 8b 45 b8 4c 8b 9d 40 ff ff ff 4c 8b 95 38 ff ff ff 48 89 85 58 ff ff ff e9 ee f3 ff ff <0f> 0b bb f4 ff ff ff e9 b7 fa ff ff be 74 16 00 00 48 c7 c7 70 
[  154.129747] RIP  [<ffffffffc01bafc2>] __btrfs_map_block+0xe22/0x11a0 [btrfs]
[  154.130748]  RSP <ffff880036187a80>
[  154.131333] ---[ end trace f0effd96a236110a ]---
[  154.137666] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  154.144669] IP: [<ffffffff810a0ba0>] kthread_data+0x10/0x20
[  154.147443] PGD 3e0e067 PUD 3e10067 PMD 0 
[  154.148121] Oops: 0000 [#4] SMP 
[  154.148632] Modules linked in: nls_iso8859_1 ppdev input_leds serio_raw snd_intel8x0 snd_ac97_codec ac97_bus joydev snd_pcm snd_timer parport_pc 8250_fintek parport mac_hid snd soundcore i2c_piix4 autofs4 btrfs xor raid6_pq drbg ansi_cprng algif_skcipher af_alg dm_crypt hid_generic usbhid hid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd psmouse ahci libahci fjes video e1000
[  154.159146] CPU: 0 PID: 175 Comm: kworker/u2:6 Tainted: G      D         4.5.0-040500-generic #201603140130
[  154.163990] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  154.165178] task: ffff880036133900 ti: ffff880036184000 task.ti: ffff880036184000
[  154.186008] RIP: 0010:[<ffffffff810a0ba0>]  [<ffffffff810a0ba0>] kthread_data+0x10/0x20
[  154.232663] RSP: 0018:ffff880036187760  EFLAGS: 00010002
[  154.241766] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff82108040
[  154.250213] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880036133900
[  154.251163] RBP: ffff880036187760 R08: 00000000ffffffff R09: 0000000000000000
[  154.258936] R10: 0000000000006000 R11: ffff880036133980 R12: 0000000000000000
[  154.294498] R13: 0000000000016b00 R14: ffff88019fc16b00 R15: ffff880036133900
[  154.366609] FS:  0000000000000000(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
[  154.392383] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  154.393517] CR2: 0000000000000028 CR3: 00000000d7839000 CR4: 00000000000406f0
[  154.397265] Stack:
[  154.397552]  ffff880036187778 ffffffff8109b311 ffff88019fc16b00 ffff8800361877c8
[  154.398654]  ffffffff8181f1e7 ffff8800d78ee0e0 ffff880000000000 ffff880036133900
[  154.436213]  ffff880036188000 ffff880036134008 ffff880036187330 0000000000000000
[  154.437544] Call Trace:
[  154.437890]  [<ffffffff8109b311>] wq_worker_sleeping+0x11/0x90
[  154.477074]  [<ffffffff8181f1e7>] __schedule+0x527/0x780
[  154.514042]  [<ffffffff8181f475>] schedule+0x35/0x80
[  154.536193]  [<ffffffff81083eca>] do_exit+0x79a/0xb20
[  154.537166]  [<ffffffff8101ac71>] oops_end+0xa1/0xd0
[  154.538240]  [<ffffffff8101b12b>] die+0x4b/0x70
[  154.540690]  [<ffffffff810180e1>] do_trap+0xb1/0x140
[  154.583627]  [<ffffffff81018489>] do_error_trap+0x89/0x110
[  154.604563]  [<ffffffffc01bafc2>] ? __btrfs_map_block+0xe22/0x11a0 [btrfs]
[  154.654083]  [<ffffffffc0187153>] ? btrfs_buffer_uptodate+0x53/0x70 [btrfs]
[  154.720987]  [<ffffffffc0164231>] ? generic_bin_search.constprop.37+0x91/0x1a0 [btrfs]
[  154.751963]  [<ffffffff81018a40>] do_invalid_op+0x20/0x30
[  154.762762]  [<ffffffff8182510e>] invalid_op+0x1e/0x30
[  154.763698]  [<ffffffffc01bafc2>] ? __btrfs_map_block+0xe22/0x11a0 [btrfs]
[  154.792357]  [<ffffffffc01ab36d>] ? release_extent_buffer+0x2d/0xd0 [btrfs]
[  154.794481]  [<ffffffffc01bb8b8>] btrfs_map_bio+0x88/0x350 [btrfs]
[  154.795991]  [<ffffffffc01d8c58>] btrfs_submit_compressed_read+0x468/0x4b0 [btrfs]
[  154.797406]  [<ffffffffc018f9a1>] btrfs_submit_bio_hook+0x1a1/0x1b0 [btrfs]
[  154.843637]  [<ffffffffc01ae4dc>] ? btrfs_create_repair_bio+0xdc/0x100 [btrfs]
[  154.845047]  [<ffffffffc01ae9c6>] end_bio_extent_readpage+0x4c6/0x5c0 [btrfs]
[  154.846409]  [<ffffffffc01ae500>] ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[  154.870077]  [<ffffffff813a8d6f>] bio_endio+0x3f/0x60
[  154.870974]  [<ffffffffc0183a2c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  154.879689]  [<ffffffffc01c01da>] btrfs_scrubparity_helper+0xca/0x2e0 [btrfs]
[  154.881068]  [<ffffffffc01c04de>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  154.885250]  [<ffffffff81099f45>] process_one_work+0x165/0x480
[  154.886354]  [<ffffffff8109a2ab>] worker_thread+0x4b/0x500
[  154.888417]  [<ffffffff8109a260>] ? process_one_work+0x480/0x480
[  154.889465]  [<ffffffff8109a260>] ? process_one_work+0x480/0x480
[  154.899651]  [<ffffffff810a04e8>] kthread+0xd8/0xf0
[  154.900856]  [<ffffffff810a0410>] ? kthread_create_on_node+0x1a0/0x1a0
[  154.929652]  [<ffffffff8182398f>] ret_from_fork+0x3f/0x70
[  154.931814]  [<ffffffff810a0410>] ? kthread_create_on_node+0x1a0/0x1a0
[  154.932704] Code: 1e cd 81 e8 23 04 fe ff e9 a2 fe ff ff 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 58 05 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[  154.943230] RIP  [<ffffffff810a0ba0>] kthread_data+0x10/0x20
[  154.944024]  RSP <ffff880036187760>
[  154.949641] CR2: ffffffffffffffd8
[  154.950113] ---[ end trace f0effd96a236110b ]---
[  154.950742] Fixing recursive fault but reboot is needed!

Best regards,

James Johnston


