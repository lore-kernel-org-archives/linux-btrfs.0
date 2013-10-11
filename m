Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:39502 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab3JKJqo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 05:46:44 -0400
Date: Fri, 11 Oct 2013 15:35:46 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH] Btrfs: disallow 'btrfs {balance,replace} cancel' on ro
 mounts
Message-ID: <20131011153546.424d69c4@natsu>
In-Reply-To: <5257C378.1060507@giantdisaster.de>
References: <1381426821-31981-1-git-send-email-idryomov@gmail.com>
	<525750B4.4090009@cn.fujitsu.com>
	<5257C378.1060507@giantdisaster.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a=xTavhI_d0YcsKCp2tvekr"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/a=xTavhI_d0YcsKCp2tvekr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Oct 2013 11:23:04 +0200
Stefan Behrens <sbehrens@giantdisaster.de> wrote:

> On Fri, 11 Oct 2013 09:13:24 +0800, Wang Shilong wrote:
> > On 10/11/2013 01:40 AM, Ilya Dryomov wrote:
> >=20
> > I have a question in my mind.
> >=20
> > Can we reach a state that there is operation in progress when filesystem
> > has been readonly?If we do cancel operations on a ro filesystem, we sho=
uld
> > get "No operations in progress" .
>=20
> Well, it's arguable what ro means. No write to the devices at all?

If I had an FS image and mounted it as -o loop,ro I'd simply expect md5sum =
of
that image to match before mount and after unmount, i.e. no writes at all.
Really, how can one argue with what "read only" means? If it will mean
something else than a complete absence of writes, then how can we mount
devices or FS images to do forensics, etc? Or do a recovery from a difficult
corruption or try to debug an FS crash.

--=20
With respect,
Roman

--Sig_/a=xTavhI_d0YcsKCp2tvekr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJXxnIACgkQTLKSvz+PZwg4ZACgiDQQdMPxW5Pf3ZT2xg5PsnmY
qSEAn2uM8PRNFO0zny2jzsQi2zMUJ6K+
=oSei
-----END PGP SIGNATURE-----

--Sig_/a=xTavhI_d0YcsKCp2tvekr--
