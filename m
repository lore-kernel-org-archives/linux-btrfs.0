Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47831 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750833AbaLCTyS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 14:54:18 -0500
Date: Wed, 3 Dec 2014 14:54:14 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141203195408.GY17380@hungrycats.org>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <20141202125252.GR12140@twin.jikos.cz>
 <20141202140945.GM32735@carfax.org.uk>
 <20141203182633.GV12140@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1PHmS26pdpOR3Xc0"
In-Reply-To: <20141203182633.GV12140@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1PHmS26pdpOR3Xc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2014 at 07:26:33PM +0100, David Sterba wrote:
> On Tue, Dec 02, 2014 at 02:09:45PM +0000, Hugo Mills wrote:
> > On Tue, Dec 02, 2014 at 01:52:52PM +0100, David Sterba wrote:
> > > On Mon, Dec 01, 2014 at 10:14:03PM -0500, Zygo Blaxell wrote:
> > > > > export BTRFS_SUBVOLUME_DELETE_CONFIRM=3D1
> > > > >=20
> > > > > Ideas?
> > > >=20
> > > > Never rely on aliasing or environment variables for defaults, and n=
ever
> > > > change default behavior if your releases are old enough that someone
> > > > has built scripts on top of them.  ;)
> > >=20
> > > Exactly.
> > >=20
> > > > If I had to pick the least evil, I'd go for interactive prompting by
> > > > default (do nothing if the interaction fails, e.g. no TTY) and add a
> > > > '-f'/'--force' flag to bypass the prompt.
> > >=20
> > > This sounds acceptable.
> > >=20
> > > > This is consistent with the
> > > > way lvm2 and mdadm work when presented with data-losing or otherwise
> > > > questionable commands and parameters.  It will break scripts, but b=
trfs
> > > > users should still be expecting that for a while as undesirable def=
ault
> > > > behaviors are identified.
> > >=20
> > > How is this going to break scripts?
> >=20
> >    Any script which relies on being able to delete subvolumes in
> > unattended operation will now require modification to use -f.
>=20
> Even with the tty/interactive shell detection in place? Maybe I
> understood the reference to lvm/mdadm tools wrong. My idea is that the
> scripts would work as now, no prompts there.

How do we reliably distinguish between "running in a script
interactively", "running in a script non-interactively", and "running
interactively"?

I could easily run a script from the command line that creates and
destroys subvols and runs for days or weeks (in fact, I quite often do).
It would be a significant productivity hit if an upgrade made it stop
every night waiting for confirmation from a user who went home hours
ago and won't be back for hours more.


--1PHmS26pdpOR3Xc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR/amAACgkQgfmLGlazG5wCMQCghFYZRugMA3jjXdiR9YK2niNV
yXsAn2syhZPHhKDWs4vdnKjGCxJ2XsI5
=bjV7
-----END PGP SIGNATURE-----

--1PHmS26pdpOR3Xc0--
