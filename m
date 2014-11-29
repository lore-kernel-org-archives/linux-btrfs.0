Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47460 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751043AbaK2E70 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 23:59:26 -0500
Date: Fri, 28 Nov 2014 23:59:24 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141129045924.GX17395@hungrycats.org>
References: <20141121042814.GR17395@hungrycats.org>
 <5470C92E.1070607@inwind.it>
 <20141123001927.GO17380@hungrycats.org>
 <5474AF87.6090702@inwind.it>
 <20141125202948.GP17380@hungrycats.org>
 <5474FBD9.5070709@inwind.it>
 <20141125222126.GQ17380@hungrycats.org>
 <54760B89.3050604@inwind.it>
 <20141127041510.GV17380@hungrycats.org>
 <5478AB6C.7030809@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yPlaimQd/TpiYx8R"
In-Reply-To: <5478AB6C.7030809@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yPlaimQd/TpiYx8R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 06:05:48PM +0100, Goffredo Baroncelli wrote:
> On 11/27/2014 05:15 AM, Zygo Blaxell wrote:
> > This is a weakness of the current udev and asynchronous device hotplug
> > concept:  there is no notion of bus enumeration in progress, so we can =
be
> > trying to assemble multi-device storage before we have all the devices
> > visible.  Assembly of aggregate storage (whatever it is--btrfs, md,
> > lvm2...) has to wait until all known storage buses are fully enumerated
> > in order to detect if there are duplicates.
>=20
> It is more complex than that. Some devices may appear after the "1st" bus
> enumeration.

That case is well handled already--a new enumeration will start with the
second (and all later) hotplug events.

The problem arises when we try to assemble disk arrays before the
known end of the "1st" (or any) enumeration.  There is no way for an
enumerating agent to tell other agents "this is definitely not the
complete list of devices yet, other devices may be inserted imminently"
and defer all the multi-device assembly until the address space of the
enumering bus is fully covered.


--yPlaimQd/TpiYx8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR5UqwACgkQgfmLGlazG5xTTwCglP1rFdcxWRTtWoC4qmyxAMtx
gMoAoK5Dej+TXPMZd51ZFgdgZRmGg3TU
=WZuY
-----END PGP SIGNATURE-----

--yPlaimQd/TpiYx8R--
