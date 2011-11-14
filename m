From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 00/21] [RFC] Btrfs: restriper
Date: Mon, 14 Nov 2011 18:59:14 -0500
Message-ID: <4EC1AB52.2070805@cfl.rr.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have a fs that started with the default policy of metadata=dup.  I
added a second device and rebalanced, and so the metadata chunks were
converted to raid1.  Now I can not remove the second device because
raid1 requires at least two devices.

If I understand this patch series correctly, I can use it to manually
convert those raid1 chunks back to dup, and then remove the second
device.  It occurs to me though, that in the restripe process, the
newly created dup chunks can be allocated from either disk still, and
any that are allocated on the second disk will then need to be
relocated in order to remove that disk.  This seems inefficient, so I
was wondering if there is a way to make sure that during the restripe,
only the disk I intend to keep is allocated from to create the dup
chunks, and thus avoid the need to relocate when I remove the second disk?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7Bq0wACgkQJ4UciIs+XuLoUACeMkb4Pd0zshDDKmVzibYtxmvX
GewAnAwKcsCaCaAX2XK6oMWxK6FvZQFc
=UxDl
-----END PGP SIGNATURE-----
