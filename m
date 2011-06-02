From: C Anthony Risinger <anthony@xtfx.me>
Subject: filesystem seeding ... BUGs on .38, .39, loopback, real devices, tmp
 branch ... everything
Date: Thu, 2 Jun 2011 04:20:11 -0500
Message-ID: <BANLkTikZyg0gyUZH5pQ9d=P4brsTUA9PCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

i'm trying to setup a seeded FS -- was only able to find this:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/10529

... and announcement-like info from 2009 or so.  i keep hitting
bugs/oops, and even though the FS *appears* to work correctly
afterwards, sometimes mount/strace/etc will hang (could only be .38
here).

i tried with loop devices at first, then "real" devices -- this is all
under KVM/QEMU, and with FSs that are/will be smaller than 1G.

i've tried with .38, .39, mixed blocks groups, the `tmp` branch from
btrfs-progs, and everything else i can think of ... what am i doing
wrong?  are these known problems (per the other thread ...)?  what is
the correct way to seed a filesystem?  `btrfs filesystem show` reports
the FS as missing a device ... but it seems to mount fine.  the
operation appears to spawn a whole new FS with the same label -- would
anyone mind elaborating more?

i used the "--rootdir" feature of mkfs.btrfs to populate the image
with ~100MB of barebone filesystem.  the `mtime` of the seeded image
never changes, so it *seems* to be working ... but i dont understand
how to reuse this image or what's really going on (per my above
questions :-).

... procedures follow along with the oops it produces; let me know
what, if anything, else i should try.  i get similar results no matter
what i attempt, so i only included the one for now.

thanks,

C Anthony

2.6.39, loopback, `tmp` branch
---------------------------------------------
#!/bin/bash

mkdir ro rw
truncate -s700MB output.img.rw
mkfs.btrfs -M -r /root/btrfs/fs -m raid0 -d raid0 -L _btrfs_ro_seed
btrfstune -S1 output.img
losetup /dev/loop0 output.img
losetup /dev/loop1 output.img.rw
mount /dev/loop0 ro
btrfs device add /dev/loop1 ro
# !!! BUG !!!
mount /dev/loop1 rw
echo there > ro/hi
# FAILS: Read-only filesystem
echo there > rw/hi
# SEEMS TO WORK ...
---------------------------------------------

# btrfs filesystem show
---------------------------------------------
Label: '_btrfs_ro_seed'  uuid: 1f29a49c-e437-4329-ac81-d50adea03688
	Total devices 1 FS bytes used 97.29MB
	devid    1 size 256.00MB used 169.96MB path /dev/loop0

Label: '_btrfs_ro_seed'  uuid: 5824e2ce-6008-4d6d-8e1a-a5b6621214ac
	Total devices 2 FS bytes used 97.29MB
	devid    2 size 667.57MB used 82.75MB path /dev/loop1
	*** Some devices missing

Btrfs v0.19-50-ge6bd18d-dirty
---------------------------------------------

