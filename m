Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46112 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751432AbcKYFSd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 00:18:33 -0500
Date: Fri, 25 Nov 2016 00:07:40 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Gareth Pye <gareth@cerberos.id.au>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
Message-ID: <20161125050740.GH8685@hungrycats.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <CA+WRLO_M=HkDox6acxxLtu9rhcK1cXu03d=cXNtvMxYfvhC3WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UthUFkbMtH2ceUK2"
In-Reply-To: <CA+WRLO_M=HkDox6acxxLtu9rhcK1cXu03d=cXNtvMxYfvhC3WA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UthUFkbMtH2ceUK2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2016 at 03:40:36PM +1100, Gareth Pye wrote:
> On Fri, Nov 25, 2016 at 3:31 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> >
> > This risk mitigation measure does rely on admins taking a machine in th=
is
> > state down immediately, and also somehow knowing not to start a scrub
> > while their RAM is failing...which is kind of an annoying requirement
> > for the admin.
>=20
> Attempting to detect if RAM is bad when scrub starts is both time
> consuming and not very reliable right.

RAM, like all hardware, could fail at any time, and a scrub could already
be running when it happens.  This is annoying but also a fact of life that
admins have to deal with.

Testing RAM before scrub starts is not more beneficial than testing RAM
at random intervals--but if you are testing RAM at random intervals,
why not do it at the same intervals as scrub?

If I see corruption errors showing up in stats, I will do a basic sanity
test to make sure they're coming from the storage layer and not somewhere
closer to the CPU.  If all errors come from one device and there are clear
log messages showing SCSI device errors and the SMART log matches the
other data, RAM is probably not the root case of failures, so scrub away.

If normally reliable programs like /bin/sh start randomly segfaulting,
there's smoke pouring out of the back of the machine, all the disks are
full of csum failures, and the BIOS welcome message has spelling errors
that weren't there before, I would *not* start a scrub.  More like
turn the machine off, take it apart, test all the pieces separately,
and only do a scrub after everything above the storage layer had been
replaced or recertified.  I certainly wouldn't want the filesystem to
try to fix the csum failures it finds in such situations.


--UthUFkbMtH2ceUK2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg3xxwACgkQgfmLGlazG5zMHQCfSTS367EOiRGyjdikg/pnqf2q
j/gAn3tViMjkAAE9pce8rIGzwPJ2fnGs
=51Az
-----END PGP SIGNATURE-----

--UthUFkbMtH2ceUK2--
