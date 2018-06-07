Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32776 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753079AbeFGT5S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 15:57:18 -0400
Received: by mail-oi0-f68.google.com with SMTP id c6-v6so8648399oiy.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 12:57:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c10bf62d-8c31-7f1d-809a-c36b39c1930c@gmx.com>
References: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>
 <274f47db-b3cc-60fd-002b-f8c1eba29d6c@gmx.com> <CA+X5Wn7ore144+BqMSmntPOGX3c5HiyQtQN_p4+F1+rfhCQSsg@mail.gmail.com>
 <c10bf62d-8c31-7f1d-809a-c36b39c1930c@gmx.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Thu, 7 Jun 2018 15:57:17 -0400
Message-ID: <CA+X5Wn6sHMVt=U81GVmD4X6ffk8H1NtN9dMuQcyheKv3BA4azA@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs-progs: map-logical: look at next leaf if slot > items
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"On Thu, Jun 7, 2018 at 3:26 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2018年06月07日 15:19, james harvey wrote:
>> On Thu, Jun 7, 2018 at 12:44 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>> On 2018年06月07日 11:33, james harvey wrote:
>>>> * btrfs_item_key_to_cpu sets key to (10955960320, BTRFS_EXTENT_ITEM_KEY, 4096)
>>>> !!! Bonus bug, LEFT FOR READER.  Why is this item #197, 5 items before the 203
>>>>     given?  I think no bounds checking causes a buffer over-read here.
>>>>     btrfs_item_key_to_cpu() calls btrfs_item_key(), which uses the macro
>>>>     read_eb_member() to call read_extent_buffer() which memcpy's using an out
>>>>     of range index, at least for this leaf.
>>>
>>> Here the key you got could be garbage.
>>> Either the leaf has enough free space, then you got pending zero into
>>> the key, or the leaf is full, you got some item data into the key.
>>>
>>> Either way, the key should be read/trusted at all.
>>
>> Is the group's preference to leave things like bounds checking to the
>> caller?
>
> The problem here is, btrfs_search_slot() is not only called for
> read_only search, but also for insert.
>
> For insert usage, such returned path is completely valid and in fact
> could be pretty useful.

I don't mean for btrfs_search_slot() behavior to change, since it is
called for inserting.  I mean btrfs_item_key_to_cpu() behavior could
change.

>>  (I get the merit to that, avoiding redundant checks.)  My
>> normal style would be to have read_extent_buffer() fail if start + len
>> is out of bounds.
>
> In this case, it's not out-of-boundary at all, and the invalid key you
> read out if from the last item, which could contain a valid key.
>
> For leaf, btrfs puts btrfs items pointers at the head, and the items
> data at the tail.
>
> Thus for this case, your invalid key slot is just in the middle of the
> leaf, making read_extent_buffer() unable to detect anything wrong.
>
> Thanks,
> Qu

You're right.  read_extent_buffer() doesn't have the information to
look at this.

And, "buffer over-read error" was probably the wrong term.  I mean in
the sense that it has 203 valid values, and is being asked for the
204'th item.

btrfs_item_key() could error on

(nr > btrfs_header_nritems(eb))

This defensive programming would cause redundant checks, if the caller
checks this too as they are supposed to, so I understand if the group
doesn't swing that far on defensive programming.

Although, perhaps in such situation, btrfs_item_key() could
automatically call btrfs_next_leaf().  I'm thinking this might not be
desired behavior everywhere, but just in case it is, mentioning it
because then btrfs_item_key() could handle all of this, not allowing
the caller to shoot their own foot, without redundant checks.
