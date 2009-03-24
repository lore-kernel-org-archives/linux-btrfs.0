From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Crash in 2.6.29-rc8
Date: Tue, 24 Mar 2009 13:43:06 -0400
Message-ID: <1237916586.5633.14.camel@think.oraclecorp.com>
References: <49C8F103.1090407@isp-services.nl>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Tom van Klinken / ISP Services BV <tom@isp-services.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49C8F103.1090407@isp-services.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-03-24 at 15:41 +0100, Tom van Klinken / ISP Services BV
wrote:
> Hi,
> 
> I started using btrfs yesterday and used the version that comes with 
> 2.6.29-rc8.
> 
> The main reason I wanted to try btrfs is that because I am running on 
> SSD's and the normal wear leveling algorithm of this SSD (MTRON 7535) 
> failed terribly with xfs. (SSD's wore out in 2 months)
> 
> I have a 64GB ssd mounted with '-o noatime' and '-o ssd'.
> 
> The load is MySQL with 300-400 inserts/sec 24/7 on a large database with 
> a lot of indexes.
> 
> Attached is the trace I got this morning. The system ran fine for about 
> 16 hours :)
> 

This is a metadata enospc oops.  You actually had about 400MB free but
it was pinned down and waiting for a commit to free it all.

There is definitely more work to do on the metadata enospc side of
things.  One possible problem is that your disk is full of data block
groups and more metadata groups are required.

I'll work on some more metadata enospc patches this week.

-chris


