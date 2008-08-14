From: Zach Brown <zach.brown@oracle.com>
Subject: Re: New feature Idea
Date: Thu, 14 Aug 2008 11:49:14 -0700
Message-ID: <48A47E2A.6010007@oracle.com>
References: <48A320A0.80609@gmail.com>  <48A32DDE.8070203@hp.com> <1218733937.15342.378.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: jim owens <jowens@hp.com>, Morey Roof <moreyroof@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218733937.15342.378.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


> File granularity is not well suited to dedup when files differ by only a
> few blocks, but I'd want to see some numbers on how often that happens
> before carrying around the disk format needed to do block level dedup.

I was imagining that one could easily make a flag to debug-tree which
caused it to just dump the file block checksums from the extent items,
maybe restricted to a given subvol.  Pipe that through sort and uniq -c
and you have a pretty easy path to a rough histogram of checksum values.

But I sort of wonder if the point isn't to dedup systems that were
deployed on previous-generation file systems.  If people knew that dedup
worked, they might be able to more easily deploy simpler systems that
didn't have to be so careful at, say, maintaining hard link farms.

I dunno, just a thought.

- z
