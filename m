From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: btrfs: warn_slowpath in clean_tree_block and others
Date: Tue, 24 Feb 2009 23:02:49 +0000
Message-ID: <20090224230249.GA6859@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   This is essentially a repost of a mail I made last week, to which I
didn't get a reply.

   I'm getting huge numbers of kernel warnings whilst using
btrfs. They're all "warn_slowpath", and all seem to be in
fs/btrfs/disk-io.c. I've included one typical example at the end of
this mail.

   Kernel versions are 2.6.29-rc2, -rc4 and -rc6.

   If I do lots of writes to my btrfs filesystem (e.g. video
encoding), I end up with a syslog in the tens-of-megabytes range. This
makes logcheck an unhappy bunny...

   I don't know if this behaviour is expected, and everyone using
btrfs simply puts up with it for now, or if it's something unusual
that needs investigating. On the chance that it's the latter, I'm
reporting it here.

   Hugo.

Feb 23 21:45:42 vlad kernel: ------------[ cut here ]------------
Feb 23 21:45:42 vlad kernel: WARNING: at fs/btrfs/disk-io.c:815 clean_tree_block+0x9d/0xbb [btrfs]()
Feb 23 21:45:42 vlad kernel: Hardware name: System Product Name
Feb 23 21:45:42 vlad kernel: Modules linked in: tun ext3 jbd btrfs zlib_deflate tcp_diag inet_diag kqemu cpufreq_userspace ipv6 nfsd nfs lockd nfs_acl auth_rpcgss sunrpc af_packet bridge stp llc xfs exportfs it87 hwmon_vid powernow_k8 sbp2 ieee1394 ide_generic ide_gd_mod ide_cd_mod pcspkr evdev k8temp hwmon i2c_viapro i2c_core button dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod usbhid usb_storage libusual sg sr_mod cdrom via82cxxx floppy via_rhine mii ehci_hcd uhci_hcd usbcore pata_via ide_pci_generic ide_core sd_mod thermal processor fan unix
Feb 23 21:45:42 vlad kernel: Pid: 27034, comm: hdparm Tainted: G        W  2.6.29-rc4 #1
Feb 23 21:45:42 vlad kernel: Call Trace:
Feb 23 21:45:42 vlad kernel: [<ffffffff80228d7d>] warn_slowpath+0xd8/0x111
Feb 23 21:45:42 vlad kernel: [<ffffffff80312f11>] radix_tree_insert+0xd7/0x19f
Feb 23 21:45:42 vlad kernel: [<ffffffff8024d55d>] add_to_page_cache_locked+0x52/0x9e
Feb 23 21:45:42 vlad kernel: [<ffffffff8024d5e9>] add_to_page_cache_lru+0x40/0x58
Feb 23 21:45:42 vlad kernel: [<ffffffff8024dbd0>] find_or_create_page+0x62/0x88
Feb 23 21:45:42 vlad kernel: [<ffffffffa03f992a>] alloc_extent_buffer+0x268/0x2ec [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03e1b18>] clean_tree_block+0x9d/0xbb [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d5eaf>] btrfs_init_new_buffer+0x99/0xf3 [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d849e>] btrfs_alloc_free_block+0x83/0x8c [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03cb2f8>] __btrfs_cow_block+0x1ff/0x87e [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03cc125>] btrfs_cow_block+0x1e7/0x1f6 [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffff80251d9e>] __alloc_pages_internal+0xd2/0x3ec
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d0915>] btrfs_search_slot+0x36f/0x99b [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d14ee>] btrfs_insert_empty_items+0x7f/0x49d [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d825d>] __btrfs_alloc_reserved_extent+0x19f/0x2bb [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d83f0>] btrfs_alloc_extent+0x77/0xa2 [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d847f>] btrfs_alloc_free_block+0x64/0x8c [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03cb2f8>] __btrfs_cow_block+0x1ff/0x87e [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d7532>] finish_current_insert+0x514/0x528 [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03d7bf9>] del_pending_extents+0xa5/0x33d [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03cc125>] btrfs_cow_block+0x1e7/0x1f6 [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03e436d>] btrfs_commit_tree_roots+0x53/0x1ba [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffff80403a3e>] schedule_timeout+0xa1/0xbc
Feb 23 21:45:42 vlad kernel: [<ffffffffa03e55dd>] btrfs_commit_transaction+0x322/0x6e5 [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffff802385fb>] autoremove_wake_function+0x0/0x2e
Feb 23 21:45:42 vlad kernel: [<ffffffffa03e4809>] join_transaction+0x129/0x147 [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffffa03c8788>] btrfs_sync_fs+0x70/0x78 [btrfs]
Feb 23 21:45:42 vlad kernel: [<ffffffff8026f332>] sync_filesystems+0xa8/0xde
Feb 23 21:45:42 vlad kernel: [<ffffffff80287256>] do_sync+0x25/0x50
Feb 23 21:45:42 vlad kernel: [<ffffffff8028728f>] sys_sync+0xe/0x13
Feb 23 21:45:42 vlad kernel: [<ffffffff8020b25b>] system_call_fastpath+0x16/0x1b
Feb 23 21:45:42 vlad kernel: ---[ end trace a315082d564863a6 ]---


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Eighth Army Push Bottles Up Germans -- WWII newspaper ---      
                     headline (possibly apocryphal)                      

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJpHyZIKyzvlFcI40RApVLAJoDrHaA+9cebRyJDm+vhGqgEQGiMACguCV+
znRCpat0ajek+ivXViQX5rg=
=GsHM
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
