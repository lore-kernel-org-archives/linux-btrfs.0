From: =?us-ascii?Q?Jaromir=20Zdrazil?= <jaromir.zdrazil@email.cz>
Subject: =?us-ascii?Q?Re=3A=20Re=3A=20Re=3A=20Two=20way=20mirror=20in=20BRTFS?=
Date: Sat, 31 Dec 2011 01:19:57 +0100 (CET)
Message-ID: <135575.22658.59661-9122-588047049-1325290797@email.cz>
References: <925a66c275d286669ba618e277e99cc3.squirrel@webmail.decarpentier.com>
Reply-To: jaromir.zdrazil@email.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Cc: linux-btrfs@vger.kernel.org
To: =?us-ascii?Q?Niels=20de=20Carpentier?= <niels@decarpentier.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <925a66c275d286669ba618e277e99cc3.squirrel@webmail.decarpentier.com>
List-ID: <linux-btrfs.vger.kernel.org>

> ------------ P=F9vodn=ED zpr=E1va ------------
> Od: Niels de Carpentier <niels@decarpentier.com>
> P=F8edm=ECt: Re: Re: Two way mirror in BRTFS
> Datum: 30.12.2011 16:15:51
> ----------------------------------------
> >>
> >> You mean like "zfs send -i"? If yes, why not just use zfs? There's
> >> zfsonlinux project, with easy-to-install ppa for ubuntu. Or you co=
uld
> >> compile it manually.
> >>
> > Thank you for your suggestion. As I know, there is not everything p=
orted
> > yet, and one of the missing important features I plan to use is to =
crypt
> > fs. And if I am not mistaken, current version does not yet support =
a
> > mountable filesystem.
>=20
> You are mistaken :) The current version is pretty stable, as long as =
you
> don't use compression or dedup. Some problems have been reported with
> weird setups (USB disks for example), but I haven't seen any reports =
of
> unrecoverable filesystems.
>=20
Thank you for the info. What I wanted from the fs was 108% acuracy, cry=
pt fs, at least some kind one way mirror, two way would be best and com=
pression of the fs would be nice.

Now it seems, that neither of the fsses cancrypt under linux, ZFS is ac=
curate&can reconstruct, BTRFS is accurate&can reconstruct only in mirro=
r, BTRFS can make live incremental backups/snapshots, ZFS can make also=
 send ... and one or two way mirror are future plans for linux ;O)

> For btrfs bugs are still fixed on a daily basis, and some reports of
> people with corrupted and unrecoverable filesystems.
>=20
> Neither supports encryption.
>=20
> I might consider ZFS for a production environment (although it's
> officially not production ready), but I don't think btrfs is ready fo=
r
> that yet. If you want to be safe, use ext4 with drbd or rsync.
>=20
> Niels
>=20
Hmm, I have concluded this afternoon, than ZFS under linux does not hav=
e what I would like to have, but there seems no better solution under l=
inux for now ... thanks for your experience! It helps me a lot. Jaromir
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
