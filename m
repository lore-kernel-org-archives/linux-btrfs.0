Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32815 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2GDUSf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 16:18:35 -0400
Received: by pbbrp8 with SMTP id rp8so11532536pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 13:18:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvZpRpB8FrgqfPG-s5N4UKUwGAzSsRVeWbQ6GLfwKQOHcA@mail.gmail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-6-git-send-email-ablock84@googlemail.com>
	<CAHf9xvZpRpB8FrgqfPG-s5N4UKUwGAzSsRVeWbQ6GLfwKQOHcA@mail.gmail.com>
Date: Wed, 4 Jul 2012 22:18:34 +0200
Message-ID: <CAB9VWqCLC-2Kj-N5U-ZRrVjgrrTpRJze2fUBiNzaZQxyFCdvfg@mail.gmail.com>
Subject: Re: [RFC PATCH 5/7] Btrfs: add btrfs_compare_trees function
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 4, 2012 at 9:13 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Hi Alex,
>
>> +static int tree_compare_item(struct btrfs_root *left_root,
>> +                            struct btrfs_path *left_path,
>> +                            struct btrfs_path *right_path,
>> +                            char *tmp_buf)
>> +{
>> +       int cmp;
>> +       int len1, len2;
>> +       unsigned long off1, off2;
>> +
>> +       len1 = btrfs_item_size_nr(left_path->nodes[0], left_path->slots[0]);
>> +       len2 = btrfs_item_size_nr(right_path->nodes[0], right_path->slots[0]);
>> +       if (len1 != len2)
>> +               return 1;
>> +
>> +       off1 = btrfs_item_ptr_offset(left_path->nodes[0], left_path->slots[0]);
>> +       off2 = btrfs_item_ptr_offset(right_path->nodes[0],
>> +                               right_path->slots[0]);
>> +
>> +       read_extent_buffer(left_path->nodes[0], tmp_buf, off1, len1);
>> +
>> +       cmp = memcmp_extent_buffer(right_path->nodes[0], tmp_buf, off2, len1);
>> +       if (cmp)
>> +               return 1;
>> +       return 0;
>> +}
> It might be worth to note in the comment, that tmp_buff should be
> large enough to hold the item from the left tree. Can it happen that
> the right tree has a different leafsize?
>
This function is only to be used for for the tree compare function and
there we allocate a buffer of root->leafsize, so definitely all items
should fit. As far as I know, Chris (please correct me if I'm wrong)
once guaranteed that ALL trees in a FS will have the same leaf size
and this will ever be the case.
>> +       /*
>> +        * Strategy: Go to the first items of both trees. Then do
>> +        *
>> +        * If both trees are at level 0
>> +        *   Compare keys of current items
>> +        *     If left < right treat left item as new, advance left tree
>> +        *       and repeat
>> +        *     If left > right treat right item as deleted, advance right tree
>> +        *       and repeat
>> +        *     If left == right do deep compare of items, treat as changed if
>> +        *       needed, advance both trees and repeat
>> +        * If both trees are at the same level but not at level 0
>> +        *   Compare keys of current nodes/leafs
>> +        *     If left < right advance left tree and repeat
>> +        *     If left > right advance right tree and repeat
>> +        *     If left == right compare blockptrs of the next nodes/leafs
>> +        *       If they match advance both trees but stay at the same level
>> +        *         and repeat
>> +        *       If they don't match advance both trees while allowing to go
>> +        *         deeper and repeat
>> +        * If tree levels are different
>> +        *   Advance the tree that needs it and repeat
>> +        *
>> +        * Advancing a tree means:
>> +        *   If we are at level 0, try to go to the next slot. If that's not
>> +        *   possible, go one level up and repeat. Stop when we found a level
>> +        *   where we could go to the next slot. We may at this point be on a
>> +        *   node or a leaf.
>> +        *
>> +        *   If we are not at level 0 and not on shared tree blocks, go one
>> +        *   level deeper.
>> +        *
>> +        *   If we are not at level 0 and on shared tree blocks, go one slot to
>> +        *   the right if possible or go up and right.
>> +        */
> According to the strategy and to the code later, "left" tree is
> treated as "newer one", while "right" as "older one", correct? Do you
> think it would be more intuitive to make it the other way around,
> although I guess this is a matter of personal taste. I had to draw the
> leafs reversed to keep going:
> R       L
> -----     -----
> | | | |     | | | |
> -----     -----
>
>
To be honest...I always preferred the way you suggested in the past
when I thought about compares. But for some reason, I didn't even
think about that and just implemented that function in single
flow...it took days until I've even noticed that I swapped left/right
in my head :D I now would like to stay with that, as all the btrfs
send code uses left/right in this way and I never had the problem with
mixing that up again. If people like, I have nothing against changing
that later if someone wants to, but that's nothing I would like to do
myself.
>> +               if (advance_left && !left_end_reached) {
>> +                       ret = tree_advance(left_root, left_path, &left_level,
>> +                                       left_root_level,
>> +                                       advance_left != ADVANCE_ONLY_NEXT,
>> +                                       &left_key);
>> +                       if (ret < 0)
>> +                               left_end_reached = ADVANCE;
>> +                       advance_left = 0;
>> +               }
>> +               if (advance_right && !right_end_reached) {
>> +                       ret = tree_advance(right_root, right_path, &right_level,
>> +                                       right_root_level,
>> +                                       advance_right != ADVANCE_ONLY_NEXT,
>> +                                       &right_key);
>> +                       if (ret < 0)
>> +                               right_end_reached = ADVANCE;
>> +                       advance_right = 0;
>> +               }
> Do you think it's worth it to put a check/warning/smth before that,
> that either advance_right or advance_left is non-zero, or we have
> reached ends in both trees?
>
>
Having the left or right end reached before the other sides end is
reached is something that is completely normal and expected.
>> +               } else if (left_level == right_level) {
> ...
>> +               } else if (left_level < right_level) {
>> +                       advance_right = ADVANCE;
>> +               } else {
>> +                       advance_left = ADVANCE;
>> +               }
> Can you pls explain why it is correct?
> Why if we are on lower level in the "newer" tree than we are in the
> "older" tree, we need to advance the "older" tree? I.e., why this
> implies that we are on the lower key in the "older" tree? (And
> vice-versa). I.e., how difference in levels indicates relation between
> keys?
Difference in levels has no relation to the keys. These advances
basically try to keep the two trees positions "in-sync". The compare
always tries to get both trees to a point where they are at the same
level, as only then we can compare keys. Also, the two trees may have
different root levels, this code also handles that case.
>
> Thanks,
>   Alex.
Thanks for the review :)
