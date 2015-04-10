Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:47816 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbbDJBJd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 21:09:33 -0400
Date: Fri, 10 Apr 2015 11:08:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: NeilBrown <neilb@suse.de>
Cc: David Howells <dhowells@redhat.com>, linux-btrfs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH/RFC] fscache/cachefiles versus btrfs
Message-ID: <20150410010850.GK13731@dastard>
References: <20150409174916.5a2efef5@notabene.brown>
 <29536.1428571388@warthog.procyon.org.uk>
 <20150409235234.GJ13731@dastard>
 <20150410104221.0d156c74@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150410104221.0d156c74@notabene.brown>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 10, 2015 at 10:42:21AM +1000, NeilBrown wrote:
> On Fri, 10 Apr 2015 09:52:34 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Thu, Apr 09, 2015 at 10:23:08AM +0100, David Howells wrote:
> > > NeilBrown <neilb@suse.de> wrote:
> > > 
> > > >  Is there a better way?  Could a better way be created?  Maybe
> > > >  SEEK_DATA_RELIABLE ??
> > > 
> > > fiemap() maybe?
> > 
> > fiemap is not reliable for mapping holes - it returns extent info,
> > not whether there is data in a range. i.e. there can be data over a
> > hole (e.g. delayed allocation) and fiemap will return it as a hole.
> > cp made this mistake back when fiemap was first introduced,
> > resulting in corrupt file copies.
> 
> I assumed from the doco that FIEMAP_EXTENT_DELALLOC would get returned in
> this case.  I guess not?

FIEMAP is advisory and implementing features in it are optional.
It's also not guaranteed to be an accurate representation of the
layout of the file because it can change even before hte FIEMAP
ioctl returns to userspace. it's also a representation of the
physical layout of the data in the file, but it does not need to be
coherent with the current data in the file.  i.e. FIEMAP is not
required to report the current state of data in the files to the
caller, just the working physical layout sitting in memory...

> > SEEK_HOLE/SEEK_DATA is what you want, as they are page cache
> > coherent, not extent based operations. And, really if you need it to
> > really be able to find real holes, then a superblock flag might be a
> > better way of marking filesystems with the required capability.
> 
> btrfs seems to use the same underlying functionality for both fiemap and
> SEEK_HOLE/SEEK_DATA...

That's just an internal implementation detail - it does not
define the behaviour and constraints of the information
FIEMAP or SEEK_HOLE/SEEK_DATA APIs are supposed to provide.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
