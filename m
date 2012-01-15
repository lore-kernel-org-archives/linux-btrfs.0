From: Nico Kruber <lists.nico.k@googlemail.com>
Subject: broken fs, "kernel BUG at fs/btrfs/free-space-cache.c:1327"
Date: Sun, 15 Jan 2012 16:07:10 +0000
Message-ID: <CAKToU+F7r+B3oPuuhoJZSq5sweYN8ooGj7dw--+yKW3FC-QXEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was using btrfs with openSUSE 12.1 and during the last update
(glibc), the system hanged and I had no choice but to reboot.
Now I can neither boot my system, nor mount my btrfs partition from a
live USB, e.g. PartedMagic or the openSUSE 12.1 live CD images.

Whenever I try mounting the fs, I get the following kernel oops:

------------------------------------------
# mount  /dev/sda3 /mnt/
# dmesg
[  379.420110] Btrfs loaded
[  379.420430] device fsid dd1cdd10-6b96-46e9-9214-0e07ca61f6d5 devid
1 transid 11562 /dev/loop2
[  379.511476] btrfs: disk space caching is enabled
[  382.959164] ------------[ cut here ]------------
[  382.959192] kernel BUG at fs/btrfs/free-space-cache.c:1327!
[  382.959219] invalid opcode: 0000 [#1] SMP
[  382.959243] CPU 3
[  382.959253] Modules linked in: btrfs ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
bluetooth nfsd exportfs dm_mod fuse vfat fat isofs snd_hda_codec_hdmi
rt2800pci rt2800lib crc_ccitt snd_hda_codec_realtek rt2x00pci
rt2x00lib snd_hda_intel mac80211 pata_acpi radeon snd_hda_codec ttm
cfg80211 sg drm_kms_helper snd_hwdep uas rfkill drm firewire_ohci
ata_generic joydev hid_logitech usbhid hid usb_storage processor
mac_hid thermal_sys snd_pcm firewire_core evdev rtc_cmos ahci
snd_timer i2c_algo_bit hwmon eeprom_93cx6 pata_jmicron button libahci
snd r8169 i2c_i801 serio_raw uhci_hcd mii soundcore intel_agp
intel_gtt agpgart ehci_hcd snd_page_alloc
[  382.959665]
[  382.959674] Pid: 5910, comm: mount Not tainted 3.1.6-pmagic #2
Gigabyte Technology Co., Ltd. EP45-DS3/EP45-DS3
[  382.959726] RIP: 0010:[<ffffffffa03e7783>]  [<ffffffffa03e7783>]
btrfs_log_new_name+0xd34/0x103b [btrfs]
[  382.959778] RSP: 0000:ffff88007eb436b8  EFLAGS: 00010206
[  382.959803] RAX: 0000000000000000 RBX: ffff8800d2fad500 RCX: 0000000000002000
[  382.959836] RDX: 000000049890e000 RSI: 0000000498872000 RDI: 0000000000001300
[  382.959868] RBP: ffff88007eb43718 R08: 0000000000006d00 R09: ffff8800cecdcda0
[  382.959900] R10: ffff88007eb43668 R11: ffff88007eb436a0 R12: ffff88007eb89bc0
[  382.959932] R13: ffff88007eb43738 R14: ffff88007eb43740 R15: 0000000499c00000
[  382.959964] FS:  0000000000000000(0000) GS:ffff88011fd80000(0063)
knlGS:00000000f763d700
[  382.960002] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  382.960028] CR2: 00000000edec40d8 CR3: 00000000ce49d000 CR4: 00000000000406e0
[  382.960060] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  382.960076] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  382.960076] Process mount (pid: 5910, threadinfo ffff88007eb42000,
task ffff880112422940)
[  382.960076] Stack:
[  382.960076]  ffff88007eb436d0 ffff8800d2faebd0 ffffffff81020a70
ffff88007eb89be4
[  382.960076]  0000000000002000 000000049890e000 ffffffff813cca8b
ffff8800d2fad500
[  382.960076]  ffff88007eb89bc0 0000000000000000 ffff88007fb43d00
ffff88007eb43738
[  382.960076] Call Trace:
[  382.960076]  [<ffffffff81020a70>] ? default_spin_lock_flags+0x9/0xd
[  382.960076]  [<ffffffff813cca8b>] ? _raw_spin_unlock_irqrestore+0x1a/0x1d
[  382.960076]  [<ffffffffa03e8c8b>] btrfs_remove_free_space+0x267/0x293 [btrfs]
[  382.960076]  [<ffffffffa03a7775>] ? btrfs_previous_item+0xdb/0xbab [btrfs]
[  382.960076]  [<ffffffffa03af7dd>]
btrfs_alloc_logged_file_extent+0x87/0x19c [btrfs]
[  382.960076]  [<ffffffffa03a24ae>] ? btrfs_free_path+0x2a/0x2e [btrfs]
[  382.960076]  [<ffffffffa03e36e0>]
btrfs_find_orphan_item+0x18b6/0x3c75 [btrfs]
[  382.960076]  [<ffffffff81101c0d>] ? iput+0x1ab/0x1b4
[  382.960076]  [<ffffffffa03d5d24>] ? read_extent_buffer+0x97/0xeb [btrfs]
[  382.960076]  [<ffffffffa03e578b>]
btrfs_find_orphan_item+0x3961/0x3c75 [btrfs]
[  382.960076]  [<ffffffffa03e4ead>]
btrfs_find_orphan_item+0x3083/0x3c75 [btrfs]
[  382.960076]  [<ffffffffa03e507f>]
btrfs_find_orphan_item+0x3255/0x3c75 [btrfs]
[  382.960076]  [<ffffffffa03b59ef>] ? btrfs_find_free_ino+0x155/0x1bb2 [btrfs]
[  382.960076]  [<ffffffffa03e68fb>] btrfs_recover_log_trees+0x1ae/0x2c7 [btrfs]
[  382.960076]  [<ffffffffa03e55e1>] ?
btrfs_find_orphan_item+0x37b7/0x3c75 [btrfs]
[  382.960076]  [<ffffffffa03ba86d>] open_ctree+0x112c/0x2075 [btrfs]
[  382.960076]  [<ffffffffa03a0813>] btrfs_sync_fs+0x4d8/0x739 [btrfs]
[  382.960076]  [<ffffffff810ccb41>] ? pcpu_next_pop+0x3d/0x4a
[  382.960076]  [<ffffffff810effd2>] mount_fs+0x6e/0x158
[  382.960076]  [<ffffffff810cda07>] ? __alloc_percpu+0x10/0x12
[  382.960076]  [<ffffffff8110537c>] vfs_kern_mount+0x5c/0x9d
[  382.960076]  [<ffffffff81105693>] do_kern_mount+0x4d/0xdf
[  382.960076]  [<ffffffff81106f02>] do_mount+0x686/0x6e9
[  382.960076]  [<ffffffff810c9d64>] ? memdup_user+0x44/0x6c
[  382.960076]  [<ffffffff81127ab1>] compat_sys_mount+0x218/0x252
[  382.960076]  [<ffffffff813cfdd3>] ia32_do_call+0x13/0x13
[  382.960076] Code: 48 29 c2 49 8b 45 00 48 39 c2 48 0f 46 c2 48 8d
55 c8 48 89 45 c0 e8 74 fe ff ff 85 c0 78 0c 48 8b 55 c8 49 8b 36 48
39 f2 74 02 <0f> 0b 48 8b 4b 18 49 8d 47 ff 48 39 ca 76 4b 48 89 d1 49
03 4d
[  382.960076] RIP  [<ffffffffa03e7783>] btrfs_log_new_name+0xd34/0x103b [btrfs]
[  382.960076]  RSP <ffff88007eb436b8>
[  382.971282] ---[ end trace 5d2fc65d77ccbfd6 ]---
------------------------------------------

