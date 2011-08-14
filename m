From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: unlink directory with files (rm -d)
Date: Sun, 14 Aug 2011 11:03:04 +0300
Message-ID: <20110814110304.1537a2a3@sf.home>
References: <CAJ1PRS=9obyg-FRq=V6pZ7J=tccYA_UXWvNzF-6SaywL6rBY9g@mail.gmail.com>
	<CAJ1PRSnJHJ+fEgYRv3xN+3hzcvtreNZrnqJUszmoK8YjVCn4VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MYc7gzHk/__y=j3bPgINXpl"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSnJHJ+fEgYRv3xN+3hzcvtreNZrnqJUszmoK8YjVCn4VA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/MYc7gzHk/__y=j3bPgINXpl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> I wonder if it would be possible to implement instant unlinking
> directory with files in it. Since btrfs is based on b trees it could
> be possible. Filesystem would have to "loose" all information on
> directory and object in it, and allow overwriting this information.
> This would be great feature, because everyone knows that recursive
> deleting large directories, with milions of files require huge io
> traffic.

I think you'll have to read directory contents anyway in order not
to break permission/vfs-mountpoint/attributes violation.

Consider the following example:

# it's me
$ id
uid=3D1000(slyfox) gid=3D100(users)

# fun layout
$ ls -ld test test/root_o test/root_o/root_o=20
drwxr-xr-x 3 slyfox users 60 Aug 14 10:56 test
drwxr-xr-x 2 root   root  60 Aug 14 10:56 test/root_o
-rw-r--r-- 1 root   root   0 Aug 14 10:56 test/root_o/root_o

$ rm -rf test/
rm: cannot remove `test/root_o/root_o': Permission denied

We can't delete it because of foreigner in our dir.

--=20

  Sergei

--Sig_/MYc7gzHk/__y=j3bPgINXpl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5HgUAACgkQcaHudmEf86pfUgCfaDKZuCAY04e1QouOrkPVZMPC
6vYAn2TZK3NG9r/ZOCkRDgh1UvyWMnEu
=ns0A
-----END PGP SIGNATURE-----

--Sig_/MYc7gzHk/__y=j3bPgINXpl--
