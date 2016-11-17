Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37066 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbcKQXN3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 18:13:29 -0500
Date: Thu, 17 Nov 2016 18:13:10 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kreijack@libero.it
Subject: Re: [PATCH 0/2] RAID5/6 scrub race fix
Message-ID: <20161117231310.GN21290@hungrycats.org>
References: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="myGquMeQRBVzK6Jb"
In-Reply-To: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--myGquMeQRBVzK6Jb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2016 at 10:50:22AM +0800, Qu Wenruo wrote:
> Fix the so-called famous RAID5/6 scrub error.
>=20
> Thanks Goffredo Baroncelli for reporting the bug, and make it into our
> sight.
> (Yes, without the Phoronix report on this,
> https://www.phoronix.com/scan.php?page=3Dnews_item&px=3DBtrfs-RAID-56-Is-=
Bad,
> I won't ever be aware of it)

If you're hearing about btrfs RAID5 bugs for the first time through
Phoronix, then your testing coverage is *clearly* inadequate.

Fill up a RAID5 array, start a FS stress test, pull a drive out while
that's running, let the FS stress test run for another hour, then try
to replace or delete the missing device.  If there are any crashes,
corruptions, or EIO during any part of this process (assuming all the
remaining disks are healthy), then btrfs RAID5 is still broken, and
you've found another bug to fix.

The fact that so many problems in btrfs can still be found this way
indicates to me that nobody is doing this basic level of testing
(or if they are, they're not doing anything about the results).

> Unlike many of us(including myself) assumed, it's not a timed bomb buried
> deeply into the RAID5/6 code, but a race condition in scrub recovery
> code.

I don't see how this patch fixes the write hole issue at the core of
btrfs RAID56.  It just makes the thin layer of bugs over that issue a
little thinner.  There's still the metadata RMW update timebomb at the
bottom of the bug pile that can't be fixed by scrub (the filesystem is
unrecoverably damaged when the bomb goes off, so scrub isn't possible).

> The problem is not found because normal mirror based profiles aren't
> affected by the race, since they are independent with each other.

True.

> Although this time the fix doesn't affect the scrub code much, it should
> warn us that current scrub code is really hard to maintain.

This last sentence is true.  I found and fixed three BUG_ONs in RAID5
code on the first day I started testing in degraded mode, then hit
the scrub code and had to give up.  It was like a brick wall made out
of mismatched assumptions and layering inversions, using uninitialized
kernel data as mortar (though I suppose the "uninitialized" data symptom
might just have been an unprotected memory access).

> Abuse of workquque to delay works and the full fs scrub is race prone.
>=20
> Xfstest will follow a little later, as we don't have good enough tools
> to corrupt data stripes pinpointly.
>=20
> Qu Wenruo (2):
>   btrfs: scrub: Introduce full stripe lock for RAID56
>   btrfs: scrub: Fix RAID56 recovery race condition
>=20
>  fs/btrfs/ctree.h       |   4 ++
>  fs/btrfs/extent-tree.c |   3 +
>  fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 199 insertions(+)
>=20
> --=20
> 2.10.2
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--myGquMeQRBVzK6Jb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlguOYYACgkQgfmLGlazG5xC0QCgiNbcfb9Q1UCDPeRJoc4ESNKI
YVwAn0RueaI3z/o+ILKug1AxEFlAOEMz
=VNu0
-----END PGP SIGNATURE-----

--myGquMeQRBVzK6Jb--
