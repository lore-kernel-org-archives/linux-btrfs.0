From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Wed, 07 Jan 2009 13:45:57 -0500
Message-ID: <1231353957.5016.2.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <1231270893.4888.19.camel@think.oraclecorp.com>
	 <1231320811.30643.30.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Ryusuke Konishi <ryusuke@osrg.net>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231320811.30643.30.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 09:33 +0000, David Woodhouse wrote:
> On Tue, 2009-01-06 at 14:41 -0500, Chris Mason wrote:

> One more thing I'd suggest is removing the INSTALL file. The parts about
> having to build libcrc32c aren't relevant when it's part of the kernel
> tree and you have 'select LIBCRC32C', and the documentation on the
> userspace utilities probably lives _with_ the userspace repo. Might be
> worth adding a pointer to the userspace utilities though, in
> Documentation/filesystems/btrfs.txt
> 
> I think you can drop your own copy of the GPL too.
> 

I've pushed out your patch for this, thanks.

-chris


