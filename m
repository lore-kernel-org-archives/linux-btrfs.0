Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:33917 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbeHTPzB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 11:55:01 -0400
Subject: Re: Are the btrfs mount options inconsistent?
To: David Howells <dhowells@redhat.com>, dsterba@suse.cz
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, wqu@suse.de
References: <20180816130515.GR24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <32208.1534767847@warthog.procyon.org.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
Date: Mon, 20 Aug 2018 20:39:14 +0800
MIME-Version: 1.0
In-Reply-To: <32208.1534767847@warthog.procyon.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WLoU1qKVgdxsKLkgONQAyJYXAvfy7svIl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WLoU1qKVgdxsKLkgONQAyJYXAvfy7svIl
Content-Type: multipart/mixed; boundary="JqaZ5CcLn0Ma0YraNWjv9OZ8lsMHFIYd6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Howells <dhowells@redhat.com>, dsterba@suse.cz
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, wqu@suse.de
Message-ID: <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
Subject: Re: Are the btrfs mount options inconsistent?
References: <20180816130515.GR24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <32208.1534767847@warthog.procyon.org.uk>
In-Reply-To: <32208.1534767847@warthog.procyon.org.uk>

--JqaZ5CcLn0Ma0YraNWjv9OZ8lsMHFIYd6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/20 =E4=B8=8B=E5=8D=888:24, David Howells wrote:
> David Sterba <dsterba@suse.cz> wrote:
>=20
>> No it's not. Compression needs the checksums so nodatasum should disab=
le
>> compression, which is missing as you found out.
>=20
> Thanks.
>=20
> Btw, do fs_info->mount_opt end up inscribed on disk as is?  I don't see=

> anywhere this obviously happens.

mount_opt should only reflects runtime mount options, and currently
there is no way to store mount option on-disk.

>=20
> Can I get rid of BTRFS_MOUNT_NOSSD as it would appear to be superfluous=
 with
> BTRFS_MOUNT_SSD?

As you already found.

But to be more clear, NOSSD shouldn't be a special case.
In fact currently NOSSD only affects whether we will output the message
"enabling ssd optimization", no real effect if I didn't miss anything.

So the the states should be only 3: nossd, ssd, ssd + ssd_spread.

Thanks,
Qu


>=20
> David
>=20


--JqaZ5CcLn0Ma0YraNWjv9OZ8lsMHFIYd6--

--WLoU1qKVgdxsKLkgONQAyJYXAvfy7svIl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt6tnIACgkQwj2R86El
/qgXfwf/XZKvhpNn+8cuV/q2aht7s3AO0ttVmGwhC08Dy5g3IffYM8uZVXp3FQ3t
/VgjCifSXVstGtmoVHIg5nF1ZtDlzTE3I0ZiAkfzV7m1StF9kSshNGZbBCCpT4PA
QnkcaEANlAcU7Q6Cdr2jmzE+pjfBOxs6jto+tlHAUUY9I0Z0eXvWcAPXO4Y2o0yC
eD95jTTjDNWzeQ5sL9dHw8b/uPmpSZv1HCtZ4gkPYukOUloA2fwMClw5O7c4ZMIq
qH6GXc4eJAkdVGHVLuVMKYz03QHut9yztCLo3SpI8akkbQHY40MB0BZ7OePZflR6
7rSo49JxyqQ6Ti8pF6cp3Aqxe5Qu0w==
=zyTs
-----END PGP SIGNATURE-----

--WLoU1qKVgdxsKLkgONQAyJYXAvfy7svIl--
