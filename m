From: Phillip Susi <psusi@cfl.rr.com>
Subject: Where's the superblock allocation?
Date: Wed, 26 Oct 2011 18:30:48 -0400
Message-ID: <4EA88A18.3040508@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

After a fresh mkfs.btrfs, I'm trying to understand the data structures,
and I'm a little confused about what keeps the boot sector from being
allocated to a file.

According to the device tree, the first 4mb of the disk are mapped
directly to the first 4mb of the chunk space:

item 0 key (1 DEV_EXTENT 0) itemoff 3947 itemsize 48
	dev extent chunk_tree 3
	chunk objectid 256 chunk offset 0 length 4194304

And the chunk tree seems to agree:

item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 3817 itemsize 80
	chunk length 4194304 owner 2 type 2 num_stripes 1
		stripe 0 devid 1 offset 0

But the only entry I find in the extent tree for offset 0 is:

item 0 key (0 BLOCK_GROUP_ITEM 4194304) itemoff 3971 itemsize 24
	block group used 0 chunk_objectid 256 flags 2

So it appears that the first 4mb of the disk are part of a block group,
and up for allocation whenever needed.  Why isn't there an entry in the
extent tree marking the first few kb as reserved for the superblock, or
alternatively, the chunk map starting at a non zero disk offset?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6oihUACgkQJ4UciIs+XuJ0EwCfYrWbAQRy7BP2Ogmvrn/pBW0y
D/wAnibm4TqPV1PyqLi2H0Vain1ftW5Q
=miI9
-----END PGP SIGNATURE-----
