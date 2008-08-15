From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Fri, 15 Aug 2008 08:46:01 -0400
Message-ID: <1218804361.15342.470.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
	 <1218747656.15342.439.camel@think.oraclecorp.com>
	 <20080814234458.GD13048@mit.edu>
	 <1218762627.15342.447.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218762627.15342.447.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-08-14 at 21:10 -0400, Chris Mason wrote:
> On Thu, 2008-08-14 at 19:44 -0400, Theodore Tso wrote:
> > > I spent a bunch of time hammering on different ways to fix this without
> > > increasing nr_requests, and it was a mixture of needing better tuning in
> > > btrfs and needing to init mapping->writeback_index on inode allocation.
> > > 
> > > So, today's numbers for creating 30 kernel trees in sequence:
> > > 
> > > Btrfs defaults                  57.41 MB/s
> > > Btrfs dup no csum               74.59 MB/s 
> > > Btrfs no duplication            76.83 MB/s
> > > Btrfs no dup no csum no inline  76.85 MB/s
> > 
> > What sort of script are you using?  Basically something like this?
> > 
> > for i in `seq 1 30` do
> >     mkdir $i; cd $i
> >     tar xjf /usr/src/linux-2.6.28.tar.bz2
> >     cd ..
> > done
> 
> Similar.  I used compilebench -i 30 -r 0, which means create 30 initial
> kernel trees and then do nothing.  compilebench simulates compiles by
> writing to the FS files of the same size that you would get by creating
> kernel trees or compiling them.
> 
> The idea is to get all of the IO without needing to keep 2.6.28.tar.bz2
> in cache or the compiler using up CPU.
> 
> http://www.oracle.com/~mason/compilebench

Whoops the link above is wrong, try:

http://oss.oracle.com/~mason/compilebench

It is worth noting that the end throughput doesn't matter quite as much
as the writeback pattern.  Ext4 is pretty solid on this test, with very
consistent results.

-chris


