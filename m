From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Btrfs for mainline
Date: Fri, 02 Jan 2009 20:05:50 +0100
Message-ID: <87r63ljzox.fsf@basil.nowhere.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	<20081231104533.abfb1cf9.akpm@linux-foundation.org>
	<1230765549.7538.8.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1230765549.7538.8.camel@think.oraclecorp.com> (Chris Mason's message of "Wed, 31 Dec 2008 18:19:09 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:

> On Wed, 2008-12-31 at 10:45 -0800, Andrew Morton wrote:
>> On Wed, 31 Dec 2008 06:28:55 -0500 Chris Mason <chris.mason@oracle.com> wrote:
>> 
>> > Hello everyone,
>> 
>> Hi!
>> 
>> > I've done some testing against Linus' git tree from last night and the
>> > current btrfs trees still work well.
>> 
>> what's btrfs?  I think I've heard the name before, but I've never
>> seen the patches :)
>
> The source is up to around 38k loc, I thought it better to use that http
> thing for people who were interested in the code.
>
> There is also a standalone git repo:
>
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git;a=summary

Some items I remember from my last look at the code that should
be cleaned up before mainline merge (that wasn't a full in depth review):

- locking.c needs a lot of cleanup.
If combination spinlocks/mutexes are really a win they should be 
in the generic mutex framework. And I'm still dubious on the hardcoded 
numbers.
- compat.h needs to go
- there's various copy'n'pasted code from the VFS (like may_create) 
that needs to be cleaned up.
- there should be manpages for all the ioctls and other interfaces.
- ioctl.c was not explicitely root protected. security issues?
- some code was severly undercommented.
e.g. each file should at least have a one liner
describing what it does (ideally at least a paragraph). Bad examples
are export.c or free-space-cache.c, but also others.
- ENOMEM checks are still missing all over (e.g. with most of the 
btrfs_alloc_path callers). If you keep it that way you would need
at least XFS style "loop for ever" alloc wrappers, but better just
fix all the callers. Also there used to be a lot of BUG_ON()s on
memory allocation failure even.
- In general BUG_ONs need review I think. Lots of externally triggerable
ones.
- various checkpath.pl level problems I think (e.g. printk levels) 
- the printks should all include which file system they refer to

In general I think the whole thing needs more review.

-Andi

-- 
ak@linux.intel.com
