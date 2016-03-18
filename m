Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44141 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbcCRXeZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 19:34:25 -0400
Date: Fri, 18 Mar 2016 23:34:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Marcin Solecki <solo@alfazone.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: recovery problem raid5
Message-ID: <20160318233422.GC1802@carfax.org.uk>
References: <56EC3DCC.6060101@alfazone.pl>
 <20160318180207.GA1802@carfax.org.uk>
 <CAJCQCtQyyk3XnyCBW0vij1RSypYXF7yEAhBqaztzmXMvMU=0ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
In-Reply-To: <CAJCQCtQyyk3XnyCBW0vij1RSypYXF7yEAhBqaztzmXMvMU=0ng@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 18, 2016 at 05:31:51PM -0600, Chris Murphy wrote:
> On Fri, Mar 18, 2016 at 12:02 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >    The main thing you haven't tried here is mount -o degraded, which
> > is the thing to do if you have a missing device in your array.
> >
> >    Also, that kernel's not really all that good for a parity RAID
> > array -- it's the very first one that had the scrub and replace
> > implementation, so it's rather less stable with parity RAID than the
> > later 4.x kernels. That's probably not the issue here, though.
> 
> 
> It's a 4.5.0 kernel with 3.19 progs. I'd update the progs even though
> that's unlikely the problem.

   Oh, my mistake. I misread the 3.19 as the kernel version.

   Marcin: Stick with the 4.5 kernel.

   Hugo.

-- 
Hugo Mills             | Yes, this is an example of something that becomes
hugo@... carfax.org.uk | less explosive as a one-to-one cocrystal with TNT.
http://carfax.org.uk/  | (Hexanitrohexaazaisowurtzitane)
PGP: E2AB1DE4          |                                            Derek Lowe

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW7JB+AAoJEFheFHXiqx3kzOsP/3RPGBsJ7++ANkJZ6hwtnAfU
ST70sz2EhfHH5jpumSIxNVlH7x3D6q4p5HdqQ8STrL18dil8gi0mtpTQToQA/snN
5BhZmudkEQkDVACfvsuPoYHVI2bfu1qeIHo9smazK7W1vmW5cQtYodkCP4bsYx8e
NLY0OrDikF+8LrCFiV1zEDeVnhcRe696jvwSrztT2G3rcJ6o55iMPO8xvmmOoFmW
AM+1Q45tFsgzT/Y0V8J8eHkyH1s2Z72BteRqnNbkPY3DJGw2xKtTLeIi2ENLdXPD
GbzA7lYKA7XgotwoLhLrIRShHiHLCg2XNFWnGwFcMoMQi1OGnRItpdNtMBFNkKxj
cnwP7/3KW/h02TyTzZCD59MnXe0RKKtWG+/rRVp57LoVB+hpnQXbifIDlY0tVknr
9Yvns+xJ8XT5IoLzCv2vK7GWBOhdqYDanQ4pLFywXv0rw/Exm3dYKzcoRbz3FXLv
9f/5aSbnwla9PCXr/0TPiFFst4wdpeyBubjD8JASghjeV04Yehd2WkV+w09dbJZ5
p2N2AjnbiY/xMQpaDedK/z1rC2H1i3i+8pu8PPLroCJHuzLT9auTFeHBAYZ1qrpH
UBG2WlKNYR6OmR+dnn0vcF2iP4QLiaV1ImpSJXfUwTj65JPcxU33SwHrXRDu5yBx
nUeDk51xenNlysuoQrJh
=EkpO
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
