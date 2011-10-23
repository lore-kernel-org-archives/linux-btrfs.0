From: Phillip Susi <psusi@cfl.rr.com>
Subject: Subvolume level allocation policy
Date: Sun, 23 Oct 2011 14:50:50 -0400
Message-ID: <4EA4620A.3060702@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Is it ( yet? ) possible to manipulate the allocation policy on a
subvolume level instead of the fs level?  For example, to make / use
raid1, and /home use raid0?  Or to have / allocated from an ssd and
/home allocated from the giant 2tb hd.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6kYgYACgkQJ4UciIs+XuISPQCglUtPmg4GMrrY53Fkafk2fkcA
E84AoMAZXBha/fDrk6moMKPzbMYEtLci
=BIdX
-----END PGP SIGNATURE-----
