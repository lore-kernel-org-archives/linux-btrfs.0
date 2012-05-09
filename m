From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH v2] Btrfs: improve space count for files with
 fragments
Date: Wed, 9 May 2012 19:29:16 +0200
Message-ID: <20120509172916.GP19331@twin.jikos.cz>
References: <1335422363-31198-1-git-send-email-liubo2009@cn.fujitsu.com>
 <20120426171430.GP22794@shiny>
 <4F99F9ED.6030106@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F99F9ED.6030106@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2012 at 09:44:13AM +0800, Liu Bo wrote:
> Let's take the above case:
> 0k              20k
> | --- extent --- |
>     | - A - |
>     1k      19k
> 
> And we assume that this extent starts from disk_bytenr on its FS logical offset.
> 
> By splitting the [0k, 20k) extent, we'll get three delayed refs into the delayed-ref rbtree:
> a) [0k, 20k),  in which only [disk_bytenr+1k, disk_bytenr+19k) will be freed at the end.
> b) [0k, 1k),   which will _not_ allocate a new extent but use the remained space of [0k, 20k).
> c) [19k, 20k), ditto.
> 
> And another ref [1k,19k) will get a new allocated space by our normal endio routine.
> 
> What I want is
> free  [0k, 20k),  set this range DIRTY in the pinned_extents tree.
> alloc [0k, 1k),   clear this range DIRTY in the pinned_extents tree.
> alloc [19k, 20k), ditto.
> 
> However, in my stress test, this three refs may not be ordered by a)->b)->c), but b)->a)->c) instead.
> That would be a problem, because it will confuse our space_info's counter: bytes_reserved, bytes_pinned.

Do you have an idea why the ordering may become broken? If it's a race,
it might be better to fix it instead of adding a new bit to extent
flags.


david
