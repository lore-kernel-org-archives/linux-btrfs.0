From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Wed, 29 Apr 2009 10:31:52 -0400
Message-ID: <1241015512.20099.30.camel@think.oraclecorp.com>
References: <20090428201619.GK7217@cip.informatik.uni-erlangen.de>
	 <200904282236.07428.hjclaes@web.de>
	 <20090428205242.GA13112@cip.informatik.uni-erlangen.de>
	 <1240952295.15136.73.camel@think.oraclecorp.com>
	 <20090428211255.GB13112@cip.informatik.uni-erlangen.de>
	 <1240953977.15136.76.camel@think.oraclecorp.com>
	 <20090428221455.GA27794@cip.informatik.uni-erlangen.de>
	 <1240960687.15136.88.camel@think.oraclecorp.com>
	 <20090429120300.GG22917@cip.informatik.uni-erlangen.de>
	 <1241010875.20099.2.camel@think.oraclecorp.com>
	 <20090429135804.GI22917@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090429135804.GI22917@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-29 at 15:58 +0200, Thomas Glanzmann wrote:
> Hello Chris,
> 
> > But, in your ioctls you want to deal with [file, offset, len], not
> > directly with block numbers.  COW means that blocks can move around
> > without you knowing, and some of the btrfs internals will COW files in
> > order to relocate storage.
> 
> > So, what you want is a dedup file (or files) where your DB knows a given
> > offset in the file has a given csum.
> 
> how do I track if a certain block has already been deduplicated?
> 

Your database should know, and the ioctl could check to see if the
source and destination already point to the same thing before doing
anything expensive.

> So, if I only have file, offset, len and not the block number, is there
> a way from userland to tell if two blocks are already point to the same
> block?

You can use the fiemap ioctl.

-chris


