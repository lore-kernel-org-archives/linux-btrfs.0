From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Atomic file data replace API
Date: Wed, 26 Jan 2011 14:30:24 -0500
Message-ID: <1296069448-sup-2841@think>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com> <AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com> <1294416073-sup-5254@think> <201101071726.02958.hka@qbs.com.pl> <1294428310-sup-9846@think> <AANLkTi=PT3+wiAjL7P0=bx7e8_VCXBGD2272PzLgJFu4@mail.gmail.com> <AANLkTim8wQuskQT1DsRX-1LY6yx91Ltd+hDz9OsYvjOP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTim8wQuskQT1DsRX-1LY6yx91Ltd+hDz9OsYvjOP@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Olaf van der Spek's message of 2011-01-26 13:30:08 -0500:
> On Sat, Jan 8, 2011 at 3:40 PM, Olaf van der Spek <olafvdspek@gmail.c=
om> wrote:
> > On Fri, Jan 7, 2011 at 8:29 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
> >> The exact amount of tracking is going to vary. =C2=A0The reason wh=
y is that
> >> actually doing the truncate is an O(size of the file) operation an=
d so
> >> you can't just flip a switch when the write or the close comes in.=
 =C2=A0You
> >> have to run through all the metadata of the file and do something
> >> temporary with each part that is only completed when the file IO i=
s
> >> actually done.
> >
> > That's true. Maybe the proper way, via O_ATOMIC, is better.
> >
> >> Honestly, there many different ways to solve this in the applicati=
on.
> >> Requiring high speed atomic replacement of individual file content=
s is a
> >> recipe for frustration.
> >
> > Did you see message of Massimo? That'd be the ideal way from an app
> > point of view.
> > Not solving this properly in the FS moves the problem to userspace
> > where it's even harder to solve and is not as performant.
> >
> > Replacing file data is a common operation that IMO the FS should
> > support in a safe way.
>=20
> Chris?
>=20

My answer hasn't really changed ;)  Replacing file data is a common
operation, but it is still surprisingly complex.  Again, the truncate i=
s
O(size of the file) and it is actually impossible to do this atomically
in most filesystems.

You don't notice this because xfs/ext34/btrfs (and many others) have
code that makes sure a truncate is restarted if you crash.  So, it
appears to be atomic even though we're really just restarting the
operation.  In order to have a truncate + replacement of data operation=
,
we'd have to do a disk format change that includes both the truncate an=
d
the new data.

It would look a lot like echo data > file.new ; truncate file ; mv
file.new file, but recorded in the FS metadata.

I don't have this in the btrfs roadmap.  It would be nice but most
people use databases for things that require atomic operations.  I
think what ext4 and btrfs do today fall into the category of best
effort and least surprise, and I think it is as good as we can get
without huge performance penalties for normal use.

Now, if you want to talk about atomic replacement of file data without
changing the file size, that's much easier.  At least it's easier for
those of us with cows in our pockets.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
