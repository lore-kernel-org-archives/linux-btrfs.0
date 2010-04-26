From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: list subvolumes with new btrfs command
Date: Mon, 26 Apr 2010 19:58:56 +0200
Message-ID: <201004261958.56440.hka@qbs.com.pl>
References: <g2kbe6460751004251127tbdf980b6q867cf1b98fc562dc@mail.gmail.com> <l2n9bd6b5361004252022wceaf4c6bj3d62a48f389331d2@mail.gmail.com> <p2qbe6460751004261023s24fe1f84xd80738387c1a3da8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: sniper <s3c24xx@gmail.com>, linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <p2qbe6460751004261023s24fe1f84xd80738387c1a3da8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 26 April 2010 19:23:21 C Anthony Risinger wrote:
> > I am using ubuntu-10.04-rc with kernel compiled from the almost
> > lastest source , the btrfs-progs is latest too.
> >
> > You can modify line
> >
> >  fprintf(stderr, "ERROR: can't perform the search\n");
> > to
> >  fprintf(stderr, "ERROR: can't perform the search: %s\n",
> > strerror(errno));
> >
> > to see what happened on earth.
>=20
> nice:
>=20
> $ sudo btrfs subvolume list /
> ERROR: can't perform the search: Inappropriate ioctl for device
>=20
> i'm not really familiar with C, or anything this low level, does this
> help you diagnose my problem?

Have you tried to run it on the device with the btrfs, not the mount po=
int?

It looks like the ioctl was made too restrictive about its arguments.

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl

System Zarz=C4=85dzania Jako=C5=9Bci=C4=85
zgodny z norm=C4=85 ISO 9001:2000
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
