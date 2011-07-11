From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: last_index variable in btrfs_buffered_write function
Date: Mon, 11 Jul 2011 17:56:25 +0100
Message-ID: <28FB38ED-FC82-4EAD-BED8-330C8FA9AF83@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-13--763780003"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-13--763780003
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1

Hello.

Am I reading the code the wrong way, or is the 'last_index' variable in =
'__btrfs_buffered_write()' (and previously used in =
'btrfs_file_aio_write()') irrelevant?=20

It appears to just be used in 'prepare_pages()', passed as an argument, =
but never actually used by this function.

Furthermore, I'm not sure what is intended with this variable, but if =
the idea is to assign it with the  last page in the range, then I would =
say that instead of

> last_index =3D (pos + iov_iter_count(i)) >> PAGE_CACHE_SHIFT;

it should be

>  last_index =3D (pos + iov_iter_count(i) - 1) >> PAGE_CACHE_SHIFT;

Then again, I may be missing something.

Cheers.

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20






--Apple-Mail-13--763780003
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJOGys5AAoJEJ9vvxhHfCblc8EH/iVUdtzdxolmdu+B3MoMlAdM
hCWfklFIdgfU+DfHMXUp3VcbnAiAPE9i0LTVr8/TjkoZMtdlQ56wnvxcW7KUoPVa
clFq3vX0o27NSbT6lmBkWqPv8Zsq79YxqD5YjcZenDFGbk7t32U+EVhhgaJkje29
pQwyXSl9/Qsnbmsmv0Z6hf/x5kCKDp0EKMyRN1klEAncH5P5VAI2YJf3tV2h173V
anLeCnvdR0jmJq3oeQz1Nok6CJMF/WS3ANo122R7Mc3O/BTUPVJj98B40IB+tEKx
NAjOjGv4ao0oAiIuYC0QqN0sGmVbqy7MrzNSnFZwijKAisHA1tT77Sp4XPUfR/M=
=pvEr
-----END PGP SIGNATURE-----

--Apple-Mail-13--763780003--
