From: Arvin Schnell <aschnell@suse.de>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Fri, 2 Mar 2012 12:34:21 +0100
Message-ID: <20120302113421.GA6214@suse.de>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com> <1330484376-16178-2-git-send-email-anand.jain@oracle.com> <CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 01, 2012 at 05:54:40AM -0600, cwillu wrote:

> There doesn't appear to be any reason for the scratch file to exist a=
t
> all (one can build up the hash while reading the directories), and
> keeping a scratch file in /etc/ is poor practice in the first place
> (that's what /tmp and/or /var/run is for).  It's also a lot of io to
> stat every file in the subvolume every time you make a snapshot, and
> I'm not convinced that the walk is actually correctly implemented:
> what stops an autosnap of / from including all of /proc and /sys in
> the hash?
>=20
> Perhaps all that is unnecessary:  rather than doing the walk, why not
> make use of btrfs subvolume find-new (or rather, the syscalls it
> uses)?

While developing snapper I faced similar problems and looked at
find-new but unfortunately it is not sufficient. E.g. when a file
is deleted find-new does not report anything, see the reply to my
mail here one year ago [1]. Also for newly created empty files
find-new reports nothing, the same with metadata changes.

If I'm wrong or find-new gets extended I happy to implement it in
snapper.

Regards,
  Arvin

[1] http://www.spinics.net/lists/linux-btrfs/msg08683.html

--=20
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6=
rffer, HRB 16746 (AG N=FCrnberg)
Maxfeldstra=DFe 5
90409 N=FCrnberg
Germany
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
