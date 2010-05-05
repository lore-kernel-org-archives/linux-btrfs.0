From: Victor Lowther <victor.lowther@gmail.com>
Subject: btrfs testing
Date: Tue, 04 May 2010 22:06:26 -0500
Message-ID: <1273028786.4136.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I ahve been using btrfs as my primary root and home partitions for a few
mo enths now, and so far that is going well.  I run Arch Linux with the
latest Linus git kernels and use the latest btrfs-progs-unstable git
trees to manage my btrfs filesystems.  

My filesystem latout consists of a single 500GB SATA drive with an
ext2 /boot partition and a dm-crypt'ed LVM volume group taking up the
rest of the space.

Some earlier playing around with the multivolume capabilities of btrfs
convinced me that LVM is still needed for serious work - my regular hard
drive upgrade habits involve pvmoving everything to a larger drive when
I feel like I am running out of space on whatever drive I happen to be
using at the time.  I decided to see if btrfs could take over that
capability right now, and my tests were negative

Here is a transcript of my testing:

[root@studio-arch ~]# uname -a
Linux studio-arch 2.6.34-rc6 #13 SMP PREEMPT Tue May 4 16:38:20 CDT 2010 x86_64 Intel(R) Core(TM)2 Duo CPU P8600 @ 2.40GHz GenuineIntel GNU/Linux
[root@studio-arch ~]# lvm
lvm> lvcreate -L 10G -n test1 gentoo
  Logical volume "test1" created
lvm> lvcreate -L 10G -n test2 gentoo
  Logical volume "test2" created
lvm> quit
  Exiting.
[root@studio-arch ~]# mkfs.btrfs /dev/gentoo/test1

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/gentoo/test1
	nodesize 4096 leafsize 4096 sectorsize 4096 size 10.00GB
Btrfs Btrfs v0.19
[root@studio-arch ~]# mount /dev/gentoo/test1 /mnt
[root@studio-arch ~]# cp -a /boot/* /mnt/
[root@studio-arch ~]# ls /mnt
grub			  initramfs-linux-2.6.34-rc6.img  vmlinuz-2.6.34-rc3
initramfs-2.6.34-rc3.img  initramfs-newroot.img		  vmlinuz-2.6.34-rc4
initramfs-2.6.34-rc4.img  lost+found			  vmlinuz-2.6.34-rc6
initramfs-2.6.34-rc6.img  memtest86+.bin
[root@studio-arch ~]# btrfs fi show
Label: none  uuid: edf442ee-729c-4868-acc9-3b45e2621262
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 10.00GB used 2.04GB path /dev/dm-6

Btrfs Btrfs v0.19
[root@studio-arch ~]# btrfs fi df /mnt
Metadata, DUP: total=1.00GB, used=540.00KB
System, DUP: total=8.00MB, used=4.00KB
Data: total=1.01GB, used=26.93MB
Metadata: total=8.00MB, used=0.00
System: total=4.00MB, used=0.00
[root@studio-arch ~]#  btrfs fi show
Label: none  uuid: edf442ee-729c-4868-acc9-3b45e2621262
	Total devices 2 FS bytes used 27.46MB
	devid    1 size 10.00GB used 3.04GB path /dev/dm-6
	devid    2 size 10.00GB used 0.00 path /dev/dm-7

Btrfs Btrfs v0.19
[root@studio-arch ~]# btrfs fi bal /mnt
[root@studio-arch ~]# dmesg
<...>
[ 6841.202960] btrfs: relocating block group 1103101952 flags 1
[ 6841.754905] btrfs: found 8 extents
[ 6842.373712] btrfs: found 8 extents
[ 6842.506431] btrfs: relocating block group 29360128 flags 36
[ 6842.893517] btrfs: found 18 extents
[ 6843.075464] btrfs: relocating block group 20971520 flags 34
[ 6843.342993] btrfs: found 1 extents
[ 6843.529189] btrfs: relocating block group 12582912 flags 1
[ 6843.875434] btrfs: found 106 extents
[ 6844.874100] btrfs: found 106 extents
[ 6845.057757] btrfs: relocating block group 4194304 flags 4
[root@studio-arch ~]# btrfs fi df /mnt
System, RAID1: total=8.00MB, used=4.00KB
Metadata, RAID1: total=128.00MB, used=540.00KB
Data, RAID0: total=4.00GB, used=26.93MB
Metadata, DUP: total=0.00, used=0.00
System, DUP: total=0.00, used=0.00
Data: total=0.00, used=0.00
Metadata: total=0.00, used=0.00
System: total=4.00MB, used=0.00
[root@studio-arch ~]# btrfs fi show 
failed to read /dev/sr0
Label: none  uuid: 9413c8ab-ad91-4330-8875-1b607df815e8
	Total devices 1 FS bytes used 4.20GB
	devid    1 size 20.00GB used 8.54GB path /dev/dm-3

