From: Chris Mason <chris.mason@oracle.com>
Subject: Re: NOCOW + compress-force = bug
Date: Thu, 16 Feb 2012 12:58:15 -0500
Message-ID: <20120216175815.GM21896@shiny>
References: <4F38B8F0.5020506@yahoo.com>
 <4F38BE53.4080204@parallels.com>
 <20120213141040.GG15350@twin.jikos.cz>
 <20120216195515.643f4aa7@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, dima <dolenin@parallels.com>,
	linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120216195515.643f4aa7@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2012 at 07:55:15PM +0600, Roman Mamedov wrote:
> Hello,
> 
> Please be aware that there seems to be a possible problem with using NOCOW
> flag on files situated on a filesystem mounted with compress-force(=lzo, in my
> case).
> 
> Since experimenting with NOCOW, I started regularly hitting this BUG at
> extent-tree.c:5813 
> 
>   5813                 BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
> 
> I was unable to make netconsole work over a bridged interface, so can only
> post screenshots of this OOPS:
>   http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-1.jpg
>   http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-2.jpg
> 
> This happened four times already, and always on snapshot creation (but not
> every case). I have hourly snapshots in crontab, and only one case out of about
> ten fails with this problem. Did not try to deliberately reproduce it yet by
> manually making snapshots very often, etc.

Interesting, NOCOW and compression don't really mix.  We always cow for
compression.  I'll try to reproduce it.

-chris
