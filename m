From: tvrtko.ursulin@sophos.com
Subject: Re: Btrfs v0.16 released
Date: Thu, 7 Aug 2008 16:07:15 +0100
Message-ID: <20080807150809.577D82FE8BE@pmx1.sophos.com>
References: <1218105242.15342.184.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218105242.15342.184.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote on 07/08/2008 11:34:02:

> > > * Helper threads for checksumming and other background tasks.  Most 
CPU
> > > intensive operations have been pushed off to helper threads to take
> > > advantage of SMP machines.  Streaming read and write throughput now
> > > scale to disk speed even with checksumming on.
> > 
> > Can this lead to the same Priority Inversion issues as seen with
> > kjournald?
> 
> Yes, although in general only the helper threads end up actually doing
> the IO for writes.  Unfortunately, they are almost but not quite an
> elevator.  It is tempting to try sorting the bios on the helper queues
> etc.  But I haven't done that because it gets into starvation and other
> fun.
> 
> I haven't done any real single cpu testing, it may make sense in those
> workloads to checksum and submit directly in the calling context.  But
> real single cpu boxes are harder to come by these days.

[just jumping in as a casual bystander with one remark]

For this purpose it seems booting up with limiting to one CPU should be 
sufficient.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

