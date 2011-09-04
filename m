From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Snapshot of root makes an undeletable folder
Date: Sun, 4 Sep 2011 11:29:43 -0400
Message-ID: <CALJXSJprxWVE3Ms1PLzWBgWa4MutRLeG0f7xx2Q58LW0nhbFrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I recently converted a long-used ext4 filesystem after e2fsck to btrfs
using btrfs-convert, everything went fine and all my files are there.
I then decided to make the filesystem more managable so I made a
snapshot of the root and removed the rest of the root like:

Original listing:
ext2_saved folder1 folder2 folder3 folder4 lost+found

btrfs sub snap . music
rm -rf folder1 folder2 folder3 folder4 lost+found music/lost+found

So now I end up with only a music folder on root which I was able to
mount using subvol= to another folder and use the btrfs FS for other
subvolumes.

The next day I decided to remove the ext2_image snapshot and grow the
filesystem to accomodate for other files, this was still OK.

Then I though about my folder organization again and renamed music to
downloads, this is still OK and then create music in downloads, I was
told "music" already exists, however I can't neither see it, list it,
cd to it or remove it.

I then made a snapshot of downloads to music and now music is listed as:
ls: cannot access /mnt/btrfs/downloads/music: No such file or directory
d????????? ? ?      ?         ?            ? music

btrfsck gives me:
root /mnt # btrfsck /dev/vgP4RAID5/btrfs
root 289 root dir 256 error
found 52167258112 bytes used err is 1
total csum bytes: 50868244
total tree bytes: 76210176
total fs tree bytes: 6860800
btree space waste bytes: 15322691
file data blocks allocated: 52091047936
 referenced 52091047936
Btrfs v0.19-35-g1b444cd-dirty


