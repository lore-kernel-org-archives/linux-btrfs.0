From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH v2] Btrfs: improve space count for files with fragments
Date: Fri, 27 Apr 2012 09:44:13 +0800
Message-ID: <4F99F9ED.6030106@cn.fujitsu.com>
References: <1335422363-31198-1-git-send-email-liubo2009@cn.fujitsu.com> <20120426171430.GP22794@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120426171430.GP22794@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/2012 01:14 AM, Chris Mason wrote:

> On Thu, Apr 26, 2012 at 02:39:23PM +0800, Liu Bo wrote:
>> > Here is a simple scenario:
>> > $ dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k count=20;sync
>> > $ btrfs fi df /mnt/btrfs
>> > 
>> > we get 20K used, but then
>> > $ dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k count=4 seek=4 conv=notrunc;sync
>> > $ btrfs fi df /mnt/btrfs
>> > 
>> > we get 24K used.
>> > Here is the problem, it is possible that an _unshared_ file with lots of
>> > fragments costs nearly double space than its i_size, like:
>> > 0k              20k
>> > | --- extent --- |      turned to be on disk    <---  extent --->  <-- A -->
>> >      | - A - |                                  | -------------- | | ----- |
>> >      1k      19k                                       20k + 18k = 38k
>> > 
>> >                         but what users want is  <---  extent --->  <-- A -->
>> >                                                 | --- |     | -- | | ----- |
>> >                                                     1k + 1k + 18k = 20k
>> > so 18k is wasted.
>> > 
>> > With the current backref design, there is no easy way to fix this, because it
>> > needs to touch several subtle parts, such as delayed ref stuff, extent backref.
>> > 
>> > So here I give it a try by splitting the extent which we're processing(the idea
>> > comes from Chris :)).
>> > 
>> > The benifits:
>> > As the above example shows, we'll get three individual extents: 1k + 1k + 18k,
>> > with their checksums are well splitted.
>> > 
>> > The defects:
>> > Yes, it makes the code much uglier.  And since we've disabled the merging of
>> > delayed refs, we'll get some performance regression.
>> > 
>> > NOTE:
>> > The patch may still have some bugs since we need more time to tune the subtle
>> > things.
> 
> Thanks for working on this.  Could you please explain in detail what the
> pinned extents do?


Sure.

Let's take the above case:
0k              20k
| --- extent --- |
    | - A - |
    1k      19k

And we assume that this extent starts from disk_bytenr on its FS logical offset.

By splitting the [0k, 20k) extent, we'll get three delayed refs into the delayed-ref rbtree:
a) [0k, 20k),  in which only [disk_bytenr+1k, disk_bytenr+19k) will be freed at the end.
b) [0k, 1k),   which will _not_ allocate a new extent but use the remained space of [0k, 20k).
c) [19k, 20k), ditto.

And another ref [1k,19k) will get a new allocated space by our normal endio routine.

What I want is
free  [0k, 20k),  set this range DIRTY in the pinned_extents tree.
alloc [0k, 1k),   clear this range DIRTY in the pinned_extents tree.
alloc [19k, 20k), ditto.

However, in my stress test, this three refs may not be ordered by a)->b)->c), but b)->a)->c) instead.
That would be a problem, because it will confuse our space_info's counter: bytes_reserved, bytes_pinned.

So I use EXTENT_PINNED flag to indicate this range will use pinned space rather than reserved space.

As for b)->a)->c), the logic will be:
b) alloc [0k, 1k),   since no range covers this, set it PINNED in the pinned_extents tree.
a) free  [0k, 20k),  set this range DIRTY in the pinned_extents tree, and find [0k, 1k) tagged with PINNED,
   clear [0k, 1k) PINNED & DIRTY in the pinned_extents tree, and update our space_info's counter: bytes_pinned.
c) alloc [19k, 20k), clear this range DIRTY in the pinned_extents tree.

Maybe I'd better pick up a new name for EXTENT_PINNED. :)

Actually I'm not satisfied with the patch as I do not want to make the code any uglier at all, so I kept it as RFC...

Any thoughts?

thanks,
liubo
