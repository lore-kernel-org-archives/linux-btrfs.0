From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Thu, 14 Aug 2008 21:25:54 -0400
Message-ID: <1218763554.15342.460.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
	 <1218747656.15342.439.camel@think.oraclecorp.com>
	 <20080814211756.GC13814@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080814211756.GC13814@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-08-14 at 23:17 +0200, Andi Kleen wrote:
> On Thu, Aug 14, 2008 at 05:00:56PM -0400, Chris Mason wrote:
> > Btrfs defaults                  57.41 MB/s

Looks like I can get the btrfs defaults up to 64MB/s with some writeback
tweaks.

> > Btrfs dup no csum               74.59 MB/s 
> 
> With duplications checksums seem to be quite costly (CPU bound?)
> 

The async worker threads should be spreading the load across CPUs pretty
well, and even a single CPU could keep up with 100MB/s checksumming.
But, the async worker threads do randomize the IO somewhat because the
IO goes from pdflush -> one worker thread per CPU -> submit_bio.  So,
maybe that 3rd thread is more than the drive can handle?

btrfsck tells me the total size of the btree is only 20MB larger with
checksumming on.

> > Btrfs no duplication            76.83 MB/s
> > Btrfs no dup no csum no inline  76.85 MB/s
> 
> But without duplication they are basically free here at least
> in IO rate. Seems odd?
> 
> Does it compute them twice in the duplication case perhaps?
> 

The duplication happens lower down in the stack, they only get done
once.

-chris


