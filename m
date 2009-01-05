From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 05 Jan 2009 09:01:58 -0500
Message-ID: <1231164118.4290.17.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20090103195034.GA27541@infradead.org>
	 <1231013856.7538.89.camel@think.oraclecorp.com>
	 <200901042252.45054.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754499AbZAEOCk@vger.kernel.org>
In-Reply-To: <200901042252.45054.arnd@arndb.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-01-04 at 22:52 +0100, Arnd Bergmann wrote:
> On Saturday 03 January 2009, Chris Mason wrote:
> > 
> > > Actually a lot of the ioctl API don't just need documentation but
> > > a complete redo.  That's true at least for the physical device
> > > management and subvolume / snaphot ones.
> > > 
> > 
> > The ioctl interface is definitely not finalized.  Adding more vs
> > replacing the existing ones is an open question.
> 
> As long as that's an open question, the ioctl interface shouldn't get
> merged into the kernel, or should get in as btrfsdev, otherwise you
> get stuck with the current ABI forever.
> 

Maintaining the current ioctls isn't a problem.  There aren't very many
and they do very discrete things.  The big part that may change is the
device scanning, which may get more integrated into udev and mount (see
other threads about this).

But, that is one very simple ioctl, and most of the code it uses is
going to stay regardless of how the device scanning is done.

-chris
