Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:58152 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbK0Fkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 00:40:31 -0500
Date: Fri, 27 Nov 2015 10:40:28 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Lukas Pirl <btrfs@lukas-pirl.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: implications of mixed mode
Message-ID: <20151127104028.4eb793ba@natsu>
In-Reply-To: <5657BE2B.10209@cn.fujitsu.com>
References: <56579BD1.4030401@lukas-pirl.de>
	<5657BE2B.10209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PgnMZOL865.ScKPeSVDzBhZ"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/PgnMZOL865.ScKPeSVDzBhZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Nov 2015 10:21:31 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> And some extra pros and cons due to fixed(4K) small(compared to 16K=20
> default) nodesize:
>=20
> + A little higher performance
>    node/leaf size is restricted to sectorsize, smaller node/leaf,
>    smaller range to lock.
>    In our SSD test, operations with high concurrency, the performance is
>    overall 10% better than 16K nodesize.
>    And in extreme metadata operation case, like high concurrency on
>    sequence write into small files, it can be 8 times the performance of
>    default 16K nodesize.

This is surprising to read, as I thought 16K is generally faster and that's
why the default value was changed to it from 4K.

https://oss.oracle.com/~mason/blocksizes/
https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?=
id=3Dc652e4efb8e2dd76ef1627d8cd649c6af5905902

Seems like the 16K size prevents fragmentation, but since your SSDs do not =
care
much about fragmentation, that's not adding a benefit for them.

--=20
With respect,
Roman

--Sig_/PgnMZOL865.ScKPeSVDzBhZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZX7MwACgkQTLKSvz+PZwg3GwCfQE0tWnolT7qAO4nB9vVgznbx
x28AoI3Ivbsw+xB3ZZDkBa9nNznlhldU
=fCTb
-----END PGP SIGNATURE-----

--Sig_/PgnMZOL865.ScKPeSVDzBhZ--
