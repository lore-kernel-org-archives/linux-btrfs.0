Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52532 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2GENEK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 09:04:10 -0400
Received: by obbuo13 with SMTP id uo13so13000967obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 06:04:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqBZXxRUBC2tLefZ1twOWmo=Ti5BsZ44+r1un7OS5JRWqQ@mail.gmail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-6-git-send-email-ablock84@googlemail.com>
	<CAHf9xvZpRpB8FrgqfPG-s5N4UKUwGAzSsRVeWbQ6GLfwKQOHcA@mail.gmail.com>
	<CAB9VWqCLC-2Kj-N5U-ZRrVjgrrTpRJze2fUBiNzaZQxyFCdvfg@mail.gmail.com>
	<CAHf9xvbH_ukL75H2+g9SscbRfqD3WSLd5xjadYxjGQ1YgjMi6g@mail.gmail.com>
	<CAB9VWqBZXxRUBC2tLefZ1twOWmo=Ti5BsZ44+r1un7OS5JRWqQ@mail.gmail.com>
Date: Thu, 5 Jul 2012 16:04:09 +0300
Message-ID: <CAHf9xvZGwDYu47NdtusEmQKqzvhWz6Pz7E0sQuhmzBwmB91Vig@mail.gmail.com>
Subject: Re: [RFC PATCH 5/7] Btrfs: add btrfs_compare_trees function
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 5, 2012 at 3:47 PM, Alexander Block <ablock84@googlemail.com> wrote:
> On Thu, Jul 5, 2012 at 2:19 PM, Alex Lyakas
> <alex.bolshoy.btrfs@gmail.com> wrote:
>> Alexander,
>>
>>>>> +               if (advance_left && !left_end_reached) {
>>>>> +                       ret = tree_advance(left_root, left_path, &left_level,
>>>>> +                                       left_root_level,
>>>>> +                                       advance_left != ADVANCE_ONLY_NEXT,
>>>>> +                                       &left_key);
>>>>> +                       if (ret < 0)
>>>>> +                               left_end_reached = ADVANCE;
>>>>> +                       advance_left = 0;
>>>>> +               }
>>>>> +               if (advance_right && !right_end_reached) {
>>>>> +                       ret = tree_advance(right_root, right_path, &right_level,
>>>>> +                                       right_root_level,
>>>>> +                                       advance_right != ADVANCE_ONLY_NEXT,
>>>>> +                                       &right_key);
>>>>> +                       if (ret < 0)
>>>>> +                               right_end_reached = ADVANCE;
>>>>> +                       advance_right = 0;
>>>>> +               }
>>>> Do you think it's worth it to put a check/warning/smth before that,
>>>> that either advance_right or advance_left is non-zero, or we have
>>>> reached ends in both trees?
>>>>
>>>>
>>> Having the left or right end reached before the other sides end is
>>> reached is something that is completely normal and expected.
>> What I meant was that when we start the loop, either advance_left!=0
>> or advance_right!=0. So I thought it would be good to notice that.
>> However, on the very first loop iteration, both of them are zero, so I
>> was wrong.
>>
>>
>>>>> +               } else if (left_level == right_level) {
>>>> ...
>>>>> +               } else if (left_level < right_level) {
>>>>> +                       advance_right = ADVANCE;
>>>>> +               } else {
>>>>> +                       advance_left = ADVANCE;
>>>>> +               }
>>>> Can you pls explain why it is correct?
>>>> Why if we are on lower level in the "newer" tree than we are in the
>>>> "older" tree, we need to advance the "older" tree? I.e., why this
>>>> implies that we are on the lower key in the "older" tree? (And
>>>> vice-versa). I.e., how difference in levels indicates relation between
>>>> keys?
>>> Difference in levels has no relation to the keys. These advances
>>> basically try to keep the two trees positions "in-sync". The compare
>>> always tries to get both trees to a point where they are at the same
>>> level, as only then we can compare keys. Also, the two trees may have
>>> different root levels, this code also handles that case.
>>
>> Can you pls tell me if I understand your algorithm correctly:
>> Basically, we need to get to the leaf levels and compare the items in
>> the leafs. Only when we are on the leaf level, we can safely signal
>> deletions and additions of items, not on upper levels.
>> There is only one optimization: we want to find nodes that are shared,
>> and such nodes can be only on the same level. To make this
>> optimization happen, we try to always match the levels of the tree.
>> This is the purpose of:
>>                 } else if (left_level < right_level) {
>>                         advance_right = ADVANCE;
>>                 } else {
>>                         advance_left = ADVANCE;
>>                 }
>>
> Sounds like you understood it.
>> Note: I think that instead of comparing levels, we could always
>> compare keys and ADVANCE the lower key. (Because on ADVANCing we never
>> loose information, we just get closer to leafs, so we don't skip
>> anything.) But then there is less chance of optimization. Does this
>> make sense? So what you said that we can compare keys only on the same
>> level...we can always compare them, correct?
> Hmm I think I don't understand what you mean. When we are at level 0,
> advancing will in most cases mean that we only get to the next
> (slot+1) item. Only in case we are on the last item for this leaf, we
> change levels. In that case, the first ADVANCE will go as much levels
> up until its possible to got to the next node at that level. After
> this, the next ADVANCEs will go down the tree again until we are at
> the same level as the other tree is.
>
> Imagine this tree:
>     R ______
>     / \          |
>    /   \         |
>   A    B      C
>  / \    / \     / \
> D  E F  G H  I
>
> It would iterate in this order:
> R(slot 0)      -> down
> A(slot 0)      -> down
> D(slot 0..nr) -> upnext
> A(slot 1)      -> down
> E(slot 0..nr) -> upnext
> R(slot 1)      -> down
> B(slot 0)      -> down
> F(slot 0..nr) -> upnext
> B(slot 1)      -> down
> G(slot 0..nr) -> upnext
> R(slot 2)      -> down
> C(slot 0)      -> down
> H(slot 0..nr) -> upnext
> C(slot 1)      -> down
> I(slot 0..nr)   -> upnext
> done because upnext can't advance anymore.
>
Thanks for the nice ASCII graphics!

Yes, if one of the scan heads is on level 0, and the other one is on a
different level, then yes, we need to ADVANCE the other one, we cannot
compare keys at this point. We need to get the other head down to
level 0, and then compare keys and items. I overlooked this case.

I meant the case when both heads are on different levels, and none of
the heads is on level 0,... then we can ADVANCE any of them actually
(or both). Because eventually we need to get to the leafs. But if we
want to have a chance of finding a shared block (and skip some leafs),
it's better to ADVANCE the higher one.

Yes, this algorithm is pretty elegant...

Alex.
