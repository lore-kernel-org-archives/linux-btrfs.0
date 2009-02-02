From: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
Subject: Re: report, kernel BUG at fs/btrfs/extent-tree.c:3106
Date: Mon, 2 Feb 2009 16:00:11 +0900
Message-ID: <20090202160011.ee5b7c03.ytakahashi@miraclelinux.com>
References: <20090130143528.2069bf78.ytakahashi@miraclelinux.com>
	<20090130134935.GB24426@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090130134935.GB24426@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Josef

On Fri, 30 Jan 2009 08:49:35 -0500 Josef Bacik <jbacik@redhat.com> wrote:
> On Fri, Jan 30, 2009 at 02:35:28PM +0900, Yoshihiro Takahashi wrote:
> > Hi.
> > 
> > I create many files on btrfs of 16GB partition.
> > may 13,000,000 files.
> > I get this report.
> > 
> > I think about the following fix.
> > When there is not space, return of ENOSPC.
> > Or add lock in free extents.
> >
> 
> Are you just creating files, or are you doing something else?  Thanks,
> 
> Josef 
> --

I made a lot of files. 
Perhaps surpass 13,000,000 file. 

I created directry first.
I get this BUG when I made the file afterwards.

I got the following report to count of the files when I performed find.

Best regards,
Yoshihiro Takahashi

