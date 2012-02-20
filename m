From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs-convert processing time
Date: Mon, 20 Feb 2012 15:12:03 +0100
Message-ID: <2748764.TcFj1pIuO7@k85hala03>
References: <4F4241D1.4080506@daevel.fr> <1920178.zXOEpupmQW@k85hala03> <CAG1y0sevgB0=Y-Sxe_N4zGeZvYp+Pmpjv0q8JeRg22qtkZ0tJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Olivier Bonvalet <btrfs.list@daevel.fr>,
	linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sevgB0=Y-Sxe_N4zGeZvYp+Pmpjv0q8JeRg22qtkZ0tJw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris: What will btrfs-convert do when it encounters a directory with m=
ore=20
hardlinks than the btrfs limit?

On Monday 20 of February 2012 21:00:34 Fajar A. Nugraha wrote:
> On Mon, Feb 20, 2012 at 8:50 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> > On Monday 20 of February 2012 14:41:33 Olivier Bonvalet wrote:
> >> Lot of small files (like compressed email from Maildir), and lot o=
f
> >> hardlinks, and probably low free space (near 15% I suppose).
> >>=20
> >>=20
> >> So I think I have my answer :)
> >=20
> > Yes, this is probably the worst possible combination.
> >=20
> > Plese keep us updated. Just to have exact numbers for new users.
>=20
> ... although it would probably fail anyway due to btrfs hardlink limi=
t
> in the same directory.

This problem also went through my mind.

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
