Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:43258 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab2JCGex (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 02:34:53 -0400
Date: Wed, 3 Oct 2012 12:34:46 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?B?U8OpYmFzdGllbg==?= Maury <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS] btrfs filesystem disk-usage
Message-ID: <20121003123446.4e4db403@natsu>
In-Reply-To: <CAJHuE_BmvmEteSg8YgcHH3cuB27Bi-j-B=yS7Y2NFhb1L5_Aog@mail.gmail.com>
References: <1349202970-6700-1-git-send-email-kreijack@gmail.com>
	<20121002234637.GF3214@shiny>
	<CAJHuE_BmvmEteSg8YgcHH3cuB27Bi-j-B=yS7Y2NFhb1L5_Aog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/C7dUfDJ/ZwN7LUewAOZi7.6"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/C7dUfDJ/ZwN7LUewAOZi7.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Oct 2012 08:22:06 +0200
Goffredo Baroncelli <kreijack@gmail.com> wrote:

> On Wed, Oct 3, 2012 at 1:46 AM, Chris Mason <chris.mason@fusionio.com> wr=
ote:
> [...]
> > I like it, thanks.  Could you please update btrfs fi df to show this
> > instead of adding a new command though?
>=20
> Hi Chris,
> no problem to update the patches, however I have one suggestion:
> - leave "btrfs fi df" as is to no break any script (if any) which
> would uses it. Hide it from the help and deprecating it in the man
> page. This because the output is very different.
> - renaming "btrfs fi disk-usage" in "btrfs fi disk-free", which make sens=
e.

1) btrfs is still labeled experimental, so no script author should have
seriously relied on utilities text output to stay unchanged long-term;
personally I don't see modifying it (especially not in some superficial way,
but as a part of major improvement) to be a problem;

2) "disk-usage" and "disk-free" are both way too awkward and too long to ty=
pe,
compared to "fi df", and "df" is the expected shorthand for "disk free" in =
the
UNIX land.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/C7dUfDJ/ZwN7LUewAOZi7.6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBr3IYACgkQTLKSvz+PZwiJ+QCeP/A9YRBlCYOdrFRIDcH4zpb1
HMYAmgLMKQ4aHX0nEW6VJWXPztCGCVLL
=2XBb
-----END PGP SIGNATURE-----

--Sig_/C7dUfDJ/ZwN7LUewAOZi7.6--
