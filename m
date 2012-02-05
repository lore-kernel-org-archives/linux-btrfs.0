From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Btrfs out of inodes becomes corrupt
Date: Sun, 5 Feb 2012 19:57:42 +0000
Message-ID: <20120205195742.GC19330@carfax.org.uk>
References: <b0ee762c11692ea16e81a34469311c14@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Cc: linux-btrfs@vger.kernel.org
To: Tommy Faasen <tommy@zwanebloem.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b0ee762c11692ea16e81a34469311c14@localhost>
List-ID: <linux-btrfs.vger.kernel.org>


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 05, 2012 at 07:18:59PM +0000, Tommy Faasen wrote:
> I have a btrfs partition that mainly hosts large files between 1 and 10
> GB's. It's about 2.5TB and had about 40GB free.
> According to df -i it had 0 inodes left.

   It will always show 0 inodes. This is not a problem in itself --
the FS will allocate inodes as it needs them.

> I tried deleting a file
> I tried echo >/path/to/file
> 
> Both resulting in a disk full error

   I'm not surprised, given the kernel you're using.

> Trying to remount with the option compress also didn't help.

   compress won't alter anything -- it only applies to new data
written to the disk when -o compress is enabled.

> This al under debian  with kernel 2.6.32-5.

   Aargh.

   You are aware that this is an *insanely* old version of the brtfs
code, and it has *major* flaws in it? Specifically, it doesn't deal
with out-of-space errors at all well, it doesn't have proper space
accounting (current kernels don't quite get it right all the time,
either, but they're orders of magnitude better at it), and there's
dozens of known bugs that can lead to your filesystem breaking.

   As far as btrfs goes, this kernel is so old, even the vultures have
given up on it, and the termites have picked the sun-bleached bones
clean and moved on...

   You need a new kernel *right now*.

> I tried to mount the partition under linux mint which has kernel 3.0.x.

   3.0 is two revisions old -- something on the order of 6
months. There's been a lot of development since then, too. You really
should be running 3.2 or 3.2-rc2 (i.e. the latest released or latest
development version of the kernel).

> This went intially ok, but after a very long btrfsck when I try to mount
> now I get a segfault in the kernel and the filesystem can no longer be
> mounted.
> 
> Is there anything I can do or just format it and look for backups?

   You could try mounting with -o recovery and see if that helps.
It'll try to ignore metadata trees that it can't access.

> This happends  under debian as well as under linux mint:
> 
> Here is the output of linux mint
> mint # btrfsck
> usage: btrfsck dev
> Btrfs Btrfs v0.19
> mint it0 # btrfsck /dev/vda1
> found 2749144604672 bytes used err is 0
> total csum bytes: 2681448928
> total tree bytes: 3340902400
> total fs tree bytes: 290160640
> btree space waste bytes: 253130450
> file data blocks allocated: 2746011525120
>  referenced 2745610993664

   Note that btrfsck doesn't actually fix anything. It simply verifies
the filesystem structures on the disk. In this case, it looks like
it's actually passed the verification. You're probably using a very
very old version of the btrfs tools, too -- there's a Debian package
of them from November, which is OK. A newer version of btrfsck _may_
report more errors, but I wouldn't bank on it (it's not had a great
deal of attention).