It does not matter whether I add the ro, clear_cache or the
subvolid=** option (can't think of anything else except for
nospace_cache, but I do not have a live image with Kernel 3.2 - if you
know of any, I could try that, too).

Is the filesystem ruined or is there still hope, I can recover from that?
Since YaST makes a snapshot before the update, my original plan was to
revert to that I tried some subvolid values, btrfsck reported and they
had the same kernel BUG as without one or even 0.

Here are some hopefully useful outputs. If you need any more, I made
an image of the partition so I can still debug it even if I
re-install.

------------------------------------------
# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: dd1cdd10-6b96-46e9-9214-0e07ca61f6d5
	Total devices 1 FS bytes used 20.55GB
	devid    1 size 31.81GB used 31.81GB path /dev/sda3

Btrfs Btrfs v0.19
------------------------------------------
# btrfsck /media/sdb1/Images/broken-btrfs.img
root 5 inode 878157 errors 1000
root 5 inode 878158 errors 1000
root 5 inode 878159 errors 1000
root 5 inode 878413 errors 1000
root 692 inode 679573 errors 1000
root 692 inode 679585 errors 1000
root 692 inode 679586 errors 1000
root 692 inode 679592 errors 1000
root 692 inode 679594 errors 1000
root 692 inode 679595 errors 1000
root 692 inode 679599 errors 1000
root 692 inode 679600 errors 1000
root 692 inode 679601 errors 1000
root 692 inode 679602 errors 1000
root 692 inode 679603 errors 1000
root 692 inode 679604 errors 1000
root 692 inode 679605 errors 1000
root 692 inode 679607 errors 1000
root 692 inode 679608 errors 1000
root 692 inode 679609 errors 1000
root 692 inode 679611 errors 1000
root 692 inode 679613 errors 1000
root 692 inode 679614 errors 1000
root 692 inode 679615 errors 1000
root 692 inode 679616 errors 1000
root 692 inode 679617 errors 1000
root 692 inode 679619 errors 1000
root 692 inode 679620 errors 1000
root 692 inode 679621 errors 1000
root 692 inode 679622 errors 1000
root 692 inode 679626 errors 1000
root 692 inode 679627 errors 1000
root 692 inode 679692 errors 1000
root 692 inode 679698 errors 1000
root 692 inode 684383 errors 1000
root 692 inode 684384 errors 1000
root 692 inode 684388 errors 1000
root 692 inode 684432 errors 1000
root 692 inode 684434 errors 1000
root 692 inode 684440 errors 1000
root 692 inode 684458 errors 1000
root 692 inode 684465 errors 1000
root 692 inode 684467 errors 1000
root 692 inode 684487 errors 1000
root 692 inode 684490 errors 1000
root 692 inode 684495 errors 1000
root 693 inode 679573 errors 1000
root 693 inode 679585 errors 1000
root 693 inode 679586 errors 1000
root 693 inode 679592 errors 1000
root 693 inode 679594 errors 1000
root 693 inode 679595 errors 1000
root 693 inode 679599 errors 1000
root 693 inode 679600 errors 1000
root 693 inode 679601 errors 1000
root 693 inode 679602 errors 1000
root 693 inode 679603 errors 1000
root 693 inode 679604 errors 1000
root 693 inode 679605 errors 1000
root 693 inode 679607 errors 1000
root 693 inode 679608 errors 1000
root 693 inode 679609 errors 1000
root 693 inode 679611 errors 1000
root 693 inode 679613 errors 1000
root 693 inode 679614 errors 1000
root 693 inode 679615 errors 1000
root 693 inode 679616 errors 1000
root 693 inode 679617 errors 1000
root 693 inode 679619 errors 1000
root 693 inode 679620 errors 1000
root 693 inode 679621 errors 1000
root 693 inode 679622 errors 1000
root 693 inode 679626 errors 1000
root 693 inode 679627 errors 1000
root 693 inode 679692 errors 1000
root 693 inode 679698 errors 1000
root 693 inode 684383 errors 1000
root 693 inode 684384 errors 1000
root 693 inode 684388 errors 1000
root 693 inode 684432 errors 1000
root 693 inode 684434 errors 1000
root 693 inode 684440 errors 1000
root 693 inode 684458 errors 1000
root 693 inode 684465 errors 1000
root 693 inode 684467 errors 1000
root 693 inode 684487 errors 1000
root 693 inode 684490 errors 1000
root 693 inode 684495 errors 1000
root 700 inode 679573 errors 1000
root 700 inode 679585 errors 1000
root 700 inode 679586 errors 1000
root 700 inode 679592 errors 1000
root 700 inode 679594 errors 1000
root 700 inode 679595 errors 1000
root 700 inode 679599 errors 1000
root 700 inode 679600 errors 1000
root 700 inode 679601 errors 1000
root 700 inode 679602 errors 1000
root 700 inode 679603 errors 1000
root 700 inode 679604 errors 1000
root 700 inode 679605 errors 1000
root 700 inode 679607 errors 1000
root 700 inode 679608 errors 1000
root 700 inode 679609 errors 1000
root 700 inode 679611 errors 1000
root 700 inode 679613 errors 1000
root 700 inode 679614 errors 1000
root 700 inode 679615 errors 1000
root 700 inode 679616 errors 1000
root 700 inode 679617 errors 1000
root 700 inode 679619 errors 1000
root 700 inode 679620 errors 1000
root 700 inode 679621 errors 1000
root 700 inode 679622 errors 1000
root 700 inode 679626 errors 1000
root 700 inode 679627 errors 1000
root 700 inode 679692 errors 1000
root 700 inode 679698 errors 1000
root 700 inode 684383 errors 1000
root 700 inode 684384 errors 1000
root 700 inode 684388 errors 1000
root 700 inode 684432 errors 1000
root 700 inode 684434 errors 1000
root 700 inode 684440 errors 1000
root 700 inode 684458 errors 1000
root 700 inode 684465 errors 1000
root 700 inode 684467 errors 1000
root 700 inode 684487 errors 1000
root 700 inode 684490 errors 1000
root 700 inode 684495 errors 1000
root 701 inode 679573 errors 1000
root 701 inode 679585 errors 1000
root 701 inode 679586 errors 1000
root 701 inode 679592 errors 1000
root 701 inode 679594 errors 1000
root 701 inode 679595 errors 1000
root 701 inode 679599 errors 1000
root 701 inode 679600 errors 1000
root 701 inode 679601 errors 1000
root 701 inode 679602 errors 1000
root 701 inode 679603 errors 1000
root 701 inode 679604 errors 1000
root 701 inode 679605 errors 1000
root 701 inode 679607 errors 1000
root 701 inode 679608 errors 1000
root 701 inode 679609 errors 1000
root 701 inode 679611 errors 1000
root 701 inode 679613 errors 1000
root 701 inode 679614 errors 1000
root 701 inode 679615 errors 1000
root 701 inode 679616 errors 1000
root 701 inode 679617 errors 1000
root 701 inode 679619 errors 1000
root 701 inode 679620 errors 1000
root 701 inode 679621 errors 1000
root 701 inode 679622 errors 1000
root 701 inode 679626 errors 1000
root 701 inode 679627 errors 1000
root 701 inode 679692 errors 1000
root 701 inode 679698 errors 1000
root 701 inode 684383 errors 1000
root 701 inode 684384 errors 1000
root 701 inode 684388 errors 1000
root 701 inode 684432 errors 1000
root 701 inode 684434 errors 1000
root 701 inode 684440 errors 1000
root 701 inode 684458 errors 1000
root 701 inode 684465 errors 1000
root 701 inode 684467 errors 1000
root 701 inode 684487 errors 1000
root 701 inode 684490 errors 1000
root 701 inode 684495 errors 1000
root 754 inode 834204 errors 1000
root 755 inode 834204 errors 1000
root 756 inode 834204 errors 1000
root 757 inode 834204 errors 1000
root 758 inode 834204 errors 1000
root 759 inode 834204 errors 1000
root 760 inode 834204 errors 1000
root 761 inode 834204 errors 1000
root 762 inode 834204 errors 1000
root 763 inode 834204 errors 1000
root 764 inode 834204 errors 1000
root 765 inode 834204 errors 1000
root 766 inode 834204 errors 1000
root 767 inode 834204 errors 1000
root 768 inode 834204 errors 1000
root 769 inode 834204 errors 1000
root 770 inode 834204 errors 1000
root 771 inode 834204 errors 1000
root 772 inode 834204 errors 1000
root 774 inode 834204 errors 1000
root 775 inode 834204 errors 1000
root 778 inode 834204 errors 1000
root 779 inode 834204 errors 1000
root 780 inode 834204 errors 1000
root 781 inode 834204 errors 1000
root 781 inode 878157 errors 1000
root 781 inode 878158 errors 1000
root 781 inode 878159 errors 1000
root 781 inode 878413 errors 1000
root 782 inode 878157 errors 1000
root 782 inode 878158 errors 1000
root 782 inode 878159 errors 1000
root 782 inode 878413 errors 1000
root 783 inode 878157 errors 1000
root 783 inode 878158 errors 1000
root 783 inode 878159 errors 1000
root 783 inode 878413 errors 1000
root 784 inode 878157 errors 1000
root 784 inode 878158 errors 1000
root 784 inode 878159 errors 1000
root 784 inode 878413 errors 1000
root 785 inode 878157 errors 1000
root 785 inode 878158 errors 1000
root 785 inode 878159 errors 1000
root 785 inode 878413 errors 1000
root 786 inode 878157 errors 1000
root 786 inode 878158 errors 1000
root 786 inode 878159 errors 1000
root 786 inode 878413 errors 1000
root 787 inode 878157 errors 1000
root 787 inode 878158 errors 1000
root 787 inode 878159 errors 1000
root 787 inode 878413 errors 1000
root 788 inode 878157 errors 1000
root 788 inode 878158 errors 1000
root 788 inode 878159 errors 1000
root 788 inode 878413 errors 1000
root 789 inode 878157 errors 1000
root 789 inode 878158 errors 1000
root 789 inode 878159 errors 1000
root 789 inode 878413 errors 1000
root 790 inode 878157 errors 1000
root 790 inode 878158 errors 1000
root 790 inode 878159 errors 1000
root 790 inode 878413 errors 1000
root 791 inode 878157 errors 1000
root 791 inode 878158 errors 1000
root 791 inode 878159 errors 1000
root 791 inode 878413 errors 1000
root 792 inode 878157 errors 1000
root 792 inode 878158 errors 1000
root 792 inode 878159 errors 1000
root 792 inode 878413 errors 1000
root 793 inode 878157 errors 1000
root 793 inode 878158 errors 1000
root 793 inode 878159 errors 1000
root 793 inode 878413 errors 1000
root 794 inode 878157 errors 1000
root 794 inode 878158 errors 1000
root 794 inode 878159 errors 1000
root 794 inode 878413 errors 1000
root 795 inode 878157 errors 1000
root 795 inode 878158 errors 1000
root 795 inode 878159 errors 1000
root 795 inode 878413 errors 1000
root 796 inode 878157 errors 1000
root 796 inode 878158 errors 1000
root 796 inode 878159 errors 1000
root 796 inode 878413 errors 1000
root 797 inode 878157 errors 1000
root 797 inode 878158 errors 1000
root 797 inode 878159 errors 1000
root 797 inode 878413 errors 1000
root 798 inode 878157 errors 1000
root 798 inode 878158 errors 1000
root 798 inode 878159 errors 1000
root 798 inode 878413 errors 1000
root 799 inode 878157 errors 1000
root 799 inode 878158 errors 1000
root 799 inode 878159 errors 1000
root 799 inode 878413 errors 1000
root 800 inode 878157 errors 1000
root 800 inode 878158 errors 1000
root 800 inode 878159 errors 1000
root 800 inode 878413 errors 1000
root 801 inode 878157 errors 1000
root 801 inode 878158 errors 1000
root 801 inode 878159 errors 1000
root 801 inode 878413 errors 1000
root 802 inode 878157 errors 1000
root 802 inode 878158 errors 1000
root 802 inode 878159 errors 1000
root 802 inode 878413 errors 1000
root 803 inode 878157 errors 1000
root 803 inode 878158 errors 1000
root 803 inode 878159 errors 1000
root 803 inode 878413 errors 1000
root 804 inode 878157 errors 1000
root 804 inode 878158 errors 1000
root 804 inode 878159 errors 1000
root 804 inode 878413 errors 1000
root 805 inode 878157 errors 1000
root 805 inode 878158 errors 1000
root 805 inode 878159 errors 1000
root 805 inode 878413 errors 1000
root 806 inode 878157 errors 1000
root 806 inode 878158 errors 1000
root 806 inode 878159 errors 1000
root 806 inode 878413 errors 1000
root 807 inode 878157 errors 1000
root 807 inode 878158 errors 1000
root 807 inode 878159 errors 1000
root 807 inode 878413 errors 1000
found 22063673411 bytes used err is 1
total csum bytes: 19134188
total tree bytes: 2288513024
total fs tree bytes: 2131046400
btree space waste bytes: 623403397
file data blocks allocated: 93240000512
 referenced 79978369024
Btrfs Btrfs v0.19
------------------------------------------

Regards,
Nico
