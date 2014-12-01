Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37835 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753102AbaLAPZN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 10:25:13 -0500
Date: Mon, 1 Dec 2014 10:25:11 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141201152511.GY17395@hungrycats.org>
References: <20141123001927.GO17380@hungrycats.org>
 <5474AF87.6090702@inwind.it>
 <20141125202948.GP17380@hungrycats.org>
 <5474FBD9.5070709@inwind.it>
 <20141125222126.GQ17380@hungrycats.org>
 <54760B89.3050604@inwind.it>
 <20141127041510.GV17380@hungrycats.org>
 <5478AB6C.7030809@inwind.it>
 <20141129045924.GX17395@hungrycats.org>
 <54797BDB.1050905@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NJ5+aVN4Egd/eJfU"
In-Reply-To: <54797BDB.1050905@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NJ5+aVN4Egd/eJfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 28, 2014 at 11:55:07PM -0800, Robert White wrote:
> On 11/28/2014 08:59 PM, Zygo Blaxell wrote:
> >On Fri, Nov 28, 2014 at 06:05:48PM +0100, Goffredo Baroncelli wrote:
> >>On 11/27/2014 05:15 AM, Zygo Blaxell wrote:
> >>>This is a weakness of the current udev and asynchronous device hotplug
> >>>concept:  there is no notion of bus enumeration in progress, so we can be
> >>>trying to assemble multi-device storage before we have all the devices
> >>>visible.  Assembly of aggregate storage (whatever it is--btrfs, md,
> >>>lvm2...) has to wait until all known storage buses are fully enumerated
> >>>in order to detect if there are duplicates.
> >>
> >>It is more complex than that. Some devices may appear after the "1st" bus
> >>enumeration.
> >
> >That case is well handled already--a new enumeration will start with the
> >second (and all later) hotplug events.
> >
> >The problem arises when we try to assemble disk arrays before the
> >known end of the "1st" (or any) enumeration.  There is no way for an
> >enumerating agent to tell other agents "this is definitely not the
> >complete list of devices yet, other devices may be inserted imminently"
> >and defer all the multi-device assembly until the address space of the
> >enumering bus is fully covered.
> >
> MDADM has an "attached" but not "started" state for arrays that
> handles this condition during incremental assembly. (see "mdadm
> --incremental /dev/whatever"),

> [...very complicated mdadm-architecture-invades-the-filesystem-layer
> thing snipped...]

I don't see why it can't all be done in user-space more or less the same
way LVM does.  Scan all the parititions known to be available, build a
table of devices with UUIDs matching the target filesystem, check for
sufficiency, check for uniqueness, and if the configuration passes all the
sanity checks (or we have hints from the user that resolve ambiguity),
submit the entire list of devices to the kernel as a BTRFS filesystem.
If there are UUID duplicates or missing devices, submit nothing to the
kernel at all.

initramfs-less multi-disk configurations can calculate all that in
advance and generate a rootflags parameter for the kernel command line.
It's not necessary to resolve every possible situation in the kernel.


--NJ5+aVN4Egd/eJfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR8iFcACgkQgfmLGlazG5wWLwCeIUj6ZgbkkkDK15AwJ9jQSw0l
mG0AoLTuhrkJ7ZODjvMbFOKDFqKYyveQ
=CSii
-----END PGP SIGNATURE-----

--NJ5+aVN4Egd/eJfU--
