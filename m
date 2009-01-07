From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Btrfs for mainline
Date: Wed, 07 Jan 2009 09:33:31 +0000
Message-ID: <1231320811.30643.30.camel@macbook.infradead.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <1231270893.4888.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Ryusuke Konishi <ryusuke@osrg.net>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231270893.4888.19.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 14:41 -0500, Chris Mason wrote:
> Hello everyone,
> 
> Thanks for all of the comments so far.  I've pushed out a number of
> fixes for btrfs mainline, covering most of the comments from this
> thread.
> 
> * All LINUX_KERNEL_VERSION checks are gone.
> * checkpatch.pl fixes
> * Extra permission checks on the ioctls
> * Some important bug fixes from the btrfs list
> * Andi found a buggy use of kmap_atomic during checksum verification
> * Drop EXPORT_SYMBOLs from extent_io.c

Looking good...

> Unresolved from this reviewing thread:
> 
> * Should it be named btrfsdev?  My vote is no, it is extra work for the
> distros when we finally do rename it, and I don't think btrfs really has
> the reputation for stability right now.  But if Linus or Andrew would
> prefer the dev on there, I'll do it.

I agree; I don't think there's any particular need for the 'dev' suffix.
It's already dependent on CONFIG_EXPERIMENTAL, after all.

> * My ugly mutex_trylock spin.  It's a hefty performance gain so I'm
> hoping to keep it until there is a generic adaptive lock.

If a better option is forthcoming, by all means use it -- but I wouldn't
see the existing version as a barrier to merging.


One more thing I'd suggest is removing the INSTALL file. The parts about
having to build libcrc32c aren't relevant when it's part of the kernel
tree and you have 'select LIBCRC32C', and the documentation on the
userspace utilities probably lives _with_ the userspace repo. Might be
worth adding a pointer to the userspace utilities though, in
Documentation/filesystems/btrfs.txt

I think you can drop your own copy of the GPL too.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

