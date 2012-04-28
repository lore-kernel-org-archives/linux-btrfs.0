From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Sat, 28 Apr 2012 18:42:52 +0200
Message-ID: <8118972.tgkAvno4mK@bursa22>
References: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com> <C7$h9m5PCXB@helmut.hullen.de> <pan.2012.04.26.20.54.46@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	josef@redhat.com
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.04.26.20.54.46@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 26 of April 2012 20:54:47 Duncan wrote:
> Helmut Hullen posted on Thu, 26 Apr 2012 13:11:00 +0200 as excerpted:
> > Hallo, Bart,
> >>=20
> >> Well I think there is a btrfs superblock still present from the
> >> full-disk filesystem. Due to the offset of the first partition fro=
m the
> >> start of the disk, this superblock was not overwritten when you cr=
eated
> >> the filesystem inside the partition.
> >=20
> > Sounds familiar ...
> >=20
> > I now use to delete about the first 10 MByte of the target disk via=
 "dd
> > if=3D/dev/zero"
>=20
> But /unlike/ reiserfs, which was only affected with the well warned a=
s
> don't-use-unless-you-have-to fsck --rebuild-tree option, it seems tha=
t
> due to btrfs scan, etc, btrfs has its similar problem in more routine
> operation.

I'd say that this kind of problem is basically impossible in btrfs beca=
use=20
of FS UUID written all over the tree.

What we see here, is a superblock that is written in *very* specific pl=
ace=20
on the partition, that just is aligned in place that makes the whole di=
sk=20
look like btrfs.

I don't think it's actually possible for btrfs to put a file with btrfs=
=20
filesystem image in place where it could seem like the basic block devi=
ce=20
has btrfs /too/. It depends on whatever the metadata block is allocated=
=20
before data block on disk. It /may/ be possible in mixed data-metadata=20
allocation mode.
Chris or Josef, can you confirm?

Still, a "zero-superblock" option would be useful for the btrfs tool. I=
'll=20
see what I can do about this.

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
