Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34261 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942093AbcJSRLb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 13:11:31 -0400
Received: by mail-lf0-f53.google.com with SMTP id b81so34021080lfe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 10:11:31 -0700 (PDT)
Subject: Re: Cross subvolume "cp --reflink"?
To: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <678dcd2e-13ca-0b83-6561-b7c6c10468b9@gmail.com>
 <20161019170408.GA16645@carfax.org.uk>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <247c8242-d999-b791-68df-06ab3d91e814@gmail.com>
Date: Wed, 19 Oct 2016 20:11:27 +0300
MIME-Version: 1.0
In-Reply-To: <20161019170408.GA16645@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="w1piAAG0ESEhU4SQ0MdKtXHRHhTo9pu6d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w1piAAG0ESEhU4SQ0MdKtXHRHhTo9pu6d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

19.10.2016 20:04, Hugo Mills =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Wed, Oct 19, 2016 at 07:52:14PM +0300, Andrei Borzenkov wrote:
>> I get "Failed to clone: Invalid cross-device link". Is it expected?
>> Basically this is (on openSUSE TW which has root on subvolume)
>>
>> mount -o subvol=3D/ /dev/vda1 /mnt
>> btrfs sub create /mnt/var/cache
>> cp -a --reflink=3Dalways /var/cache/* /mnt/var/cache
>>
>> Kernel 4.7.5-1-default.
>=20
>    Yes, you're trying to copy across a mountpoint boundary. This isn't
> going to work. You'll need to mount subvolid=3D0 on /mnt, and then use
> the source and target of the cp *both* from within the /mnt subtree.
>=20
>    Reflink operations (including cp --reflink=3Dalways, and the
> reflink-aware mv) work across subvol boundaries, but not mount
> boundaries.
>=20
>    Hugo.
>=20
Yes, figured that much too. Thank you!


--w1piAAG0ESEhU4SQ0MdKtXHRHhTo9pu6d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlgHqT8ACgkQR6LMutpd94zEYQCcDZNm0IH1D3tR2R+67yBLf1FG
w64AnRBaXccqPqImp13V5ntCdvAB1wLO
=WfOv
-----END PGP SIGNATURE-----

--w1piAAG0ESEhU4SQ0MdKtXHRHhTo9pu6d--
