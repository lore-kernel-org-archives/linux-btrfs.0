From: =?us-ascii?Q?Jaromir=20Zdrazil?= <jaromir.zdrazil@email.cz>
Subject: =?us-ascii?Q?Two=20way=20mirror=20in=20BRTFS?=
Date: Fri, 30 Dec 2011 13:32:45 +0100 (CET)
Message-ID: <135518.24516.61340-2734-1521609493-1325248365@email.cz>
References: <135478.27027.62193-16529-1080748879-1325245275@email.cz>
Reply-To: jaromir.zdrazil@email.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <135478.27027.62193-16529-1080748879-1325245275@email.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry fo the typo in the subject!

Just to add, I would like to see a two way mirror solution, but if it w=
ill not work now/is not implemnted yet, I would propably choose between=
 drbd in asynchronous mode or make a some kind if "incremental" snapsho=
t to a remote mapped disk (I do not know yet, if brtfs support it)  - i=
t means have one shapshop and let's say have a daily incremental update=
 of this snapshot.

How would you do it?

I have never used btrfs, baucause in "brtfs home page" is still written=
 experimental, and lately with three kids I have less and less time to =
experiment ... but, as I found some short time ago, there is laso a sug=
gestion to use it ... and I know it is used more and more frequently ..=
=2E so i will give it a try.

Btw when is a plan to move it from experimental? ;o)

Have to look at the source code a bit (hope there are some notes about =
future). Jaromir

> ------------ P=F9vodn=ED zpr=E1va ------------
> Od: Jaromir Zdrazil <jaromir.zdrazil@email.cz>
> P=F8edm=ECt: Who way mirror in BRTFS
> Datum: 30.12.2011 12:55:44
> ----------------------------------------
> Hi Jan,
>=20
>    sorry to borther you, but I need some info and you are propably th=
e best one
> to answer.
>=20
>    I am planing now a new backup system (servers) for a medical compa=
ny. My idea
> is to have a dedicated backup server in each building and wia two way=
 mirror
> mirror it to another server in diff building (bacause of security) th=
rough fs.
> ZFS is capable, but i would like to stick to a Linux.
>    As I understand, there is some work done in two way mirror in brtf=
s (which
> seems to me as best solustion for that under linux) and you are the o=
ne working
> on that.
>=20
>    My Qs are:
> - do you know any better fs for this purpose, other than brtfs under =
Linux?
> - What is the implementation of two way mirror in brtfs, and when do =
you expect
> to have it done to a degree so I can try it? Tt does not have to work=
 now, but
> it should work next year ;O)
>=20
> I have 20years experience in linux, and if I do not have to debug any=
thing, I am
> more less happy ;O)
>=20
> Thank you very much! Jaromir
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