START OOPS
---------------------------------------------
[ 2808.826972] device label _btrfs_ro_seed devid 1 transid 13 /dev/loop0
[ 2808.832205] device label _btrfs_ro_seed devid 1 transid 13 /dev/loop0
[ 2808.834058] btrfs: disk space caching is enabled
[ 2808.906916] ------------[ cut here ]------------
[ 2808.907673] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2808.908981] Hardware name: Bochs
[ 2808.909604] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2808.920256] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2808.921097] Call Trace:
[ 2808.921724]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2808.922532]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2808.923371]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2808.924257]  [<ffffffffa039f337>] ? read_extent_buffer+0xd7/0x1e0 [btrfs]
[ 2808.925134]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2808.925992]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2808.926863]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2808.927736]  [<ffffffffa039a202>] ? free_extent_state+0x32/0x50 [btrfs]
[ 2808.928589]  [<ffffffffa0360930>] btrfs_insert_empty_items+0x70/0xd0 [btrfs]
[ 2808.929455]  [<ffffffffa03609f0>] btrfs_insert_item+0x60/0xe0 [btrfs]
[ 2808.930323]  [<ffffffffa036e40c>] btrfs_make_block_group+0x25c/0x2d0 [btrfs]
[ 2808.931204]  [<ffffffffa03a41c4>] __btrfs_alloc_chunk+0x524/0x970 [btrfs]
[ 2808.932083]  [<ffffffffa03a4874>] init_first_rw_device+0x74/0x130 [btrfs]
[ 2808.932945]  [<ffffffff813c95a9>] ? __mutex_lock_slowpath+0x239/0x320
[ 2808.933805]  [<ffffffffa03a6512>] btrfs_init_new_device+0x642/0xcd0 [btrfs]
[ 2808.934669]  [<ffffffffa03ac128>] ? btrfs_ioctl+0x7c8/0xa20 [btrfs]
[ 2808.935519]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2808.936328]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2808.937151]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2808.937938]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2808.938710]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2808.939458]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2808.940236]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2808.941811] ---[ end trace ce763fabdc763f6c ]---
[ 2808.943259] ------------[ cut here ]------------
[ 2808.943985] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2808.945272] Hardware name: Bochs
[ 2808.945913] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2808.956191] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2808.957034] Call Trace:
[ 2808.957646]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2808.958433]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2808.959204]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2808.960064]  [<ffffffff81139c24>] ?
mem_cgroup_get_reclaim_stat_from_page+0x24/0x70
[ 2808.961293]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2808.962115]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2808.962930]  [<ffffffffa035b3dc>] ? bin_search+0xdc/0x130 [btrfs]
[ 2808.963752]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2808.964575]  [<ffffffffa0360930>] btrfs_insert_empty_items+0x70/0xd0 [btrfs]
[ 2808.965435]  [<ffffffffa03609f0>] btrfs_insert_item+0x60/0xe0 [btrfs]
[ 2808.966251]  [<ffffffffa036e40c>] btrfs_make_block_group+0x25c/0x2d0 [btrfs]
[ 2808.967113]  [<ffffffffa03a41c4>] __btrfs_alloc_chunk+0x524/0x970 [btrfs]
[ 2808.967936]  [<ffffffffa03a4874>] init_first_rw_device+0x74/0x130 [btrfs]
[ 2808.968764]  [<ffffffff813c95a9>] ? __mutex_lock_slowpath+0x239/0x320
[ 2808.969563]  [<ffffffffa03a6512>] btrfs_init_new_device+0x642/0xcd0 [btrfs]
[ 2808.970422]  [<ffffffffa03ac128>] ? btrfs_ioctl+0x7c8/0xa20 [btrfs]
[ 2808.971220]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2808.972020]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2808.972809]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2808.973578]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2808.974298]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2808.975032]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2808.975767]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2808.977292] ---[ end trace ce763fabdc763f6d ]---
[ 2808.978581] ------------[ cut here ]------------
[ 2808.979292] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2808.980720] Hardware name: Bochs
[ 2808.981352] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2808.991723] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2808.992528] Call Trace:
[ 2808.993141]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2808.993922]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2808.994702]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2808.995559]  [<ffffffffa039fb03>] ? map_extent_buffer+0xd3/0xe0 [btrfs]
[ 2808.996369]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2808.997298]  [<ffffffffa03562d4>] ? leaf_space_used+0xf4/0x130 [btrfs]
[ 2808.998106]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2808.998916]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2808.999730]  [<ffffffff8112bb1f>] ? kmem_cache_free+0x1f/0x150
[ 2809.000534]  [<ffffffffa0360930>] btrfs_insert_empty_items+0x70/0xd0 [btrfs]
[ 2809.001381]  [<ffffffffa03a3bab>] btrfs_alloc_dev_extent+0x8b/0x180 [btrfs]
[ 2809.002238]  [<ffffffffa03a421b>] __btrfs_alloc_chunk+0x57b/0x970 [btrfs]
[ 2809.003091]  [<ffffffffa03a4874>] init_first_rw_device+0x74/0x130 [btrfs]
[ 2809.003907]  [<ffffffff813c95a9>] ? __mutex_lock_slowpath+0x239/0x320
[ 2809.004705]  [<ffffffffa03a6512>] btrfs_init_new_device+0x642/0xcd0 [btrfs]
[ 2809.005547]  [<ffffffffa03ac128>] ? btrfs_ioctl+0x7c8/0xa20 [btrfs]
[ 2809.006335]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2809.007148]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2809.007917]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2809.008688]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2809.009412]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2809.010193]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2809.012264]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2809.013893] ---[ end trace ce763fabdc763f6e ]---
[ 2809.015277] ------------[ cut here ]------------
[ 2809.015995] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2809.017446] Hardware name: Bochs
[ 2809.018095] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2809.028304] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2809.029131] Call Trace:
[ 2809.029719]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2809.030528]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2809.031310]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2809.032161]  [<ffffffff81139c24>] ?
mem_cgroup_get_reclaim_stat_from_page+0x24/0x70
[ 2809.033421]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2809.034235]  [<ffffffff81205370>] ? rb_insert_color+0x110/0x150
[ 2809.035034]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2809.035849]  [<ffffffffa035b3dc>] ? bin_search+0xdc/0x130 [btrfs]
[ 2809.036677]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2809.037493]  [<ffffffffa0364a84>]
lookup_inline_extent_backref+0x94/0x460 [btrfs]
[ 2809.038831]  [<ffffffff8112ce73>] ? kmem_cache_alloc+0x133/0x160
[ 2809.039622]  [<ffffffffa0366872>] __btrfs_free_extent+0xc2/0x6d0 [btrfs]
[ 2809.040523]  [<ffffffffa03698f9>] run_clustered_refs+0x389/0x830 [btrfs]
[ 2809.041339]  [<ffffffffa035b295>] ?
generic_bin_search.constprop.36+0x175/0x1e0 [btrfs]
[ 2809.042587]  [<ffffffffa03b8f00>] ?
btrfs_delayed_ref_lock+0x150/0x150 [btrfs]
[ 2809.043834]  [<ffffffffa0369e60>] btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
[ 2809.044662]  [<ffffffff813c9369>] ? mutex_unlock+0x9/0x10
[ 2809.045488]  [<ffffffffa037acd8>] btrfs_commit_transaction+0x78/0x7f0 [btrfs]
[ 2809.046332]  [<ffffffffa038d1a5>] ? btrfs_device_id+0xf5/0x100 [btrfs]
[ 2809.047185]  [<ffffffff810791f0>] ? abort_exclusive_wait+0xb0/0xb0
[ 2809.047991]  [<ffffffffa03a686d>] btrfs_init_new_device+0x99d/0xcd0 [btrfs]
[ 2809.048851]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2809.049916]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2809.050674]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2809.051421]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2809.052171]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2809.052910]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2809.053681]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2809.055504] ---[ end trace ce763fabdc763f6f ]---
[ 2809.057003] ------------[ cut here ]------------
[ 2809.057733] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2809.059042] Hardware name: Bochs
[ 2809.059683] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2809.070155] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2809.072329] Call Trace:
[ 2809.072939]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2809.073746]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2809.074526]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2809.075378]  [<ffffffffa039fb03>] ? map_extent_buffer+0xd3/0xe0 [btrfs]
[ 2809.076198]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2809.077052]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2809.077872]  [<ffffffffa035b3dc>] ? bin_search+0xdc/0x130 [btrfs]
[ 2809.078727]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2809.079555]  [<ffffffffa0364a84>]
lookup_inline_extent_backref+0x94/0x460 [btrfs]
[ 2809.080802]  [<ffffffff8112ce73>] ? kmem_cache_alloc+0x133/0x160
[ 2809.081595]  [<ffffffffa0366872>] __btrfs_free_extent+0xc2/0x6d0 [btrfs]
[ 2809.082445]  [<ffffffffa03698f9>] run_clustered_refs+0x389/0x830 [btrfs]
[ 2809.083282]  [<ffffffffa035b295>] ?
generic_bin_search.constprop.36+0x175/0x1e0 [btrfs]
[ 2809.084537]  [<ffffffffa03b8f00>] ?
btrfs_delayed_ref_lock+0x150/0x150 [btrfs]
[ 2809.085769]  [<ffffffffa0369e60>] btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
[ 2809.086624]  [<ffffffff813c9369>] ? mutex_unlock+0x9/0x10
[ 2809.087382]  [<ffffffffa037acd8>] btrfs_commit_transaction+0x78/0x7f0 [btrfs]
[ 2809.088249]  [<ffffffffa038d1a5>] ? btrfs_device_id+0xf5/0x100 [btrfs]
[ 2809.089083]  [<ffffffff810791f0>] ? abort_exclusive_wait+0xb0/0xb0
[ 2809.089914]  [<ffffffffa03a686d>] btrfs_init_new_device+0x99d/0xcd0 [btrfs]
[ 2809.090750]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2809.091542]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2809.092312]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2809.093056]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2809.093815]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2809.094548]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2809.095282]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2809.096966] ---[ end trace ce763fabdc763f70 ]---
[ 2809.097727] ------------[ cut here ]------------
[ 2809.098464] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2809.099925] Hardware name: Bochs
[ 2809.100561] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2809.110856] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2809.111680] Call Trace:
[ 2809.112288]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2809.113086]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2809.113857]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2809.114685]  [<ffffffff81139c24>] ?
mem_cgroup_get_reclaim_stat_from_page+0x24/0x70
[ 2809.115917]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2809.116752]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2809.117553]  [<ffffffffa035b3dc>] ? bin_search+0xdc/0x130 [btrfs]
[ 2809.118343]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2809.119153]  [<ffffffffa0364a84>]
lookup_inline_extent_backref+0x94/0x460 [btrfs]
[ 2809.120397]  [<ffffffff8112ce73>] ? kmem_cache_alloc+0x133/0x160
[ 2809.121171]  [<ffffffffa0366872>] __btrfs_free_extent+0xc2/0x6d0 [btrfs]
[ 2809.121998]  [<ffffffffa0369688>] ? run_clustered_refs+0x118/0x830 [btrfs]
[ 2809.122825]  [<ffffffffa03698f9>] run_clustered_refs+0x389/0x830 [btrfs]
[ 2809.123672]  [<ffffffffa035b295>] ?
generic_bin_search.constprop.36+0x175/0x1e0 [btrfs]
[ 2809.124917]  [<ffffffffa03b8f00>] ?
btrfs_delayed_ref_lock+0x150/0x150 [btrfs]
[ 2809.126122]  [<ffffffffa0369e60>] btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
[ 2809.126987]  [<ffffffff813c9369>] ? mutex_unlock+0x9/0x10
[ 2809.127753]  [<ffffffffa037acd8>] btrfs_commit_transaction+0x78/0x7f0 [btrfs]
[ 2809.128605]  [<ffffffffa038d1a5>] ? btrfs_device_id+0xf5/0x100 [btrfs]
[ 2809.129405]  [<ffffffff810791f0>] ? abort_exclusive_wait+0xb0/0xb0
[ 2809.130217]  [<ffffffffa03a686d>] btrfs_init_new_device+0x99d/0xcd0 [btrfs]
[ 2809.131047]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2809.131842]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2809.132604]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2809.133384]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2809.134109]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2809.134833]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2809.135586]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2809.137274] ---[ end trace ce763fabdc763f71 ]---
[ 2809.138051] ------------[ cut here ]------------
[ 2809.138776] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2809.140258] Hardware name: Bochs
[ 2809.140922] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2809.151191] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2809.152031] Call Trace:
[ 2809.152622]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2809.153435]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2809.154213]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2809.155066]  [<ffffffffa039fb03>] ? map_extent_buffer+0xd3/0xe0 [btrfs]
[ 2809.155887]  [<ffffffff8112bb1f>] ? kmem_cache_free+0x1f/0x150
[ 2809.156700]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2809.157511]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2809.158319]  [<ffffffffa035b3dc>] ? bin_search+0xdc/0x130 [btrfs]
[ 2809.159101]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2809.159949]  [<ffffffffa0364a84>]
lookup_inline_extent_backref+0x94/0x460 [btrfs]
[ 2809.161167]  [<ffffffffa035c1ab>] ? btrfs_leaf_free_space+0x8b/0xe0 [btrfs]
[ 2809.162003]  [<ffffffff8112ce73>] ? kmem_cache_alloc+0x133/0x160
[ 2809.162778]  [<ffffffffa0366872>] __btrfs_free_extent+0xc2/0x6d0 [btrfs]
[ 2809.163639]  [<ffffffffa03698f9>] run_clustered_refs+0x389/0x830 [btrfs]
[ 2809.164458]  [<ffffffffa03b8f00>] ?
btrfs_delayed_ref_lock+0x150/0x150 [btrfs]
[ 2809.165674]  [<ffffffffa0369e60>] btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
[ 2809.166521]  [<ffffffff813c9369>] ? mutex_unlock+0x9/0x10
[ 2809.167269]  [<ffffffffa037acd8>] btrfs_commit_transaction+0x78/0x7f0 [btrfs]
[ 2809.168110]  [<ffffffffa038d1a5>] ? btrfs_device_id+0xf5/0x100 [btrfs]
[ 2809.168971]  [<ffffffff810791f0>] ? abort_exclusive_wait+0xb0/0xb0
[ 2809.169825]  [<ffffffffa03a686d>] btrfs_init_new_device+0x99d/0xcd0 [btrfs]
[ 2809.170669]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2809.171448]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2809.172215]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2809.172954]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2809.173711]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2809.174444]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2809.175176]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2809.184760] ---[ end trace ce763fabdc763f72 ]---
[ 2809.186652] ------------[ cut here ]------------
[ 2809.187385] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2809.188699] Hardware name: Bochs
[ 2809.189338] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2809.199756] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2809.200584] Call Trace:
[ 2809.201193]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2809.202053]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2809.202819]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2809.203682]  [<ffffffff81041c7d>] ? cpuacct_charge+0x5d/0x70
[ 2809.204442]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2809.205276]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2809.206094]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2809.206948]  [<ffffffffa036fb3f>] btrfs_update_root+0x4f/0xe0 [btrfs]
[ 2809.207766]  [<ffffffffa037a251>] commit_fs_roots.isra.18+0xe1/0x120 [btrfs]
[ 2809.208610]  [<ffffffff813c95a9>] ? __mutex_lock_slowpath+0x239/0x320
[ 2809.209416]  [<ffffffffa037af95>]
btrfs_commit_transaction+0x335/0x7f0 [btrfs]
[ 2809.210650]  [<ffffffff810791f0>] ? abort_exclusive_wait+0xb0/0xb0
[ 2809.211453]  [<ffffffffa03a686d>] btrfs_init_new_device+0x99d/0xcd0 [btrfs]
[ 2809.212293]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2809.213090]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2809.213845]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2809.214590]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2809.215362]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2809.216096]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2809.216855]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2809.218312] ---[ end trace ce763fabdc763f73 ]---
[ 2809.219087] ------------[ cut here ]------------
[ 2809.219943] WARNING: at fs/btrfs/extent-tree.c:5790
btrfs_alloc_free_block+0x1ec/0x330 [btrfs]()
[ 2809.221221] Hardware name: Bochs
[ 2809.222817] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2809.233244] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2809.234062] Call Trace:
[ 2809.234668]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2809.235456]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2809.236226]  [<ffffffffa036c74c>] btrfs_alloc_free_block+0x1ec/0x330 [btrfs]
[ 2809.237088]  [<ffffffff81139c24>] ?
mem_cgroup_get_reclaim_stat_from_page+0x24/0x70
[ 2809.238324]  [<ffffffffa0358d19>] __btrfs_cow_block+0x159/0x890 [btrfs]
[ 2809.239137]  [<ffffffffa0359563>] btrfs_cow_block+0x113/0x350 [btrfs]
[ 2809.239961]  [<ffffffffa035b3dc>] ? bin_search+0xdc/0x130 [btrfs]
[ 2809.240745]  [<ffffffffa035ef82>] btrfs_search_slot+0x1d2/0x9f0 [btrfs]
[ 2809.241557]  [<ffffffffa036a091>]
btrfs_write_dirty_block_groups+0xe1/0x520 [btrfs]
[ 2809.242801]  [<ffffffffa0369f49>] ?
btrfs_run_delayed_refs+0x1a9/0x210 [btrfs]
[ 2809.244036]  [<ffffffffa03799ad>] commit_cowonly_roots+0x10d/0x1d0 [btrfs]
[ 2809.246215]  [<ffffffffa037afb7>]
btrfs_commit_transaction+0x357/0x7f0 [btrfs]
[ 2809.247674]  [<ffffffff810791f0>] ? abort_exclusive_wait+0xb0/0xb0
[ 2809.248491]  [<ffffffffa03a686d>] btrfs_init_new_device+0x99d/0xcd0 [btrfs]
[ 2809.249329]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2809.250221]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2809.250978]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2809.251733]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2809.252453]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2809.253206]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2809.253946]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2809.255507] ---[ end trace ce763fabdc763f74 ]---
[ 2811.436853] btrfs: relocating block group 248209408 flags 2
[ 2812.761837] btrfs: relocating block group 0 flags 2
[ 2815.211927] btrfs: relocating block group 256598016 flags 2
[ 2819.200018] btrfs: relocating block group 248209408 flags 2
[ 2821.045273] ------------[ cut here ]------------
[ 2821.046012] WARNING: at fs/btrfs/volumes.c:1972
btrfs_init_new_device+0xc0a/0xcd0 [btrfs]()
[ 2821.047516] Hardware name: Bochs
[ 2821.048151] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2821.058383] Pid: 2695, comm: btrfs Tainted: G      D W   2.6.39-ARCH #1
[ 2821.059188] Call Trace:
[ 2821.059800]  [<ffffffff810577da>] warn_slowpath_common+0x7a/0xb0
[ 2821.060576]  [<ffffffff81057825>] warn_slowpath_null+0x15/0x20
[ 2821.061357]  [<ffffffffa03a6ada>] btrfs_init_new_device+0xc0a/0xcd0 [btrfs]
[ 2821.062212]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2821.063014]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2821.063803]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2821.064546]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2821.065296]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2821.066029]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2821.066795]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2821.067977] ---[ end trace ce763fabdc763f75 ]---
[ 2821.068713] ------------[ cut here ]------------
[ 2821.069423] kernel BUG at fs/btrfs/volumes.c:1657!
[ 2821.070116] invalid opcode: 0000 [#3] PREEMPT SMP
[ 2821.070116] last sysfs file: /sys/devices/virtual/block/loop1/dev
[ 2821.070116] CPU 0
[ 2821.070116] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
loop ipv6 ext2 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd uhci_hcd i2c_piix4 psmouse floppy ehci_hcd processor soundcore
snd_page_alloc pcspkr evdev button usbcore serio_raw sg i2c_core ext4
mbcache jbd2 crc16 sr_mod cdrom pata_acpi ata_piix libata scsi_mod
virtio_rng virtio_pci virtio_net virtio_console virtio_blk
virtio_balloon virtio_ring virtio
[ 2821.070116]
[ 2821.070116] Pid: 2695, comm: btrfs Tainted: G      D W
2.6.39-ARCH #1 Bochs Bochs
[ 2821.070116] RIP: 0010:[<ffffffffa03a6ae2>]  [<ffffffffa03a6ae2>]
btrfs_init_new_device+0xc12/0xcd0 [btrfs]
[ 2821.070116] RSP: 0018:ffff880009e25d48  EFLAGS: 00010296
[ 2821.070116] RAX: ffff88001e707001 RBX: 0000000000000001 RCX: 000000000014c600
[ 2821.070116] RDX: 000000000014c5c0 RSI: 000000000001be30 RDI: ffffea00006a8988
[ 2821.070116] RBP: ffff880009e25e08 R08: ffffffffa0357ffa R09: 0000000000000000
[ 2821.070116] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88001e707000
[ 2821.070116] R13: ffff880000212800 R14: 0000000000000000 R15: 00000000003fffff
[ 2821.070116] FS:  00007fb1967dc740(0000) GS:ffff88001fc00000(0000)
knlGS:0000000000000000
[ 2821.070116] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2821.070116] CR2: 00007f371ce50000 CR3: 000000001db75000 CR4: 00000000000006f0
[ 2821.070116] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2821.070116] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2821.070116] Process btrfs (pid: 2695, threadinfo ffff880009e24000,
task ffff88001deddbc0)
[ 2821.070116] Stack:
[ 2821.070116]  ffff88001e383d90 ffff88001de60200 0000000000000002
ffff880000213800
[ 2821.070116]  ffff880000213800 ffff880000212801 ffff880000000000
0000000000000100
[ 2821.070116]  0100880000000000 00e4000000000000 0000000000004000
e400000000000001
[ 2821.070116] Call Trace:
[ 2821.070116]  [<ffffffffa03ac14a>] btrfs_ioctl+0x7ea/0xa20 [btrfs]
[ 2821.070116]  [<ffffffff81174d8e>] ? __blkdev_put+0x1ee/0x200
[ 2821.070116]  [<ffffffff8115264e>] do_vfs_ioctl+0x8e/0x500
[ 2821.070116]  [<ffffffff8115ec2a>] ? mntput+0x1a/0x30
[ 2821.070116]  [<ffffffff81142927>] ? fput+0x167/0x210
[ 2821.070116]  [<ffffffff81152b51>] sys_ioctl+0x91/0xa0
[ 2821.070116]  [<ffffffff813cb312>] system_call_fastpath+0x16/0x1b
[ 2821.070116] Code: fa ff ff c7 85 70 ff ff ff ea ff ff ff e9 92 fc
ff ff be b4 07 00 00 48 c7 c7 41 86 3c a0 e8 36 0d cb e0 4c 89 e7 e8
ee 14 fb ff <0f> 0b 0f 1f 40 00 41 bf 10 00 00 00 e9 8e f6 ff ff 4c 89
e7 48
[ 2821.070116] RIP  [<ffffffffa03a6ae2>]
btrfs_init_new_device+0xc12/0xcd0 [btrfs]
[ 2821.070116]  RSP <ffff880009e25d48>
[ 2821.121930] ---[ end trace ce763fabdc763f76 ]---
[ 2821.134349] device label _btrfs_ro_seed devid 2 transid 24 /dev/loop1
