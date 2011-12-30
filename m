From: =?us-ascii?Q?Jaromir=20Zdrazil?= <jaromir.zdrazil@email.cz>
Subject: =?us-ascii?Q?Re=3A=20Re=3A=20Re=3A=20Two=20way=20mirror=20in=20BRTFS?=
Date: Fri, 30 Dec 2011 16:27:24 +0100 (CET)
Message-ID: <135550.23479.60309-2401-1978249025-1325258844@email.cz>
References: <CAG1y0sf8D1Nfzz90Dn5yun6d9CYjvT6xoZGo5DE29OkguHVuAw@mail.gmail.com>
Reply-To: jaromir.zdrazil@email.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Cc: linux-btrfs@vger.kernel.org
To: =?us-ascii?Q?Fajar=20A=2E=20Nugraha?= <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sf8D1Nfzz90Dn5yun6d9CYjvT6xoZGo5DE29OkguHVuAw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> ------------ P=F9vodn=ED zpr=E1va ------------
> Od: Fajar A. Nugraha <list@fajar.net>
> P=F8edm=ECt: Re: Re: Two way mirror in BRTFS
> Datum: 30.12.2011 15:34:02
> ----------------------------------------
> 2011/12/30 Jaromir Zdrazil <jaromir.zdrazil@email.cz>:
> >> > Just to add, I would like to see a two way mirror solution, but =
if it will
> not
> >> work now/is not implemnted yet, I would propably choose between dr=
bd in
> >> asynchronous mode or make a some kind if "incremental" snapshot to=
 a remote
> >> mapped disk (I do not know yet, if brtfs support it) =A0- it means=
 have one
> >> shapshop and let's say have a daily incremental update of this sna=
pshot.
> >>
> >> You mean like "zfs send -i"? If yes, why not just use zfs? There's
> >> zfsonlinux project, with easy-to-install ppa for ubuntu. Or you co=
uld
> >> compile it manually.
> >>
> > Thank you for your suggestion. As I know, there is not everything p=
orted yet,
> and one of the missing important features I plan to use is to crypt f=
s.
>=20
> correct. But btrfs doesn't do encryption as well.

I thought it does. Hmm, don't know why ;O)

> And if you're thinking of using luks/dm-crupt to provide encryption
> for btrfs, there's nothing preventing you to use the same thing with
> zfs.
>=20
> > And if I am not mistaken, current version does not yet support a mo=
untable
> filesystem.
>=20
> You're mistaken :) With some extra work, you can even use it as root:
> - http://zfsonlinux.org/example-zpl.html
> -
> https://github.com/dajhorn/pkg-zfs/wiki/HOWTO-install-Ubuntu-to-a-Nat=
ive-ZFS-Root-Filesystem
>=20
It seems I trust the web pages too much - in http://zfsonlinux.org/ is =
written that it does not ;O)) otherwise I would be using it already.

> >> >
> >> > How would you do it?
> >>
> >> If you DO mean zfs-send-like-functionality, then you should ask ab=
out
> >> "btrfs send and receive", not "two way mirror" (which is not an
> >> accurate way to describe what you want). Also, send/receive abilit=
y
> >> does not mean it can act as two-way mirror. It CAN be an alternati=
ve
> >> to drbd async though.
> >
> > If I understand it correctly, the diff between send and receive and=
 two way
> mirror is that one is synchronous and the other is not (sends the sig=
nal that
> the file have been succesfully written after all/one instance have be=
en
> succesfully written).
> > Maybe you can explain it a bit more.
>=20
> Two way: A replicates changes to B, and B can replicate it's own chan=
ges to A
> One way: A replicates changes to B, but B can not replicate it's own
> changes to A
>=20
Of course.

> While drbd only supports synchronous mode for active-active setup, th=
e
> generic "two way replication" does not have to be so. Also, just
> because something is synchronous does not automatically mean it
> supports two-way replication.
>=20
Correct.

> Either way, neither zfs or the (planned) btrfs send/receive supports
> two-way/active-active setup. Both should (or will) work just fine for
> one-way replication.
>=20
That is what I needed to know! Thank you very much!

Jaromir
> --=20
> Fajar
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
