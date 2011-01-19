From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs defrag: how does it work?
Date: Wed, 19 Jan 2011 16:25:12 -0500
Message-ID: <1295471646-sup-7764@think>
References: <AANLkTintJmDE7VVa5eTiepew68gztjh1j8Li1Fgq2iS6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Paul Komkoff <i@stingr.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTintJmDE7VVa5eTiepew68gztjh1j8Li1Fgq2iS6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Paul Komkoff's message of 2011-01-19 14:58:28 -0500:
> Hello.
> 
> [root@botva incoming]# btrfs fi defrag file-350mb
> [root@botva incoming]# filefrag file-350mb
> file-350mb: 132 extents found

The defrag code doesn't actually defrag.  It opens up the file and
recows all the extents and then the delayed allocation code jumps in and
makes the biggest possible extent that it can.

The reason why you're still seeing extents after running the defrag
command is because the file hasn't been written yet, so the delayed
allocation code hasn't kicked in.

If you use btrfs fi defrag -f it'll trigger writeback on the file and
you should see the results of the defrag sooner.

-chris
