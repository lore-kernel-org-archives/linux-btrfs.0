From: Paul Komkoff <i@stingr.net>
Subject: Re: btrfs defrag: how does it work?
Date: Wed, 19 Jan 2011 22:31:56 +0000
Message-ID: <AANLkTikcNy1FdRjLu=bDpE=A7krUysmV2uLwN9jh4AF2@mail.gmail.com>
References: <AANLkTintJmDE7VVa5eTiepew68gztjh1j8Li1Fgq2iS6@mail.gmail.com>
	<1295471646-sup-7764@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1295471646-sup-7764@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 19, 2011 at 9:25 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> The defrag code doesn't actually defrag. =A0It opens up the file and
> recows all the extents and then the delayed allocation code jumps in =
and
> makes the biggest possible extent that it can.
>
> The reason why you're still seeing extents after running the defrag
> command is because the file hasn't been written yet, so the delayed
> allocation code hasn't kicked in.
>
> If you use btrfs fi defrag -f it'll trigger writeback on the file and
> you should see the results of the defrag sooner.

I tried, and just tried it again, with the same file. I even tried
doing btrfs fi sync in random order. No matter what I do, it's still
132 extents :)
--=20
This message represents the official view of the voices in my head
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
