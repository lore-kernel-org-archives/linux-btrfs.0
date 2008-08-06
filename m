From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Hot topics for the next release
Date: Wed, 06 Aug 2008 12:36:51 -0400
Message-ID: <1218040611.15342.92.camel@think.oraclecorp.com>
References: <1218032511.15342.73.camel@think.oraclecorp.com>
	 <4899C64C.2040107@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4899C64C.2040107@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-06 at 11:42 -0400, jim owens wrote:
> > Improved allocator threading
> 
> I wanted to work on the allocator with a larger scope
> where threading is only a minor part of trying to address

Josef's allocator fix is on the list because we currently fall over in
some workloads at 100% cpu time when the FS is 60% full.  The space
indexing is complex and strange, it just needs to be redone.

> these items from the Project_ideas that I think could change
> disk format in some way (to fix it before v1.0):
>   - Different sector sizes

Sector alignment and sector sizes definitely need to happen before 1.0

>   - Multiple chunk trees and extent allocation trees

For these I was planning on only adding the disk format bits needed and
leaving the code alone.

>   - Limiting btree failure domains
> and maybe impacting this from Development_timeline
>    - Reserved space for online fsck and the ability to add
>      storage so that a background extent allocation check can proceed

The reserved space is important as well.

> 
> Maybe this is too ambitious or I am seeing intersections that
> are not there, but I am prepared to try doing the allocator.
> 

I'd love to have help on all of the above, and you're welcome to dive in
and give it a shot.  I'd say to pick one though, starting with smaller
patches is going to be a good idea.

> jim
> 
> P.S.  Are there other V1.0 format issues to lock down that
> should be worked before the missing features like O_DIRECT?

Yes, I'm trying to walk the line between having enough performance for
people to do baseline tests (the results of which may force disk format
changes) and pushing out the disk format changes.

So, things that are very well understood like multiple copies of the
super block or compat flags, I'm pushing off.

-chris




