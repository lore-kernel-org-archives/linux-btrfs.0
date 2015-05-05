Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38334 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753960AbbEEC75 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 May 2015 22:59:57 -0400
Date: Mon, 4 May 2015 22:59:53 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: mlocate/updatedb and btrfs subvolume mounts
Message-ID: <20150505025953.GB18025@hungrycats.org>
References: <CADw2B2NDTqOXQdh+xBTfk3=MfYJUtGAvQ-B4RaADA4XXJ30OZw@mail.gmail.com>
 <20150412201107.GA4711@hungrycats.org>
 <pan$3396c$51a072b0$71501292$8af8c3ee@cox.net>
 <CADw2B2NuyxorUUJvpwUuPF78adrey9OORgviWg5NWx56cknOdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
In-Reply-To: <CADw2B2NuyxorUUJvpwUuPF78adrey9OORgviWg5NWx56cknOdg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 04, 2015 at 04:40:08PM -0700, G. Richard Bellamy wrote:
> On Sun, Apr 12, 2015 at 9:12 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> >
> > Zygo Blaxell posted on Sun, 12 Apr 2015 16:11:07 -0400 as excerpted:
> >
> > > Since these are simple binds (not rbinds), they don't see any other
> > > filesystems, period.  They do see btrfs subvolumes, though.
> >
> > Tho... for systemd users...
> >
> > Do note that systemd plays with the kernel's shared-subtree "private"
> > default, switching it to shared for /.
>=20
> I like to think I know a bit about a thing or two. I've read both Zygo
> and Duncan's probably cogent responses.
>=20
> My brain hurts, and I am just not getting it.
>=20
> If I am to understand correctly, and specific to my OP, the problem
> with updatedb et al. on my system is that /, /home, /var, /opt and
> /var/lib/libvirt are all subvolume mounts - which appear as bind
> mounts. Thus the PRUNE_BIND_MOUNTS prunes ALL mounts, and updatedb
> sees nothing.
>=20
> Everything else is a blur when we start talking about "mount --bind /
> /.binds/root"
>=20
> Oh wait, maybe I get it now...
>=20
> By running "mount --bind / /.binds/root" and running updatedb in
> "/.binds/root" while still allowing it to see binds, I am certain to
> get a an mlocate db, and it won't ever see anything outside that
> explicit hierarchy.
>=20
> Something like that?

Something like that.  You might also have to do=20
'chroot /.binds/root <your-updatedb-script-here>' in order to get path
names that make sense from / (i.e. to prevent updatedb from adding
'/.binds/root' to everything).

Bind mounts are awesome.  And also evil.  ;)

> -rb
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVIMikACgkQgfmLGlazG5xlNQCfSVxHHcgcfqw6R+T/yCkWaO0s
0+MAnjBbHOO0199JMTtRbVE84Cf4aFg5
=XReE
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
