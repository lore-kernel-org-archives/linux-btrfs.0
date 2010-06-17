From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
Date: Thu, 17 Jun 2010 17:04:13 +0200
Message-ID: <201006171704.14541.hka@qbs.com.pl>
References: <201006092035.46481.knikanth@novell.com> <201006151611.36443.knikanth@novell.com> <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: "Nikanth Karthikesan" <knikanth@novell.com>,
	"OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Christoph Hellwig" <hch@lst.de>,
	"Chris Mason" <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: "David Pottage" <david@electric-spoon.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 15 June 2010 17:16:06 David Pottage wrote:
> On 15/06/10 11:41, Nikanth Karthikesan wrote:
> > I had a one-off use-case, where I had no free-space, which made me
> > think along this line.
> >=20
> > 1. We have the GNU split tool for example, which I guess, many of u=
s
> > use to split larger files to be transfered via smaller thumb drives=
,
> > for example. We do cat many files into one, afterwards. [For this
> > usecase, one can simply dd with seek and skip and avoid split/cat
> > completely, but we dont.]
>=20
> I am not sure how you gain here as either way you have to do I/O to g=
et
> the split files on and off the thumb drive. It might make sense if th=
e
> thumb drive is formated with btrfs, and the file needs to be copied t=
o
> another filling system that can't handle large files (eg FAT-16), but=
 I
> would say that is unlikely.
>=20

But you do have to do only half as much of I/O with those features=20
implemented.

The old way is:
1. Have a file
2. split a file (in effect use twice as much drive space)
3. copy fragments to flash disks

The btrfs way would be:
1. Have a file
2. split the file by using COW and referencing blocks in the original f=
ile (in=20
effect using only a little more space after splitting)
3. copy fragments to flash disks

the amount of I/O in the second case is limited only to metadata operat=
ions,=20
in the first case, all data must be duplicated

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