Label: none  uuid: 4a19cf55-c0ca-4941-9202-a02fb312da99
	Total devices 1 FS bytes used 29.53GB
	devid    1 size 70.00GB used 70.00GB path /dev/dm-4

Label: none  uuid: edf442ee-729c-4868-acc9-3b45e2621262
	Total devices 2 FS bytes used 27.46MB
	devid    1 size 10.00GB used 2.14GB path /dev/dm-6
	devid    2 size 10.00GB used 2.13GB path /dev/dm-7

Btrfs Btrfs v0.19
[root@studio-arch ~]#

So far, so good -- 2 devices in the filesystem, metadata mirrored across
them, data striped across them -- about what I would expect.  Here is
where I run into the main glitch:

[root@studio-arch ~]# btrfs dev del /dev/gentoo/test1 /mnt
ERROR: error removing the device '/dev/gentoo/test1'
[root@studio-arch ~]# dmesg 
<...>
[ 7181.202675] btrfs: unable to go below two devices on raid1
[root@studio-arch ~]#

That error should not happen.  The filesystem was not created as a RAID1
(it was a single disk only), and the data is not redundant across the
devices.  Maybe the btrfs command is not doing the Right Thing, so try
the older btrfs-vol command:

[root@studio-arch ~]# btrfs-vol -r /dev/gentoo/test1 /mnt
ioctl returns -1
[root@studio-arch ~]# dmesg
<...>
[ 7471.892633] btrfs: unable to go below two devices on raid1
[root@studio-arch ~]#

At this point, I am stuck.  There does not appear to be a
--yes-really-do-it switch for either btrfs or btrfs-vol that will
proceed to rebalance all the data off test1 and remove it from the
filesystem.  The offending bit of kernel code in btrfs_rm_device seems
to be

	all_avail = root->fs_info->avail_data_alloc_bits |
		root->fs_info->avail_system_alloc_bits |
		root->fs_info->avail_metadata_alloc_bits;

and the checks that follow it.  We should arguably only care about the
redundancy imposed by the data allocation policy (not system or
metadata) when doing device adds and removes, otherwise we are caught in
a bit of a trap -- you can grow your filesystem from one device to many,
but you can only shrink it back down to two. Trying the semi obvious fix
of 

all_avail = root->fs_info->avail_data_alloc_bits;

fails with the following oops:

