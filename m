From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Fri, 08 Aug 2008 14:48:13 -0400
Message-ID: <1218221293.15342.263.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <877ias66v4.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-08-07 at 20:02 +0200, Andi Kleen wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> >
> > Metadata is duplicated by default even on single spindle drives, 
> 
> Can you please say a bit how much that impacts performance? That sounds 
> costly.

Most metadata is allocated in groups of 128k or 256k, and so most of the
writes are nicely sized.  The mirroring code has areas of the disk
dedicated to mirror other areas.  So we end up with something like this:

metadata chunk A (~1GB in size)
[ ......................... ]

mirror of chunk A (~1GB in size)
[ ......................... ]

So, the mirroring turns a single large write into two large writes.
Definitely not free, but always a fixed cost.

I started to make some numbers of this yesterday on single spindles and
discovered that my worker threads are not doing as good a job as they
should be of maintaining IO ordering.  I've been using an array with a
writeback cache for benchmarking lately and hadn't noticed.

I need to fix that, but here are some numbers on a single sata drive.
The drive can do about 100MB/s streaming reads/writes.  Btrfs
checksumming and inline data (tail packing) are both turned on.

Single process creating 30 kernel trees (2.6.27-rc2)

Btrfs defaults	36MB/s
Btrfs no mirror 50MB/s
Ext4 defaults   59.2MB/s (much better than ext3 here)

With /sys/block/sdb/queue/nr_requests at 8192 to hide my IO ordering
submission problems:

Btrfs defaults: 57MB/s
Btrfs no mirror: 61.51MB/s

-chris


