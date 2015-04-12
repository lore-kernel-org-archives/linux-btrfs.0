Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39130 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862AbbDLUUl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Apr 2015 16:20:41 -0400
Date: Sun, 12 Apr 2015 16:11:07 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: mlocate/updatedb and btrfs subvolume mounts
Message-ID: <20150412201107.GA4711@hungrycats.org>
References: <CADw2B2NDTqOXQdh+xBTfk3=MfYJUtGAvQ-B4RaADA4XXJ30OZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
In-Reply-To: <CADw2B2NDTqOXQdh+xBTfk3=MfYJUtGAvQ-B4RaADA4XXJ30OZw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I generally set up that kind of service on bind mounts of its own,
e.g.

        mount --bind / /.binds/root
        mount --bind /boot /.binds/root/boot
        mount --bind /home /.binds/root/home
        ... repeat for everything else you care about

then I tell backup / indexing software to process everything it finds
under /.binds/root.  If it's not possible to have the software drop
the /.binds/root prefix, run it chroot inside /.binds/root instead.
Tell locate to go ahead and process bind mounts since there's nothing
else it will have access to.

Since these are simple binds (not rbinds), they don't see any
other filesystems, period.  They do see btrfs subvolumes, though.

There are plenty of non-btrfs reasons to do things this way.  You can
let users mount SMB shares, FUSE filesystems, or whatever other insane
crap they like, and it won't affect locate or similar services (but make
sure your users have no access to /.binds--chmod it 700, or put them
under an isolated bind mount hierarchy of their own).

On Fri, Apr 03, 2015 at 01:07:37PM -0700, G. Richard Bellamy wrote:
> I've just noticed that I'm having issues with finding files using
> "locate" when those files are on btrfs subvolume mounts.
>=20
> The issue is that updatedb cannot discern the difference between a
> btrfs bind mount and btrfs subvolume [1][2]. This generally means that
> if you're using btrfs subvolume mounts and updatedb at the same time,
> and you want to index those subvolumes, you'll need to set
> PRUNE_BIND_MOUNTS to 0 or "no". And then deal with all the cruft that
> causes.
>=20
> >From the bug above, you can see that the RedHat dev Michal Sekletar is
> out of ideas. I'm not sure if he's reached out here or not... and if
> not, he might welcome some help from the folks on this list.
>=20
> Regrads,
> Richard
>=20
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=3D906591#c3
> [2] http://www.spinics.net/lists/linux-btrfs/msg42510.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUq0VsACgkQgfmLGlazG5ykGACg0XhU2ne6z6dymkK703VNj/gw
L38An3G6foChqW+L7wbG2AfxHIhsAGhF
=Mvpk
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
