Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:41778 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbJEIvE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 04:51:04 -0400
Date: Mon, 5 Oct 2015 13:51:01 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Erkki Seppala <flux-btrfs@inside.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
Message-ID: <20151005135101.3b65065c@natsu>
In-Reply-To: <m498u7hd7tl.fsf@coffee.modeemi.fi>
References: <55F88ECC.1040604@menke.ac>
	<201510021421.09558.russell@coker.com.au>
	<560E737C.7050206@gmail.com>
	<201510031832.17802.russell@coker.com.au>
	<pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
	<56111598.2080403@bouton.name>
	<m498u7hd7tl.fsf@coffee.modeemi.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J5mHOuh7=ElYsMKdPTqijVK"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/J5mHOuh7=ElYsMKdPTqijVK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Oct 2015 11:43:18 +0300
Erkki Seppala <flux-btrfs@inside.org> wrote:

> Lionel Bouton <lionel-subscription@bouton.name> writes:
>=20
> > 1/ AFAIK the kernel md RAID1 code behaves the same (last time I checked
> > you need 2 processes to read from 2 devices at once) and I've never seen
> > anyone arguing that the current md code is unstable.
>=20
> This indeed seems to be the case on my MD RAID1 HDD.

The key difference is that MD is smart enough to distribute reads to the le=
ast
loaded devices in a RAID (i.e. two processes reading from a two-HDD RAID1 w=
ill
~always use different HDDs, no matter what their PIDs are).

Another example of the differences was that in my limited testing I saw Btr=
fs
submit writes sequentially on RAID1: according to 'iostat', there were long
periods of only one drive writing, and then only the other one. The result =
was
the RAID's write performance ended up being lower than that of a single dri=
ve.

--=20
With respect,
Roman

--Sig_/J5mHOuh7=ElYsMKdPTqijVK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlYSOfUACgkQTLKSvz+PZwhxlQCcCthQDV2/cqBx+pYqh1X+UsgN
CQAAoJfBx7SiatJZTnAMi0nQ/umumu5I
=teow
-----END PGP SIGNATURE-----

--Sig_/J5mHOuh7=ElYsMKdPTqijVK--
