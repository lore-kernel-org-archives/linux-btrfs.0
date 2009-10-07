From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Warning and BUG using btrfs-vol -b
Date: Wed, 7 Oct 2009 21:10:28 +0200
Message-ID: <200910072110.28958.diegocg@gmail.com>
References: <200910062048.32381.diegocg@gmail.com> <200910071551.46430.diegocg@gmail.com> <20091007143309.GF3757@think>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091007143309.GF3757@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 07 October 2009 16:33:09 Chris Mason escribi=F3:
> Ok, in this case you ended up with raid0 on the data.  If you:
>=20
> mkfs.btrfs -d raid1 /dev/loop0 /dev/loop1 you'll get data raid1.

I got a BUG...but it may be a different bug. Unlike the last time,
I didn't even need to zero one of the "disks", the second I
rebalanced it oopsed:

[  705.060358] btrfs: relocating block group 4194304 flags 4           =
                                                      =20
[ 1006.106133] btrfs: relocating block group 5704777728 flags 18       =
                                                      =20
[ 1006.336521] btrfs: found 1 extents                                  =
                                                      =20
[ 1006.469967] btrfs: relocating block group 5384896512 flags 20       =
                                                      =20
[ 1006.471043] btrfs allocation failed flags 20, wanted 4096           =
                                                      =20
[ 1006.471048] space_info has 317378560 free, is full                  =
                                                      =20
[ 1006.471052] space_info total=3D319881216, pinned=3D16384, delalloc=3D=
0, may_use=3D0, used=3D2355200, root=3D2875392, super=3D131072, reserve=
d=3D0                                                                  =
                                                     =20
[ 1006.471058] block group 5384896512 has 319881216 bytes, 2355200 used=
 16384 pinned 0 reserved                              =20
[ 1006.471063] entry offset 5384896512, bytes 483328, bitmap yes       =
                                                      =20
[ 1006.471065] block group has cluster?: yes                           =
                                                      =20
[ 1006.471067] 1 blocks of free space at or bigger than bytes is       =
                                                      =20
[ 1006.471092] ------------[ cut here ]------------                    =
                                                      =20
[ 1006.471094] kernel BUG at fs/btrfs/transaction.c:1001!              =
                                                      =20
