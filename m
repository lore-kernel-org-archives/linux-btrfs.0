Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47353 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752067AbaLCTtJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 14:49:09 -0500
Date: Wed, 3 Dec 2014 14:49:08 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: dsterba@suse.cz, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141203194908.GX17380@hungrycats.org>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <20141202125252.GR12140@twin.jikos.cz>
 <20141202152555.GA17395@hungrycats.org>
 <20141203184843.GW12140@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mgIE+9cwyCTt+85Z"
In-Reply-To: <20141203184843.GW12140@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mgIE+9cwyCTt+85Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2014 at 07:48:43PM +0100, David Sterba wrote:
> On Tue, Dec 02, 2014 at 10:25:55AM -0500, Zygo Blaxell wrote:
> > On Tue, Dec 02, 2014 at 01:52:52PM +0100, David Sterba wrote:
> > > > On a side note...only root can delete subvolumes, but non-root users
> > > > can create them, which results in...this:
> > > >=20
> > > > 	$ /sbin/btrfs sub create foo
> > > > 	Create subvolume './foo'
> > > > 	$ date > foo/bar
> > > > 	$ /sbin/btrfs sub delete foo
> > > > 	Transaction commit: none (default)
> > > > 	Delete subvolume '/home/testuser/foo'
> > > > 	ERROR: cannot delete '/home/testuser/foo' - Operation not permitted
> > > > 	$ rm -rf foo
> > > > 	rm: cannot remove `foo': Operation not permitted
> > > > 	$ cat /proc/version
> > > > 	Linux version 3.17.1-zb64+ (root@buildbot) (gcc version 4.7.2 (Deb=
ian 4.7.2-5) ) #1 SMP PREEMPT Tue Oct 21 00:17:49 EDT 2014
> > > >=20
> > > > ...uh oh?
> > >=20
> > > That's how it works now. I'd like to enable the user to delete their
> > > subvolumes even without the user_subvol_rm_allowed option someday.
> >=20
> > That seems...odd.  It should be symmetrical, i.e. if you can create a
> > subvol you should be able to delete it, and if can't delete a subvol
> > then you shouldn't be able to create them either.
>=20
> It should and I don't know the exact reasons why it's been restricted.
> AFAICS it should be safe to enable the user_subvol_rm_allowed mode by
> default.
>=20
> > I can imagine
> > quite a bit of havoc could be wrought by an unprivileged user creating
> > subvols indiscriminately (or in various specific, targeted locations).
>=20
> Is this different from creating directories the same way?

'rmdir' doesn't know how to delete an empty subvolume, so neither does
'rm -rf', 'rsync --delete', or probably a thousand other independently
developed file-handling admin tools.

	buildbot:~# btrfs sub create /tmp/foo
	Create subvolume '/tmp/foo'
	buildbot:~# rmdir /tmp/foo
	rmdir: failed to remove `/tmp/foo': Operation not permitted

It seems unreasonable to require all the existing admin tools to learn
a new way to delete something that a non-root user can create, when we
could just teach btrfs rmdir to delete subvols instead.

> There is a difference in metadata consumption between subvolume and
> directory, but this would lead to "just" ENOSPC.

There's another subtle havoc-wreaking semantic difference between a
directory and a subvolume:  if a user has an open file on a subvolume,
the file can be deleted, but the subvolume can't:

	buildbot:~# cd /tmp/foo
	buildbot:/tmp/foo# ls -l
	total 0
	buildbot:/tmp/foo# exec 9>file
	buildbot:/tmp/foo# date >&9
	buildbot:/tmp/foo# cat file
	Wed Dec  3 14:40:24 EST 2014
	buildbot:/tmp/foo# rm file
	buildbot:/tmp/foo# cd ..
	buildbot:/tmp# ls foo/
	buildbot:/tmp# btrfs sub del foo
	Transaction commit: none (default)
	Delete subvolume '/tmp/foo'
	ERROR: cannot delete '/tmp/foo' - Device or resource busy

Close the file and subvol del works again:

	buildbot:/tmp# exec 9>&-
	buildbot:/tmp# btrfs sub del foo
	Transaction commit: none (default)
	Delete subvolume '/tmp/foo'
	buildbot:/tmp# ls foo/
	ls: cannot access foo/: No such file or directory

	buildbot:/tmp# cat /proc/version
	Linux version 3.17.2-zb64+ (root@buildbot) (gcc version 4.7.2 (Debian 4.7.=
2-5) ) #1 SMP PREEMPT Thu Nov 13 21:57:39 EST 2014

--mgIE+9cwyCTt+85Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR/aTQACgkQgfmLGlazG5wmQACgprqkPqYABN+iIOTvThQLxfIq
AGYAn3/L4C0ItWzX04GGWzoIIV+EaJO8
=Aubg
-----END PGP SIGNATURE-----

--mgIE+9cwyCTt+85Z--
