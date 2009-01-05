From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 05 Jan 2009 11:30:56 -0500
Message-ID: <1231173056.4290.130.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <1231057922.6497.30.camel@localhost.localdomain>
	 <1231166153.4290.38.camel@think.oraclecorp.com>
	 <20090105150149.GA9053@mother.fordon.pl.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Gabor MICSKO <gabor.micsko@gmail.com>, linux-btrfs@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090105150149.GA9053@mother.fordon.pl.eu.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-05 at 16:01 +0100, Tomasz Torcz wrote:
> On Mon, Jan 05, 2009 at 09:35:53AM -0500, Chris Mason wrote:
> > On Sun, 2009-01-04 at 09:32 +0100, Gabor MICSKO wrote:
> > > Hi Chris,
> > > 
> > > 
> > > Does this means that disk format finalised or at least backward
> > > compatible?
> > > 
> > 
> > We're making every effort to avoid new disk format changes now (that are
> > not backward compatible).  Only a critical bug would result in a disk
> > format change now.
> 
> 
>   Is this means that new format is ready for RAID5-like disk layout?
> 

That will be done through forward compat bits.  So you won't be able to
use today's code to mount a RAID5 FS, but the raid5 fs will understand
today's FS.

-chris




