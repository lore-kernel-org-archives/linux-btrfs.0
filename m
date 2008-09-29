From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Hang running fs_mark
Date: Mon, 29 Sep 2008 14:48:49 -0400
Message-ID: <1222714129.30627.27.camel@think.oraclecorp.com>
References: <20080925175643.GA14205@unused.rdu.redhat.com>
	 <1222367822.7028.55.camel@think.oraclecorp.com>
	 <20080925183435.GB14205@unused.rdu.redhat.com>
	 <1222369531.7028.58.camel@think.oraclecorp.com> <48DBF693.20501@redhat.com>
	 <1222376682.7028.80.camel@think.oraclecorp.com>
	 <48DBFE4D.6080100@redhat.com>
	 <1222381686.7028.86.camel@think.oraclecorp.com>
	 <48DC178E.7070302@redhat.com>
	 <1222390093.7028.88.camel@think.oraclecorp.com>
	 <48DC3455.9010907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48DC3455.9010907@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-09-25 at 21:01 -0400, Ric Wheeler wrote:
> Chris Mason wrote:
> > On Thu, 2008-09-25 at 18:58 -0400, Ric Wheeler wrote:
> >   
> >>> I'm at 6.9 million files so far on a 500GB disk, and not surprisingly, I
> >>> get  155 files/sec ;)  My hope is that we're spinning around due to bad
> >>> accounting on the reserved extents, and that Yan's latest patch set will
> >>> fix it.
> >>>
> >>> -chris
> >>>       
> >> I can update & restart my test as well. It is an odd box (8 CPUs, only 
> >> 1GB of DRAM and a single large 1TB s-ata drive). Hopefully useful in 
> >> testing out edge conditions ;-)
> >>     
> >
> > I'll push out Yan's patches tomorrow.  My box here is at 17.5 million
> > files and still going at 148 files/sec
> >   
> Sounds like a plan, thanks!

I turned up a long standing balancing bug while testing Yan's latest
code.  It took forever to track down, but I've finally pushed out his
patches.

My fs_mark run never did stall, but I'm retesting now with all of the
latest changes.  You'll need to pull the latest unstable btrfs-progs and
kernel from git.

-chris


