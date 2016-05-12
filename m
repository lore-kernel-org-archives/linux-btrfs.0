Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34159 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbcELQsb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 12:48:31 -0400
Date: Thu, 12 May 2016 12:48:17 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org, Clemens Eisserer <linuxhippy@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>, 1i5t5.duncan@cox.net
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
Message-ID: <20160512164817.GD15597@hungrycats.org>
References: <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
 <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
 <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
 <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
 <799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
 <52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
 <20160509162940.GC15597@hungrycats.org>
 <c5fa6a35-f6bd-4546-8297-7f6225696157@linuxsystems.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
In-Reply-To: <c5fa6a35-f6bd-4546-8297-7f6225696157@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 12, 2016 at 04:35:24PM +0200, Niccol=F2 Belli wrote:
> When doing the btrfs check I also always do a btrfs scrub and it never fo=
und
> any error. Once it didn't manage to finish the scrub because of:
> BTRFS critical (device dm-0): corrupt leaf, slot offset bad:
> block=3D670597120,root=3D1, slot=3D6
> and btrfs scrub status reported "was aborted after 00:00:10".
>=20
> Talking about scrub I created a systemd timer to run scrub hourly and I
> noticed 2 *uncorrectable* errors suddenly appeared on my system. So I
> immediately re-run the scrub just to confirm it and then I rebooted into =
the
> Arch live usb and runned btrfs check: the metadata were perfect. So I run=
ned
> btrfs scrub from the live usb and there were no errors at all! I rebooted
> into my system and runned scrub once again and the uncorrectable errors
> where really gone! It happened two times in the past few days.

That's what a RAM corruption problem looks like when you run btrfs scrub.
Maybe the RAM itself is OK, but *something* is scribbling on it.

Does the Arch live usb use the same kernel as your normal system?

> Almost no patches get applied by the Arch kernel team:
> https://git.archlinux.org/svntogit/packages.git/tree/trunk?h=3Dpackages/l=
inux
> At the moment the only one is an harmless
> "change-default-console-loglevel.patch".

Did you try an older (or newer) kernel?  I've been running 4.5.x on a few
canary systems, but so far none of them have survived more than a day.
Contrast with 4.1.x and 4.4.x, which runs for months between reboots
for me.  Maybe there's a regression in 4.5.x, maybe I did something
wrong in my config or build, or maybe I just have too few data points
to draw any conclusions, but my data so far is telling me to stay on
4.4.x until something changes (i.e. wait for a 4.5.x stable update or
skip directly to 4.6.x).  :-/

It's always worth trying this if only to eliminate regression as a
possible root cause early.  In practice, every mainline kernel release
has a regression that affects at least one combination of config options
and hardware.  btrfs is stable enough now that you can be running one
or two releases behind to avoid a problem elsewhere in the kernel.

> Another option will be crashing it with my car's wheels hoping that becau=
se
> of my comprehensive insurance policy Dell will give me the next model (the
> Skylake one) as a replacement (hoping that it will not suffer from the sa=
me
> issue of the Broadwell one).

The first rule of Insurance Fraud Club:  don't talk about Insurance
Fraud Club.  ;)

It's possible there's a problem that affects only very specific chipsets
You seem to have eliminated RAM in isolation, but there could be a problem
in the kernel that affects only your chipset.


--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlc0s9EACgkQgfmLGlazG5yVJQCg1sSS+Az2XUgivLpKiG2DG1/Q
D50AnjqZTiviGeweIsOdxQGJT65NKxqz
=ArBT
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
