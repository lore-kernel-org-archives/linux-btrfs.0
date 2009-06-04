From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Thu, 4 Jun 2009 07:43:57 -0400
Message-ID: <20090604114357.GK13945@think>
References: <1240953977.15136.76.camel@think.oraclecorp.com> <20090428221455.GA27794@cip.informatik.uni-erlangen.de> <1240960687.15136.88.camel@think.oraclecorp.com> <20090429120300.GG22917@cip.informatik.uni-erlangen.de> <1241010875.20099.2.camel@think.oraclecorp.com> <20090429135804.GI22917@cip.informatik.uni-erlangen.de> <1241015512.20099.30.camel@think.oraclecorp.com> <20090429152614.GJ22917@cip.informatik.uni-erlangen.de> <1241019915.20099.35.camel@think.oraclecorp.com> <20090604084919.GB22607@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090604084919.GB22607@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 04, 2009 at 10:49:19AM +0200, Thomas Glanzmann wrote:
> Hello Chris,
> 
> > >  My question is now, how often can a block in btrfs be refferenced?
> 
> > The exact answer depends on if we are referencing it from a single
> > file or from multiple files.  But either way it is roughly 2^32.
> 
> could you please explain to me what underlying datastructure is used to
> monitor if the block is still referenced or already free? Is a counter
> used, bitmap (but that can't be if is 2^32) or some sort of list? I
> assume that a counter is used. If this is the case, I assume when a
> snapshot for example is deleted the reference counter of every block
> that was referenced in the snapshot will be decremented by one. Is this
> correct or am I missing something here?

It is a counter and a back reference.  With Yan Zheng's new format work,
the limit is not 2^64.

When a snapshot is deleted, the btree is walked to efficiently drop the
references on the blocks it referenced.

>From a dedup point of view, we'll want the dedup file to hold a
reference on the file extents.  The kernel ioctl side of things will
take care of that part.

-chris

