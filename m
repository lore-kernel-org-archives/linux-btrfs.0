From: RK <rkasl@computer.org>
Subject: kernel BUG at /build/buildd/linux-2.6.32/fs/btrfs/volumes.c:1772!
Date: Sun, 24 Jan 2010 11:36:46 -0500
Message-ID: <4B5C771E.9010700@computer.org>
References: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com> <201001240902.38535.kreijack@libero.it> <4B5C34D2.5060701@freeshell.org> <201001241423.28286.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001241423.28286.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

..  btrfs-vol -r missing /mnt/btrfs will end with segmentation fault due to this kernel BUG 
(this box runs ubuntu server 10.02 Alpha 2 and the btrfs-tools package is from the ubuntu depository)
 
# btrfs-show
failed to read /dev/sdf
failed to read /dev/sr0
Label: btrfs_label_01  uuid: acc4b180-4a26-43cf-a103-1fc83faced1a
    Total devices 6 FS bytes used 2.00GB
    devid    1 size 931.51GB used 1.02GB path /dev/sda
    devid    2 size 931.51GB used 1.00GB path /dev/sdb
    devid    3 size 931.51GB used 2.00GB path /dev/sdc
    devid    4 size 931.51GB used 2.00GB path /dev/sdd
    devid    6 size 931.48GB used 1.01GB path /dev/sdg
    *** Some devices missing

Btrfs Btrfs v0.19

# umount /mnt/btrfs

#  btrfsctl -a
Scanning for Btrfs filesystems
failed to read /dev/sdg
failed to read /dev/sr0

# mount -o degraded /dev/sda /mnt/btrfs
# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sde1              66G  3.8G   59G   7% /
/dev/sda              5.5T   28K  5.5T   1% /mnt/btrfs

# btrfs-vol -r missing /mnt/btrfs
removing missing devices from /mnt/btrfs
Segmentation fault

# dmsg

