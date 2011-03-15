From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: BTRFS fsck tool
Date: Tue, 15 Mar 2011 15:18:41 +0100
Message-ID: <201103151518.42007.hka@qbs.com.pl>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <4D7BF890.5010601@shiftmail.org> <4D7C075C.2060702@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Spelic <spelic@shiftmail.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Stuge <peter@stuge.se>,
	Alexey A Nikitin <moonwalker@syrius.us>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D7C075C.2060702@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, March 13, 2011 00:53:00 Ric Wheeler wrote:
> On 03/12/2011 05:49 PM, Spelic wrote:
> > On 03/10/2011 02:02 PM, Chris Mason wrote:
> >> Cutting the power isn't problem unless you're using something
> >> where cache flushes are not supported.
> >=20
> > Some disks lie about cache flush having completed.
>=20
> This is really not true for modern enterprise class drives. You might=
 have
> more issues with USB thumbdrives and other really low end parts.

btrfs is supposed to be an ext3/4 replacement - it _will_ be used with =
low end=20
parts (commodity SATA HDDs)

Regards
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