[  242.083305] btrfs allocation failed flags 4, wanted 4096
[  242.083335] BUG: unable to handle kernel NULL pointer dereference at 00000000000000b8
[  242.083346] IP: [<ffffffff81060c79>] do_raw_spin_lock+0x9/0x1a
[  242.083364] PGD 10c9b8067 PUD 10c987067 PMD 0 
[  242.083375] Oops: 0002 [#1] PREEMPT SMP 
[  242.083385] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT0/energy_full
[  242.083393] CPU 1 
[  242.083397] Modules linked in: loop fuse ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT iptable_filter ip_tables bridge stp llc af_packet ext2 mbcache xfs exportfs uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 dell_wmi wmi battery ac sdhci_pci sdhci iwlagn iwlcore mmc_core thermal mac80211 cfg80211 snd_hda_codec_intelhdmi snd_hda_codec_idt dell_laptop rfkill dcdbas evdev joydev snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc uhci_hcd tg3 libphy ehci_hcd usbcore ipv6 kvm_intel kvm rtc_cmos rtc_core rtc_lib
[  242.083530] 
[  242.083538] Pid: 4119, comm: btrfs Not tainted 2.6.34-rc6 #14 0D176M/Studio 1555
[  242.083545] RIP: 0010:[<ffffffff81060c79>]  [<ffffffff81060c79>] do_raw_spin_lock+0x9/0x1a
[  242.083558] RSP: 0018:ffff88010ca13508  EFLAGS: 00010213
[  242.083564] RAX: 0000000000000100 RBX: 00000000000000b8 RCX: 0000000000012e3f
[  242.083570] RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00000000000000b8
[  242.083577] RBP: ffff88010ca13508 R08: 0000000000000002 R09: 00000000000000d3
[  242.083583] R10: ffffffff814f180a R11: 00000000ffffffff R12: 00000000000000b8
[  242.083589] R13: 0000000000000001 R14: 0000000000001000 R15: 0000000000001000
[  242.083597] FS:  00007f9b2f344740(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
[  242.083605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  242.083611] CR2: 00000000000000b8 CR3: 0000000115e5d000 CR4: 00000000000406e0
[  242.083618] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  242.083624] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  242.083632] Process btrfs (pid: 4119, threadinfo ffff88010ca12000, task ffff880114df4d40)
[  242.083637] Stack:
[  242.083641]  ffff88010ca13528 ffffffff8136a853 0000000000000004 0000000000000000
[  242.083651] <0> ffff88010ca13588 ffffffff8111c43d 0000000000000018 ffff88010ca13598
[  242.083663] <0> ffff88010ca13558 ffffffff8111e10d ffff88010ca13588 0000000000000000
[  242.083677] Call Trace:
[  242.083688]  [<ffffffff8136a853>] _raw_spin_lock+0x1e/0x23
[  242.083700]  [<ffffffff8111c43d>] dump_space_info+0x29/0x158
[  242.083710]  [<ffffffff8111e10d>] ? rcu_read_unlock+0x23/0x2e
[  242.083721]  [<ffffffff8112120c>] btrfs_reserve_extent+0x141/0x155
[  242.083731]  [<ffffffff8112295c>] btrfs_alloc_free_block+0x59/0x192
[  242.083742]  [<ffffffff81147310>] ? read_extent_buffer+0xbe/0xde
[  242.083752]  [<ffffffff81116b2e>] __btrfs_cow_block+0xfc/0x312
[  242.083761]  [<ffffffff81117a1e>] ? comp_keys+0x26/0x28
[  242.083771]  [<ffffffff81143c38>] ? pagefault_enable+0x23/0x2e
[  242.083782]  [<ffffffff8111532f>] ? kmap_atomic+0x16/0x4b
[  242.083791]  [<ffffffff81116e40>] btrfs_cow_block+0xfc/0x10b
[  242.083800]  [<ffffffff81119b98>] btrfs_search_slot+0x137/0x4e4
[  242.083811]  [<ffffffff8111aace>] btrfs_insert_empty_items+0x5b/0xa1
[  242.083819]  [<ffffffff811162ef>] ? btrfs_alloc_path+0x15/0x26
[  242.083828]  [<ffffffff8111ab66>] btrfs_insert_item+0x52/0x9d
[  242.083839]  [<ffffffff811239b2>] btrfs_make_block_group+0x223/0x254
[  242.083849]  [<ffffffff8114a72f>] __btrfs_alloc_chunk+0x54e/0x5d0
[  242.083859]  [<ffffffff81143c38>] ? pagefault_enable+0x23/0x2e
[  242.083870]  [<ffffffff8114b074>] btrfs_alloc_chunk+0x4d/0x7d
[  242.083879]  [<ffffffff8111e2fb>] ? update_space_info+0xe3/0x16f
[  242.083889]  [<ffffffff8111f3d1>] do_chunk_alloc+0x174/0x1d3
[  242.083900]  [<ffffffff81123116>] btrfs_prepare_block_group_relocation+0xe5/0x113
[  242.083912]  [<ffffffff8115f2d4>] btrfs_relocate_block_group+0xb2/0x2cc
[  242.083922]  [<ffffffff81148564>] btrfs_relocate_chunk+0x65/0x4a2
[  242.083930]  [<ffffffff8114746c>] ? map_extent_buffer+0x67/0xa1
[  242.083940]  [<ffffffff81143c38>] ? pagefault_enable+0x23/0x2e
[  242.083949]  [<ffffffff811474af>] ? unmap_extent_buffer+0x9/0xb
[  242.083958]  [<ffffffff8113cd74>] ? btrfs_dev_extent_chunk_offset+0xb6/0xc6
[  242.083969]  [<ffffffff8114ad14>] btrfs_shrink_device+0x1ce/0x2f1
[  242.083980]  [<ffffffff8114c7f9>] btrfs_rm_device+0x210/0x4aa
[  242.083989]  [<ffffffff81150b88>] ? btrfs_ioctl+0x60c/0x7d0
[  242.084000]  [<ffffffff8109db7a>] ? copy_from_user+0x9/0xb
[  242.084010]  [<ffffffff81150baa>] btrfs_ioctl+0x62e/0x7d0
[  242.084022]  [<ffffffff810ca834>] vfs_ioctl+0x31/0xa2
[  242.084032]  [<ffffffff810cb150>] do_vfs_ioctl+0x457/0x48a
[  242.084042]  [<ffffffff810cb1d4>] sys_ioctl+0x51/0x75
[  242.084053]  [<ffffffff8100212b>] system_call_fastpath+0x16/0x1b
[  242.084059] Code: 00 00 01 74 05 e8 28 e9 13 00 c9 c3 55 48 89 e5 f0 ff 07 c9 c3 55 48 89 e5 f0 81 07 00 00 00 01 c9 c3 55 b8 00 01 00 00 48 89 e5 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 55 48 89 e5 
[  242.084155] RIP  [<ffffffff81060c79>] do_raw_spin_lock+0x9/0x1a
[  242.084165]  RSP <ffff88010ca13508>
[  242.084170] CR2: 00000000000000b8
[  242.084177] ---[ end trace 368ef32f0f0e8e74 ]---
[  242.084184] note: btrfs[4119] exited with preempt_count 1
[root@studio-arch ~]# 

What to do to fix? 

-- 
Victor Lowther
LPIC2 UCP RHCE 



