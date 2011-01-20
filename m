From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Btrfs balance
Date: Thu, 20 Jan 2011 18:46:20 +0100
Message-ID: <201101201846.20370.hka@qbs.com.pl>
References: <BeD$lESD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BeD$lESD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, January 20, 2011 14:40:00 Helmut Hullen wrote:
> Hallo, Andreas,
>=20
> Du meintest am 20.01.11:
> > Maybe it is a very stupid question but I want to ask it anyway. In
> > general, 'btrfs filesystem balance' takes very long to finish and
> > produces lots of IO. So what are the classical usage scenarios, whe=
n
> > it is (really) worth doing a balance?
>=20
> Here (Kernel 2.6.37, btrfs git Nov. 2010): balancing two disks/
> partitions with 2 and 1.5 TByte needs about 24 hours (CPU 1.5 GHz).
>=20
That's the effect of lots of IO. IMHO it shouldn't take more than 4-8h =
for 1TB=20
7200rpm disks in an otherwise idle system, as such it's rather ineffici=
ent=20
right now.

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
