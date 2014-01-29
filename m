Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:48641 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbaA2PIz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 10:08:55 -0500
Date: Wed, 29 Jan 2014 21:02:13 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS corrupted by combination of mistreatment of hiberantion
 and accidental power loss.
Message-ID: <20140129210213.34848eff@natsu>
In-Reply-To: <52E91535.8090306@statystyka.net>
References: <52E91535.8090306@statystyka.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Z0Qwl=XLMozmW9GXgpu2sri"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Z0Qwl=XLMozmW9GXgpu2sri
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jan 2014 15:50:29 +0100
Adam Ryczkowski <adam.ryczkowski@statystyka.net> wrote:

> I have two independent Linux installations my notebook, both sharing the=
=20
> same btrfs partition as root file system

!!!

> 1) I accidentally ran the other system, which wasn't hibernated

!!!!!

> Ubuntu=20
> 12.10. Realizing the problem, I waited until the system booted up, and=20
> then shutdowned it.

You were already screwed at this point. The following power-down is
irrelevant, and this is not a BTRFS-specific issue either.

What you did was kind of like plugging a HDD into one computer, then at the
same time plugging it into another one (let's imagine this would be possibl=
e)
then "waiting until the system booted up" at the second one, shutting it do=
wn,
then expecting the 1st computer doesn't notice a thing. But then again from
your initial post I wonder will you realize why such imagined scenario would
cause any problem.

--=20
With respect,
Roman

--Sig_/Z0Qwl=XLMozmW9GXgpu2sri
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLpF/UACgkQTLKSvz+PZwjRrQCeMZVh3HPmjGRLslAafUX7dX2H
Lp4An1ViIT6BuMAVpLuXulsjabitBE2u
=bKH/
-----END PGP SIGNATURE-----

--Sig_/Z0Qwl=XLMozmW9GXgpu2sri--
