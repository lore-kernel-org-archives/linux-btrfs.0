Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58999 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbaGYJNW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 05:13:22 -0400
Date: Fri, 25 Jul 2014 10:13:11 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
Message-ID: <20140725091311.GB31950@carfax.org.uk>
References: <1502954.OtX3SzjMKZ@merkaba>
 <1809953.ithLVmijbn@merkaba>
 <53D11F2B.1070008@fb.com>
 <1557956.045aK4K0qS@merkaba>
 <pan$aa09d$75e2870b$4abbbcef$7f21a37d@cox.net>
 <CAPDOMVhXL2nS8BDbwfhZpBehE2Tmb7wo3iK45KKqK38n9YzF2A@mail.gmail.com>
 <20140725080244.GA31950@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
In-Reply-To: <20140725080244.GA31950@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[this time, to the mailing list as well]

On Fri, Jul 25, 2014 at 09:02:44AM +0100, Hugo Mills wrote:
> On Thu, Jul 24, 2014 at 11:06:34PM -0400, Nick Krause wrote:
> > On Thu, Jul 24, 2014 at 10:32 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> [snip]
> > Hey Duncan and others ,
> > I have read this and this seems to need some working on.
> > If you want my help please ask , I am new to the kernel
> > so I may ask a dumb question or two but if that's fine with
> > you I have no problem helping out here. I would like
> > a log of printk statements leading to the hand if that's
> > not too much work in order for me to trace this back.
>=20
>    Note that btrfs is complex -- there's something around 100k lines
> of code in it. My first piece of kernel work in btrfs was simply
> documenting the way that the on-disk data structures related to each
> other[1]. That on its own took me two to three weeks of solid
> full-time effort, reading the code to find where each structure was
> used and how its elements related to other structures. You can't just
> wander up and dive in without putting in the effort of learning first.
> Whilst people will help you (come over to #btrfs on Freenode for more
> real-time interaction), they can't do the basic work of sitting down
> and understanding the code in detail for you.
>=20
>    Chris, who designed and wrote the filesystem, has spent the last
> couple of weeks tracking down this particular problem. Do you think
> it's appropriate to leap into the middle of the discussion on this
> subtle bug as someone with absolutely no experience in the area?
>=20
>    Your first task is to reproduce the bug on your own machine. If you
> can do that, _then_ you might be able to start tracking down its
> cause. But I wouldn't recommend doing that, as (a) it's a nasty subtle
> bug, and (b) Chris seems to be close to tracking it down anyway.
>=20
>    My recommendations for you, if you want to work on btrfs, are:
>=20
>  * Build and install the latest kernel from Linus's git repo
>=20
>  * Read and understand the user documentation [2]
>=20
>  * Create one or several btrfs filesystems with different
>    configurations and learn how they work in userspace -- what are the
>    features, what are the problems you see? Actually use at least one
>    of the filesystems you created for real data in daily use (with
>    backups)
>=20
>  * Build the userspace tools from git
>=20
>  * Pick up one of the userspace projects from [3] and implement that.
>    If you pick the right one(s), you'll have to learn about some of
>    the internal structures of the FS anyway. Compile and test your
>    patch. If you're adding a new feature, write an automated xfstest
>    for it as well.
>=20
>  * Get that patch accepted. This will probably involve a sequence of
>    revisions to it, multiple versions over a period of several weeks
>    or more, with a review process. You should also send your test to
>    xfstests and get that accepted.
>=20
>  * Do the above again, until you get used to the processes involved,
>    and have demonstrated that you can work well with the other people
>    in the subsystem, and are generally producing useful and sane code.
>    It's all about trust -- can you be trusted to mostly do the right
>    thing? (So far on linux-kernel, you've rather demonstrated the
>    opposite: your intentions are good, but your execution leaves a lot
>    to be desired)
>=20
>  * Use the documentation at [4], and the output of btrfs-debug-tree to
>    understand the internal structure of the FS
>=20
>  * Pick up one of the smaller, more self-contained ideas from the
>    projects page [5] (say, [6] or [7]) and try to implement it. Again:
>    build, write test code, test thoroughly, submit patch for review,
>    modify as suggested by reviewers, and repeat as often as necessary
>=20
>    Hugo.
>=20
> [1] https://btrfs.wiki.kernel.org/index.php/Data_Structures
> [2] https://btrfs.wiki.kernel.org/index.php/Main_Page#Guides_and_usage_in=
formation
> [3] https://btrfs.wiki.kernel.org/index.php/Project_ideas#Userspace_tools=
_projects
> [4] https://btrfs.wiki.kernel.org/index.php/Main_Page#Developer_documenta=
tion
> [5] https://btrfs.wiki.kernel.org/index.php/Project_ideas
> [6] https://btrfs.wiki.kernel.org/index.php/Project_ideas#Cancellable_ope=
rations
> [7] https://btrfs.wiki.kernel.org/index.php/Project_ideas#Implement_new_F=
ALLOC_FL_.2A_modes
>=20
> --=20
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.=
uk =3D=3D=3D
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- But people have always eaten people,  / what else is there to --- =
=20
>          eat?  / If the Juju had meant us not to eat people / he        =
=20
>                      wouldn't have made us of meat.                     =
=20



--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                        --- ORLY? I=C4! R'LYH! ---                       =
=20

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9Ifp1heFHXiqx3kAQLz4xAAqRna5Ge8tk/nIt60P03Rc2XdRq4fI26L
IA8V/Y4kFlHwr9u5UclbyrZiH3WpfxVC8GEmS8WZ1l97uSDxKaGzLMSCnHTCYeY+
0BmeKyC0mG60m5ndCuVOsxZymNalKvdIyDu/5Esa2YgBa58cEkyccVRPnSOvkQh4
ztfVmLs0LOz1DJltxOx2FLUIFpnvC4Jnkj9L4IPPOMCuHkBH8Md4g6S1bId19Jes
gkHkErq3nDvczrSVf3RvVs+qzv9tbRu6RmtVg/zTg017iop8JMrRaOdOmpV8+1w3
HxAFs7ThzRUwL07bO2JFpGw63NtJz2R9p9E7VeWe/dx83UGz0QyCUWJPo28z0IQn
dJwJQ6L3Iki7dlDQ1mPS4/7S1Dkz5VbIXWlBOZkiAc9aTaYBUeQ+6+rK3y53yqqd
4Yvv65jeY5pObwZHp0EOlN8McJOJ9StIgypGDTI/mhnSkS3Qr2mKJtZapu1HmiAH
+Izc1Abx64+m+L+/P75l0+BhwRgkR2yzsv5YS16XIXYX53gGtV/PLCGg/R7vceYf
l2FnF4EXuTiK7IWGir5qsH1zLgYXHbn4QXYBc7ylJ+y50Oo+wgQHmpsBLheB3XYH
eCnLz5fLiV+7HUGkGD4GBfuh+zpzXfTheGFVAGyJ66gLXpf95E16YpXXTdy0D8MO
XbNNsdKvLyM=
=p9G8
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
