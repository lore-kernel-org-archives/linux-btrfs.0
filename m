From: Chris Mason <chris.mason@oracle.com>
Subject: Re: block discard.
Date: Fri, 08 Aug 2008 10:13:09 -0400
Message-ID: <1218204789.15342.237.camel@think.oraclecorp.com>
References: <1218202998.12232.161.camel@pmac.infradead.org>
	 <1218203792.15342.235.camel@think.oraclecorp.com>
	 <1218204306.12232.169.camel@pmac.infradead.org>
	 <1218204617.12232.171.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218204617.12232.171.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-08-08 at 15:10 +0100, David Woodhouse wrote:
> On Fri, 2008-08-08 at 15:05 +0100, David Woodhouse wrote:
> > On Fri, 2008-08-08 at 09:56 -0400, Chris Mason wrote:
> > > So you mkfs ; dd large file ; rm large file ; look for discards?
> > > 
> > > Try rm large file ; sync ; sync; look for discards
> > 
> > Yeah, I did that. The actual data extent isn't getting removed.
> 
> Oh, you really did mean _two_ syncs. And then yes, I see why it isn't
> working; mea culpa.
> 

The first sync commits the transaction and writes out the data.  The
second sync does the same thing, but this time it finds the old snapshot
pending deletion and deletes it.

-chris


