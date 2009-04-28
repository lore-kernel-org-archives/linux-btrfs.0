From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 19:18:07 -0400
Message-ID: <1240960687.15136.88.camel@think.oraclecorp.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
	 <200904281945.10274.hjclaes@web.de>
	 <20090428201619.GK7217@cip.informatik.uni-erlangen.de>
	 <200904282236.07428.hjclaes@web.de>
	 <20090428205242.GA13112@cip.informatik.uni-erlangen.de>
	 <1240952295.15136.73.camel@think.oraclecorp.com>
	 <20090428211255.GB13112@cip.informatik.uni-erlangen.de>
	 <1240953977.15136.76.camel@think.oraclecorp.com>
	 <20090428221455.GA27794@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090428221455.GA27794@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-29 at 00:14 +0200, Thomas Glanzmann wrote:
> Hello Chris,
> 
> > They are, but only the crc32c are stored today.
> 
> maybe crc32c is good enough to identify duplicated blocks, I mean we
> only need a hint, the dedup ioctl does the double checking. I will write
> tomorrow a perl script and compare the results to the one that uses md5
> and repoort back.

Its a start at least.

> 
> > Yes, that's the idea.  An ioctl to walk the tree and report on
> > changes, but this doesn't have to be done with version 1 of the dedup
> > code, you can just scan the file based on mtime/ctime.
> 
> Good point.
> 
> > > > But, the ioctl to actually do the dedup needs to be able to verify a
> > > > given block has the contents you expect it to.  The only place you can
> > > > lock down the pages in the file and prevent new changes is inside the
> > > > kernel.
> 
> > > I totally agree to that. How much time would it consume to implement
> > > such a systemcall?
> 
> > It is probably a 3 week to one month effort.
> 
> I'm taking the challenge. Is there a document that I can read that
> introduces me to the structures used in btrfs or can someone walk me
> through on the phone to get a quick start?
> 

Great to hear.  It's an ambitious project, but I'll definitely help
explain things.

You can start with the code documentation section on
http://btrfs.wiki.kernel.org

I'll write up my ideas on how userspace controlled dedup should work.

> I also would like to retrieve the checksums and identify the potential
> blocks and after that work is done (even in a very preliminary state) in
> a way that someone can work with it, I would like to move on to the
> dedup ioctl.

Sounds fair, I'll forward the original patch.

-chris


