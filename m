From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Atomic file data replace API
Date: Fri, 07 Jan 2011 10:13:41 -0500
Message-ID: <1294412980-sup-1924@think>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com> <1294412141-sup-1734@think> <AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com> <1294412553-sup-9058@think> <AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Olaf van der Spek's message of 2011-01-07 10:08:24 -0500:
> On Fri, Jan 7, 2011 at 4:05 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> >> > The problem is the write() // 0+ times. =C2=A0The kernel has no =
idea what
> >> > new result you want the file to contain because the application =
isn't
> >> > telling us.
> >>
> >> Isn't it safe for the kernel to wait until the first write or clos=
e
> >> before writing anything to disk?
> >
> > I'm afraid not. =C2=A0Picture an application that opens a thousand =
files and
> > writes 1MB to each of them, and then didn't close any. =C2=A0If we =
waited
> > until close, you'd have 1GB of memory pinned or staged somehow.
>=20
> That's not what I asked. ;)
> I asked to wait until the first write (or close). That way, you don't
> get unintentional empty files.
> One step further, you don't have to keep the data in memory, you're
> free to write them to disk. You just wouldn't update the meta-data
> (yet).

Sorry ;) Picture an application that truncates 1024 files without closi=
ng any
of them.  Basically any operation that includes the kernel waiting for
applications because they promise to do something soon is a denial of
service attack, or a really easy way to run out of memory on the box.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
