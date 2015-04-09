Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7321 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831AbbDIXw7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 19:52:59 -0400
Date: Fri, 10 Apr 2015 09:52:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-btrfs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH/RFC] fscache/cachefiles versus btrfs
Message-ID: <20150409235234.GJ13731@dastard>
References: <20150409174916.5a2efef5@notabene.brown>
 <29536.1428571388@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <29536.1428571388@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 10:23:08AM +0100, David Howells wrote:
> NeilBrown <neilb@suse.de> wrote:
> 
> >  Is there a better way?  Could a better way be created?  Maybe
> >  SEEK_DATA_RELIABLE ??
> 
> fiemap() maybe?

fiemap is not reliable for mapping holes - it returns extent info,
not whether there is data in a range. i.e. there can be data over a
hole (e.g. delayed allocation) and fiemap will return it as a hole.
cp made this mistake back when fiemap was first introduced,
resulting in corrupt file copies.

SEEK_HOLE/SEEK_DATA is what you want, as they are page cache
coherent, not extent based operations. And, really if you need it to
really be able to find real holes, then a superblock flag might be a
better way of marking filesystems with the required capability.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
