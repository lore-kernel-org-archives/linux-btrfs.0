From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Testsuite (was: Re: Hi!)
Date: Mon, 25 Aug 2008 13:15:14 -0400
Message-ID: <20080825171514.GA15530@infradead.org>
References: <1219221805.15514.13.camel@telesto> <1219256750.7854.7.camel@think.oraclecorp.com> <200808251006.03791.slong@rathaus.eclipse.co.uk> <1219667498.28188.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve Long <slong@rathaus.eclipse.co.uk>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219667498.28188.4.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 25, 2008 at 08:31:38AM -0400, Chris Mason wrote:
> On Mon, 2008-08-25 at 10:06 +0100, Steve Long wrote:
> > > Testing, discussing and reporting bugs are a great first step.
> > >
> > Just wondering whether btrfs has, or might want, something like this:
> > http://blogs.sun.com/bill/entry/zfs_and_the_all_singing
> > 
> > I don't have anything like it from btrfs-progs, apart from btrfs-debug-tree.
> > I'm sure you're doing tests internally and users are testing stuff too; 
> > formalising it a bit and collaborating on that element might be useful?
> > 
> > (Apologies if I'm missing something obvious.)
> 
> We don't have an official test suite yet, but a few people are working
> on various parts of it.  It is definitely an area where collaboration is
> useful and needed.

And I'd like to again say that if you want to start on a testsuite it
might be a good idea to extend the xfs testsuite.  It already deals with
udf and partially nfs and having one testsuite to run on multiple
filesystems is always a good idea.  It already supports testcases
specific to a certain filesystem or OS.
