Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:45258 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401AbcCPJBR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 05:01:17 -0400
Date: Wed, 16 Mar 2016 14:01:09 +0500
From: Roman Mamedov <rm@romanrm.net>
To: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
Message-ID: <20160316140109.3497dfa6@natsu>
In-Reply-To: <CABXGCsOVeEBn9A=Wj6VtAEsban6LKj6B958gN8JqK9omLjDt9A@mail.gmail.com>
References: <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
	<CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
	<CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
	<CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
	<20160211191741.GA4762@localhost.localdomain>
	<CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
	<20160212032226.GA10542@localhost.localdomain>
	<CABXGCsNjHq4M8TBibeWQLyK+Of0cu++P3QQ=+e=TUuZjaPMLtA@mail.gmail.com>
	<20160212203426.GA24399@localhost.localdomain>
	<CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
	<20160214213224.GB28882@localhost.localdomain>
	<20160215034219.2f0df0ce@natsu>
	<CABXGCsOVeEBn9A=Wj6VtAEsban6LKj6B958gN8JqK9omLjDt9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/3xaYW.e5xr_OEbUqBiXH=ku"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/3xaYW.e5xr_OEbUqBiXH=ku
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Mar 2016 09:18:14 +0500
=D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB =D0=93=D0=B0=D0=B2=D1=80=D0=B8=D0=BB=
=D0=BE=D0=B2 <mikhail.v.gavrilov@gmail.com> wrote:

> Yesterday btrfs again hangs on kernel 4.4.5
> It's the same or another problem?

Seems different to me, as there's also defrag involved. Try removing and not
using the defrag mount option.

> This messages say that restore failed?

So you can't mount the FS anymore? Did you try btrfsck, what does it report?

--=20
With respect,
Roman

--Sig_/3xaYW.e5xr_OEbUqBiXH=ku
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbpINcACgkQTLKSvz+PZwjXDwCePM3qwLWAPgFoaaGFL5olOhAV
zsIAn14DWY6yINYrm12q5ZEVboa1yPsY
=08qW
-----END PGP SIGNATURE-----

--Sig_/3xaYW.e5xr_OEbUqBiXH=ku--
