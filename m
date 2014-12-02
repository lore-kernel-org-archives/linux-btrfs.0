Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44020 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932172AbaLBPZ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 10:25:57 -0500
Date: Tue, 2 Dec 2014 10:25:55 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: dsterba@suse.cz, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141202152555.GA17395@hungrycats.org>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <20141202125252.GR12140@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ohyzAr2DuZRs7WU"
In-Reply-To: <20141202125252.GR12140@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7ohyzAr2DuZRs7WU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2014 at 01:52:52PM +0100, David Sterba wrote:
> > On a side note...only root can delete subvolumes, but non-root users
> > can create them, which results in...this:
> >=20
> > 	$ /sbin/btrfs sub create foo
> > 	Create subvolume './foo'
> > 	$ date > foo/bar
> > 	$ /sbin/btrfs sub delete foo
> > 	Transaction commit: none (default)
> > 	Delete subvolume '/home/testuser/foo'
> > 	ERROR: cannot delete '/home/testuser/foo' - Operation not permitted
> > 	$ rm -rf foo
> > 	rm: cannot remove `foo': Operation not permitted
> > 	$ cat /proc/version
> > 	Linux version 3.17.1-zb64+ (root@buildbot) (gcc version 4.7.2 (Debian =
4.7.2-5) ) #1 SMP PREEMPT Tue Oct 21 00:17:49 EDT 2014
> >=20
> > ...uh oh?
>=20
> That's how it works now. I'd like to enable the user to delete their
> subvolumes even without the user_subvol_rm_allowed option someday.

That seems...odd.  It should be symmetrical, i.e. if you can create a
subvol you should be able to delete it, and if can't delete a subvol
then you shouldn't be able to create them either.  I can imagine
quite a bit of havoc could be wrought by an unprivileged user creating
subvols indiscriminately (or in various specific, targeted locations).

--7ohyzAr2DuZRs7WU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR92gMACgkQgfmLGlazG5yfzwCgnpmIcTXJBqJsYCOGoBRuWjid
gsAAoJ5RcvIvj1szsRIh3wuVvSiN/k9j
=dWdb
-----END PGP SIGNATURE-----

--7ohyzAr2DuZRs7WU--
