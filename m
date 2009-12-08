From: Daniel Armak <danarmak@gmail.com>
Subject: Kernel oops trying to remove a missing disk
Date: Wed, 9 Dec 2009 01:51:17 +0200
Message-ID: <200912090151.17319.danarmak@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had a filesystem of 4x1GB disks in raid10. One died (real unplanned disk 
failure, not part of my testing) in the middle of a btrfs-vol -b run. The bad 
disk decided it's only 33MB large, so btrfs started displaying various errors 
related to pointers pointing beyond end of disk.

I've now pulled the bad disk:

Label: none  uuid: e40a14c7-7be7-4248-8b74-22fd5cc1e316
        Total devices 4 FS bytes used 2.03TB
        devid    3 size 931.51GB used 582.01GB path /dev/sdb1
        devid    1 size 922.20GB used 601.01GB path /dev/sdc2
        devid    2 size 911.95GB used 573.00GB path /dev/sdd4
        *** Some devices missing

Mounting with -o degraded prints these kernel errors:

btrfs: allowing degraded mounts
btrfs bad tree block start 17517162628300600453 7668718657536
btrfs bad tree block start 3141689552950487413 7668718665728
btrfs bad tree block start 1474953444005052354 7668718669824
btrfs bad tree block start 13452497792987862783 7668718678016
btrfs bad tree block start 8270016379796020352 7668718702592
btrfs bad tree block start 2723291376741258298 7668718706688
btrfs bad tree block start 10528685341008040285 7668718710784
btrfs bad tree block start 9043639721281971072 7668718694400
btrfs bad tree block start 14211769779666844633 7668718698496
btrfs bad tree block start 6206578445793925291 7668718686208
warning devid 4 missing
__ratelimit: 1928 callbacks suppressed
btrfs bad tree block start 0 7665507205120
btrfs bad tree block start 0 7665507205120
btrfs bad tree block start 7471179476992 7647273136128
btrfs bad tree block start 7471179476992 7647273136128
btrfs bad tree block start 7471252631552 7647346290688
btrfs bad tree block start 7471252639744 7647346298880
btrfs bad tree block start 7471252652032 7647346311168
btrfs bad tree block start 7471252684800 7647346343936
btrfs bad tree block start 7471252688896 7647346348032
btrfs bad tree block start 7471252705280 7647346364416
__ratelimit: 1504 callbacks suppressed
btrfs bad tree block start 0 7665581350912
btrfs bad tree block start 0 7665581350912
btrfs bad tree block start 0 7665590784000
btrfs bad tree block start 0 7665590784000
btrfs bad tree block start 7517129043968 7645978062848
btrfs bad tree block start 7517129043968 7645978062848

Attempting btrfs-vol -r missing:

btrfs: relocating block group 6286804516864 flags 9                                                                                                                                 
------------[ cut here ]------------                                                                                                                                                
WARNING: at fs/btrfs/relocation.c:3588 btrfs_relocate_block_group+0x293/0x3a0 
[btrfs]()                                                                                             
Hardware name:                                                                                                                                                                      
Modules linked in: loop btrfs zlib_deflate crc32c libcrc32c cryptd aes_x86_64 
aes_generic nfs fscache ipv6 nfsd usbhid lockd nfs_acl hid auth_rpcgss 
exportfs ata_generic pata_acpi pata_amd snd_hda_codec_realtek ide_pci_generic 
arc4 fan ecb battery snd_seq_dummy snd_seq_oss ohci_hcd snd_seq_midi_event ac 
snd_seq snd_seq_device snd_hda_intel ath5k snd_hda_codec snd_hwdep mac80211 
snd_pcm_oss ath snd_pcm cfg80211 snd_mixer_oss snd_timer amd64_edac_mod snd 
rfkill edac_core soundcore amd74xx psmouse i2c_nforce2 ehci_hcd thermal evdev 
serio_raw sg k8temp led_class edac_mce_amd button processor snd_page_alloc 
sunrpc forcedeth pcspkr ide_core i2c_core usbcore rtc_cmos rtc_core rtc_lib 
ext4 mbcache jbd2 crc16 sd_mod sata_nv libata scsi_mod                                                                                                                                                                
Pid: 1919, comm: btrfs-vol Not tainted 2.6.32-ARCH #7                                                                                                                               
Call Trace:                                                                                                                                                                         
 [<ffffffff81055b23>] ? warn_slowpath_common+0x73/0xb0                                                                                                                              
 [<ffffffffa06a7fc3>] ? btrfs_relocate_block_group+0x293/0x3a0 [btrfs]                                                                                                              
 [<ffffffffa068e3a7>] ? btrfs_relocate_chunk+0x77/0x560 [btrfs]                                                                                                                     
 [<ffffffffa0678e07>] ? btrfs_dev_extent_chunk_offset+0xf7/0x110 [btrfs]                                                                                                            
 [<ffffffffa068eae0>] ? btrfs_shrink_device+0x250/0x380 [btrfs]
 [<ffffffffa068f13a>] ? btrfs_rm_device+0x1da/0x580 [btrfs]
 [<ffffffffa0693f12>] ? btrfs_ioctl+0x272/0xa60 [btrfs]
 [<ffffffffa0693f34>] ? btrfs_ioctl+0x294/0xa60 [btrfs]
 [<ffffffff8111ee8d>] ? vfs_ioctl+0x1d/0xb0
 [<ffffffff8111f048>] ? do_vfs_ioctl+0x88/0x570
 [<ffffffff810385d6>] ? do_page_fault+0x136/0x3d0
 [<ffffffff8111f5b0>] ? sys_ioctl+0x80/0xa0
 [<ffffffff81012042>] ? system_call_fastpath+0x16/0x1b
