From: Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: [PULL] Btrfs error handling v4
Date: Mon, 24 Oct 2011 17:51:33 -0400
Message-ID: <4EA5DDE5.9030700@jeffreymahoney.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi David -

Please pull from git://git.jeffreymahoney.com/linux/btrfs-unstable
for-david.

It contains the previously integrated v3 error handling patch with an
updated ("btrfs: clear_extent_bit error push-up") commit that resets
the return value in btrfs_direct_IO.

This branch is built on the base of the integration branch you sent me
previously. If it needs updating, let me know.

- -Jeff

- -- 
Jeff Mahoney
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6l3eUACgkQLPWxlyuTD7L/aQCcC7lo+p5lv8Grfb1GcIPL9GlA
hsoAoIFKFr3+gn8SfGOdnWd00fREmYcO
=ekcX
-----END PGP SIGNATURE-----
