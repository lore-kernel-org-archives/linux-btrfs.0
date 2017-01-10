Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:32850 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756635AbdAJQKa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 11:10:30 -0500
Date: Tue, 10 Jan 2017 16:10:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mkfs.btrfs/balance small-btrfs chunk size RFC
Message-ID: <20170110161028.GL19585@carfax.org.uk>
References: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
 <db8aff8c-44a5-f488-56de-4a9ec87e44e0@gmail.com>
 <20170110152905.GJ19585@carfax.org.uk>
 <c934f74c-6dac-b66f-13cf-eb9bf0a79aac@gmail.com>
 <20170110154753.GK19585@carfax.org.uk>
 <46721c7c-2be2-28e8-c387-4d88b6d1a09d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPDwMsyfds7q4mrK"
In-Reply-To: <46721c7c-2be2-28e8-c387-4d88b6d1a09d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZPDwMsyfds7q4mrK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 10, 2017 at 11:05:17AM -0500, Austin S. Hemmelgarn wrote:
> On 2017-01-10 10:47, Hugo Mills wrote:
> >On Tue, Jan 10, 2017 at 10:42:51AM -0500, Austin S. Hemmelgarn wrote:
> >>Most of the issue in this case is with the size of the initial
> >>chunk. That said, I've got quite a few reasonably sized filesystems
> >>(I think the largest is 200GB) with moderate usage (max 90GB of
> >>data), and none of them are using more than the first 16kB block in
> >>the System chunk. While I'm not necessarily a typical user, I'd be
> >>willing to bet based on this that in general, most people who aren't
> >>storing very large amounts of data or taking huge numbers of
> >>snapshots aren't going to need a system chunk much bigger than 1MB.
> >
> >   Again, the system chunk has *nothing* to do with snapshots.
> Apologies, I somehow completely missed the part of your first reply
> where you commented on that...

   There was quite a lot of it. :)

   Hugo.

-- 
Hugo Mills             | Anyone who claims their cryptographic protocol is
hugo@... carfax.org.uk | secure is either a genius or a fool. Given the
http://carfax.org.uk/  | genius/fool ratio for our species, the odds aren't
PGP: E2AB1DE4          | good.                                  Bruce Schneier

--ZPDwMsyfds7q4mrK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYdQd0AAoJEFheFHXiqx3kR5QP/2X2+Jr++V43QFPEXayEJhna
2Iuo16UWwOWILLi7Ldb7FigNZUoOJ4eZvCKqEdyCdqm5zitCHPDbjLxnbxqFNCtO
7TQLJonUeklMJVadOcLjJ0Yci7++VLiQDez6GvhuoaQ+/1TcQlhBuC35fCty5uwV
2y5+8mQ2/L58SyWm8QPEtdoGZRhXKj7cU4oL9IA/nvdpguobu4x1TJ1s1y+Sc3t/
JrD+1YQ78teiLaOS7V4EZK63rIdv751db1R29dPdiqZim4Tg6rAy0L0cGXLHA1kA
FetHQKndam7NTbxoM300Jgod0jA/s6BsGjyzDUP0/W0JUSFdOdm2BwLx9g0nRph3
RTPwW78X66XoWYq+6ETa8CufY/rFTr9wssVeuz7mcV7F8rT3Bj+nBg74hO0JOS30
1DvjDm2bCBodMCyr4MFtBilOM0s8cKs4oW3OkArNmI6lq5qJ/VnJluBeFxPKlRrr
9pLtqLn7fBii/aLyygKzMR1Fs9IPD+EhqInX23YtxrvdsjsRcKUtljsFY0B2O7o6
0hm45F7ZchSkt5wfEe4e1n+ay5hEdbnYyclIdUGsJyBGfUl/k9a6Ye+Gafiu7O9l
R1BEB6bU00KwJWNgrr/tyxOU07hNCghu+1ZhnG7hOFjUhxnvYe+a+oswpz6jQS0B
0Cqb66N5I7ZiLVlUn5Qa
=XVCT
-----END PGP SIGNATURE-----

--ZPDwMsyfds7q4mrK--
