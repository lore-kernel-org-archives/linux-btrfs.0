From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Thu, 07 Aug 2008 06:39:57 -0400
Message-ID: <1218105597.15342.189.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756847AbYHGMoZ@vger.kernel.org>
In-Reply-To: <1218100464.8625.9.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-08-07 at 11:14 +0200, Peter Zijlstra wrote:
> On Tue, 2008-08-05 at 15:01 -0400, Chris Mason wrote:
> 
> > There are still more disk format changes planned, but we're making every
> > effort to get them out of the way as quickly as we can.  You can see the
> > major features we have planned on the development timeline:
> > 
> > http://btrfs.wiki.kernel.org/index.php/Development_timeline
> 
> Just took a peek, seems to be slightly out of date as it still lists the
> single mutex thingy.

Thanks, I thought I had removed all the references to it on that page,
but there was one left.

> 
> Also, how true is the IO-error and disk-full claim?
> 

We still don't handle disk full.  The IO errors are handled most of the
time.  If a checksum doesn't match or the lower layers report an IO
error, btrfs will use an alternate mirror of the block.  If there is no
alternate mirror, the caller gets EIO and in the case of a failed csum,
the page is zero filled (actually filled with ones so I can find bogus
pages in an oops).

Metadata is duplicated by default even on single spindle drives, so this
means that metadata IO errors are handled as long as the other mirror is
happy.

If mirroring is off or both mirrors are bad, we currently get into
trouble.

data pages work better, those errors bubble up to userland just like in
other filesystems.

-chris
