Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:56062 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932914AbcI0CRF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 22:17:05 -0400
Date: Tue, 27 Sep 2016 07:16:56 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Ruben Salzgeber <ruben.salzgeber@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: OS X Time Machine and BTRFS
Message-ID: <20160927071656.51ef5ef0@natsu>
In-Reply-To: <CAJCQCtQvaJM-kkP12KRdNpMLAJYcJdi8Fm2b3GgE=Fqm2sUEjg@mail.gmail.com>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
        <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
        <CAJCQCtQvaJM-kkP12KRdNpMLAJYcJdi8Fm2b3GgE=Fqm2sUEjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NE+cbAVm9sfG8orXxu=94=1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/NE+cbAVm9sfG8orXxu=94=1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Sep 2016 15:06:39 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> First question is if the directory containing the sparsebundle file
> has xattr +C set on it?

It's not xattr, but chattr. "xattr" manages "extended attributes", i.e.
arbitrary name=3Dvalue pairs you can set on a file or directory. But +C is =
just
one of the standard ones.

--=20
With respect,
Roman

--Sig_/NE+cbAVm9sfG8orXxu=94=1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfp1pwACgkQTLKSvz+PZwhxkgCeNZAxjm8YJU+aqfdVmDCf94G4
0xsAoIqLiK4Wu3qkeK/0Jwi+G/Y5fHFi
=qSuM
-----END PGP SIGNATURE-----

--Sig_/NE+cbAVm9sfG8orXxu=94=1--
