From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH] [btrfs-progs integration] incorrect argument checking
 for "btrfs sub snap -r"
Date: Thu, 30 Jun 2011 22:55:15 +0200
Message-ID: <4E0CE2B3.1080600@gmail.com>
References: <chaz20110629143747.GA28702@seebyte.com> <chaz20110629150041.GB28702@seebyte.com> <4E0BC7AA.7000709@cn.fujitsu.com> <chaz20110630084046.GC28702@seebyte.com> <4E0C3F72.5040508@gmail.com> <chaz20110630104340.GD28702@seebyte.com> <20110630105813.GD11170@carfax.org.uk> <chaz20110630123438.GE28702@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110630123438.GE28702@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 30.06.2011 14:34, Stephane Chazelas wrote:
> Looks like this was missing in integration-20110626 for the
> readonly snapshot patch:
>
> diff --git a/btrfs.c b/btrfs.c
> index e117172..be6ece5 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -49,7 +49,7 @@ static struct Command commands[] = {
> /*
> avoid short commands different for the case only
> */
> - { do_clone, 2,
> + { do_clone, -1,
> "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
> "Create a writable/readonly snapshot of the subvolume <source> with\n"
> "the name <name> in the <dest> directory.",
>
> Without that, "btrfs sub snap -r x y" would fail as it's not *2*
> arguments.
Unfortunately, this is not correct either. "-1" means that the minimum
number of arguments is 1 and since we need at least <source> and
<name> this is 2. So the correct version should be -2.

Thanks,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJODOKyAAoJEJIcBJ3+XkgiEzEP/1vXuvIqPvWQ6Yg3KGW31vZB
80BZRUIKJQel2VqZ8NN4mNJoXPsQ3r21gTv9aZQwHHnCRszBCDqo5uhJUIKfVsWX
WIOkQo6uJLUeO5tCwuIGBDwzy8WBgFyCNhUT06GVNJxNP2WZddsp3Wo540Mmmoof
en3+4SPC5godW2+t80811le+bfQpZ1N+Q2MXLTx0ilvt3y2cCjoV26yIhRj1mzOn
QBKRZCwvMafmE9jBdZLIx4h+W3agT3EWQj9F7c4ZsJFsrc5SJWtjMNZrWg8aRtYR
YFcHwuAH4IzVHxB0a84tiCtH+N+fnmQpXUWUZGjJLODgmJnJ+wq/vi1ek2J8Dw+c
pF3E+U6oy/bX/sQ7Ef/Zxs3qlp88hgLypd9Y2/Lk7i0XmKNYxpg9KisMiAS+Ensa
ucb0lNxB1rCSEtN48JfWJ55aA0Yh4B1WompXuRseekcVKFuOW/OqBkE73Q0YBSQo
FogqVGvrdmfgAeC8Uft83oo1zXXNYoxIpP5PjPgmpgwBQihZDHfVqbagFhKnRsRq
bsXyzl2C7SkgVUxtuD3/Co3uyFm/So9MsgJmkcDDGo4APhUGxSOxGqhWo49C/1CZ
xfUSC1+rYnzTwK+5vhjbJjjXTdjaRGprcEH0803+cVikPdOSYfKsztrf+9OGSAp7
J+vEuVEESjhEcn2ySfSx
=bSbf
-----END PGP SIGNATURE-----

