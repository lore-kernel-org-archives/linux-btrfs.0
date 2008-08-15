From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Fri, 15 Aug 2008 09:00:56 -0400
Message-ID: <1218805256.15342.484.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
	 <1218747656.15342.439.camel@think.oraclecorp.com>
	 <20080814211756.GC13814@one.firstfloor.org>
	 <1218763554.15342.460.camel@think.oraclecorp.com>
	 <20080815013934.GE19125@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080815013934.GE19125@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-08-15 at 03:39 +0200, Andi Kleen wrote:
> > The async worker threads should be spreading the load across CPUs pretty
> > well, and even a single CPU could keep up with 100MB/s checksumming.
> > But, the async worker threads do randomize the IO somewhat because the
> > IO goes from pdflush -> one worker thread per CPU -> submit_bio.  So,
> > maybe that 3rd thread is more than the drive can handle?
> 
> You have more threads with duplication? 
> 

It was a very confusing use of the word thread.  I have the same number
of kernel threads running, but the single spindle on the drive has to
deal with 3 different streams of writes.  The seeks/sec portion of the
graph shows a big enough increase in seeks on the duplication run to
explain the performance.

> > btrfsck tells me the total size of the btree is only 20MB larger with
> > checksumming on.
> > 
> > > > Btrfs no duplication            76.83 MB/s
> > > > Btrfs no dup no csum no inline  76.85 MB/s
> > > 
> > > But without duplication they are basically free here at least
> > > in IO rate. Seems odd?
> > > 
> > > Does it compute them twice in the duplication case perhaps?
> > > 
> > 
> > The duplication happens lower down in the stack, they only get done
> > once.
> 
> Ok was just speculation. The big difference still seems odd.

It does, I'll give the test a shot on other hardware too.  To be honest
I'm pretty happy at matching ext4 with duplication on.  The graph shows
even writeback and the times from each iteration are fairly consistent.

Ext3 and XFS score somewhere between 10-15MB/s on the same test...

-chris


