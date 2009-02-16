From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: warn_slowpath in clean_tree_block
Date: Mon, 16 Feb 2009 13:42:34 +0000
Message-ID: <20090216134234.GB11816@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Cc: linux-kernel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I've just started playing with Btrfs, and I'm getting a log full of
kernel warnings that look something like this:

Feb 16 09:02:17 vlad kernel: ------------[ cut here ]------------
Feb 16 09:02:17 vlad kernel: WARNING: at fs/btrfs/disk-io.c:815 clean_tree_block+0x9d/0xbb [btrfs]()
Feb 16 09:02:17 vlad kernel: Hardware name: System Product Name
Feb 16 09:02:17 vlad kernel: Modules linked in: btrfs zlib_deflate tcp_diag inet_diag kqemu cpufreq_userspace ipv6 nfsd nfs lockd nfs_acl auth_rpcgss sunrpc af_packet bridge stp llc xfs exportfs it87 hwmon_vid powernow_k8 sbp2 ieee1394 ide_generic ide_gd_mod ide_cd_mod pcspkr evdev k8temp hwmon i2c_viapro i2c_core button dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod usbhid usb_storage libusual sg sr_mod cdrom via82cxxx floppy via_rhine mii ehci_hcd uhci_hcd usbcore pata_via ide_pci_generic ide_core sd_mod thermal processor fan unix
Feb 16 09:02:17 vlad kernel: Pid: 24129, comm: btrfs-endio-wri Tainted: G        W  2.6.29-rc4 #1
Feb 16 09:02:17 vlad kernel: Call Trace:
Feb 16 09:02:17 vlad kernel: [<ffffffff80228d7d>] warn_slowpath+0xd8/0x111
Feb 16 09:02:17 vlad kernel: [<ffffffff80251d9e>] __alloc_pages_internal+0xd2/0x3ec
Feb 16 09:02:17 vlad kernel: [<ffffffff8024d55d>] add_to_page_cache_locked+0x52/0x9e
Feb 16 09:02:17 vlad kernel: [<ffffffff8024d5e9>] add_to_page_cache_lru+0x40/0x58
Feb 16 09:02:17 vlad kernel: [<ffffffff8024dbd0>] find_or_create_page+0x62/0x88
Feb 16 09:02:17 vlad kernel: [<ffffffff80313244>] rb_insert_color+0xba/0xe2
Feb 16 09:02:17 vlad kernel: [<ffffffffa03f992a>] alloc_extent_buffer+0x268/0x2ec [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03e1b18>] clean_tree_block+0x9d/0xbb [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03d5eaf>] btrfs_init_new_buffer+0x99/0xf3 [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03d849e>] btrfs_alloc_free_block+0x83/0x8c [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03cda8b>] split_leaf+0x159/0xa0a [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03f0de5>] btrfs_item_offset+0xb3/0xbe [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03c96bc>] leaf_space_used+0xb5/0xe8 [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03d0ebd>] btrfs_search_slot+0x917/0x99b [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03ef06a>] btrfs_drop_extents+0xa75/0xab3 [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03d14ee>] btrfs_insert_empty_items+0x7f/0x49d [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03e6f0f>] insert_reserved_file_extent+0xd9/0x230 [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03fa44f>] set_extent_bit+0x220/0x277 [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03fadce>] lock_extent+0x46/0x95 [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03e885c>] btrfs_finish_ordered_io+0xfe/0x198 [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa03fb4ff>] end_bio_extent_writepage+0xa9/0x1b1 [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa04023e4>] worker_loop+0x5f/0x15e [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa0402385>] worker_loop+0x0/0x15e [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffffa0402385>] worker_loop+0x0/0x15e [btrfs]
Feb 16 09:02:17 vlad kernel: [<ffffffff80238269>] kthread+0x47/0x73
Feb 16 09:02:17 vlad kernel: [<ffffffff8020c03a>] child_rip+0xa/0x20
Feb 16 09:02:17 vlad kernel: [<ffffffff80238222>] kthread+0x0/0x73
Feb 16 09:02:17 vlad kernel: [<ffffffff8020c030>] child_rip+0x0/0x20
Feb 16 09:02:17 vlad kernel: ---[ end trace a315082d5647b979 ]---

   They're not all identical -- there are bits in the middle of the
trace that change. They tend to arrive in groups of 4-8 warnings very
close together, separated by 15-20 seconds without a warning. The
workload was encoding a video from another filesystem, onto the Btrfs
filesystem. It's quiet when there's nothing accessing the filesystem.

   The filesystem is 19GiB in size, residing on LVM-on-RAID-1 on a
2.6.29-rc4 kernel. It was created on 2.6.29-rc3, 20GiB in size using
btrfs tools 0.18-ge3b0f66, and shrunk online to its current size.

   I haven't found any similar reports on the mailing list, which
means either I've got something unusual, or something so blindingly
expected that nobody's bothered to mention it. I suspect the latter,
but I'm reporting it in case it's the former.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "You got very nice eyes, Deedee. Never noticed them ---       
                           before. They real?"                           

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJmW1KIKyzvlFcI40RAjlmAJ91KrL0ur9EkEdbhhYHPbU786WPngCfQ5/j
K5vUToe/n2/5FIgLb8J4e3g=
=c1Qa
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
