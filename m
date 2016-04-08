Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56442 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbcDHLM5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 07:12:57 -0400
Date: Fri, 8 Apr 2016 11:12:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive using generation number as source
Message-ID: <20160408111254.GU29474@carfax.org.uk>
References: <7303236.im7zcVY3uK@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7XuS4gr/+Xj300Yp"
In-Reply-To: <7303236.im7zcVY3uK@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7XuS4gr/+Xj300Yp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 08, 2016 at 01:01:03PM +0200, Martin Steigerwald wrote:
> Hello!
>=20
> As far as I understood, for differential btrfs send/receive =E2=80=93 I d=
idn=C2=B4t use it=20
> yet =E2=80=93 I need to keep a snapshot on the source device to then tell=
 btrfs send=20
> to send the differences between the snapshot and the current state.
>=20
> Now the BTRFS filesystems on my SSDs are often quite full, thus I do not =
keep=20
> any snapshots except for one during rsync or borgbackup script run-time.
>=20
> Is it possible to tell btrfs send to use generation number xyz to calcula=
te=20
> the difference? This way, I wouldn=C2=B4t have to keep a snapshot around,=
 I=20
> believe.

   btrfs sub find-new

   BUT that will only tell you which files have been added or updated.
It won't tell you which files have been deleted. It's also unrelated
to send/receive, so you'd have to roll your own solution.

> I bet not, at the time cause -c wants a snapshot. Ah and it wants a
> snapshot of the same state on the destination as well. Well on the
> destination I let the script make a snapshot after the backup so=E2=80=A6
> what I would need is to remember the generation number of the source
> snapshot that the script creates to backup from and then tell btrfs
> send that generation number + the destination snapshots.

> Well, or get larger SSDs or get rid of some data on them.

   Those are the other options, of course.

   Hugo.

--=20
Hugo Mills             | The trouble with you, Ibid, is you think you know
hugo@... carfax.org.uk | everything.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--7XuS4gr/+Xj300Yp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXB5I2AAoJEFheFHXiqx3kO/4P/iLeWfZI/kyDe7ClRNn7NZ1f
tbFpbq6brUxwT5QhyfotEeJU8gIyVAZH1ikocJ/hR2qgmxO98VDGaoN7DwV1f8ie
BqWYEgTipidAJlR49dWTTUQONSagazRR6VyciV+tqhjSxpOWRkJR0j4UpmXlqgUe
YYZTTjuf6u79iZZ5UB8Hyk2Ep9Qbf3XWpb6EWzF3Gnd/Hw8F6bvxFgZ5NfJvDxK4
1+Jtsot+nM5AIHtaiXuqSXRlRTeqwwA6bIvpAtk5r1ZGtPN63cZKEnQEx0Q5KVa+
4ji0+0MUniRjHiTrbFX8pyjeZyTWgJFwxUS7I1mS2XiEBWlvQuEzL7VIEE4TUs1W
moijbjnFXrEOOkdAgvTwCbtCl81LTGqzM8f79rCkp+Z4dFLKtIxooE3nTI7v1LAX
jPz5P8hXKJFzboxBMjjbpdLbWnzXAySVTIOljkmk2wa3/WrgYwwyDOi4TJvM8oA1
j+daSawV0bNQsFvTt+q0eS/wvxwyL71FAzwF/ELbg/wW4/vKVbzjKlEew5Gglpdu
YkZPbHc2zJAUoxWufp1iIVf8j3WVYLDNAtCu9XFhOaVd9Hk83rDZc46hQExLybkb
9Swm7WE12QeOGitg2P2g1g5/rm3BADeCvF/Emi+XVC5b4UL2LxP18DDpjLq5n1lb
kY18/qVhP1ffO1qF5hSh
=LrdR
-----END PGP SIGNATURE-----

--7XuS4gr/+Xj300Yp--