---[ end trace 168f13ad0626c5d7 ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:1746!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/block/loop7/removable
CPU 0
Modules linked in: loop btrfs zlib_deflate crc32c libcrc32c cryptd aes_x86_64 
aes_generic nfs fscache ipv6 nfsd usbhid lockd nfs_acl hid auth_rpcgss 
exportfs ata_generic pata_acpi pata_amd snd_hda_codec_realtek ide_pci_generic 
arc4 fan ecb battery snd_seq_dummy snd_seq_oss ohci_hcd snd_seq_midi_event ac 
snd_seq snd_seq_device snd_hda_intel ath5k snd_hda_codec snd_hwdep mac80211 
snd_pcm_oss ath snd_pcm cfg80211 snd_mixer_oss snd_timer amd64_edac_mod snd 
rfkill edac_core soundcore amd74xx psmouse i2c_nforce2 ehci_hcd thermal evdev 
serio_raw sg k8temp led_class edac_mce_amd button processor snd_page_alloc 
sunrpc forcedeth pcspkr ide_core i2c_core usbcore rtc_cmos rtc_core rtc_lib 
ext4 mbcache jbd2 crc16 sd_mod sata_nv libata scsi_mod
Pid: 1919, comm: btrfs-vol Tainted: G        W  2.6.32-ARCH #7
RIP: 0010:[<ffffffffa068e874>]  [<ffffffffa068e874>] btrfs_relocate_chunk+0x544/0x560 
[btrfs]
RSP: 0018:ffff880015b21b98  EFLAGS: 00010282
RAX: 00000000fffffffb RBX: ffff880015bfc000 RCX: 0000000000000000
RDX: 000000000000000e RSI: ffffea000046a4b8 RDI: 0000000000000282
RBP: ffff88001689d800 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001ab4d000
R13: 000005b7c2c00000 R14: 0000000000000003 R15: 0000000000000000
FS:  00007fa3b97fd740(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fa3b912e5f0 CR3: 0000000015a8c000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-vol (pid: 1919, threadinfo ffff880015b20000, task ffff88001b3fbc30)
Stack:
 ffff880015b21cf8 0000000073a7c38c 0000000000000003 ffff880015b20000
<0> ffff880015b21fd8 ffff880015b21fd8 0000000100000000 000005b7c2c00000
<0> ffff88001689f000 0000000000000000 ffff880016898800 0000000000000003
Call Trace:
 [<ffffffffa0678e07>] ? btrfs_dev_extent_chunk_offset+0xf7/0x110 [btrfs]
 [<ffffffffa068eae0>] ? btrfs_shrink_device+0x250/0x380 [btrfs]
 [<ffffffffa068f13a>] ? btrfs_rm_device+0x1da/0x580 [btrfs]
 [<ffffffffa0693f12>] ? btrfs_ioctl+0x272/0xa60 [btrfs]
 [<ffffffffa0693f34>] ? btrfs_ioctl+0x294/0xa60 [btrfs]
 [<ffffffff8111ee8d>] ? vfs_ioctl+0x1d/0xb0
 [<ffffffff8111f048>] ? do_vfs_ioctl+0x88/0x570
 [<ffffffff810385d6>] ? do_page_fault+0x136/0x3d0
 [<ffffffff8111f5b0>] ? sys_ioctl+0x80/0xa0
 [<ffffffff81012042>] ? system_call_fastpath+0x16/0x1b
Code: ff 31 c0 e9 30 fb ff ff 0f 1f 80 00 00 00 00 0f 0b eb fe 0f 1f 40 00 0f 0b 
eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 0f 0b eb 
fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f
RIP  [<ffffffffa068e874>] btrfs_relocate_chunk+0x544/0x560 [btrfs]
 RSP <ffff880015b21b98>
---[ end trace 168f13ad0626c5d8 ]---


Attempting btrfsck also segfaults:

[root@faun ~]# btrfsck /dev/sdb1
warning devid 4 not found already
leaf parent key incorrect 7638657990656
bad block 7638657990656
leaf parent key incorrect 7638662852608
bad block 7638662852608
leaf parent key incorrect 7638768693248
bad block 7638768693248
bad block 7641986412544
parent transid verify failed on 7638786170880 wanted 99369 found 98472
parent transid verify failed on 7638786170880 wanted 99369 found 98472
Segmentation fault

With dmesg merely adding:
device fsid 4842e77bc7140ae4-16e3c15cfd22748b devid 2 transid 99767 /dev/sdd4
device fsid 4842e77bc7140ae4-16e3c15cfd22748b devid 1 transid 99767 /dev/sdc2
device fsid 4842e77bc7140ae4-16e3c15cfd22748b devid 3 transid 99767 /dev/sdb1
btrfsck[1831]: segfault at c4 ip 000000000040ed3e sp 00007fffc30fde90 error 4 
in btrfsck[400000+1d000]

------------------

This is kernel 2.6.32 and btrfs-progs from git (I ran 0.19, had this problem, 
then upgraded but that made no difference).

Is this any use to you? Is there a way to rescue (perhaps part of) the 
filesystem? The metadata (dir structure, etc) seems fine when mounted in 
degraded mode, but trying to read (some?) files results in IO errors.

If you want more info or the debug tree, please say so now because I'll reuse 
the disks in a day or two if I can't get any data out.

Thanks,

Dan Armak
