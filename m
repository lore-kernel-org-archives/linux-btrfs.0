Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:48914 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752746AbcIOICU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 04:02:20 -0400
Date: Thu, 15 Sep 2016 13:02:13 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: 4.4.0 - no space left with >1.7 TB free space left
Message-ID: <20160915130213.1734d462@natsu>
In-Reply-To: <20160408165332.450659c4@natsu>
References: <0c19f800da3013f22f2ab0d77d5a9efb@admin.virtall.com>
        <20160208162410.58cb2b4a@natsu>
        <eaeffce90cd04fa5b91284ca580b5969@admin.virtall.com>
        <20160408165332.450659c4@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/B5djnWnQpWuyRwb7jCnannb"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/B5djnWnQpWuyRwb7jCnannb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Apr 2016 16:53:32 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> On Fri, 08 Apr 2016 20:36:26 +0900
> Tomasz Chmielewski <tch@virtall.com> wrote:
>=20
> > On 2016-02-08 20:24, Roman Mamedov wrote:
> >=20
> > >> Linux 4.4.0 - btrfs is mainly used to host lots of test containers,
> > >> often snapshots, and at times, there is heavy IO in many of them for
> > >> extended periods of time. btrfs is on HDDs.
> > >>=20
> > >>=20
> > >> Every few days I'm getting "no space left" in a container running=20
> > >> mongo
> > >> 3.2.1 database. Interestingly, haven't seen this issue in containers
> > >> with MySQL. All databases have chattr +C set on their directories.
> > >=20
> > > Hello,
> > >=20
> > > Do you snapshot the parent subvolume which holds the databases? Can y=
ou
> > > correlate that perhaps ENOSPC occurs at the time of snapshotting? If=
=20
> > > yes, then
> > > you should try the patch https://patchwork.kernel.org/patch/7967161/
> > >=20
> > > (Too bad this was not included into 4.4.1.)
> >=20
> > By the way - was it included in any later kernel? I'm running 4.4.5 on=
=20
> > that server, but still hitting the same issue.
>=20
> It's not in 4.4.6 either. I don't know why it doesn't get included, or wh=
at
> we need to do. Last time I asked, it was queued:
> http://www.spinics.net/lists/linux-btrfs/msg52478.html
> But maybe that meant 4.5 or 4.6 only? While the bug is affecting people on
> 4.4.x today.

This got applied now in 4.4.21, thanks.

--=20
With respect,
Roman

--Sig_/B5djnWnQpWuyRwb7jCnannb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfaVYgACgkQTLKSvz+PZwjCwACff06f/0P/5tVPW0g09hRw303R
rfwAoI0dZn6kkchHxh2vMnbLfVnlkuRQ
=NvsG
-----END PGP SIGNATURE-----

--Sig_/B5djnWnQpWuyRwb7jCnannb--
