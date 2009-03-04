From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Entirely unexpected ENOSPC?
Date: Wed, 4 Mar 2009 18:06:19 +0000
Message-ID: <20090304180619.GA3282@selene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Last night, this event jammed up a good chunk of my server:

Mar  4 01:51:36 vlad kernel: btrfs searching for 1716224 bytes, num_bytes 1716224, loop 2, allowed_alloc 1
Mar  4 01:51:36 vlad kernel: btrfs searching for 860160 bytes, num_bytes 860160, loop 2, allowed_alloc 1
[lots of this...]
Mar  4 01:55:52 vlad kernel: btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
Mar  4 01:55:52 vlad kernel: btrfs allocation failed flags 1, wanted 4096
Mar  4 01:55:52 vlad kernel: space_info has 0 free, is full
Mar  4 01:55:52 vlad kernel: block group 12582912 has 8388608 bytes, 8388608 used 0 pinned 0 reserved
Mar  4 01:55:52 vlad kernel: 0 blocks of free space at or bigger than bytes is
Mar  4 01:55:52 vlad kernel: block group 1103101952 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Mar  4 01:55:52 vlad kernel: 0 blocks of free space at or bigger than bytes is
[30 more lines of this]
Mar  4 01:55:52 vlad kernel: ------------[ cut here ]------------
Mar  4 01:55:52 vlad kernel: kernel BUG at fs/btrfs/extent-tree.c:3190!
Mar  4 01:55:52 vlad kernel: invalid opcode: 0000 [#1]
Mar  4 01:55:52 vlad kernel: last sysfs file: /sys/devices/virtual/block/dm-1/removable
Mar  4 01:55:52 vlad kernel: CPU 0
Mar  4 01:55:52 vlad kernel: Modules linked in: tcp_diag inet_diag kqemu tun cpufreq_userspace ipv6 nfsd nfs lockd nfs_acl auth_rpcgss sunrpc bridge stp llc btrfs zlib_deflate xfs exportfs it87 hwmon_vid powernow_k8 sbp2 ieee1394 ide_generic ide_gd_mod ide_cd_mod pcspkr evdev k8temp hwmon i2c_viapro i2c_core button usbhid usb_storage libusual dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod sg sr_mod cdrom via82cxxx floppy via_rhine mii ehci_hcd uhci_hcd usbcore pata_via ide_pci_generic ide_core sd_mod thermal processor fan unix
Mar  4 01:55:52 vlad kernel: Pid: 218, comm: pdflush Tainted: G    B      2.6.29-rc6 #1 System Product Name
Mar  4 01:55:52 vlad kernel: RIP: 0010:[<ffffffffa0256b6b>]  [<ffffffffa0256b6b>] __btrfs_reserve_extent+0x296/0x2ab [btrfs]
Mar  4 01:55:52 vlad kernel: RSP: 0018:ffff88003ea618d0  EFLAGS: 00010282
Mar  4 01:55:52 vlad kernel: RAX: ffff880039924aa0 RBX: ffff8800399249d0 RCX: 0000000000001000
Mar  4 01:55:52 vlad kernel: RDX: 00000000ffffffff RSI: 0000000000023b8a RDI: ffff880039924a98
Mar  4 01:55:52 vlad kernel: RBP: ffff880039924a88 R08: 0000000000000000 R09: 000000000000000a
Mar  4 01:55:52 vlad kernel: R10: 000000000000000a R11: ffff88000100f980 R12: ffff880039924a98
Mar  4 01:55:52 vlad kernel: R13: 0000000000001000 R14: ffff88003cb74488 R15: 0000000000001000
Mar  4 01:55:52 vlad kernel: FS:  00007ff4154246e0(0000) GS:ffffffff80577010(0000) knlGS:0000000000000000
Mar  4 01:55:52 vlad kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar  4 01:55:52 vlad kernel: CR2: 00007f45ee1f54f8 CR3: 000000003bdea000 CR4: 00000000000006e0
Mar  4 01:55:52 vlad kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  4 01:55:52 vlad kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  4 01:55:52 vlad kernel: Process pdflush (pid: 218, threadinfo ffff88003ea60000, task ffff88003f93b1b0)
Mar  4 01:55:52 vlad kernel: Stack:
Mar  4 01:55:52 vlad kernel: 0000000381c00000 ffff88003ea619f0 0000000000000000 0000000000000000
Mar  4 01:55:52 vlad kernel: ffff880000000001 0000000381c00000 0000000000000000 ffff88003ea619f0
Mar  4 01:55:52 vlad kernel: 000000001da5d000 0000000000001000 ffff88003ef22800 ffff88003a8214f0
Mar  4 01:55:52 vlad kernel: Call Trace:
Mar  4 01:55:52 vlad kernel: [<ffffffffa0256bae>] ? btrfs_reserve_extent+0x2e/0x52 [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffffa026903d>] ? cow_file_range+0x1ae/0x307 [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffffa026983f>] ? run_delalloc_range+0x9e/0x2f1 [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffffa027c814>] ? find_lock_delalloc_range+0x124/0x17d [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffffa027d066>] ? __extent_writepage+0x1e3/0x791 [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffff802890ff>] ? sync_buffer+0x0/0x3d
Mar  4 01:55:52 vlad kernel: [<ffffffff80312f86>] ? radix_tree_gang_lookup_tag_slot+0x7d/0xa2
Mar  4 01:55:52 vlad kernel: [<ffffffff8024d343>] ? find_get_pages_tag+0x46/0xb6
Mar  4 01:55:52 vlad kernel: [<ffffffff802387b1>] ? wake_bit_function+0x0/0x23
Mar  4 01:55:52 vlad kernel: [<ffffffffa027a95a>] ? extent_write_cache_pages+0x13c/0x242 [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffffa027967a>] ? flush_write_bio+0x0/0x23 [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffffa027ce83>] ? __extent_writepage+0x0/0x791 [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffffa027aa9b>] ? extent_writepages+0x3b/0x5c [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffffa02677c9>] ? btrfs_get_extent+0x0/0x73c [btrfs]
Mar  4 01:55:52 vlad kernel: [<ffffffff80252cf5>] ? do_writepages+0x20/0x2d
Mar  4 01:55:52 vlad kernel: [<ffffffff80284549>] ? __writeback_single_inode+0x15a/0x33b
Mar  4 01:55:52 vlad kernel: [<ffffffffa01048b2>] ? dm_any_congested+0x2f/0x39 [dm_mod]
Mar  4 01:55:52 vlad kernel: [<ffffffff80284afa>] ? generic_sync_sb_inodes+0x287/0x3e4
Mar  4 01:55:52 vlad kernel: [<ffffffff80284dbe>] ? writeback_inodes+0x68/0xa1
Mar  4 01:55:52 vlad kernel: [<ffffffff80252e10>] ? wb_kupdate+0x8b/0xfd
Mar  4 01:55:52 vlad kernel: [<ffffffff8025374b>] ? pdflush+0x0/0x1b5
Mar  4 01:55:52 vlad kernel: [<ffffffff8025374b>] ? pdflush+0x0/0x1b5
Mar  4 01:55:52 vlad kernel: [<ffffffff80253869>] ? pdflush+0x11e/0x1b5
Mar  4 01:55:52 vlad kernel: [<ffffffff80252d85>] ? wb_kupdate+0x0/0xfd
Mar  4 01:55:52 vlad kernel: [<ffffffff802383f1>] ? kthread+0x47/0x73
Mar  4 01:55:52 vlad kernel: [<ffffffff8020c07a>] ? child_rip+0xa/0x20
Mar  4 01:55:52 vlad kernel: [<ffffffff802383aa>] ? kthread+0x0/0x73
Mar  4 01:55:52 vlad kernel: [<ffffffff8020c070>] ? child_rip+0x0/0x20
Mar  4 01:55:52 vlad kernel: Code: 8b 83 b8 00 00 00 48 8d 98 48 ff ff ff 48 8b 83 b8 00 00 00 0f 18 08 48 8d 83 b8 00 00 00 48 39 c5 75 b0 4c 89 e7 e8 63 42 fe df <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3
Mar  4 01:55:52 vlad kernel: RIP  [<ffffffffa0256b6b>] __btrfs_reserve_extent+0x296/0x2ab [btrfs]
Mar  4 01:55:52 vlad kernel: RSP <ffff88003ea618d0>
Mar  4 01:55:52 vlad kernel: ---[ end trace eb8a7132a207a474 ]---

   Now, to my untrained eye, this looks like it might be an ENOSPC
problem, and thus wouldn't be entirely unexpected, except for one
thing:

hrm@vlad:~ $ df -h
Filesystem            Size  Used Avail Use% Mounted on
[...]
/dev/mapper/media-scratch
                       41G   17G   25G  42% /media/vlad/video/video

   The filesystem was nowhere near full, and I wasn't expecting it to
become anywhere near full. The only thing that writes to the
filesystem is deliberately coded to leave several gigabytes of space
free.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Nothing wrong with being written in Perl... Some of my best ---   
                      friends are written in Perl.                       

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJrsMaIKyzvlFcI40RAsZpAJ0Q6pW217dRssE9SII00289AluZEwCeKAJn
WuNXdJLjZ6+PKzKkLjJkBSI=
=kmjq
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
