From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Number of hard links limit
Date: Fri, 6 Aug 2010 09:46:07 -0400
Message-ID: <20100806134607.GB19942@think>
References: <20100802114046.GA29926@lh.kyla.fi>
 <20100802130556.GF30325@jeru.org>
 <4ad406cb8ee6c52747b67b4c79a6d7dd@smtp.arbitraryconstant.com>
 <20100802215647.7466601d@simplux>
 <4C572DDC.5050108@robertoragusa.it>
 <0362zshcyx.fsf@msgid.viggen.net>
 <20100806113039.GA18858@lh.kyla.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, sliedes@cc.hut.fi
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100806113039.GA18858@lh.kyla.fi>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 06, 2010 at 02:30:39PM +0300, Sami Liedes wrote:
> On Tue, Aug 03, 2010 at 12:22:14AM +0200, Oystein Viggen wrote:
> > IIRC, the limit on hard links is per directory.  That is, if you put
> > each hard link into its own directory, there's basically no limit to the
> > amount of hard links you can make to one file.
> 
> Yes, that's always pointed out in these threads. Still, it seems to be
> breaking real use cases also beyond backuppc (someone mentioned
> installing some Gentoo package).

Right, this will get fixed in a future btrfs update.  We're focusing on
stability with what we have right now, but I do agree we should have
done this link back reference design differently.

-chris
