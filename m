Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:37773 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaFVOLr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 10:11:47 -0400
Date: Sun, 22 Jun 2014 20:11:40 +0600
From: Roman Mamedov <rm@romanrm.net>
To: george@chinilu.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on whole disk (no partitions)
Message-ID: <20140622201140.08e74b7e@natsu>
In-Reply-To: <53A6DDAD.8070804@chinilu.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<53A6DDAD.8070804@chinilu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LLNwQjQ_BMneA.DhbC22Sd8"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LLNwQjQ_BMneA.DhbC22Sd8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Jun 2014 06:44:13 -0700
George Mitchell <george@chinilu.com> wrote:

> On 06/22/2014 12:49 AM, Imran Geriskovan wrote:
> >> The 64KB Btrfs bootloader pad is 8 sector aligned, so for 512e AF disks
> >> there's no problem formatting the whole drive. The alignment problem
> >> actually happens when partitioning it, using old partition tools that =
don't
> >> align on 8 sector boundaries. There are some such tools still floating
> >> around.
> > A 'somewhat' related question:
> >
> > So called Advanced Format drives has 4K physical sector size,
> > however they report 512B logical sector size.
> >
> > How does linux kernel access those drives?
> > 512B or 4K at a time?
>
> This is a problem related to Western Digital drives.  They lie in order=20
> to be compatible with older versions of Windows.

Wake up and smell the coffee.

Device Model:     HGST HTE725050A7E630
Sector Sizes:     512 bytes logical, 4096 bytes physical


Device Model:     TOSHIBA DT01ACA050
Sector Sizes:     512 bytes logical, 4096 bytes physical


The "AF" standard as accepted by the industry does include this "lying", and
it's not just WD doing this by any stretch of the imagination. Aside from
USB-only drives (which lack the ability to be plugged into SATA), no one can
afford to produce and  a drive incompatible with Windows these days. In fact
I'd be glad if you could support your Seagate 4K claim by any model names a=
nd
their smartctl output.

--=20
With respect,
Roman

--Sig_/LLNwQjQ_BMneA.DhbC22Sd8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOm5BwACgkQTLKSvz+PZwgJ7gCgmJc8QsbSEJHfdbm7QH/wSszc
Uv8An0acgu3Zwrn98BxeWxn4sWReHdqe
=RShf
-----END PGP SIGNATURE-----

--Sig_/LLNwQjQ_BMneA.DhbC22Sd8--
