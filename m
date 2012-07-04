Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38927 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2GDTN7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 15:13:59 -0400
Received: by obbuo13 with SMTP id uo13so11811706obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 12:13:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341409108-13567-6-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-6-git-send-email-ablock84@googlemail.com>
Date: Wed, 4 Jul 2012 22:13:59 +0300
Message-ID: <CAHf9xvZpRpB8FrgqfPG-s5N4UKUwGAzSsRVeWbQ6GLfwKQOHcA@mail.gmail.com>
Subject: Re: [RFC PATCH 5/7] Btrfs: add btrfs_compare_trees function
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

> +static int tree_compare_item(struct btrfs_root *left_root,
> +                            struct btrfs_path *left_path,
> +                            struct btrfs_path *right_path,
> +                            char *tmp_buf)
> +{
> +       int cmp;
> +       int len1, len2;
> +       unsigned long off1, off2;
> +
> +       len1 = btrfs_item_size_nr(left_path->nodes[0], left_path->slots[0]);
> +       len2 = btrfs_item_size_nr(right_path->nodes[0], right_path->slots[0]);
> +       if (len1 != len2)
> +               return 1;
> +
> +       off1 = btrfs_item_ptr_offset(left_path->nodes[0], left_path->slots[0]);
> +       off2 = btrfs_item_ptr_offset(right_path->nodes[0],
> +                               right_path->slots[0]);
> +
> +       read_extent_buffer(left_path->nodes[0], tmp_buf, off1, len1);
> +
> +       cmp = memcmp_extent_buffer(right_path->nodes[0], tmp_buf, off2, len1);
> +       if (cmp)
> +               return 1;
> +       return 0;
> +}
It might be worth to note in the comment, that tmp_buff should be
large enough to hold the item from the left tree. Can it happen that
the right tree has a different leafsize?

> +       /*
> +        * Strategy: Go to the first items of both trees. Then do
> +        *
> +        * If both trees are at level 0
> +        *   Compare keys of current items
> +        *     If left < right treat left item as new, advance left tree
> +        *       and repeat
> +        *     If left > right treat right item as deleted, advance right tree
> +        *       and repeat
> +        *     If left == right do deep compare of items, treat as changed if
> +        *       needed, advance both trees and repeat
> +        * If both trees are at the same level but not at level 0
> +        *   Compare keys of current nodes/leafs
> +        *     If left < right advance left tree and repeat
> +        *     If left > right advance right tree and repeat
> +        *     If left == right compare blockptrs of the next nodes/leafs
> +        *       If they match advance both trees but stay at the same level
> +        *         and repeat
> +        *       If they don't match advance both trees while allowing to go
> +        *         deeper and repeat
> +        * If tree levels are different
> +        *   Advance the tree that needs it and repeat
> +        *
> +        * Advancing a tree means:
> +        *   If we are at level 0, try to go to the next slot. If that's not
> +        *   possible, go one level up and repeat. Stop when we found a level
> +        *   where we could go to the next slot. We may at this point be on a
> +        *   node or a leaf.
> +        *
> +        *   If we are not at level 0 and not on shared tree blocks, go one
> +        *   level deeper.
> +        *
> +        *   If we are not at level 0 and on shared tree blocks, go one slot to
> +        *   the right if possible or go up and right.
> +        */
According to the strategy and to the code later, "left" tree is
treated as "newer one", while "right" as "older one", correct? Do you
think it would be more intuitive to make it the other way around,
although I guess this is a matter of personal taste. I had to draw the
leafs reversed to keep going:
R       L
-----     -----
| | | |     | | | |
-----     -----


> +               if (advance_left && !left_end_reached) {
> +                       ret = tree_advance(left_root, left_path, &left_level,
> +                                       left_root_level,
> +                                       advance_left != ADVANCE_ONLY_NEXT,
> +                                       &left_key);
> +                       if (ret < 0)
> +                               left_end_reached = ADVANCE;
> +                       advance_left = 0;
> +               }
> +               if (advance_right && !right_end_reached) {
> +                       ret = tree_advance(right_root, right_path, &right_level,
> +                                       right_root_level,
> +                                       advance_right != ADVANCE_ONLY_NEXT,
> +                                       &right_key);
> +                       if (ret < 0)
> +                               right_end_reached = ADVANCE;
> +                       advance_right = 0;
> +               }
Do you think it's worth it to put a check/warning/smth before that,
that either advance_right or advance_left is non-zero, or we have
reached ends in both trees?


> +               } else if (left_level == right_level) {
...
> +               } else if (left_level < right_level) {
> +                       advance_right = ADVANCE;
> +               } else {
> +                       advance_left = ADVANCE;
> +               }
Can you pls explain why it is correct?
Why if we are on lower level in the "newer" tree than we are in the
"older" tree, we need to advance the "older" tree? I.e., why this
implies that we are on the lower key in the "older" tree? (And
vice-versa). I.e., how difference in levels indicates relation between
keys?

Thanks,
  Alex.
