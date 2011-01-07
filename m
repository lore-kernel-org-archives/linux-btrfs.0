From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Atomic file data replace API
Date: Fri, 07 Jan 2011 10:05:15 -0500
Message-ID: <1294412553-sup-9058@think>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com> <1294412141-sup-1734@think> <AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Olaf van der Spek's message of 2011-01-07 10:01:59 -0500:
> On Fri, Jan 7, 2011 at 3:58 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > Excerpts from Olaf van der Spek's message of 2011-01-06 15:01:15 -0=
500:
> >> Hi,
> >>
> >> Does btrfs support atomic file data replaces? Basically, the atomi=
c
> >> variant of this:
> >> // old stage
> >> open(O_TRUNC)
> >> write() // 0+ times
> >> close()
> >> // new state
> >
> > Yes and no. =C2=A0We have a best effort mechanism where we try to g=
uess that
> > since you've done this truncate and the write that you want the wri=
tes
> > to show up quickly. =C2=A0But its a guess.
> >
> > The problem is the write() // 0+ times. =C2=A0The kernel has no ide=
a what
> > new result you want the file to contain because the application isn=
't
> > telling us.
>=20
> Isn't it safe for the kernel to wait until the first write or close
> before writing anything to disk?

I'm afraid not.  Picture an application that opens a thousand files and
writes 1MB to each of them, and then didn't close any.  If we waited
until close, you'd have 1GB of memory pinned or staged somehow.

>=20
> > What btrfs can do (but we haven't yet implemented) is make sure tha=
t the
> > results of a single write file are on disk atomically, even if they=
 are
> > replacing existing bytes in the file.
> >
> > Because we cow and because we don't update metadata pointers until =
the
> > IO is complete, we can wait until all the IO for a given write call=
 is
> > on disk before we update any of the metadata.
> >
> > This isn't hard, it's on my TODO list.
>=20
> What about a new flag: O_ATOMIC that'd take the guesswork out of the =
kernel?

We can't guess beyond a single write call.  Otherwise we get into
the problem above where an application can force the kernel to wait
forever.  I'm not against O_ATOMIC to enable the new btrfs
functionality, but it will still be limited to one write.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
