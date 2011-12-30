From: =?us-ascii?Q?Jaromir=20Zdrazil?= <jaromir.zdrazil@email.cz>
Subject: =?us-ascii?Q?Re=3A=20Re=3A=20Two=20way=20mirror=20in=20BRTFS?=
Date: Fri, 30 Dec 2011 14:59:25 +0100 (CET)
Message-ID: <135535.24205.61145-582-206632053-1325253564@email.cz>
References: <CAG1y0sd2AvxucVJ5BKc4ysu08gS6SF7GJNX2DiP17co_NN6xLg@mail.gmail.com>
Reply-To: jaromir.zdrazil@email.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sd2AvxucVJ5BKc4ysu08gS6SF7GJNX2DiP17co_NN6xLg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> ------------ P=F9vodn=ED zpr=E1va ------------
> Od: Fajar A. Nugraha <list@fajar.net>
> P=F8edm=ECt: Re: Two way mirror in BRTFS
> Datum: 30.12.2011 14:27:39
> ----------------------------------------
> 2011/12/30 Jaromir Zdrazil <jaromir.zdrazil@email.cz>:
> > Sorry fo the typo in the subject!
> >
> > Just to add, I would like to see a two way mirror solution, but if =
it will not
> work now/is not implemnted yet, I would propably choose between drbd =
in
> asynchronous mode or make a some kind if "incremental" snapshot to a =
remote
> mapped disk (I do not know yet, if brtfs support it) =A0- it means ha=
ve one
> shapshop and let's say have a daily incremental update of this snapsh=
ot.
>=20
> You mean like "zfs send -i"? If yes, why not just use zfs? There's
> zfsonlinux project, with easy-to-install ppa for ubuntu. Or you could
> compile it manually.
>=20
Thank you for your suggestion. As I know, there is not everything porte=
d yet, and one of the missing important features I plan to use is to cr=
ypt fs. And if I am not mistaken, current version does not yet support =
a mountable filesystem.
> >
> > How would you do it?
>=20
> If you DO mean zfs-send-like-functionality, then you should ask about
> "btrfs send and receive", not "two way mirror" (which is not an
> accurate way to describe what you want). Also, send/receive ability
> does not mean it can act as two-way mirror. It CAN be an alternative
> to drbd async though.

If I understand it correctly, the diff between send and receive and two=
 way mirror is that one is synchronous and the other is not (sends the =
signal that the file have been succesfully written after all/one instan=
ce have been succesfully written).
Maybe you can explain it a bit more.
>=20
> I don't think there's any publicly available code for it yet though.
>=20
Thank you. Jaromir
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
