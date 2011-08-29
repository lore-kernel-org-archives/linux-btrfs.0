From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Mon, 29 Aug 2011 06:34:16 +0300
Message-ID: <20110829063416.00f4652c@sf>
References: <20110817185619.4660.78543.stgit@localhost6>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+OetoMhad/VLD00Ny73_Yol"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110817185619.4660.78543.stgit@localhost6>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/+OetoMhad/VLD00Ny73_Yol
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Aug 2011 22:56:19 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> iput() shouldn't be called for inodes in I_NEW state,
> lets call __destroy_inode() and btrfs_destroy_inode() instead

Hi Konstantin!

Running 'sync' program after the load does not finish and eats 100%CPU
busy-waiting for something in kernel.

It's easy to reproduce hang with patch for me. I just run liferea and sync
after it. Without patch I haven't managed to hang btrfs up.

--=20

  Sergei

--Sig_/+OetoMhad/VLD00Ny73_Yol
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5bCL4ACgkQcaHudmEf86rBtQCeNQafNwpLMrLFMVd2pr9+v6/q
l8UAnjJHg1CC+mL4BaSoNeCx+sRaj5ES
=u2d3
-----END PGP SIGNATURE-----

--Sig_/+OetoMhad/VLD00Ny73_Yol--
