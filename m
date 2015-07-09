Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:38239 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbGIPEn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 11:04:43 -0400
Date: Thu, 9 Jul 2015 20:04:41 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: sander@humilis.net, "Fajar A. Nugraha" <list@fajar.net>,
        james harvey <jamespharvey20@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Message-ID: <20150709200441.111e3d64@natsu>
In-Reply-To: <559E6D80.7010607@gmail.com>
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
	<CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
	<559E6411.6090109@gmail.com>
	<20150709124121.GA25033@panda>
	<559E6D80.7010607@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VwI97jRwithwgKNusth0Yx."; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/VwI97jRwithwgKNusth0Yx.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 09 Jul 2015 08:48:00 -0400
Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 2015-07-09 08:41, Sander wrote:
> > Austin S Hemmelgarn wrote (ao):
> >>> What's wrong with "btrfs subvolume snapshot"?
> >>
> >> Well, personally I would say the fact that once something is tagged as
> >> a snapshot, you can't change it to a regular subvolume without doing a
> >> non-incremental send/receive.
> >
> > A snapshot is a subvolume. There is no such thing as "tagged as a
> > snapshot".
> >
> > 	Sander
> >
> No, there is a bit in the subvolume metadata that says whether it's=20
> considered a snapshot or not.  Internally, they are handled identically,=
=20
> but it does come into play when you consider things like btrfs subvolume=
=20
> show -s (which only lists snapshots), which in turn means that certain=20
> tasks are more difficult to script robustly.

This sounds like a vestigial leftover from back when snapshots were
conceptualized to be somehow functionally different from subvolumes... But =
as
you said, now there is effectively no difference, so that bit is used for
what, only to track how a subvolume was created? And to output in the
subvolume list if the user passes "-s"? I'd say that's a pretty oddball fea=
ture
to even have, since in any case if you want to distinguish and list only yo=
ur
snapshots, you would typically just name them in a certain way, e.g.
"/snaps/originalname/<datetime>".

--=20
With respect,
Roman

--Sig_/VwI97jRwithwgKNusth0Yx.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWejYkACgkQTLKSvz+PZwgrtgCgg0Y6jBpXeiQfWGnr/7ap0Yah
QRwAoIMiw8U1He0do3XxwVXSWWggs4n5
=JaYP
-----END PGP SIGNATURE-----

--Sig_/VwI97jRwithwgKNusth0Yx.--
