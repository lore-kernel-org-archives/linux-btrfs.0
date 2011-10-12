From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs-progs: new integration branch out
Date: Wed, 12 Oct 2011 22:22:45 +0700
Message-ID: <CAG1y0sdm17RGcqVRakE6355iicsSmQ9vF23Kw9h5jm+7C22Fyw@mail.gmail.com>
References: <20111012123411.GC21931@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111012123411.GC21931@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2011 at 7:34 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> =A0 Fixes or updated patches for any problems you may find are
> welcomed, of course.

I noticed that "btrfs subvolume snapshot" is now broken. It keeps on
saying "Invalid arguments for subvolume snapshot".

=46urther checking shows it's caused by

commit f71210f87e0c684d8c76dfa2e19ea86256fc3d1f
Author: Andreas Philipp <philipp.andreas@gmail.com>
Date:   Thu Aug 11 08:45:40 2011 +0200

    check number of args for btrfs sub snap correctly

    Check whether there are the right number of arguments (exatly 2 wit=
hout
    the flag -r) in the subcommand handler for the btrfs subvolume snap=
shot
    command.



changing

       if (argc - optind !=3D 3) {

back to

       if (argc - optind !=3D 2) {

makes the snapshot creation works again, tested both with and without
"-r" on Ubuntu Natty + kernel 3.1.0-rc9. I reverted that commit for my
system for now.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
