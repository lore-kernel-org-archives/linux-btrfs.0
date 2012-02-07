From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Tue, 7 Feb 2012 08:04:31 -0600
Message-ID: <20120207140431.GB5639@localhost.localdomain>
References: <20120205184128.GC18806@localhost.localdomain>
 <20120207033945.GA5639@localhost.localdomain>
 <pan.2012.02.07.09.53.58@cox.net>
Reply-To: nemesis@icequake.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.02.07.09.53.58@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>


> > Unfortunately, I am going to have to give up on btrfs if it
> > is really so fragile.
> 
> However, complaining about the fragility of a still in development
> and 
> marked experimental filesystem would seem disingenuous at best.  
[snip paragraphs of tut-tutting]
> IOW, yes, btrfs is to be considered fragile at this point.

So you re-stated my position.  I gave btrfs a chance but it is still
apparently far more fragile than ext4 when corruption is introduced --
although btrfs is the filesystem of the two which is specifically
designed to provide internal fault tolerance and resilience.  Is there
a fine line between "user feedback" and "disingenuous complaining"
that I am not aware of?

The data in question is not that important, though I would like to
have it back considering it should mostly still be there as on the
ext4 volumes.  40MB of bad sectors on one 2TB disk in a 6TB volume
does not seem like a lot.  Even if the whole beginning of the volume
was wiped out surely there is the equivalent of backup superblocks?  I
can hack if I could just get a clue where to start.

-- 
Ryan C. Underwood, <nemesis@icequake.net>
