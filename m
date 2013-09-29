Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54055 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3I2AVW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 20:21:22 -0400
Date: Sun, 29 Sep 2013 01:21:15 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Aastha Mehta <aasthakm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions regarding logging upon fsync in btrfs
Message-ID: <20130929002115.GG28147@carfax.org.uk>
References: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
 <CAEx9m450LqPOH=2tmSss=njScuY4yC4eBhwJDsTF-+jv97C_Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ndw/alBWmZEhfcZ"
In-Reply-To: <CAEx9m450LqPOH=2tmSss=njScuY4yC4eBhwJDsTF-+jv97C_Vg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4ndw/alBWmZEhfcZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 29, 2013 at 01:46:23AM +0200, Aastha Mehta wrote:
> I am using linux kernel 3.1.10-1.16, just to let you know.

   Not that it invalidates the questions below, but that's a really
old kernel. You should update to something recent (3.11, or 3.12-rc2)
as soon as possible. There are major problems in 3.1 (and most of the
subsequent kernels) that have been fixed in 3.11. Of course, there are
still major problems in 3.11 that haven't been fixed yet, but we don't
know about very many of those. :) (And when we do, we'll be
recommending that you upgrade to whatever has them fixed...)

   Hugo.

> Thanks
> 
> On 29 September 2013 01:35, Aastha Mehta <aasthakm@gmail.com> wrote:
> > Hi,
> >
> > I have few questions regarding logging triggered by calling fsync in BTRFS:
> >
> > 1. If I understand correctly, fsync will call to log entire inode in
> > the log tree. Does this mean that the data extents are also logged
> > into the log tree? Are they copied into the log tree, or just
> > referenced? Are they copied into the subvolume's extent tree again
> > upon replay?
> >
> > 2. During replay, when the extents are added into the extent
> > allocation tree, do they acquire the physical extent number during
> > replay? Does they physical extent allocated to the data in the log
> > tree differ from that in the subvolume?
> >
> > 3. I see there is a mount option of notreelog available. After
> > disabling tree logging, does fsync still lead to flushing of buffers
> > to the disk directly?
> >
> > 4. Is it possible to selectively identify certain files in the log
> > tree and flush them to disk directly, without waiting for the replay
> > to do it?
> >
> > Thanks
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- <Diablo-D3> My code is never released,  it escapes from the ---   
          git repo and kills a few beta testers on the way out.          

--4ndw/alBWmZEhfcZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUkdye1heFHXiqx3kAQLIGRAAtdkvMXJ3doRMi6HqtHoMmtjCcxm1yLS2
D7bAVgUEMhEAe3fHm2cRIpQsDZfZoV4as7bKr8oUPq5rf1IZXJKIOBDtA95S81K6
q0wz6pZcSfp34o/UEkgZy+KiYuXLqwy8VhmxPT6xW9atcsYvFMBwLuI5IseiWYGQ
726y6Nn9hLqgWGvTyBch9Jo+JgQ19O3oK6EMMWjyq/2MwqC9/p1JNTfilAvYakmn
IHAaeg1xDEbil6bXgzv9pGZYg7QMmApDc4ZJqm/ktEVLO4cGOWzLEueK0tEUpsBm
B/qT/8BSpidqhmr1omgIfHO375UvJIwc51F44IBP01P4UabZcIU7LPxLaR3iBc9E
VGYvEdPzE+D7gb98yYrAhcZ0vAAL7D8plnYJ5oTlcwKUKMxHMfXJGBmog7mfDcN4
AgN4al1rtWnWqeyDp1LU60VOM3BKZDvBm6ECd4d97D3hKU/OKzjrek3kw5hE7ZzH
GdTb1DMtvUB476SqXfo/UdTv93fijqpCh8douY0Irva2X+DRye9tilsvpajNKxfZ
li5WKN22s7W8PCCINTdLf8uruDis6LUA0aDxhVcRYWEnKn6tZKGpTEDOoLbpauAJ
6js6weTydooKh4rPyg7gQkU5h/leMgKx//46W1VYWDQpbEV2aCgNwu9einyqQaew
4AFG0xBR2Ac=
=Foi3
-----END PGP SIGNATURE-----

--4ndw/alBWmZEhfcZ--
