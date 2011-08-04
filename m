From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: btrfs-progs repository
Date: Thu, 4 Aug 2011 11:14:25 +0100
Message-ID: <CAAeznTrRTuWQD64HRxE0Q2GAL_ZivQdJyGU_KL8P=9+43eq27w@mail.gmail.com>
References: <CAAeznTpDgdQ3T8MGrNXAE2H6K4fO27sDNQADaXkx7J=_Epzf6A@mail.gmail.com>
	<20110804100142.GB28326@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Leonidas Spyropoulos <artafinde@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110804100142.GB28326@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 4, 2011 at 11:01 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Aug 04, 2011 at 10:45:30AM +0100, Leonidas Spyropoulos wrote:
>> Why the official repository is not updated with the latest patched f=
or gcc 4.6?
>> I noticed that http://git.darksatanic.net/repo/btrfs-progs-unstable.=
git/
>> includes more patches than the
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unst=
able.git
>>
>> So I was wondering is it some kind of testing to be done on patches =
to
>> be included into the official repo?
>
> =A0 There have been a lot of patches published in the 9 months or so
> since the upstream repo was last updated -- Chris has been
> concentrating on other things (like kernel-side stability and the new
> fsck). I pulled them all into one place and started to try to make
> sense of them all, which is the ongoing work that is the darksatanic
> repo.
>
> =A0 There's a for-chris branch (which is actually the same as my mast=
er
> branch now), which is the "stable" patches that have (mostly) been
> reviewed. Then there's the integration-* branches, which are general
> dumps of things that aren't ready to go upstream yet, but which I'm
> publishing simply to get patches available for testing (particularly
> new features like scrub).
>
> =A0 I should probably send Chris another pull request. :)
The only reason for me to search the mailing list for an alternative
repository (and I send the message after) was because with the latest
stable gcc 4.6 it doesn't compile due to some unused variables
(WARNINGS) so your repository seems to compile fine.
I wasn't after some cool new untested feature tbh, just the latest
btrfs. Would be cool to update it.
>
>> Another thing is that there are commands for creating the build
>> enviroment for fedora and debian but I found nowhere in the wiki the
>> dependencies of the btrfs-progs to compile them.
>> Shouldn't be a list of packages or dependencies for it?
>
> =A0 The website is a wiki, so feel free to update the instructions wi=
th
> anything you've found to be missing. And I'll happily accept patches
> to any instructions that are shipped with the userspace tools. :)
I would be happy to update the wiki if I knew the dependencies :P
And I don't know what you mean with the patched to userspace tools,
sorry for my naiveness.
(even If I make a patch I don't know how to actually produce the
standartize patch mails I see on the mailing list, but that's out of
the mailing list question; would be grateful in an off-the-list email
with instructions).

>
> =A0 (I believe the only dependencies are libuuid and libxattr --
> whatever they're called on $distribution).
No idea and when I searched on Arch linux for those packages didn't
find any with that name, should be under another package.

>
> =A0 Hugo.
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org=
=2Euk
> =A0 =A0 =A0 =A0--- emacs: =A0Eighty Megabytes And Constantly Swapping=
=2E ---
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iD8DBQFOOm4GIKyzvlFcI40RAhsRAJ9G+zIkvJcOAxJp/bACRlLFYqbwIwCggMaU
> mMaunZQG3NDI4yazFuC517Y=3D
> =3DGQRp
> -----END PGP SIGNATURE-----
>
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
