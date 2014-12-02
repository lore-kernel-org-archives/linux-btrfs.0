Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48486 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753557AbaLBDOG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 22:14:06 -0500
Date: Mon, 1 Dec 2014 22:14:03 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141202031403.GZ17395@hungrycats.org>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4mUolEm2oNas7DxE"
In-Reply-To: <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4mUolEm2oNas7DxE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 10:09:44PM +0530, Shriramana Sharma wrote:
> On Mon, Dec 1, 2014 at 7:16 PM, Roman Mamedov <rm@romanrm.net> wrote:
> >
> > A more sensible idea could be adding a global-level '-i' switch, same a=
s in
> > 'rm', so that you or distros could then alias 'btrfs' to 'btrfs -i' (ask
> > confirmation on any irreversible action).
>=20
> Well the difference being that there doesn't seem to be any other
> irreversible action from my scan of man btrfs -- am I missing
> anything? This is the only thing that actually leads to loss of data.
>=20
> When btrfs has so many features (esp snapshots) to prevent user
> accidentally deleting data (I liked especially
> http://www.youtube.com/v/9H7e6BcI5Fo?start=3D209) I think there has to
> be *some* modicum of support for warning against deleting a subvolume
> (and it seems others agree too).
>=20
> But I see what you mean in the bugzilla comment about not wanting your
> existing backup snapshot scripts to fail because they don't have a -f.
> At the same time, aliasing via -i on top level btrfs binary may not be
> so practical here because this is the only command which will actually
> use it (again, correct if wrong).
>=20
> Perhaps exporting some envvar in the default shell's rc file (or
> whichever file will be read only if the shell is interactive) would
> work? Like in ~/.bashrc:
>=20
> export BTRFS_SUBVOLUME_DELETE_CONFIRM=3D1
>=20
> Ideas?

Never rely on aliasing or environment variables for defaults, and never
change default behavior if your releases are old enough that someone
has built scripts on top of them.  ;)

	fprintf(stderr, "Deleting subvolume '%s' in 5 seconds.\n", subvol_path);
	if (!f_flag_on_cmd_line) {
		fprintf(stderr, "If this is not what you want,\n");
		fprintf(stderr, "*** PRESS Ctrl-C TO ABORT NOW!!! ***\a\n");
		sleep(5);
	}

Of course, in an init-shell-type environment, Ctrl-C doesn't work
either...

If I had to pick the least evil, I'd go for interactive prompting by
default (do nothing if the interaction fails, e.g. no TTY) and add a
'-f'/'--force' flag to bypass the prompt.  This is consistent with the
way lvm2 and mdadm work when presented with data-losing or otherwise
questionable commands and parameters.  It will break scripts, but btrfs
users should still be expecting that for a while as undesirable default
behaviors are identified.

OTOH maybe there is no issue with the current behavior.  Only root can
delete subvolumes, and maybe we assume root knows what they're doing?

On a side note...only root can delete subvolumes, but non-root users
can create them, which results in...this:

	$ /sbin/btrfs sub create foo
	Create subvolume './foo'
	$ date > foo/bar
	$ /sbin/btrfs sub delete foo
	Transaction commit: none (default)
	Delete subvolume '/home/testuser/foo'
	ERROR: cannot delete '/home/testuser/foo' - Operation not permitted
	$ rm -rf foo
	rm: cannot remove `foo': Operation not permitted
	$ cat /proc/version
	Linux version 3.17.1-zb64+ (root@buildbot) (gcc version 4.7.2 (Debian 4.7.=
2-5) ) #1 SMP PREEMPT Tue Oct 21 00:17:49 EDT 2014

=2E..uh oh?

> --=20
> Shriramana Sharma =E0=AE=B6=E0=AF=8D=E0=AE=B0=E0=AF=80=E0=AE=B0=E0=AE=AE=
=E0=AE=A3=E0=AE=B6=E0=AE=B0=E0=AF=8D=E0=AE=AE=E0=AE=BE =E0=A4=B6=E0=A5=8D=
=E0=A4=B0=E0=A5=80=E0=A4=B0=E0=A4=AE=E0=A4=A3=E0=A4=B6=E0=A4=B0=E0=A5=8D=E0=
=A4=AE=E0=A4=BE
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4mUolEm2oNas7DxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR9LnsACgkQgfmLGlazG5wLTACdHz/czQZ6XudlWm+pcI28FyBF
clMAoIb1LtwD5V+KjwxPjMlGIHHfmMfa
=Umkf
-----END PGP SIGNATURE-----

--4mUolEm2oNas7DxE--
