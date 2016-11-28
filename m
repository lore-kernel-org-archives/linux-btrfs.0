Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48832 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1755713AbcK1Vsh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 16:48:37 -0500
Date: Mon, 28 Nov 2016 16:48:29 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
Message-ID: <20161128214829.GO8685@hungrycats.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
 <1480304269.6254.6.camel@scientia.net>
 <2b15ae6f-51ce-45ff-47c0-699506de4e56@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yK/6QRnH3Zanb0EF"
In-Reply-To: <2b15ae6f-51ce-45ff-47c0-699506de4e56@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yK/6QRnH3Zanb0EF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 28, 2016 at 07:32:38PM +0100, Goffredo Baroncelli wrote:
> On 2016-11-28 04:37, Christoph Anton Mitterer wrote:
> > I think for safety it's best to repair as early as possible (and thus
> > on read when a damage is detected), as further  blocks/devices may fail
> > till eventually a scrub(with repair) would be run manually.
> >=20
> > However, there may some workloads under which such auto-repair is
> > undesirable as it may cost performance and safety may be less important
> > than that.
>=20
> I am assuming that a corruption is a quite rare event. So occasionally
> it could happens that a page is corrupted and the system corrects
> it. This shouldn't  have an impact on the workloads.

Depends heavily on the specifics of the failure case.  If a drive's
embedded controller RAM fails, you get corruption on the majority of
reads from a single disk, and most writes will be corrupted (even if they
were not before).  If there's a transient failure due to environmental
issues (e.g. short-term high-amplitude vibration or overheating) then
writes may pause for mechanical retry loops.  If there is bitrot in SSDs
(particularly in the address translation tables) it looks like a wall
of random noise that only ends when the disk goes offline.  You can get
combinations of these (e.g. RAM failures caused by transient overheating)
where the drive's behavior changes over time.

When in doubt, don't write.

> BR
> G.Baroncelli
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>=20

--yK/6QRnH3Zanb0EF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg8pi0ACgkQgfmLGlazG5yU9QCgj+dkjWhfe2JkQE/8r4IV+XNU
UHwAn0V4IbEw1K8Yr7kmev8tqFmWgklx
=aEv8
-----END PGP SIGNATURE-----

--yK/6QRnH3Zanb0EF--
