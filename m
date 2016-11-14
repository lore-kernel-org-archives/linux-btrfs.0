Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42056 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbcKNSHQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 13:07:16 -0500
Date: Mon, 14 Nov 2016 13:07:15 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: James Pharaoh <james@wellbehavedsoftware.com>
Cc: Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161114180714.GF21290@hungrycats.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gdEaXsHGJIWX/19R"
In-Reply-To: <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gdEaXsHGJIWX/19R
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 07, 2016 at 07:49:51PM +0100, James Pharaoh wrote:
> Annoyingly I can't find this now, but I definitely remember reading someo=
ne,
> apparently someone knowledgable, claim that the latest version of the ker=
nel
> which I was using at the time, still suffered from issues regarding the
> dedupe code.

> This was a while ago, and I would be very pleased to hear that there is h=
igh
> confidence in the current implementation! I'll post a link if I manage to
> find the comments.

I've been running the btrfs dedup ioctl 7 times per second on average
over 42TB of test data for most of a year (and at a lower rate for two
years).  I have not found any data corruptions due to _dedup_.  I did find
three distinct data corruption kernel bugs unrelated to dedup, and two
test machines with bad RAM, so I'm pretty sure my corruption detection
is working.

That said, I wouldn't run dedup on a kernel older than 4.4.  LTS kernels
might be OK too, but only if they're up to date with backported btrfs
fixes.

Kernels older than 3.13 lack the FILE_EXTENT_SAME ioctl and can
only deduplicate static data (i.e. data you are certain is not being
concurrently modified).  Before 3.12 there are so many bugs you might
as well not bother.

Older kernels are bad for dedup because of non-corruption reasons.
Between 3.13 and 4.4, the following bugs were fixed:

	- false-negative capability checks (e.g. same-inode, EOF extent)
	reduce dedup efficiency

	- ctime updates (older versions would update ctime when a file was
	deduped) mess with incremental backup tools, build systems, etc.

	- kernel memory leaks (self-explanatory)

	- multiple kernel hang/panic bugs (e.g. a deadlock if two threads
	try to read the same extent at the same time, and at least one
	of those threads is dedup; and there was some race condition
	leading to invalid memory access on dedup's comparison reads)
	which won't eat your data, but they might ruin your day anyway.

There is also a still-unresolved problem where the filesystem CPU usage
rises exponentially for some operations depending on the number of shared
references to an extent.  Files which contain blocks with more than a few
thousand shared references can trigger this problem.  A file over 1TB can
keep the kernel busy at 100% CPU for over 40 minutes at a time.

There might also be a correlation between delalloc data and hangs in
extent-same, but I have NOT been able to confirm this.  All I know
at this point is that doing a fsync() on the source FD just before
doing the extent-same ioctl dramatically reduces filesystem hang rates:
several weeks between hangs (or no hangs at all) with fsync, vs. 18 hours
or less without.

> James
>=20
> On 07/11/16 18:59, Mark Fasheh wrote:
> >Hi James,
> >
> >Re the following text on your project page:
> >
> >"IMPORTANT CAVEAT =E2=80=94 I have read that there are race and/or error
> >conditions which can cause filesystem corruption in the kernel
> >implementation of the deduplication ioctl."
> >
> >Can you expound on that? I'm not aware of any bugs right now but if
> >there is any it'd absolutely be worth having that info on the btrfs
> >list.
> >
> >Thanks,
> >    --Mark
> >
> >
> >On Sun, Nov 6, 2016 at 7:30 AM, James Pharaoh
> ><james@wellbehavedsoftware.com> wrote:
> >>Hi all,
> >>
> >>I'm pleased to announce my btrfs deduplication utility, written in Rust.
> >>This operates on whole files, is fast, and I believe complements the
> >>existing utilities (duperemove, bedup), which exist currently.
> >>
> >>Please visit the homepage for more information:
> >>
> >>http://btrfs-dedupe.com
> >>
> >>James Pharaoh
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--gdEaXsHGJIWX/19R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgp/VIACgkQgfmLGlazG5waigCeIz747WJy95VWCXcAuHayno4Y
dfwAn1WZNGmrVLeykozYSG4jyurDrTrL
=LtrY
-----END PGP SIGNATURE-----

--gdEaXsHGJIWX/19R--
