Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38799 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaERKKY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 06:10:24 -0400
Date: Sun, 18 May 2014 11:10:18 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140518101018.GA5783@carfax.org.uk>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140416171219.GC29256@twin.jikos.cz>
 <20140517174315.GC2537@carfax.org.uk>
 <5378587B.5010205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
In-Reply-To: <5378587B.5010205@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 18, 2014 at 02:51:39PM +0800, Qu Wenruo wrote:
>=20
> -------- Original Message --------
> Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
> page for each btrfs subcommand.
> From: Hugo Mills <hugo@carfax.org.uk>
> To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
> linux-btrfs@vger.kernel.org, clm@fb.com
> Date: 2014=E5=B9=B405=E6=9C=8818=E6=97=A5 01:43
> >On Wed, Apr 16, 2014 at 07:12:19PM +0200, David Sterba wrote:
> >>On Wed, Apr 02, 2014 at 04:29:11PM +0800, Qu Wenruo wrote:
> >>>Convert the old btrfs man pages to new asciidoc and split the huge
> >>>btrfs man page into subcommand man page.
> >>I'm merging this patchset into the base series of integration because
> >>several patches need to update the docs and it's no longer feasible to
> >>keep it in a separate branch from the patches.
> >    I've just been poking around in the docs for a completely different
> >reason, and I think there's a fairly serious problem (well, as serious
> >as problems get with documentation).
> >
> >    Take, for example, the format for btrfs fi resize:
> >
> >'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::
> >
> >    Now, this has just thrown away all of the useful markup which
> >indicates the semantics of the command. The asciidoc renders all of
> >that text literally and unformatted, making alphasymbolic(*) soup of
> >the docs. Compare this to the old roff man page:
> >
> >\fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm=
]|[\fIdevid\fP:]\fImax <path>\fP
> Yes, When I convert man pages to asciidoc docs, I have already realized t=
he
> problem.
> As mentioned in first patch, most things including the Makefile is 'stole=
n'
> from git,
> which means I also apply the git way to deal with the all 'useful' markup=
s,
> *just throw them away* .
> >
> >    This isn't perfect -- we're missing a \fB around the "max" -- but
> >it has text in bold(=E2=81=91) and italics(=E2=81=82) and neither(=E2=98=
=83). I've just looked
> >at some of the other pages, and they've also got similar typographical
> >problems. This is a lot of fiddly tedious work to get it right, and if
> >it doesn't get done now in the initial commit, then we're going to end
> >up with poor examples copied for every new feature or docs update,
> >making the problem worse before anyone does the work to make it
> >better.
> As I mentions above, it's meant to be like this, without extra markup just
> like git.
>=20
> I choose asciidoc and the git documentation style for the following purpo=
se:
>=20
> 1) Split up the huge 'btrfs' man page. (Main purpose of the patchset)
>=20
> The 'btrfs' man page is so huge that the synopsis is serveral pages long,
> force developers to edit man page twice(one for synopsis and one for
> command).
> This makes editing frustrating and easy to make things inconsistent.
> (serveral synopsis and command description are already inconsistent)

   I don't have a problem with that, but it's irrelevant to my point.

> 2) Make the documenation more general purpose. (Why choose asciidoc)
>=20
> Not only generating man pages, but also html/pdf, much like git.

   I have no objections at all to that either. It's a great idea. But
again, it's orthogonal to my main point here, which is that we've lost
useful semantics, because the markup _is_ part of the meaning of the
document.

> 3) Make the original txt more human readable (Why choose git style)
>=20
> I can use the old markup method but after doing that I realize if you rea=
d a
> document full of
> markups, the markups have alread lost their meaning.
>=20
> If using too many markup, there will be other problems:
>     3.1) making the synopsis in original txt too long
>=20
>             This will make both developer and reviewer harder to
> edit/review.
>             I choose asciidoc to reduce the hard-to-understand groff
> grammar, if these \fX are
>             just converted to ' or `, IMO the cost is still not cut.

   I don't think we should be throwing away meaning just because it
makes things shorter in the source.

>     3.2) the markup is not so highlighted if every thing is highlighted
>=20
>             So I choose only to highlight really important things, since
> with all the bold and itatlic
>             things full of the page, there is no difference between all
> normal formatted text.

   I'm only talking about two things: the syntactic summaries, where
we need to distinguish between literals, placeholders and descriptive
elements like []; and "command text" where we distinguish between the
descriptive English text and the stuff you type. This second point is
particularly important for us because so many of our commands consist
of recognisable English words strung together, and having the literal
commands shown in a distinctive style (typically a monospace font)
helps enormously with parsing the text when reading at speed.

> Due to the above 3 reasons, I think throwing all markup in synopsis is a
> better choice.

   I disagree strongly.

   Hugo.

> Thanks,
> Qu
> >
> >    Hugo.
> >
> >(*) Or possibly alphashambolic. :)
> >(=E2=81=91) For literal text
> >(=E2=81=82) For variables that require substitution by the user
> >(=E2=98=83) For structural syntax indicators such as [] for optional par=
ts, |
> >     for alternation and ... to indicate optional continuation of a list
> >
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Two things came out of Berkeley in the 1960s: LSD and Unix. ---  =20
                       This is not a coincidence.                       =20

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3iHClheFHXiqx3kAQJM9Q//ZXX6JW4xeMAygH5gvt8TqtKXkJaiJbGK
qYs/MOS6k5+xqJLpNvVmIyhC877jVmHhIi3smibOTClXMUKutYUqxBG3T/gcxQ1s
/8DNFkaKyl0Hd1ZUgZy6O+I9ZeaDSgbmZffze+rUNDD6+hNwjspAmw8BIkc5nbrf
7UIlSgqh1f7PWwsow75N9ljT9qeuNARrFEa3kclffxMjo4LLPnZJFgGOum51Q/m0
IMpZu7PkS9fMghaxCMEcva+p6MoU9L24AOR+XB9WKosyJynak6YBTwSqHwTzqk9+
4ISX9Z/KnKI7nWYzG2kELXdspxlam6NS/yADJ8GOjTNRr8+1LIWtGL6VIOslOPVg
CWZ2qI/jcAVKpYHBypZiTtRcX4UsJDar8UcSaqdAkYcE1ZAXVebBIOtI21rwyOfz
uTBiUZ50zH9gvHbFCEB3FvnkcJe3FXzHStthkakbzMKqj53yUM9a/42gj2/Nybys
dGiH9EXMuZyuYO8YugmyYzJEzCqc5wYi6+mER4XyknkXpo9Dofa8GA25+iMJ9Mdo
NWv7NFyTmAGgs9/N4ep/MjlagfpJx+9zjXr3V8N42bGMOoV2+r36DZsIzakoi4XF
moS2PsSnaEqTmw8nBEVDXM38kvGOOT6ZYe04XgFT4RttAdnrtDdX8ulDRYoBr6zz
uQwpWovHJjg=
=u9/U
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
