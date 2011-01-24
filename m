From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Defragmentation Not Working with Directory as Argument
Date: Mon, 24 Jan 2011 19:21:58 +0100
Message-ID: <201101241921.59201.hka@qbs.com.pl>
References: <AANLkTi=AtFgMoES1z7jXwwXkZynbBjYbPTJK_4_iULSF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=AtFgMoES1z7jXwwXkZynbBjYbPTJK_4_iULSF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, January 24, 2011 19:11:07 Mitch Harder wrote:
> Defragmentation is not working when a directory is supplied as the
> argument.  When a file name is supplied as the argument,
> defragmentation works well.
>=20
> This can be demonstrated as follows:
>=20
> # mount /dev/sdb2 /mnt/btrfs
> # cd /mnt/btrfs/
> # cp /usr/src/linux/fs/btrfs/zlib.c  .    (any suitable file will do,
> small text files seemed appropriate)
> # cp zlib.c fragmented-zlib.c
> # btrfs fi sync /mnt/btrfs
> # cat zlib.c >> fragmented-zlib.c
> # btrfs fi sync /mnt/btrfs
> # filefrag zlib.c fragmented-zlib.c
> zlib.c: 1 extent found
> fragmented-zlib.c: 2 extents found
> # btrfs filesystem defragment /mnt/btrfs/
> # btrfs fi sync /mnt/btrfs
> # filefrag zlib.c fragmented-zlib.c
> zlib.c: 1 extent found
> fragmented-zlib.c: 2 extents found
>=20
> Now, supply a filename as the argument
>=20
> # btrfs filesystem defragment /mnt/btrfs/fragmented-zlib.c
> # btrfs fi sync /mnt/btrfs
> # filefrag zlib.c fragmented-zlib.c
> zlib.c: 1 extent found
> fragmented-zlib.c: 1 extent found
>=20
> I've also tested defragmentation on my normal btrfs filesystems, and
> have seen the same results.  I've never seen a file defragmented when
> using a directory as the argument.

That's because this defragments only directory metadata.

> Also, I was wondering if one of the Btrfs developers could clarify th=
e
> intended scope of defragmentation when a directory is supplied as the
> argument.

I submited apropriate patches few days back to update man and help mess=
ages

> I have seen comments on the mailing list indicating that only the
> directory supplied is intended to be defragmented, and defragmentatio=
n
> will not recurse to subdirectories below.

that's true

> However, if I look at the code, and read the documentation for the
> older btrfsctl command (which seems to be the basis for the current
> btrfs command), it seems like the intention is to recursively
> defragment the entire tree below the directory supplied in the
> argument.

Then it looks like the userspace part of implementation changed, don't =
know=20
why though.

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
