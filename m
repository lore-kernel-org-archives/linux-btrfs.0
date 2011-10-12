From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: btrfs-progs: new integration branch out
Date: Wed, 12 Oct 2011 11:50:01 -0500
Message-ID: <CAKcLGm_KAaumCLY+aO4suh=J6tcY85ktSMhAxq+av0G1gDw6+w@mail.gmail.com>
References: <20111012123411.GC21931@carfax.org.uk>
	<CAG1y0sdm17RGcqVRakE6355iicsSmQ9vF23Kw9h5jm+7C22Fyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdm17RGcqVRakE6355iicsSmQ9vF23Kw9h5jm+7C22Fyw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2011 at 10:22 AM, Fajar A. Nugraha <list@fajar.net> wro=
te:
> On Wed, Oct 12, 2011 at 7:34 PM, Hugo Mills <hugo@carfax.org.uk> wrot=
e:
>> =A0 Fixes or updated patches for any problems you may find are
>> welcomed, of course.
>
> I noticed that "btrfs subvolume snapshot" is now broken. It keeps on
> saying "Invalid arguments for subvolume snapshot".
>
> Further checking shows it's caused by
>
> commit f71210f87e0c684d8c76dfa2e19ea86256fc3d1f
> Author: Andreas Philipp <philipp.andreas@gmail.com>
> Date: =A0 Thu Aug 11 08:45:40 2011 +0200
>
> =A0 =A0check number of args for btrfs sub snap correctly
>
> =A0 =A0Check whether there are the right number of arguments (exatly =
2 without
> =A0 =A0the flag -r) in the subcommand handler for the btrfs subvolume=
 snapshot
> =A0 =A0command.
>
>
>
> changing
>
> =A0 =A0 =A0 if (argc - optind !=3D 3) {
>
> back to
>
> =A0 =A0 =A0 if (argc - optind !=3D 2) {
>
> makes the snapshot creation works again, tested both with and without
> "-r" on Ubuntu Natty + kernel 3.1.0-rc9. I reverted that commit for m=
y
> system for now.
>

It looks like there have been two patches that touched on this issue,
and they conflicted with one-another.

Arne Jansen's "btrfs-progs: add qgroup commands" patch added a "optind
=3D 1;" line, where optind was defaulting to zero before.

This conflicted with Hugo Mills"fix incorrect argument checking for
"btrfs sub snap -r"" patch.

So it looks like "(argc - optind !=3D 2)" is now correct.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
