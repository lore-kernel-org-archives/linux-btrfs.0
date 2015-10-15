Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:37828 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbJOFZG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 01:25:06 -0400
Date: Thu, 15 Oct 2015 10:25:02 +0500
From: Roman Mamedov <rm@romanrm.net>
To: audio muze <audiomuze@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS raid 5/6 status
Message-ID: <20151015102502.5d0b4353@natsu>
In-Reply-To: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
References: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TwF.WCx=uaGk/NC=BmQyc7u"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/TwF.WCx=uaGk/NC=BmQyc7u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Oct 2015 06:11:49 +0200
audio muze <audiomuze@gmail.com> wrote:

> Before I go down this road I'd appreciate thoughts/ suggestions/
> alternatives?  Have I left anything out?  Most importantly is btrfs
> raid6 now stable enough to use in this fashion?

I would suggest going with Btrfs on top of mdadm RAID6, Btrfs still does ha=
ve
a number of "you what"-grade showstoppers in its native multi-device modes,
but a single device mode Btrfs (on top of some other multi-device system su=
ch
as Linux software RAID and/or LVM) in my experience works very well.

--=20
With respect,
Roman

--Sig_/TwF.WCx=uaGk/NC=BmQyc7u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlYfOK4ACgkQTLKSvz+PZwgE4QCcCfnby/f0hLStMwSMAJClPJCq
naAAn1wRomEz+MKd+v3nm+OnS1Al6BCG
=RLA5
-----END PGP SIGNATURE-----

--Sig_/TwF.WCx=uaGk/NC=BmQyc7u--
