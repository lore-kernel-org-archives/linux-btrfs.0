Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16928 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750934AbcILXSa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 19:18:30 -0400
Date: Tue, 13 Sep 2016 09:18:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com, jack@suse.com,
        viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@lst.de,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/3] writeback: allow for dirty metadata accounting
Message-ID: <20160912231826.GK22388@dastard>
References: <1471887302-12730-1-git-send-email-jbacik@fb.com>
 <1471887302-12730-3-git-send-email-jbacik@fb.com>
 <20160909081743.GC22777@quack2.suse.cz>
 <bd00ed53-00c8-49d2-13b2-5f7dfa607185@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bd00ed53-00c8-49d2-13b2-5f7dfa607185@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 12, 2016 at 10:56:04AM -0400, Josef Bacik wrote:
> I think that looping through all the sb's in the system would be
> kinda shitty for this tho, we want the "get number of dirty pages"
> part to be relatively fast.  What if I do something like the
> shrinker_control only for dirty objects. So the fs registers some
> dirty_objects_control, we call into each of those and get the counts
> from that.  Does that sound less crappy?  Thanks,

Hmmm - just an off-the-wall thought on this....

If you're going to do that, then why wouldn't you simply use a
"shrinker" to do the metadata writeback rather than having a hook to
count dirty objects to pass to some other writeback code that calls
a hook to write the metadata?

That way filesystems can also implement dirty accounting and
"writers" for each cache of objects they currently implement
shrinkers for. i.e. just expanding shrinkers to be able to "count
dirty objects" and "write dirty objects" so that we can tell
filesystems to write back all their different metadata caches
proportionally to the size of the page cache and it's dirty state.
The existing file data and inode writeback could then just be new
generic "superblock shrinker" operations, and the fs could have it's
own private metadata writeback similar to the private sb shrinker
callout we currently have...

And, in doing so, we might be able to completely hide memcg from the
writeback implementations similar to the way memcg is completely
hidden from the shrinker reclaim implementations...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
