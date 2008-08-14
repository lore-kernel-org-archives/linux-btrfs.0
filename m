From: "Morey Roof" <moreyroof@gmail.com>
Subject: Re: New feature Idea
Date: Thu, 14 Aug 2008 13:45:40 -0600
Message-ID: <91a37e890808141245w7042211aseab3b27284002547@mail.gmail.com>
References: <48A320A0.80609@gmail.com> <48A32DDE.8070203@hp.com>
	 <1218733937.15342.378.camel@think.oraclecorp.com>
	 <48A47E2A.6010007@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Zach Brown" <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A47E2A.6010007@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2008 at 12:49 PM, Zach Brown <zach.brown@oracle.com> wrote:
>
>> File granularity is not well suited to dedup when files differ by only a
>> few blocks, but I'd want to see some numbers on how often that happens
>> before carrying around the disk format needed to do block level dedup.
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
>
> - z
>

Well, if we look at NetApp's claims dedup can be pretty useful.  Also,
it really depends on what kinds of data workload the volume is being
used for.  People claim that they often see a size reduction of about
40%-80% of the space used when they have volumes that store virtual
machine disk files.

Chris, I would like to go ahead and make a small simple prototype for
this and see how it works before just ruling it out of the code base.

-Morey
