Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56429 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbbKXXaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 18:30:03 -0500
Date: Tue, 24 Nov 2015 23:30:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: subvols and parents - how?
Message-ID: <20151124233000.GX24333@carfax.org.uk>
References: <1448340960.14125.51.camel@scientia.net>
 <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
 <1448400350.21291.88.camel@scientia.net>
 <20151124215542.GT24333@carfax.org.uk>
 <1448407209.21291.112.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tkgHWL40pCDFFyey"
In-Reply-To: <1448407209.21291.112.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tkgHWL40pCDFFyey
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2015 at 12:20:09AM +0100, Christoph Anton Mitterer wrote:
> On Tue, 2015-11-24 at 21:55 +0000, Hugo Mills wrote:
> > =A0 =A0In practice, new content is checked by a number of people when
> > it's
> > put in, so the case of someone putting random poorly-thought-out crap
> > in the wiki isn't particularly likely to happen.
> Well... it may work in 99% cases... but there could something slip
> through, which isn't as easy the case in manpages, which also tend to
> be less messy than the huge pile of wiki pages where similar/related
> things are described on different pages.
>=20
> Imagine a case, a non-experienced user update the wiki saying that --
> repair should be used, he may not even doing it in bad faith, perhaps
> he had success with it and now writes a recipe.
> It may take a while until someone of the more experienced guys notices
> that and corrects it.

   You can get update notifications, with the diffs for each page, via
RSS. (At least, I do, and I think David and a few others monitor it in
the same way). The window of failure is fairly small, particularly in
view of the number of such "dangerous" changes made. The total
vulnerability is measured in hours per year...

> But if ", in the meantime had some fs corruptions,... I may experience
> already severe problems by following that suggestion... (and while I do
> have many backups of all my data, others may not, and if their life's
> data is concerned, they'd be screwed).
>=20
> So even if it takes you just a few hours to correct such rubbish, you
> know that Murphy's law may still hit n people during that time ;-)
>=20
>=20
> > Please feel free to add the things you'd like to see. As I said
> > above, we do check the docs on the wiki as they're changed, so if
> > you're wrong on some details, it won't be a major issue for very
> > long. If you want to discuss details before you write something,
> > start
> > a conversation -- either on here, or on IRC (or even on the Talk
> > pages
> > of the wiki).
> Well I can write a list together of things which I think should be part
> of some more general documentation (i.e. less documentation about
> options of the tools)... questions a complete newcomer to btrfs may
> have who needs however more than "just a filesystem".
>=20
>=20
> > =A0=A0=A0Note that the "parent" of send -p and of snapshots is not the =
same
> > relationship as the "parent" (containing subvol) of the tree
> > structure. This is an awkward nomenclature problem, and I'm not sure
> > how to fix it.
> Yeah, that was clear... :-)
> Maybe call the "parent" from send -p "base" or something like that...
> IMHO that would fit more as the parent there is more like a
> "fundament".

   Yes, that makes sense.

> Anyway, it's still not as bad as the usage of "RAID1" ;-)
>=20
>=20
> > because
> > you can't rename a subvol across another subvol boundary.
> That's not quite clear to me... I had subvols like that:
> /top/root/below-root
> /top/below-top
> and was able to move that to:
> /top/root/below-top
> /top/below-root
>=20
> i.e. not just changing names but swapping as in:
> mv /top/root/below-top /top/tmp
> mv /top/below-root /top/root/below-root
> mv /top/tmp /top/below-top
>=20
> with top, root, below-top and below-root all being the same subvols

   With a recent mv, it'll be doing doing reflink copies followed by
delete for all of the contents, which makes it pretty efficient, but I
think you'll find that the UUID of the subvols changes. (At least, I
hope it does. If it doesn't, then my mental model of what the FS is
doing is *really* screwed up).

   Hugo.

> Thanks a lot for your explanations :)
>=20
> Chris.



--=20
Hugo Mills             | Never underestimate the bandwidth of a Volvo filled
hugo@... carfax.org.uk | with backup tapes.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--tkgHWL40pCDFFyey
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVPL4AAoJEFheFHXiqx3kdVkP/RgHpKeKliQpXu4gBBkych0k
X/32XdWnICNXLoOW2a0NhBcL9rArii9YGaSdZC63g1pCcH4UjSriE+M22Vj0cO2i
EGtffzwX4T0tnnxyVAKtWe34URuNs5w/pb0R1+mP6+QqvBM2g05sJE52r62NBacy
ONG3FOHenuxriugj7GAqIfKLExF2E647fR3rkwAPu0tAORSumBEhn1JvDkne3fuZ
nDZsQnKC2U41uGXgFxq0GiCHKW7ep6/BUs7PIoj6aGRv2r8Y1jzrnnuG4KjUTBQA
wLeB2odmPdDWXVDE7Bkzi1LaqzKzVQLjmq+7psrG/an2qEkRsLskutTaYeCK7nWv
7VKiuRRG5Z55HpGTk4bBWJoJAJ4Hidm+knIIklfcTrL9bJNsk8uO1Bl8uBqvErDC
Q0JE4fJz8W4zmaXQeRejdByhoMnCJj3E65Cud4/vud5CcWkRnbkGWkwJHruAXwFg
8jS0XjVYfpTdEgL9eY7aLTQtPSc0HpYDuzXfDbj58eVTDD3tSJNvlcBuOOY3LenQ
RDKfU3HK7Z1Dieby2EXoEY8eypnn6MOMdFenKotmmNzCJDh7I9OktP9sISP2WhrW
qbwVOb/jqh89hpz6PNPVIaQR0C2sMAxh51R8HS8oRtfIn6cnxxja6kIIPplWDhNx
lzUin8C/CmJmlt/bALNs
=pK+Z
-----END PGP SIGNATURE-----

--tkgHWL40pCDFFyey--
