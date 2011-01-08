From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Sat, 8 Jan 2011 15:40:39 +0100
Message-ID: <AANLkTi=PT3+wiAjL7P0=bx7e8_VCXBGD2272PzLgJFu4@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
	<1294416073-sup-5254@think>
	<201101071726.02958.hka@qbs.com.pl>
	<1294428310-sup-9846@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294428310-sup-9846@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 8:29 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> The exact amount of tracking is going to vary. =C2=A0The reason why i=
s that
> actually doing the truncate is an O(size of the file) operation and s=
o
> you can't just flip a switch when the write or the close comes in. =C2=
=A0You
> have to run through all the metadata of the file and do something
> temporary with each part that is only completed when the file IO is
> actually done.

That's true. Maybe the proper way, via O_ATOMIC, is better.

> Honestly, there many different ways to solve this in the application.
> Requiring high speed atomic replacement of individual file contents i=
s a
> recipe for frustration.

Did you see message of Massimo? That'd be the ideal way from an app
point of view.
Not solving this properly in the FS moves the problem to userspace
where it's even harder to solve and is not as performant.

Replacing file data is a common operation that IMO the FS should
support in a safe way.
--=20
Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
