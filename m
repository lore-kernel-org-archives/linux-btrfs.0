From: Bernhard Duebi <bernhard@due.bi>
Subject: Re: btrfs defra
Date: Fri, 17 Jun 2011 14:19:27 +0200
Message-ID: <1308313167.2504.157.camel@andromeda>
References: <1307976637.2285.15.camel@andromeda>
	 <20110613155420.GA14384@carfax.org.uk>
	 <BANLkTim-gxATkTSgGncJcc_WC4RHvtibWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTim-gxATkTSgGncJcc_WC4RHvtibWg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-06-16 at 08:50 -0500, David Nicol wrote:
> >   Defrag works on individual files, and tries to find a contiguous
> > sequence of bytes to write the file's data to. In the process, the
> > current implementation will break any CoW duplication -- either within
> > single files (copies with cp --reflink=always) or files copied via
> > snapshotting.
> 
> 
> While it's obviously impossible to defrag and maintain deduplicated
> partial chunks simultaneously without some kind of compromise (the
> ideal form of which is just beyond the reach of this list
> participant's obviousness flashlight),  how difficult is it going to
> be to modify the current defrag implementation to hip the additional
> references to the file to the fact that a contiguous version (of an
> individual file) is now available and it's time to update their links
> too, after each file with multiple reflinks/snapshots to its current
> form has been copied to contiguous space?
> 
> Could Bernhard Duebi do it?

Unfortunately not, I'm just a system engineer with interest in storage.
I'm sorry to disapoint you.

Sincerely
Bernhard



