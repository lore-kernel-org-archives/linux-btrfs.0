Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:38048 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab3BENq2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Feb 2013 08:46:28 -0500
Date: Tue, 5 Feb 2013 19:46:23 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
Message-ID: <20130205194623.07a9bcfd@natsu>
In-Reply-To: <5110DC02.4030409@gmail.com>
References: <50F3E77B.2030901@gmail.com>
	<20130114145904.GA1387@shiny>
	<50F422BC.4000901@gmail.com>
	<20130114155718.GC1387@shiny>
	<50F43319.9040009@gmail.com>
	<20130114163433.GD1387@shiny>
	<50F5E6FA.60803@gmail.com>
	<50F6712F.3070408@itwm.fraunhofer.de>
	<5110DC02.4030409@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VcPE.PqaSOjYL1hK=uy6X.e"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/VcPE.PqaSOjYL1hK=uy6X.e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Feb 2013 10:16:34 +0000
Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:

> that I was using one of those fantastic pci 4 port ethernet cards and=20
> printer was directly to it - after moving it and everything else to=20
> switch all problem and issues have went away. AT the moment I'm running=20
> server for 2 weeks without any corruptions, any random kernel btrfs=20
> crashes etc.

If moving the printer over to a switch helped, perhaps it is indeed an
electrical interference problem, but if your card is an old one from Sun, k=
eep
in mind that they also have some problems with DMA on machines with large
amounts of RAM:

  "sunhme" experiences corrupt packets if machine has more than 2GB of memo=
ry
  https://bugzilla.kernel.org/show_bug.cgi?id=3D10790

Not hard to envision a horror story scenario where a rogue network card wou=
ld
shred your filesystem buffer cache with network packets DMAed all over it,
like bullets from a machine gun :) But in reality afaik IOMMU is supposed to
protect against this.

--=20
With respect,
Roman

--Sig_/VcPE.PqaSOjYL1hK=uy6X.e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlERDS8ACgkQTLKSvz+PZwjL8QCfTO5/QtiYFb+cStWRJ4Pnw5ZR
+dEAn1EpcA1O4gH+dEFsrxqMvbbVwoA0
=obRG
-----END PGP SIGNATURE-----

--Sig_/VcPE.PqaSOjYL1hK=uy6X.e--
