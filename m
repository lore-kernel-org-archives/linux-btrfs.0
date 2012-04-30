From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Mon, 30 Apr 2012 19:03:58 +0200
Message-ID: <1530119.sl3296EQTA@bursa01>
References: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com> <8118972.tgkAvno4mK@bursa22> <pan.2012.04.29.04.15.24@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.04.29.04.15.24@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 29 of April 2012 04:15:24 Duncan wrote:
> > Still, a "zero-superblock" option would be useful for the btrfs too=
l.
> > I'll see what I can do about this.
>=20
> Yes, indeed.  Particularly since various bits of btrfs functionality=20
> depend on scanning for filesystems (presumably their superblocks), an=
d=20
> output like that in the OP can be confusing indeed, as well as=20
> potentially dangerous in recovery situations, where the wrong one mig=
ht=20
> be activated by accident.  (FWIW, there's an mdadm --zero-superblock=20
> option.  I should take note of this thread and be sure I use it when =
next=20
> I redo my layouts, probably when I switch some of them to btrfs inste=
ad,=20
> tho that's going to be a bit as I'm waiting for N-way-mirroring, aka=20
> proper raid1 mode, not the 2-way-only-mirroring that btrfs calls raid=
1=20
> mode currently.)

mdadm --zero-superblock removes MD superblock, it doesn't modify the da=
ta part=20
of the partition, it just zeroes the MD metadata.

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