There is also a OOPS associated to it:
[82291.652513] new size for /dev/mapper/vgP4RAID5-btrfs is 75161927680
[83636.560865] btrfs failed to delete reference to music, inode 263 parent 256
[83679.232134] ------------[ cut here ]------------
[83679.232142] WARNING: at fs/dcache.c:1350 d_set_d_op+0x8e/0xc0()
[83679.232144] Hardware name: P55-USB3
[83679.232145] Modules linked in: snd_seq_dummy snd_seq snd_seq_device
nvidia(P) squashfs xfs exportfs reiserfs ext3 jbd
snd_hda_codec_realtek usbhid snd_hda_intel snd_hda_codec hid usblp
snd_hwdep snd_pcm sg i2c_i801 intel_agp snd_timer snd evdev ppdev
parport_pc soundcore snd_page_alloc i2c_core r8169 intel_gtt parport
mii processor pcspkr iTCO_wdt iTCO_vendor_support button ipv6 sr_mod
sd_mod cdrom pata_acpi pata_jmicron ahci libahci libata uhci_hcd
xhci_hcd btrfs zlib_deflate crc32c libcrc32c ext4 mbcache jbd2 crc16
fuse usb_storage scsi_mod ehci_hcd usbcore raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 md_mod
dm_snapshot dm_mod loop
[83679.232186] Pid: 14614, comm: ls Tainted: P            3.0.4-Ti #2
[83679.232187] Call Trace:
[83679.232193]  [<ffffffff8105c7ef>] warn_slowpath_common+0x7f/0xc0
[83679.232195]  [<ffffffff8105c84a>] warn_slowpath_null+0x1a/0x20
[83679.232196]  [<ffffffff8116bdfe>] d_set_d_op+0x8e/0xc0
[83679.232199]  [<ffffffff8117c50f>] simple_lookup+0x3f/0x60
[83679.232201]  [<ffffffff811626f5>] d_alloc_and_lookup+0x45/0x90
[83679.232204]  [<ffffffff8116f765>] ? d_lookup+0x35/0x60
[83679.232206]  [<ffffffff81163f5e>] do_lookup+0x29e/0x310
[83679.232208]  [<ffffffff81164bdc>] path_lookupat+0x11c/0x700
[83679.232210]  [<ffffffff811651f1>] do_path_lookup+0x31/0xc0
[83679.232211]  [<ffffffff81166db9>] user_path_at+0x59/0xa0
[83679.232214]  [<ffffffff812b871b>] ? tty_ioctl+0x5cb/0xbc0
[83679.232217]  [<ffffffff810398f0>] ? do_page_fault+0x1c0/0x4d0
[83679.232220]  [<ffffffff8115c284>] vfs_fstatat+0x44/0x70
[83679.232224]  [<ffffffff81072f0d>] ? do_sigaction+0x12d/0x1f0
[83679.232226]  [<ffffffff8115c2eb>] vfs_stat+0x1b/0x20
[83679.232227]  [<ffffffff8115c42a>] sys_newstat+0x1a/0x40
[83679.232229]  [<ffffffff810732dd>] ? sys_rt_sigaction+0x8d/0xc0
[83679.232233]  [<ffffffff813f4485>] ? page_fault+0x25/0x30
[83679.232267]  [<ffffffff813f4a42>] system_call_fastpath+0x16/0x1b
[83679.232269] ---[ end trace 6bdc8b9bb849be1c ]---
[83679.232270] ------------[ cut here ]------------
[83679.232272] WARNING: at fs/dcache.c:1354 d_set_d_op+0xb1/0xc0()
[83679.232273] Hardware name: P55-USB3
[83679.232274] Modules linked in: snd_seq_dummy snd_seq snd_seq_device
nvidia(P) squashfs xfs exportfs reiserfs ext3 jbd
snd_hda_codec_realtek usbhid snd_hda_intel snd_hda_codec hid usblp
snd_hwdep snd_pcm sg i2c_i801 intel_agp snd_timer snd evdev ppdev
parport_pc soundcore snd_page_alloc i2c_core r8169 intel_gtt parport
mii processor pcspkr iTCO_wdt iTCO_vendor_support button ipv6 sr_mod
sd_mod cdrom pata_acpi pata_jmicron ahci libahci libata uhci_hcd
xhci_hcd btrfs zlib_deflate crc32c libcrc32c ext4 mbcache jbd2 crc16
fuse usb_storage scsi_mod ehci_hcd usbcore raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 md_mod
dm_snapshot dm_mod loop
[83679.232309] Pid: 14614, comm: ls Tainted: P        W   3.0.4-Ti #2
[83679.232310] Call Trace:
[83679.232313]  [<ffffffff8105c7ef>] warn_slowpath_common+0x7f/0xc0
[83679.232316]  [<ffffffff8105c84a>] warn_slowpath_null+0x1a/0x20
[83679.232318]  [<ffffffff8116be21>] d_set_d_op+0xb1/0xc0
[83679.232321]  [<ffffffff8117c50f>] simple_lookup+0x3f/0x60
[83679.232323]  [<ffffffff811626f5>] d_alloc_and_lookup+0x45/0x90
[83679.232326]  [<ffffffff8116f765>] ? d_lookup+0x35/0x60
[83679.232328]  [<ffffffff81163f5e>] do_lookup+0x29e/0x310
[83679.232330]  [<ffffffff81164bdc>] path_lookupat+0x11c/0x700
[83679.232333]  [<ffffffff811651f1>] do_path_lookup+0x31/0xc0
[83679.232336]  [<ffffffff81166db9>] user_path_at+0x59/0xa0
[83679.232338]  [<ffffffff812b871b>] ? tty_ioctl+0x5cb/0xbc0
[83679.232341]  [<ffffffff810398f0>] ? do_page_fault+0x1c0/0x4d0
[83679.232344]  [<ffffffff8115c284>] vfs_fstatat+0x44/0x70
[83679.232346]  [<ffffffff81072f0d>] ? do_sigaction+0x12d/0x1f0
[83679.232349]  [<ffffffff8115c2eb>] vfs_stat+0x1b/0x20
[83679.232351]  [<ffffffff8115c42a>] sys_newstat+0x1a/0x40
[83679.232354]  [<ffffffff810732dd>] ? sys_rt_sigaction+0x8d/0xc0
[83679.232356]  [<ffffffff813f4485>] ? page_fault+0x25/0x30
[83679.232359]  [<ffffffff813f4a42>] system_call_fastpath+0x16/0x1b
[83679.232361] ---[ end trace 6bdc8b9bb849be1d ]---
[84677.658072] BTRFS: inode 263 still on the orphan list
[84678.463683] ------------[ cut here ]------------
[84678.463714] WARNING: at fs/btrfs/extent-tree.c:6891
btrfs_free_block_groups+0x226/0x310 [btrfs]()
[84678.463718] Hardware name: P55-USB3
[84678.463720] Modules linked in: snd_seq_dummy snd_seq snd_seq_device
nvidia(P) squashfs xfs exportfs reiserfs ext3 jbd
snd_hda_codec_realtek usbhid snd_hda_intel snd_hda_codec hid usblp
snd_hwdep snd_pcm sg i2c_i801 intel_agp snd_timer snd evdev ppdev
parport_pc soundcore snd_page_alloc i2c_core r8169 intel_gtt parport
mii processor pcspkr iTCO_wdt iTCO_vendor_support button ipv6 sr_mod
sd_mod cdrom pata_acpi pata_jmicron ahci libahci libata uhci_hcd
xhci_hcd btrfs zlib_deflate crc32c libcrc32c ext4 mbcache jbd2 crc16
fuse usb_storage scsi_mod ehci_hcd usbcore raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 md_mod
dm_snapshot dm_mod loop
[84678.463782] Pid: 14783, comm: umount Tainted: P        W   3.0.4-Ti #2
[84678.463785] Call Trace:
[84678.463795]  [<ffffffff8105c7ef>] warn_slowpath_common+0x7f/0xc0
[84678.463802]  [<ffffffff8105c84a>] warn_slowpath_null+0x1a/0x20
[84678.463809]  [<ffffffffa01dde06>] btrfs_free_block_groups+0x226/0x310 [btrfs]
[84678.463816]  [<ffffffffa01e938e>] close_ctree+0x1de/0x370 [btrfs]
[84678.463819]  [<ffffffff81171821>] ? dispose_list+0x41/0x50
[84678.463821]  [<ffffffff81172574>] ? evict_inodes+0x124/0x140
[84678.463825]  [<ffffffffa01c34bd>] btrfs_put_super+0x1d/0x30 [btrfs]
[84678.463828]  [<ffffffff811598a2>] generic_shutdown_super+0x72/0x100
[84678.463830]  [<ffffffff811599c6>] kill_anon_super+0x16/0x60
[84678.463832]  [<ffffffff81159cdc>] deactivate_locked_super+0x3c/0x90
[84678.463834]  [<ffffffff8115a72e>] deactivate_super+0x4e/0x70
[84678.463836]  [<ffffffff81175fb8>] mntput_no_expire+0x98/0xe0
[84678.463838]  [<ffffffff81176c9c>] sys_umount+0x6c/0x380
[84678.463841]  [<ffffffff813f4a42>] system_call_fastpath+0x16/0x1b
[84678.463842] ---[ end trace 6bdc8b9bb849be1e ]---
[84678.463844] space_info has 2883506176 free, is not full
[84678.463845] space_info total=17863540736, used=14979870720,
pinned=0, reserved=98304, may_use=0, readonly=65536
[84999.733748] device label music devid 1 transid 77 /dev/mapper/vgP4RAID5-btrfs
[84999.734781] btrfs: enabling disk space caching


So as a workaround I applied to my kernel 2 patches:
* Btrfs-reverse-enough-space-for-file-clone.patch   (I hope this patch
is in 3.1, as it could cause DoS else.)
* 2-2-btrfs-allow-cross-subvolume-BTRFS_IOC_CLONE.patch

I snapshotted the btrfs volume using LVM to test, made a new
subvolume, cp -a --reflink=always the content of the downloads
subvolume except music, then deleted the other subvolume, and now
everything works, btrfsck is happy and no more problems.

I will keep working with the old subvolume until I get an answer in
case you need more informations.
I can also tell that this is half-reproducible using a new btrfs
filesystem and snapshotting the root, except that after the second
snapshot the folder won't appear as unlistable, however it is not
removable unless you delete the original subvolume.
