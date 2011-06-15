From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Block-level de-duplication?
Date: Wed, 15 Jun 2011 17:31:50 +0100
Message-ID: <20110615163150.GC17257@carfax.org.uk>
References: <74a2889dbc80754b492bcda4ee06b4ee.squirrel@webmail.jots.org>
 <20110615152614.GA17257@carfax.org.uk>
 <BANLkTinf4tJea2u6dEoFu5z++1KuOMKA1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Cc: Ken D'Ambrosio <ken@jots.org>, linux-btrfs@vger.kernel.org
To: Wilfrid Allembrand <wilfrid.allembrand@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinf4tJea2u6dEoFu5z++1KuOMKA1Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 15, 2011 at 06:03:34PM +0200, Wilfrid Allembrand wrote:
> Too bad it's not pushed further than that :(  That really could be a
> good feature saving a lot of space for some use cases !

   There are several different use cases, with different requirements.
My memory of the earlier discussion was that there would probably need
to be two different implementations of deduplication -- one "offline"
batch mode (examining the whole filesystem in one go), and one
"online" incremental mode (deduplication as data is written to disk).

   That complexity, plus what I think are probably some awkward corner
cases, is probably the main reason that nobody's working on dedup
right now. Oh, and that there's only a handful of people actually
developing code, and they've all got other (btrfs) work on their hands
right now.

   It's also not a feature we see many requests for -- fsck, changing
RAID levels, and RAID-5/6 are probably the most requested, from what I
can see. All of those are currently in progress at some level.

> Is encryption as well banned to end of the pipe ?

   Good encryption is *hard*. We've got good and reliable encryption
algorithm implementations in the kernel, which gives us half of the
job. The other half, however, is just as difficult, if not more so --
managing things like keys and block chaining methods (and probably
other stuff that I don't know about because I'm not a cryptographer).
None of the major developers on btrfs have (as far as I'm aware) much
experience of designing or implementing encryption systems, so it's
generally being deferred, because there are easier things with just as
large an impact to work on; at the very least, if they're not easier,
they're generally easier to work out when you've made a mistake...

> I was wondering : is there a tracker with the roadmap, the
> bugs/features in the pipe for the next releases ?

   No, probably the closest we've got is the project ideas page[1] on
the wiki.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Project_ideas

> 2011/6/15 Hugo Mills <hugo@carfax.org.uk>:
> > On Wed, Jun 15, 2011 at 11:13:26AM -0400, Ken D'Ambrosio wrote:
> >> Hey, all. =A0I'm just wondering if synchronous byte-level de-duplicati=
on is
> >> something that's even on the stove, or if it's just in the nebulous,
> >> "Yeah, maybe sometime" category?
> >
> > =A0 Josef posted a prototype deduplicator to this list earlier in the
> > year, as an RFC. It caused a lot of discussion about what was wanted
> > in dedup, but I don't think anyone took it any further than that.
> >
> > =A0 Hugo.
> >
> > --
> > =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.or=
g.uk =3D=3D=3D
> > =A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
> > =A0 =A0--- Anyone using a computer to generate random numbers is, of ---
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 course, =A0in a state of si=
n.
> >
> > -----BEGIN PGP SIGNATURE-----
> > Version: GnuPG v1.4.10 (GNU/Linux)
> >
> > iD8DBQFN+M8VIKyzvlFcI40RApQEAKC4F7cGdaTlCT19/dEOJJYS2K4edQCeImtQ
> > WzE2Vz/br5sKMhgr3UJjAHs=3D
> > =3D08oK
> > -----END PGP SIGNATURE-----
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- There are three things you should never see being made: laws, --- =20
                        standards,  and sausages.                       =20

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN+N52IKyzvlFcI40RAlcnAKDJi16bqfg9O3lQw3HvZf0HK8V/yQCglE8n
JSXISA1y7nZWX1AFMf91zBo=
=1GMy
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
