From: Phillip Susi <psusi@cfl.rr.com>
Subject: understanding the tree-log
Date: Thu, 03 Nov 2011 23:21:16 -0400
Message-ID: <4EB35A2C.8060708@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Given how a transaction is committed, why is there a tree-log?  When
modifying the tree, either the super block is still pointing to the
old tree root, or the new generation has been fully committed, so how
can there ever be an intermediate state that needs a log to recover?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6zWiwACgkQJ4UciIs+XuK+FQCfTnTIu8iYgW38Qk3YoZ4KjA/9
uhwAnjOH36EkQ1EhoUdWg7OJr+0L0lbA
=7DUz
-----END PGP SIGNATURE-----
