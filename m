From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Sat, 16 Aug 2008 14:10:10 -0400
Message-ID: <1218910210.19495.25.camel@think.oraclecorp.com>
References: <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
	 <1218747656.15342.439.camel@think.oraclecorp.com>
	 <20080814234458.GD13048@mit.edu>
	 <1218762627.15342.447.camel@think.oraclecorp.com>
	 <1218804361.15342.470.camel@think.oraclecorp.com>
	 <20080815134545.GM13048@mit.edu>
	 <1218822772.15342.503.camel@think.oraclecorp.com>
	 <20080815195941.GB22395@mit.edu>
	 <1218832622.19495.14.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218832622.19495.14.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-08-15 at 16:37 -0400, Chris Mason wrote:
> On Fri, 2008-08-15 at 15:59 -0400, Theodore Tso wrote:
> > On Fri, Aug 15, 2008 at 01:52:52PM -0400, Chris Mason wrote:
> > > Have you tried this one:
> > > 
> > > http://article.gmane.org/gmane.linux.file-systems/25560
> > > 
> > > This bug should cause fragmentation on small files getting forced out
> > > due to memory pressure in ext4.  But, I wasn't able to really
> > > demonstrate it with ext4 on my machine.
> > 
> > I've been able to use compilebench to see the fragmentation problem
> > very easily.
> > 
> > Annesh has been workign on it, and has some fixes that he queued up.
> > I'll have to point him at your proposed fix, thanks.  This is what he
> > came up with in the common code.  What do you think?
> > 
> 
> It sounds like ext4 would show the writeback_index bug with
> fragmentation on disk and btrfs would show it with seeks during the
> benchmark.  I was only watching the throughput numbers and not looking
> at filefrag results.
> 

I tried just the writeback_index patch and got only 4 fragmented files
on ext4 after a compilebench run.  Then I tried again and got 1200.
Seems there is something timing dependent in here ;)

By default compilebench uses 256k buffers for writing (see compilebench
-b) and btrfs_file_write will lock down up to 512 pages at a time during
a single write.  This means that for most small files, compilebench will
send the whole file down in one write() and btrfs_file_write will lock
down pages for the entire write() call while working on it.

So, even if pdflush tries to jump in and do the wrong thing, the pages
will be locked by btrfs_file_write and pdflush will end up skipping
them.

With the generic file write routines, pages are locked one at a time,
giving pdflush more windows to trigger delalloc while a write is still
ongoing.

-chris


