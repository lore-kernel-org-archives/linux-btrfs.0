From: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
Subject: Re: [PATCH] btrfs: add better -ENOSPC handling VERSION 3
Date: Tue, 17 Feb 2009 18:21:10 +0900
Message-ID: <20090217182110.00bdb9e3.ytakahashi@miraclelinux.com>
References: <1234557604-28769-1-git-send-email-jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: chris.mason@oracle.com
To: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234557604-28769-1-git-send-email-jbacik@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef.

I created file till return of ENOSPC.
I created 18874027 files of size zero on btrfs of 16Gbyte in 1609 seconds.
I test to cause ENOSPC-problem but there was not the problem.
ENOSPC-problem were fixed in linux-2.6.29-rc5 and this patch.
This is a good patch.

Next.
I created 2758939 files of size 4096 on btrfs of 16Gbyte in 431 seconds.
And I received the following messages when I unlink files.

 btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
 btrfs allocation failed flags 36, wanted 4096
 space_info has 65536 free, is full
 space_info total=1932853248, pinned=164216832, delalloc=0, may_use=0, used=1768570880
 block group 29360128 has 1073741824 bytes, 942583808 used 131092480 pinned 0 reserved
 0 blocks of free space at or bigger than bytes is
 block group 8619294720 has 859111424 bytes, 825987072 used 33124352 pinned 0 reserved
 0 blocks of free space at or bigger than bytes is
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/extent-tree.c:3360!
 invalid opcode: 0000 [#1] SMP
 last sysfs file: /sys/devices/pci0000:80/0000:80:0e.0/0000:84:00.0/local_cpus
 CPU 3
 Modules linked in: btrfs zlib_deflate nls_utf8 hfsplus autofs4 hidp rfcomm l2cap bluetooth sunrpc ib_iser libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib inet_lro rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ib_sa ib_mad ib_core dm_mirror dm_region_hash dm_log dm_multipath dm_mod sbs sbshc battery acpi_memhotplug ac ipv6 lp floppy snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss sg rtc_cmos snd_mixer_oss snd_pcm snd_timer rtc_core parport_pc tg3 libphy ide_cd_mod snd button parport cdrom serio_raw rtc_lib i2c_amd8111 i2c_amd756 k8temp soundcore hwmon snd_page_alloc shpchp amd_rng i2c_core pcspkr sata_sil libata aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
 
 Pid: 20535, comm: rm Tainted: G   M       2.6.29-rc5 #1 -[62176J7]-
 RIP: 0010:[<ffffffffa041e529>]  [<ffffffffa041e529>] __btrfs_reserve_extent+0x25b/0x270 [btrfs]
 RSP: 0018:ffff8800acd6d3d8  EFLAGS: 00010246
 RAX: ffff88011996ca38 RBX: ffff88011996c960 RCX: 0000000000008610
 RDX: 000000000000e1e1 RSI: 0000000000000246 RDI: ffff88011996ca34
 RBP: ffff8800acd6d448 R08: 0000000000000000 R09: 00000000ffffff00
 R10: 000000000000000a R11: 0000000000000000 R12: ffff88011996c9c0
 R13: 0000000000001000 R14: ffff88011996ca30 R15: 0000000000001000
 FS:  00007fea3f7486e0(0000) GS:ffff88012ecffcc0(0000) knlGS:00000000f7fa38d0
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00007f651b793000 CR3: 00000000c64be000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process rm (pid: 20535, threadinfo ffff8800acd6c000, task ffff88012ed8c970)
 Stack:
  0000000000000000 ffff8800acd6d4f8 0000000000000000 0000000000000000
  ffffe20000000024 ffff880000000000 0000000000000000 0000000000000000
  ffff88010c0c4000 0000000000001000 ffff8800acd6d4f8 ffff88012a516000
 Call Trace:
  [<ffffffffa0421005>] btrfs_alloc_extent+0x48/0xa7 [btrfs]
  [<ffffffffa04210c0>] btrfs_alloc_free_block+0x5c/0x87 [btrfs]
  [<ffffffffa04155e1>] __btrfs_cow_block+0x1e7/0x82e [btrfs]
  [<ffffffffa04162d9>] btrfs_cow_block+0x1ed/0x1fc [btrfs]
  [<ffffffffa0419cb2>] btrfs_search_slot+0x31a/0x90f [btrfs]
  [<ffffffffa041add4>] btrfs_insert_some_items+0xb2/0x570 [btrfs]
  [<ffffffff80279fa3>] ? unlock_page+0x22/0x27
  [<ffffffffa04482df>] ? set_extent_buffer_dirty+0x102/0x131 [btrfs]
  [<ffffffffa041f50b>] insert_extents+0x162/0x36f [btrfs]
  [<ffffffffa0420105>] finish_current_insert+0x4de/0x553 [btrfs]
  [<ffffffffa04228dc>] __btrfs_inc_extent_ref+0x1b5/0x1e4 [btrfs]
  [<ffffffff8034a2fe>] ? generic_swap+0x0/0x1c
  [<ffffffffa04256fb>] btrfs_inc_ref+0x42d/0x4ce [btrfs]
  [<ffffffffa0422727>] ? __btrfs_inc_extent_ref+0x0/0x1e4 [btrfs]
  [<ffffffffa0445c95>] ? copy_extent_buffer+0x115/0x149 [btrfs]
  [<ffffffffa0415834>] __btrfs_cow_block+0x43a/0x82e [btrfs]
  [<ffffffffa04162d9>] btrfs_cow_block+0x1ed/0x1fc [btrfs]
  [<ffffffffa0419cb2>] btrfs_search_slot+0x31a/0x90f [btrfs]
  [<ffffffff8034d5e8>] ? crc32c+0x4c/0x60
  [<ffffffffa0427d8d>] btrfs_lookup_dir_item+0x71/0xe7 [btrfs]
  [<ffffffffa04337e4>] btrfs_unlink_inode+0x60/0x26f [btrfs]
  [<ffffffffa042f0e5>] ? start_transaction+0xf9/0x105 [btrfs]
  [<ffffffffa0433dbc>] btrfs_unlink+0x55/0x97 [btrfs]
  [<ffffffff802af53b>] vfs_unlink+0xb9/0x12c
  [<ffffffff802b197e>] do_unlinkat+0xc1/0x173
  [<ffffffff802b4063>] ? vfs_readdir+0x9a/0xaf
  [<ffffffff8026855b>] ? audit_syscall_entry+0x16b/0x19e
  [<ffffffff802b1a41>] sys_unlink+0x11/0x13
  [<ffffffff8020c05b>] system_call_fastpath+0x16/0x1b
 Code: 00 48 81 eb b8 00 00 00 48 8b 83 b8 00 00 00 48 8d 93 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 9f 4c 89 f7 e8 29 1e e3 df <0f> 0b eb fe 48 83 c4 48 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3
 RIP  [<ffffffffa041e529>] __btrfs_reserve_extent+0x25b/0x270 [btrfs]
  RSP <ffff8800acd6d3d8>
 ---[ end trace b5c34207a1ecc394 ]---

And, I received the following messages when I utime(2) files.

 btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
 btrfs allocation failed flags 36, wanted 4096
 space_info has 65536 free, is full
 space_info total=1932853248, pinned=54943744, delalloc=0, may_use=0, used=1877843968
 block group 29360128 has 1073741824 bytes, 1041494016 used 32182272 pinned 0 reserved
 0 blocks of free space at or bigger than bytes is
 block group 8619294720 has 859111424 bytes, 836349952 used 22761472 pinned 0 reserved
 0 blocks of free space at or bigger than bytes is
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/extent-tree.c:3360!
 invalid opcode: 0000 [#1] SMP
 last sysfs file: /sys/devices/pci0000:80/0000:80:0e.0/0000:84:00.0/local_cpus
 CPU 3
 Modules linked in: btrfs zlib_deflate autofs4 hidp rfcomm l2cap bluetooth sunrpc ib_iser libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib inet_lro rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ib_sa ib_mad ib_core dm_mirror dm_region_hash dm_log dm_multipath dm_mod sbs sbshc battery acpi_memhotplug ac ipv6 lp floppy snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss k8temp button sg snd_pcm i2c_amd8111 snd_timer snd serio_raw parport_pc rtc_cmos tg3 i2c_amd756 soundcore rtc_core parport hwmon libphy i2c_core ide_cd_mod cdrom rtc_lib amd_rng pcspkr snd_page_alloc shpchp sata_sil libata aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
 Pid: 14421, comm: mkfbmt Tainted: G   M       2.6.29-rc5 #1 -[62176J7]-
 RIP: 0010:[<ffffffffa0407529>]  [<ffffffffa0407529>] __btrfs_reserve_extent+0x25b/0x270 [btrfs]
 RSP: 0018:ffff88010010d968  EFLAGS: 00010246
 RAX: ffff880026bed8f8 RBX: ffff880026bed820 RCX: 0000000000008689
 RDX: 0000000000005959 RSI: 0000000000000246 RDI: ffff880026bed8f4
 RBP: ffff88010010d9d8 R08: 0000000000000000 R09: 00000000ffffff00
 R10: 000000000000000a R11: 0000000000000000 R12: ffff880026bed880
 R13: 0000000000001000 R14: ffff880026bed8f0 R15: 0000000000001000
 FS:  00007fb97df446e0(0000) GS:ffff88012ecffcc0(0000) knlGS:00000000f7f4f8d0
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 000000342e614ce5 CR3: 000000011557b000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process mkfbmt (pid: 14421, threadinfo ffff88010010c000, task ffff88011f9738d0)
 Stack:
  0000000000000000 ffff88010010da88 0000000000000000 0000000000000000
  ffff880100000024 ffff88010010dad4 0000000000000000 0000000000000000
  ffff8801145c0000 0000000000001000 ffff88010010da88 ffff8801149cd000
 Call Trace:
  [<ffffffffa040a005>] btrfs_alloc_extent+0x48/0xa7 [btrfs]
  [<ffffffffa040a0c0>] btrfs_alloc_free_block+0x5c/0x87 [btrfs]
  [<ffffffffa03fe5e1>] __btrfs_cow_block+0x1e7/0x82e [btrfs]
  [<ffffffffa03ff2d9>] btrfs_cow_block+0x1ed/0x1fc [btrfs]
  [<ffffffffa0402cb2>] btrfs_search_slot+0x31a/0x90f [btrfs]
  [<ffffffffa0419b89>] ? btrfs_lookup_dentry+0x159/0x16f [btrfs]
  [<ffffffff802cd6a1>] ? inotify_d_instantiate+0x1a/0x43
  [<ffffffff802b6984>] ? d_splice_alias+0xc4/0xd0
  [<ffffffffa0412a8c>] btrfs_lookup_inode+0x2c/0x90 [btrfs]
  [<ffffffffa041bb13>] btrfs_update_inode+0x46/0xbd [btrfs]
  [<ffffffffa041c770>] btrfs_dirty_inode+0x3e/0x52 [btrfs]
  [<ffffffff802c0f3c>] __mark_inode_dirty+0x33/0x178
  [<ffffffff802b998c>] inode_setattr+0x11b/0x125
  [<ffffffffa041ace0>] btrfs_setattr+0x56/0x6e [btrfs]
  [<ffffffff802b9b2a>] notify_change+0x194/0x2d6
  [<ffffffff802c3969>] utimes_common+0x121/0x163
  [<ffffffff802c3a64>] do_utimes+0xb9/0xda
  [<ffffffff802c3c0f>] sys_utime+0x66/0x7b
  [<ffffffff8020c05b>] system_call_fastpath+0x16/0x1b
 Code: 00 48 81 eb b8 00 00 00 48 8b 83 b8 00 00 00 48 8d 93 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 9f 4c 89 f7 e8 29 8e e4 df <0f> 0b eb fe 48 83 c4 48 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3
 RIP  [<ffffffffa0407529>] __btrfs_reserve_extent+0x25b/0x270 [btrfs]
  RSP <ffff88010010d968>
 ---[ end trace 16075f4743156c16 ]---

Thanks, regards,

On Fri, 13 Feb 2009 15:40:04 -0500
Josef Bacik <jbacik@redhat.com> wrote:

> This is a step in the direction of better -ENOSPC handling.  Instead of checking
> the global bytes counter we check the space_info bytes counters to make sure we
> have enough space.  If we don't we go ahead and try to allocate a new chunk, and
> then if that fails we return -ENOSPC.  This patch adds two counters to
> btrfs_space_info, bytes_delalloc and bytes_may_use.  bytes_delalloc account for
> extents we've actually setup for delalloc and will be allocated at some point
> down the line.  bytes_may_use is to keep track of how many bytes we may use for
> delalloc at some point.  When we actually set the extent_bit for the delalloc
> bytes we subtract the reserved bytes from the bytes_may_use counter.  This keeps
> us from not actually being able to allocate space for any delalloc bytes.  This
> has been tested with fs_mark and dbench.
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>
