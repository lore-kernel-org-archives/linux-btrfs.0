From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Latest tree?
Date: Thu, 2 Jul 2009 14:03:21 -0400
Message-ID: <20090702180321.GH9498@think>
References: <4A4CDC43.2020300@austin.ibm.com> <20090702162448.GF9498@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090702162448.GF9498@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 02, 2009 at 12:24:48PM -0400, Chris Mason wrote:
> On Thu, Jul 02, 2009 at 11:11:47AM -0500, Steven Pratt wrote:
> > What is the latest experimental tree to pull from?  We had an  
> > experimental branch, plus the newformat and newformat2 branches.  Which  
> > has the very latest stuff?
> 
> Right now the master branch and the newformat2 branch are the same.  The
> master branch is what I ask Linus to pull from and the newformat2 branch
> is the dedicated backport of all the critical newformat fixes against
> 2.6.30.
> 
> There's one bug in both branches around the nodatacow and nodatasum
> modes (both are ignored).  I plan on pushing that out today.

Just a quick note, I've pushed out my current queue of fixes to both the
master and newformat2 trees.  The big thing missing is Josef's work on
the free space tracking and async block group caching, but I'll pull
that in once it stabilizes.

-chris
