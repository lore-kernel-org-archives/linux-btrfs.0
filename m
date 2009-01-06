From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Tue, 06 Jan 2009 14:41:33 -0500
Message-ID: <1231270893.4888.19.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Ryusuke Konishi <ryusuke@osrg.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1230722935.4680.5.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Thanks for all of the comments so far.  I've pushed out a number of
fixes for btrfs mainline, covering most of the comments from this
thread.

* All LINUX_KERNEL_VERSION checks are gone.
* checkpatch.pl fixes
* Extra permission checks on the ioctls
* Some important bug fixes from the btrfs list
* Andi found a buggy use of kmap_atomic during checksum verification
* Drop EXPORT_SYMBOLs from extent_io.c

Unresolved from this reviewing thread:

* Should it be named btrfsdev?  My vote is no, it is extra work for the
distros when we finally do rename it, and I don't think btrfs really has
the reputation for stability right now.  But if Linus or Andrew would
prefer the dev on there, I'll do it.

* My ugly mutex_trylock spin.  It's a hefty performance gain so I'm
hoping to keep it until there is a generic adaptive lock.

The full kernel tree is here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary


The standalone tree just has the btrfs files and commits, reviewers may
find it easier:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git;a=summary

The utilities can be found here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

-chris


