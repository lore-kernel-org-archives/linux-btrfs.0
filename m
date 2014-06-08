Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52521 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaFHLLq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 07:11:46 -0400
Received: by mail-lb0-f169.google.com with SMTP id s7so2446932lbd.14
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Jun 2014 04:11:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140608105359.GB9291@localhost.localdomain>
References: <1402035958-30013-1-git-send-email-bo.li.liu@oracle.com>
	<CAL3q7H7pYVLzaoLM6Je6dnDoHiACBAA0r_n1DGAWDuQJzJ7n3Q@mail.gmail.com>
	<20140608105359.GB9291@localhost.localdomain>
Date: Sun, 8 Jun 2014 12:11:43 +0100
Message-ID: <CAL3q7H7P17Q9v_x_zN_R8e1B0n-mtZecQp1NV3MVrLNz_A68JQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix leaf corruption after __btrfs_drop_extents
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, levin.front@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 8, 2014 at 11:54 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Jun 06, 2014 at 01:11:17PM +0100, Filipe David Manana wrote:
>> On Fri, Jun 6, 2014 at 7:25 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> > Several reports about leaf corruption has been floating on the list, one of them
>> > points to __btrfs_drop_extents(), and we find that the leaf becomes corrupted
>> > after __btrfs_drop_extents(), it's really a rare case but it does exist.
>> >
>> > The problem turns out to be btrfs_next_leaf() called in __btrfs_drop_extents().
>> >
>> > So in btrfs_next_leaf(), we release the current path to re-search the last key of
>> > the leaf for locating next leaf, and we've taken it into account that there might
>> > be balance operations between leafs during this 'unlock and re-lock' dance, so
>> > we check the path again and advance it if there are now more items available.
>> > But things are a bit different if that last key happens to be removed and balance
>> > gets a bigger key as the last one, and btrfs_search_slot will return it with
>> > ret > 0,
>>
>> Hi Liu,
>>
>> That makes a lot of sense outside the context of btrfs_drop_extents().
>>
>> If I understand you correctly, you're saying that we have a file
>> extent item that gets deleted after we release the path in
>> btrfs_next_leaf and before btrfs_search_slot finishes for doing a
>> lookup for that item.
>
> Hi Filipe,
>
> Not just "finishes", even before btrfs_search_slot "starts".

Yes :)

>
>>
>> But who calls btrfs_drop_extents(), is supposed to have locked the
>> file range in the inode's io tree, right? Isn't the goal of locking
>> ranges in the io tree to serialize manipulation of file extent items
>> within a certain range? Unless there's some caller of _drop_extents()
>> that isn't locking the range in the io tree, I'm not seeing how we can
>> get the file extent item deleted or updated by another task.
>
> Oh, good question!  I must admit I forget about that locking, just check the log,
> so here is the answer -- the locking range and the extent range is not
> consistent.
>
> In __btrfs_drop_extents(), there is such a case,
>
>                 /*
>                  *       | ---- range to drop ----- |
>                  *  | -------- extent -------- |
>                  */
>                 if (start > key.offset && end >= extent_end) {
>
> we do actually lock the range, but in this case, the extent is not included in
> our range, so this give a chance for others to hack in to do 'confusing-us' things.

Hum, yes. I thought about the cases where others split our extent
item, but that shouldn't remove the key.

There is one case (I thought about after)  where it's obvious the
issue you found in btrfs_next_leaf can affect btrfs_drop_extents: we
have NO_HOLES set, our first tree seach returns us an extent that ends
before our target range's start (therefore outside the range we locked
in the io tree) and that extent is the last item in a leaf. And then
the problem you described happens between the unlock and re-lock.

>
> I can add these to the commit log if you want, others may also feel confused.

It is fine for me as it is.

Thanks Liu

>
> thanks,
> -liubo
>
>>
>> Thanks
>>
>> > IOW, nothing change in this leaf except the new last key, then we think
>> > we're okay because there is no more item balanced in, fine, we thinks we can
>> > go to the next leaf.
>> >
>> > However, we should return that bigger key, otherwise we deserve leaf corruption,
>> > for example, in endio, skipping that key means that __btrfs_drop_extents() thinks
>> > it has dropped all extent matched the required range and finish_ordered_io can
>> > safely insert a new extent, but it actually doesn't and ends up a leaf
>> > corruption.
>> >
>> > This takes the special case into account.
>> >
>> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> > ---
>> >  fs/btrfs/ctree.c | 18 ++++++++++++++++++
>> >  1 file changed, 18 insertions(+)
>> >
>> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> > index 1bcfcdb..bbb256c 100644
>> > --- a/fs/btrfs/ctree.c
>> > +++ b/fs/btrfs/ctree.c
>> > @@ -5736,6 +5736,24 @@ again:
>> >                 ret = 0;
>> >                 goto done;
>> >         }
>> > +       /*
>> > +        * So the above check misses one case:
>> > +        * - after releasing the path above, someone has removed the item that
>> > +        *   used to be at the very end of the block, and balance between leafs
>> > +        *   gets another one with bigger key.offset to replace it.
>> > +        *
>> > +        * This one should be returned as well, or we can get leaf corruption
>> > +        * later(esp. in __btrfs_drop_extents()).
>> > +        *
>> > +        * And a bit more explanation about this check,
>> > +        * with ret > 0, the key isn't found, the path points to the slot
>> > +        * where it should be inserted, so the path->slots[0] item must be the
>> > +        * bigger one.
>> > +        */
>> > +       if (nritems > 0 && ret > 0 && path->slots[0] == nritems - 1) {
>> > +               ret = 0;
>> > +               goto done;
>> > +       }
>> >
>> >         while (level < BTRFS_MAX_LEVEL) {
>> >                 if (!path->nodes[level]) {
>> > --
>> > 1.8.1.4
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
