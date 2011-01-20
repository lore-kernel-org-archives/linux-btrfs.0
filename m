From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs defrag: how does it work?
Date: Thu, 20 Jan 2011 16:38:18 -0500
Message-ID: <1295559487-sup-9500@think>
References: <AANLkTintJmDE7VVa5eTiepew68gztjh1j8Li1Fgq2iS6@mail.gmail.com> <1295471646-sup-7764@think> <AANLkTikcNy1FdRjLu=bDpE=A7krUysmV2uLwN9jh4AF2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Paul Komkoff <i@stingr.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTikcNy1FdRjLu=bDpE=A7krUysmV2uLwN9jh4AF2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Paul Komkoff's message of 2011-01-19 17:31:56 -0500:
> On Wed, Jan 19, 2011 at 9:25 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > The defrag code doesn't actually defrag. =C2=A0It opens up the file=
 and
> > recows all the extents and then the delayed allocation code jumps i=
n and
> > makes the biggest possible extent that it can.
> >
> > The reason why you're still seeing extents after running the defrag
> > command is because the file hasn't been written yet, so the delayed
> > allocation code hasn't kicked in.
> >
> > If you use btrfs fi defrag -f it'll trigger writeback on the file a=
nd
> > you should see the results of the defrag sooner.
>=20
> I tried, and just tried it again, with the same file. I even tried
> doing btrfs fi sync in random order. No matter what I do, it's still
> 132 extents :)

Are you using compression?

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
