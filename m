From: Chris Mason <chris.mason@oracle.com>
Subject: Re: block discard.
Date: Fri, 08 Aug 2008 09:56:32 -0400
Message-ID: <1218203792.15342.235.camel@think.oraclecorp.com>
References: <1218202998.12232.161.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218202998.12232.161.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-08-08 at 14:43 +0100, David Woodhouse wrote:
> Playing with the trim/punch/discard support, I tried the patch below. It
> see it getting invoked at times, but when I create a large file and then
> delete it, I don't see it getting invoked _enough_. And when I grep the
> block device for the contents of the file, they're still there.
> 
> I have a suspicion my added code is only getting invoked for
> metadata/tree extents, not the actual data extents. What'd I miss?
> 

So you mkfs ; dd large file ; rm large file ; look for discards?

Try rm large file ; sync ; sync; look for discards

-chris