[ 1006.471098] invalid opcode: 0000 [#1] PREEMPT SMP                   =
                                                      =20
[ 1006.471103] last sysfs file: /sys/devices/virtual/block/loop0/range =
                                                      =20
[ 1006.471106] CPU 0                                                   =
                                                      =20
[ 1006.471109] Modules linked in: ppp_deflate bsd_comp ppp_async crc_cc=
itt btrfs zlib_deflate crc32c libcrc32c loop ppp_generic slhc kvm_intel=
 kvm i915 snd_ca0106 snd_rawmidi drm_kms_helper snd_ac97_codec ac97_bus=
 cfbcopyarea snd_pcm_oss video snd_mixer_oss backlight snd_pcm snd_time=
r cfbimgblt processor wacom intel_agp cfbfillrect button snd soundcore =
snd_page_alloc usbhid fan fuse ehci_hcd uhci_hcd thermal thermal_sys at=
l1 mii usbcore                                                         =
      =20
[ 1006.471159] Pid: 8207, comm: btrfs-vol Not tainted 2.6.32-rc3 #1 Sys=
tem Product Name                                      =20
[ 1006.471162] RIP: 0010:[<ffffffffa0257665>]  [<ffffffffa0257665>] btr=
fs_commit_transaction+0x6c5/0x6f0 [btrfs]             =20
[ 1006.471183] RSP: 0018:ffff8800bc285a78  EFLAGS: 00010286            =
                                                      =20
[ 1006.471186] RAX: 00000000ffffffe4 RBX: ffff8800bdef5800 RCX: 0000000=
000000016                                             =20
[ 1006.471189] RDX: 0000000000000000 RSI: ffff8800bc2859f8 RDI: ffff880=
0a86d8060                                             =20
[ 1006.471192] RBP: ffff8800bc285b18 R08: 0000000000000000 R09: 0000000=
000000000                                             =20
[ 1006.471195] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880=
0a181f5c0                                             =20
[ 1006.471199] R13: ffff8800a1eb1ae0 R14: ffff8800bc285ab8 R15: ffff880=
0a1eb1b50
[ 1006.471202] FS:  00007f7c5427f730(0000) GS:ffff880001800000(0000) kn=
lGS:0000000000000000
[ 1006.471206] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1006.471209] CR2: 0000000002812500 CR3: 00000000a2f88000 CR4: 0000000=
0000026f0
[ 1006.471212] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 1006.471215] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 1006.471219] Process btrfs-vol (pid: 8207, threadinfo ffff8800bc28400=
0, task ffff88000b2bae00)
[ 1006.471221] Stack:
[ 1006.471223]  ffff8800bc285ad8 0000000000000206 00000001bf15ad00 0000=
000001000010
[ 1006.471229] <0> ffff8800a181f5c0 0000000000000004 ffff8800a1eb1b80 f=
fff8800a1eb1ae0
[ 1006.471235] <0> 0000000000000000 ffff88000b2bae00 ffffffff8106eb30 f=
fff8800bc285ad0
[ 1006.471242] Call Trace:
[ 1006.471250]  [<ffffffff8106eb30>] ? autoremove_wake_function+0x0/0x4=
0
[ 1006.471264]  [<ffffffffa0256d0e>] ? start_transaction+0x11e/0x170 [b=
trfs]
[ 1006.471285]  [<ffffffffa029630c>] relocate_block_group+0xec/0x4b0 [b=
trfs]
[ 1006.471291]  [<ffffffff813cf4e9>] ? sub_preempt_count+0x59/0x60
[ 1006.471301]  [<ffffffffa025596b>] ? btrfs_clean_old_snapshots+0x8b/0=
x1c0 [btrfs]
[ 1006.471314]  [<ffffffffa02714fb>] ? btrfs_wait_ordered_extents+0x1bb=
/0x1d0 [btrfs]
[ 1006.471325]  [<ffffffffa0296a5a>] btrfs_relocate_block_group+0x15a/0=
x390 [btrfs]
[ 1006.471336]  [<ffffffffa027cfab>] btrfs_relocate_chunk+0x8b/0x5e0 [b=
trfs]
[ 1006.471348]  [<ffffffffa0272a0b>] ? map_extent_buffer+0xdb/0xe0 [btr=
fs]
[ 1006.471359]  [<ffffffffa0271b13>] ? unmap_extent_buffer+0x13/0x40 [b=
trfs]
[ 1006.471372]  [<ffffffffa0266c54>] ? btrfs_item_offset+0xe4/0xf0 [btr=
fs]
[ 1006.471383]  [<ffffffffa027db3f>] btrfs_balance+0x1ef/0x270 [btrfs]
[ 1006.471387]  [<ffffffff810cc0ef>] ? find_get_page+0x7f/0xf0
[ 1006.471398]  [<ffffffffa0282e10>] btrfs_ioctl+0x510/0xa20 [btrfs]
[ 1006.471401]  [<ffffffff810cc3e7>] ? unlock_page+0x27/0x30
[ 1006.471406]  [<ffffffff810e8409>] ? __do_fault+0x449/0x540
[ 1006.471412]  [<ffffffff8111bf62>] vfs_ioctl+0x22/0xa0
[ 1006.471415]  [<ffffffff813cf4e9>] ? sub_preempt_count+0x59/0x60
[ 1006.471419]  [<ffffffff8111c108>] do_vfs_ioctl+0x88/0x570
[ 1006.471424]  [<ffffffff8120ecc9>] ? __up_read+0x99/0xc0
[ 1006.471428]  [<ffffffff8107323e>] ? up_read+0xe/0x10
[ 1006.471432]  [<ffffffff8111c63f>] sys_ioctl+0x4f/0x80
[ 1006.471438]  [<ffffffff8100b5db>] system_call_fastpath+0x16/0x1b
[ 1006.471440] Code: 00 00 00 00 e9 c4 fe ff ff be ab 03 00 00 48 c7 c7=
 1a 84 29 a0 e8 ac 83 df e0 e9 e8 fa ff ff 0f 0b eb fe 0f 0b eb fe 0f 0=
b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe be d7 03 00 0=
0
[ 1006.471492] RIP  [<ffffffffa0257665>] btrfs_commit_transaction+0x6c5=
/0x6f0 [btrfs]
[ 1006.471504]  RSP <ffff8800bc285a78>
[ 1006.471507] ---[ end trace 14afea9f89710f14 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