**
[  482.623701] ------------[ cut here ]------------
[  482.623703] kernel BUG at /build/buildd/linux-2.6.32/fs/btrfs/volumes.c:1772!
[  482.623706] invalid opcode: 0000 [#1] SMP
[  482.623709] last sysfs file:
/sys/devices/pci0000:00/0000:00:06.0/0000:02:05.0/host1/target1:0:0/1:0:0:0/block/sdb/uevent
[  482.623712] CPU 0
[  482.623714] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
aoe binfmt_misc snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd ppdev parport_pc
soundcore snd_page_alloc amd64_edac_mod i2c_amd756 amd_rng psmouse
serio_raw i2c_amd8111 edac_core k8temp edac_mce_amd shpchp lp parport
fbcon tileblit font bitblit softcursor vga16fb vgastate r8169 ohci1394
mii aic7xxx ieee1394 e1000 scsi_transport_spi aacraid radeon ttm floppy
drm_kms_helper drm i2c_algo_bit
[  482.623754] Pid: 3417, comm: btrfs-vol Not tainted 2.6.32-11-server
#15-Ubuntu To Be Filled By O.E.M.
[  482.623757] RIP: 0010:[<ffffffffa03671d4>]  [<ffffffffa03671d4>]
btrfs_relocate_chunk+0x2f4/0x320 [btrfs]
[  482.623788] RSP: 0018:ffff8800baaf7c88  EFLAGS: 00010286
[  482.623790] RAX: 00000000ffffffe4 RBX: ffff8800a7c77100 RCX:
ffff8800bc35d000
[  482.623792] RDX: 0000000000000000 RSI: ffffea000292bc58 RDI:
0000000000000206
[  482.623795] RBP: ffff8800baaf7d18 R08: 0000000000000036 R09:
000000000000c101
[  482.623797] R10: 0000000000000005 R11: 0000000000000000 R12:
ffff8800bc3b4000
[  482.623799] R13: 0000000000000020 R14: 0000000000000000 R15:
0000000000000003
[  482.623802] FS:  00007f306b2ac740(0000) GS:ffff880001c00000(0000)
knlGS:0000000000000000
[  482.623804] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  482.623806] CR2: 00007f306ac16ac0 CR3: 00000000aa012000 CR4:
00000000000006f0
[  482.623808] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  482.623810] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  482.623813] Process btrfs-vol (pid: 3417, threadinfo
ffff8800baaf6000, task ffff8800a7c68000)
[  482.623815] Stack:
[  482.623816]  0000000000000da0 ffff8800aa275c00 ffff8800baaf7d18
ffffffffa03537a5
[  482.623820] <0> ffff8800baaf7cd8 ffff8800ba7c80e8 0000000000000100
ffff8800ba7c80f0
[  482.623823] <0> ffff8800a7d45000 ffff8800a3c3c108 ffff8800a7d43000
0000000041c00000
[  482.623827] Call Trace:
[  482.623839]  [<ffffffffa03537a5>] ?
btrfs_dev_extent_chunk_offset+0xe5/0xf0 [btrfs]
[  482.623848]  [<ffffffffa0367701>] btrfs_shrink_device+0x221/0x390 [btrfs]
[  482.623857]  [<ffffffffa0367cd1>] btrfs_rm_device+0x1e1/0x480 [btrfs]
[  482.623865]  [<ffffffffa036dd97>] btrfs_ioctl+0x1c7/0x3f0 [btrfs]
[  482.623871]  [<ffffffff811508d2>] vfs_ioctl+0x22/0xa0
[  482.623876]  [<ffffffff812b1fba>] ? __up_read+0x9a/0xc0
[  482.623879]  [<ffffffff81150a71>] do_vfs_ioctl+0x81/0x410
[  482.623884]  [<ffffffff8108780e>] ? up_read+0xe/0x10
[  482.623889]  [<ffffffff815642cf>] ? do_page_fault+0x18f/0x360
[  482.623891]  [<ffffffff81150e81>] sys_ioctl+0x81/0xa0
[  482.623897]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
[  482.623898] Code: 48 8b 7d c0 e8 be d2 ff ff 48 8b 75 c0 4c 89 e7 e8
42 ad fd ff 48 83 c4 68 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 90 0f 0b
eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f
[  482.623924] RIP  [<ffffffffa03671d4>]
btrfs_relocate_chunk+0x2f4/0x320 [btrfs]
[  482.623933]  RSP <ffff8800baaf7c88>
[  482.623936] ---[ end trace 92bb2e88797fdf58 ]---
#
***


# lsscsi -g
[0:0:0:0]    disk    ATA      ST31000520AS     CC32  /dev/sda  /dev/sg0
[1:0:0:0]    disk    ATA      ST31000520AS     CC32  /dev/sdb  /dev/sg1
[2:0:0:0]    disk    ATA      ST31000520AS     CC32  /dev/sdc  /dev/sg2
[3:0:0:0]    disk    ATA      ST31000520AS     CC32  /dev/sdd  /dev/sg3
[4:0:0:0]    cd/dvd  SONY     CD-RW  CRX320E   NYK5  /dev/sr0  /dev/sg4
[6:0:0:0]    disk    Adaptec  system           V1.0  /dev/sde  /dev/sg5
[6:0:1:0]    disk    Adaptec  disk2            V1.0  /dev/sdf  /dev/sg6
[6:0:2:0]    disk    Adaptec  disk3            V1.0  /dev/sdg  /dev/sg7
[6:1:0:0]    disk    WDC      WD740GD-00FLA2   31.0  -         /dev/sg8
[6:1:1:0]    disk    WDC      WD740GD-00FLA2   31.0  -         /dev/sg9
[6:1:2:0]    disk    ST310005 20AS             CC32  -         /dev/sg10
[6:1:3:0]    disk    ST310005 20AS             CC32  -         /dev/sg11


**