kernel: Btrfs loaded
kernel: device fsid 2047df6816b4db3c-c6db45ac0ec98490 <6>devid 1 transid 126 /dev/sda2
kernel: btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
kernel: btrfs allocation failed flags 36, wanted 4096
kernel: space_info has 65536 free, is full
kernel: block group 29360128 has 1073741824 bytes, 1057210368 used 16465920 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 1103101952 has 859111424 bytes, 842813440 used 16297984 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 1962213376 has 859111424 bytes, 830881792 used 28229632 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 2821324800 has 859111424 bytes, 816119808 used 42991616 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 3680436224 has 859111424 bytes, 823795712 used 35315712 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 4539547648 has 859111424 bytes, 830922752 used 28188672 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 5398659072 has 859111424 bytes, 830865408 used 28246016 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 6257770496 has 859111424 bytes, 815796224 used 43315200 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 7116881920 has 859111424 bytes, 832589824 used 26521600 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/btrfs/extent-tree.c:3106!
kernel: invalid opcode: 0000 [#1] SMP
kernel: last sysfs file: /sys/class/misc/btrfs-control/dev
kernel: CPU 1
kernel: Modules linked in: btrfs zlib_deflate ipv6 cpufreq_powersave firewire_ohci firewire_core crc_itu_t dm_mirror dm_region_hash dm_log dm_multipath dm_mod sbshc button battery acpi_memhotplug ac ehci_hcd ohci_hcd k8temp hwmon amd_rng i2c_amd8111 i2c_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc tg3 libphy floppy ide_cd_mod cdrom ext3 jbd sata_sil libata aic79xx scsi_transport_spi sd_mod scsi_mod [last unloaded: x_tables]
kernel: Pid: 5289, comm: find Not tainted 2.6.29-rc3 #1
kernel: RIP: 0010:[<ffffffffa0455ed0>]  [<ffffffffa0455ed0>] __btrfs_reserve_extent+0x28c/0x2a1 [btrfs]
kernel: RSP: 0018:ffff880116e37498  EFLAGS: 00010246
kernel: RAX: ffff88012a0aed28 RBX: ffff88012d8e57c0 RCX: 00000000ffffffff
kernel: RDX: 0000000000008181 RSI: 0000000000000246 RDI: ffff88012a0aed24
kernel: RBP: ffff880116e37508 R08: 00000000ffffffff R09: 0000000000000000
kernel: R10: ffffffff8087b6a0 R11: ffff880116e37398 R12: ffff88012a0aed08
kernel: R13: ffff88012a0aecc0 R14: 0000000000001000 R15: ffff88011e1f54c0
kernel: FS:  00007f459c7846e0(0000) GS:ffff88012ec7adc0(0000) knlGS:00000000f7fca6c0
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 0000000000512828 CR3: 0000000116e32000 CR4: 00000000000006e0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process find (pid: 5289, threadinfo ffff880116e36000, task ffff88012bb04fe0)
kernel: Stack:
kernel:  00000001db66c000 ffff880116e375a8 0000000000000000 0000000000000000
kernel:  ffff880000000024 ffff88011e300b38 00000001db66c000 0000000000000000
kernel:  0000000000001000 ffff880116e375a8 ffff88012b50d000 0000000000000002
kernel: Call Trace:
kernel:  [<ffffffffa0456401>] btrfs_alloc_extent+0x47/0x9f [btrfs]
kernel:  [<ffffffffa04565a3>] btrfs_alloc_free_block+0x5c/0x86 [btrfs]
kernel:  [<ffffffffa044d886>] split_leaf+0x180/0x9d6 [btrfs]
kernel:  [<ffffffffa044e88c>] btrfs_search_slot+0x7b0/0x805 [btrfs]
kernel:  [<ffffffffa0474da8>] ? btrfs_item_offset+0xba/0xc7 [btrfs]
kernel:  [<ffffffffa044f7f0>] btrfs_insert_some_items+0xac/0x5ed [btrfs]
kernel:  [<ffffffffa0479523>] ? set_extent_bit+0x264/0x295 [btrfs]
kernel:  [<ffffffff8027a06b>] ? unlock_page+0x24/0x29
kernel:  [<ffffffffa047cc7e>] ? set_extent_buffer_dirty+0x10b/0x11e [btrfs]
kernel:  [<ffffffffa0485127>] ? btrfs_tree_unlock+0xd/0x11 [btrfs]
kernel:  [<ffffffffa0451b7f>] insert_extents+0x17a/0x3a0 [btrfs]
kernel:  [<ffffffffa04539d7>] finish_current_insert+0x4b2/0x551 [btrfs]
kernel:  [<ffffffffa0454dc4>] __btrfs_inc_extent_ref+0x1b5/0x1e4 [btrfs]
kernel:  [<ffffffffa0474a77>] ? btrfs_key_blockptr+0xbd/0xcb [btrfs]
kernel:  [<ffffffffa0452c0e>] btrfs_inc_ref+0x36e/0x3e4 [btrfs]
kernel:  [<ffffffffa0454c0f>] ? __btrfs_inc_extent_ref+0x0/0x1e4 [btrfs]
kernel:  [<ffffffffa047d822>] ? copy_extent_buffer+0x124/0x154 [btrfs]
kernel:  [<ffffffffa04484bc>] __btrfs_cow_block+0x44c/0x84e [btrfs]
kernel:  [<ffffffffa0479ce8>] ? test_range_bit+0x49/0xe2 [btrfs]
kernel:  [<ffffffffa0448abc>] btrfs_cow_block+0x1fe/0x20d [btrfs]
kernel:  [<ffffffffa044e431>] btrfs_search_slot+0x355/0x805 [btrfs]
kernel:  [<ffffffff804cad27>] ? thread_return+0x3e/0xa4
kernel:  [<ffffffff802a2752>] ? cache_alloc_refill+0x145/0x1c4
kernel:  [<ffffffffa045ec6f>] btrfs_lookup_inode+0x2c/0xa1 [btrfs]
kernel:  [<ffffffffa046613c>] btrfs_update_inode+0x44/0xad [btrfs]
kernel:  [<ffffffff802b46e9>] ? filldir64+0x0/0xc4
kernel:  [<ffffffff802b46e9>] ? filldir64+0x0/0xc4
kernel:  [<ffffffffa04692a2>] btrfs_dirty_inode+0x3c/0x4f [btrfs]
kernel:  [<ffffffff802c0d1c>] __mark_inode_dirty+0x30/0x175
kernel:  [<ffffffff802b46e9>] ? filldir64+0x0/0xc4
kernel:  [<ffffffff802b92bd>] touch_atime+0x10f/0x120
kernel:  [<ffffffff802b4427>] vfs_readdir+0x8f/0xaa
kernel:  [<ffffffff802b4826>] sys_getdents64+0x79/0xbf
kernel:  [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
kernel: Code: 48 ff ff ff e8 86 6f de df 4c 89 f6 48 89 df e8 95 53 03 00 41 fe 84 24 74 ff ff ff 4d 8b 24 24 eb 96 49 8d 7d 60 e8 1a b4 df df <0f> 0b eb fe 48 83 c4 48 89 c8 5b 41 5c 41 5d 41 5e 41 5f c9 c3
kernel: RIP  [<ffffffffa0455ed0>] __btrfs_reserve_extent+0x28c/0x2a1 [btrfs]
kernel:  RSP <ffff880116e37498>
kernel: ---[ end trace 5bfb95b22897a3f4 ]---
kernel: btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
kernel: btrfs allocation failed flags 36, wanted 4096
kernel: space_info has 65536 free, is full
kernel: block group 29360128 has 1073741824 bytes, 1057210368 used 16465920 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 1103101952 has 859111424 bytes, 842813440 used 16297984 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 1962213376 has 859111424 bytes, 830881792 used 28229632 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 2821324800 has 859111424 bytes, 816119808 used 42991616 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 3680436224 has 859111424 bytes, 823795712 used 35315712 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 4539547648 has 859111424 bytes, 830922752 used 28188672 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 5398659072 has 859111424 bytes, 830865408 used 28246016 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 6257770496 has 859111424 bytes, 815796224 used 43315200 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 7116881920 has 859111424 bytes, 832589824 used 26521600 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/btrfs/extent-tree.c:3106!
kernel: invalid opcode: 0000 [#2] SMP
kernel: last sysfs file: /sys/class/misc/btrfs-control/dev
kernel: CPU 3
kernel: Modules linked in: btrfs zlib_deflate ipv6 cpufreq_powersave firewire_ohci firewire_core crc_itu_t dm_mirror dm_region_hash dm_log dm_multipath dm_mod sbshc button battery acpi_memhotplug ac ehci_hcd ohci_hcd k8temp hwmon amd_rng i2c_amd8111 i2c_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc tg3 libphy floppy ide_cd_mod cdrom ext3 jbd sata_sil libata aic79xx scsi_transport_spi sd_mod scsi_mod [last unloaded: x_tables]
kernel: Pid: 5285, comm: btrfs-cleaner Tainted: G      D    2.6.29-rc3 #1
kernel: RIP: 0010:[<ffffffffa0455ed0>]  [<ffffffffa0455ed0>] __btrfs_reserve_extent+0x28c/0x2a1 [btrfs]
kernel: RSP: 0018:ffff88011a9e7830  EFLAGS: 00010246
kernel: RAX: ffff88012a0aed28 RBX: ffff88012d8e57c0 RCX: ffffffff803b5112
kernel: RDX: 0000000000008585 RSI: 0000000000000246 RDI: ffff88012a0aed24
kernel: RBP: ffff88011a9e78a0 R08: ffffffff803b5112 R09: 0000000000000000
kernel: R10: ffffffff8087b6a0 R11: ffff88011a9e7730 R12: ffff88012a0aed08
kernel: R13: ffff88012a0aecc0 R14: 0000000000001000 R15: ffff88011e1f5488
kernel: FS:  00007f212e4236e0(0000) GS:ffff88012ecffcc0(0000) knlGS:00000000f7fca6c0
kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
kernel: CR2: 00007f893b4396e0 CR3: 0000000123153000 CR4: 00000000000006e0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process btrfs-cleaner (pid: 5285, threadinfo ffff88011a9e6000, task ffff88011a9b91e0)
kernel: Stack:
kernel:  0000000180000000 ffff88011a9e7940 0000000000000000 0000000000000000
kernel:  ffff880100000024 0000000000000246 0000000180000000 0000000000000000
kernel:  0000000000001000 ffff88011a9e7940 ffff88012b50d000 0000000000000002
kernel: Call Trace:
kernel:  [<ffffffffa0456401>] btrfs_alloc_extent+0x47/0x9f [btrfs]
kernel:  [<ffffffffa04565a3>] btrfs_alloc_free_block+0x5c/0x86 [btrfs]
kernel:  [<ffffffffa0448269>] __btrfs_cow_block+0x1f9/0x84e [btrfs]
kernel:  [<ffffffffa047d3fb>] ? map_extent_buffer+0x92/0xd8 [btrfs]
kernel:  [<ffffffffa0448abc>] btrfs_cow_block+0x1fe/0x20d [btrfs]
kernel:  [<ffffffffa044e431>] btrfs_search_slot+0x355/0x805 [btrfs]
kernel:  [<ffffffff80271597>] ? __delayacct_blkio_end+0x39/0x3b
kernel:  [<ffffffff80279d3a>] ? wait_on_page_bit+0x8d/0x97
kernel:  [<ffffffffa045166c>] lookup_extent_backref+0x3d/0xe2 [btrfs]
kernel:  [<ffffffffa0455200>] __btrfs_free_extent+0x376/0x7ef [btrfs]
kernel:  [<ffffffffa0474a77>] ? btrfs_key_blockptr+0xbd/0xcb [btrfs]
kernel:  [<ffffffffa0456f2a>] walk_down_tree+0x5ea/0x62f [btrfs]
kernel:  [<ffffffffa04577c0>] btrfs_drop_snapshot+0x1ca/0x273 [btrfs]
kernel:  [<ffffffffa046333a>] ? start_transaction+0xf9/0x105 [btrfs]
kernel:  [<ffffffffa0463f45>] drop_dirty_roots+0x98/0x27b [btrfs]
kernel:  [<ffffffffa0464d1f>] btrfs_clean_old_snapshots+0x91/0x9e [btrfs]
kernel:  [<ffffffffa0460bb7>] ? cleaner_kthread+0x0/0x169 [btrfs]
kernel:  [<ffffffffa0460ca2>] cleaner_kthread+0xeb/0x169 [btrfs]
kernel:  [<ffffffff8023575a>] ? __wake_up_common+0x49/0x74
kernel:  [<ffffffffa0460bb7>] ? cleaner_kthread+0x0/0x169 [btrfs]
kernel:  [<ffffffffa0460bb7>] ? cleaner_kthread+0x0/0x169 [btrfs]
kernel:  [<ffffffff8024e424>] kthread+0x44/0x6d
kernel:  [<ffffffff8020d0ba>] child_rip+0xa/0x20
kernel:  [<ffffffff8024e3e0>] ? kthread+0x0/0x6d
kernel:  [<ffffffff8020d0b0>] ? child_rip+0x0/0x20
kernel: Code: 48 ff ff ff e8 86 6f de df 4c 89 f6 48 89 df e8 95 53 03 00 41 fe 84 24 74 ff ff ff 4d 8b 24 24 eb 96 49 8d 7d 60 e8 1a b4 df df <0f> 0b eb fe 48 83 c4 48 89 c8 5b 41 5c 41 5d 41 5e 41 5f c9 c3
kernel: RIP  [<ffffffffa0455ed0>] __btrfs_reserve_extent+0x28c/0x2a1 [btrfs]
kernel:  RSP <ffff88011a9e7830>
kernel: ---[ end trace 5bfb95b22897a3f5 ]---


# df -t btrfs
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda2             16779892   7500980   9278912  45% /btrfs
