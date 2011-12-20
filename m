From: Dave <dave@thekilempire.com>
Subject: COW a file from snapshot
Date: Tue, 20 Dec 2011 10:07:18 -0500
Message-ID: <20111220150717.GA24891@hendrix.borisch.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

So I've got a daily snapshot of my /home subvolume.  Due to a fat finger, I've
damaged a rather large file so I'd like to pull if from one of these snapshot
backups.  I don't want to simply copy the file since it's many gigs and cp
- --reflink=always doesn't work (produces the error Invalid cross-device link).
Is there a way to recover that file and benefit from COW?
- -- 
- -=[dave]=-

Entropy isn't what it used to be.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iF4EAREIAAYFAk7wpKUACgkQXM0u5ajNnCgMUQD/Uf0/HygZ9D8StT9Oc6E3+wM/
MBokh6h1iPN2OslJTxgA/RUzFMM2n0+3ORHwvOraJMBJl1P4JfabT31iuemn/BL2
=2cds
-----END PGP SIGNATURE-----
