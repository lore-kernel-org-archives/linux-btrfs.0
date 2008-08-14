From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New feature Idea
Date: Thu, 14 Aug 2008 15:53:56 -0400
Message-ID: <1218743636.15342.415.camel@think.oraclecorp.com>
References: <48A320A0.80609@gmail.com> <48A32DDE.8070203@hp.com>
	 <1218733937.15342.378.camel@think.oraclecorp.com>
	 <48A47E2A.6010007@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: jim owens <jowens@hp.com>, Morey Roof <moreyroof@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A47E2A.6010007@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-08-14 at 11:49 -0700, Zach Brown wrote:
> > File granularity is not well suited to dedup when files differ by only a
> > few blocks, but I'd want to see some numbers on how often that happens
> > before carrying around the disk format needed to do block level dedup.
> 
> I was imagining that one could easily make a flag to debug-tree which
> caused it to just dump the file block checksums from the extent items,
> maybe restricted to a given subvol.  Pipe that through sort and uniq -c
> and you have a pretty easy path to a rough histogram of checksum values.
> 
> But I sort of wonder if the point isn't to dedup systems that were
> deployed on previous-generation file systems.  If people knew that dedup
> worked, they might be able to more easily deploy simpler systems that
> didn't have to be so careful at, say, maintaining hard link farms.
> 
> I dunno, just a thought.

The backup and virtualization use cases are why I've still got it on the
table for consideration at least.  Especially virtualization because
there you'll tend to have large disk image files that have tiny changes
between each other.

-chris