> kernel output
> 
> [11138.535482] device fsid 808bddf9-a2c5-4121-814f-ebbf4ec7d50c devid 1
> transid 11368 /dev/vda1
> [11276.469967] ------------[ cut here ]------------
> [11276.469980] WARNING: at
> /build/buildd/linux-3.0.0/fs/btrfs/extent-tree.c:5693
> use_block_rsv+0xc0/0x170 [btrfs]()
> [11276.469982] Hardware name: Bochs
> [11276.469983] Modules linked in: btrfs zlib_deflate libcrc32c nls_utf8
> isofs rfcomm bnep bluetooth parport_pc ppdev dm_crypt joydev binfmt_misc
> psmouse serio_raw i2c_piix4 lp parport usbhid hid virtio_net virtio_blk
> floppy virtio_pci virtio_ring virtio
> [11276.469999] Pid: 2160, comm: mount Not tainted 3.0.0-13-generic
> #22-Ubuntu
> [11276.470001] Call Trace:
> [11276.470016]  [<ffffffff8105e8af>] warn_slowpath_common+0x7f/0xc0
> [11276.470019]  [<ffffffff8105e90a>] warn_slowpath_null+0x1a/0x20
> [11276.470025]  [<ffffffffa014bc40>] use_block_rsv+0xc0/0x170 [btrfs]
> [11276.470031]  [<ffffffffa0154e7d>] btrfs_alloc_free_block+0x3d/0x200
> [btrfs]
> [11276.470040]  [<ffffffffa017ca55>] ? btrfs_key_blockptr+0xe5/0xf0
> [btrfs]
> [11276.470045]  [<ffffffffa014277c>] __btrfs_cow_block+0x14c/0x5b0 [btrfs]
> [11276.470050]  [<ffffffffa0142cf3>] btrfs_cow_block+0x113/0x260 [btrfs]
> [11276.470053]  [<ffffffff815ea3de>] ? _raw_spin_lock+0xe/0x20
> [11276.470058]  [<ffffffffa0147751>] btrfs_search_slot+0x2b1/0x550 [btrfs]
> [11276.470064]  [<ffffffffa014d829>]
> lookup_inline_extent_backref+0x89/0x450 [btrfs]
> [11276.470069]  [<ffffffffa014e1b0>] lookup_extent_backref+0x60/0xf0
> [btrfs]
> [11276.470074]  [<ffffffffa014f62f>] __btrfs_free_extent+0xbf/0x650
> [btrfs]
> [11276.470079]  [<ffffffffa014fcd4>] run_delayed_tree_ref+0x114/0x1a0
> [btrfs]
> [11276.470085]  [<ffffffffa015281e>] run_one_delayed_ref+0xae/0xf0 [btrfs]
> [11276.470091]  [<ffffffffa0152934>] run_clustered_refs+0xd4/0x240 [btrfs]
> [11276.470096]  [<ffffffffa0152b6a>] btrfs_run_delayed_refs+0xca/0x220
> [btrfs]
> [11276.470103]  [<ffffffffa0164105>] __btrfs_end_transaction+0x85/0x320
> [btrfs]
> [11276.470111]  [<ffffffffa0164415>] btrfs_end_transaction+0x15/0x20
> [btrfs]
> [11276.470121]  [<ffffffffa016e960>] btrfs_evict_inode+0x1e0/0x270 [btrfs]
> [11276.470134]  [<ffffffff81181e81>] evict+0x91/0x170
> [11276.470137]  [<ffffffff81182082>] iput_final+0xd2/0x1a0
> [11276.470139]  [<ffffffff81182188>] iput+0x38/0x50
> [11276.470145]  [<ffffffffa016ee6c>] btrfs_orphan_cleanup+0x1ec/0x360
> [btrfs]
> [11276.470151]  [<ffffffffa0161d29>] open_ctree+0x1469/0x1760 [btrfs]
> [11276.470156]  [<ffffffffa013e438>] btrfs_fill_super.isra.38+0x78/0x150
> [btrfs]
> [11276.470167]  [<ffffffff811cf501>] ? disk_name+0x61/0xc0
> [11276.470174]  [<ffffffff812efbd7>] ? strlcpy+0x47/0x60
> [11276.470179]  [<ffffffffa013f806>] btrfs_mount+0x3c6/0x470 [btrfs]
> [11276.470182]  [<ffffffff8116ae13>] mount_fs+0x43/0x1b0
> [11276.470186]  [<ffffffff8118565a>] vfs_kern_mount+0x6a/0xc0
> [11276.470188]  [<ffffffff81186a54>] do_kern_mount+0x54/0x110
> [11276.470190]  [<ffffffff811884f4>] do_mount+0x1a4/0x260
> [11276.470192]  [<ffffffff81188990>] sys_mount+0x90/0xe0
> [11276.470196]  [<ffffffff815f27c2>] system_call_fastpath+0x16/0x1b
> [11276.470197] ---[ end trace eeca3fbe2d1be463 ]---

   It's not obvious (without me digging into the 2.6.32 code, which
I'm not going to do) which tree this is failing in, but if -o recovery
doesn't work, you could try using btrfs-zero-log on the FS. That _may_
help.

   Failing that, there's the restore tool in the btrfs-progs git repo,
which has a good track record for allowing people to copy data off
broken filesystems.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- It's against my programming to impersonate a deity! ---       

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPLt81IKyzvlFcI40RAgALAKDXWOWB7m3vPUJcjao+C+hnKH7GbACePfU0
pKf3+c+e3F0x5R/9OkTzPhc=
=r8GT
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
