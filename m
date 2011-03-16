From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs mount segfaults or crashes after powerloss
Date: Wed, 16 Mar 2011 15:43:52 -0400
Message-ID: <1300304176-sup-1475@think>
References: <20110315002856.GC37926@emmi.physik-pool.tu-berlin.de> <1300208269-sup-5260@think> <20110315172617.GD37926@emmi.physik-pool.tu-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?utf-8?q?Leon_Me=C3=9Fner?= <l.messner@physik.tu-berlin.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110315172617.GD37926@emmi.physik-pool.tu-berlin.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Leon Me=C3=9Fner's message of 2011-03-15 13:26:17 -0400:
> On Tue, Mar 15, 2011 at 12:58:43PM -0400, Chris Mason wrote:
> > Excerpts from Leon Me=C3=9Fner's message of 2011-03-14 20:28:56 -04=
00:
> > > Hi,
> > >=20
> > > i'm having a problem with a damaged btrfs after power loss. When =
i try
> > > to mount the fs mount either segfaults (trace at bottom) or hangs=
 in=20
> > > "D" state together with [btrfs-transacti].
> > >=20
> > > Please CC me as i'm not an the list.
> > > # btrfsck -s 1 /dev/sdb2
> >=20
> > Does btrfsck /dev/sdb2 work?  -s 1 selects a different super, hopef=
ully
> > all the supers are the same.  If plain btrfsck runs without failing=
 we
> > can easily work around the log tree crash.
>=20
> Yes it does (i think), output is below.
>=20
> # btrfsck /dev/sdb2
> root 256 inode 257 errors 800
> found 50907959296 bytes used err is 1
> total csum bytes: 46730092
> total tree bytes: 407293952
> total fs tree bytes: 315609088
> btree space waste bytes: 111966302
> file data blocks allocated: 184320000000
>  referenced 56142348288
> Btrfs v0.19-35-g1b444cd

Ok, if you have the latest btrfs-progs from git, you can

make btrfs-zero-log
=2E/btrfs-zero-log /dev/xxx

It will make you skip the log replay that is crashing the box on your
next mount.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
