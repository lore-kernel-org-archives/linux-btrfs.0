Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:33061 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdHaTV2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 15:21:28 -0400
Received: by mail-qt0-f177.google.com with SMTP id e2so2743448qta.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 12:21:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831185922.GC30990@carfax.org.uk>
References: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
 <20170831183302.GB30990@carfax.org.uk> <CAJ_hD5D49amQEq7YMu=d-EhRK-CkJerbT=uAc1+rpg+_12KFsQ@mail.gmail.com>
 <20170831185922.GC30990@carfax.org.uk>
From: Eric Wolf <19wolf@gmail.com>
Date: Thu, 31 Aug 2017 15:21:07 -0400
Message-ID: <CAJ_hD5DLufKpJPHpvFhsq8fj-oL++=NMkMPEHe9y=dCcsbUwtg@mail.gmail.com>
Subject: Re: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
To: Hugo Mills <hugo@carfax.org.uk>, Eric Wolf <19wolf@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've previously confirmed it's a bad ram module which I have already
submitted an RMA for. Any advice for manually fixing the bits?

Sorry for top leveling, not sure how mailing lists work (again sorry
if this message is top leveled, how do I ensure it's not?)
---
Eric Wolf
(201) 316-6098
19wolf@gmail.com


On Thu, Aug 31, 2017 at 2:59 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>    (Please don't top-post; edited for conversation flow)
>
> On Thu, Aug 31, 2017 at 02:44:39PM -0400, Eric Wolf wrote:
>> On Thu, Aug 31, 2017 at 2:33 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> > On Thu, Aug 31, 2017 at 01:53:58PM -0400, Eric Wolf wrote:
>> >> I'm having issues with a bad block(?) on my root ssd.
>> >>
>> >> dmesg is consistently outputting "BTRFS critical (device sda2):
>> >> corrupt leaf, bad key order: block=293438636032, root=1, slot=11"
>> >>
>> >> "btrfs scrub stat /" outputs "scrub status for b2c9ff7b-[snip]-48a02cc4f508
>> >> scrub started at Wed Aug 30 11:51:49 2017 and finished after 00:02:55
>> >> total bytes scrubbed: 53.41GiB with 2 errors
>> >> error details: verify=2
>> >> corrected errors: 0, uncorrectable errors: 2, unverified errors: 0"
>> >>
>> >> Running "btrfs check --repair /dev/sda2" from a live system stalls
>> >> after telling me corrupt leaf etc etc then "11 12". CPU usage hits
>> >> 100% and disk activity remains at 0.
>> >
>> >    This error is usually attributable to bad hardware. Typically RAM,
>> > but might also be marginal power regulation (blown capacitor
>> > somewhere) or a slightly broken CPU.
>> >
>> >    Can you show us the output of "btrfs-debug-tree -b 293438636032 /dev/sda2"?
>
>    Here's the culprit:
>
> [snip]
>> item 10 key (890553 EXTENT_DATA 0) itemoff 14685 itemsize 269
>>    inline extent data size 248 ram 248 compress 0
>> item 11 key (890554 INODE_ITEM 0) itemoff 14525 itemsize 160
>>    inode generation 5386763 transid 5386764 size 135 nbytes 135
>>    block group 0 mode 100644 links 1 uid 100000 gid 100000
>>    rdev 0 flags 0x0
>> item 12 key (856762 INODE_REF 31762) itemoff 14496 itemsize 29
>>    inode ref index 2745 namelen 19 name: dpkg.statoverride.0
>> item 13 key (890554 EXTENT_DATA 0) itemoff 14340 itemsize 156
>>    inline extent data size 135 ram 135 compress 0
> [snip]
>
>    Note the objectid field -- the first number in the brackets after
> "key" for each item. This sequence of values should be non-decreasing.
> Thus, item 12 should have an objectid of 890554 to match the items
> either side of it, and instead it has 856762.
>
>    In hex, these are:
>
>>>> hex(890554)
> '0xd96ba'
>>>> hex(856762)
> '0xd12ba'
>
>    Which means you've had two bitflips close together:
>
>>>> hex(856762 ^ 890554)
> '0x8400'
>
>    Given that everything else is OK, and it's just one byte affected
> in the middle of a load of data that's really quite sensitive to
> errors, it's very unlikely that it's the result of a misplaced pointer
> in the kernel, or some other subsystem accidentally walking over that
> piece of RAM. It is, therefore, almost certainly your hardware that's
> at fault.
>
>    I would strongly suggest running memtest86 on your machine -- I'd
> usually say a minimum of 8 hours, or longer if you possibly can (24
> hours), or until you have errors reported. If you get errors reported
> in the same place on multiple passes, then it's the RAM. If you have
> errors scattered around seemingly at random, then it's probably your
> power regulation (PSU or motherboard).
>
>    Sadly, btrfs check on its own won't be able to fix this, as it's
> two bits flipped. (It can cope with one bit flipped in the key, most
> of the time, but not two). It can be fixed manually, if you're
> familiar with a hex editor and the on-disk data structures.
>
>    Hugo.
>
> --
> Hugo Mills             | "You got very nice eyes, Deedee. Never noticed them
> hugo@... carfax.org.uk | before. They real?"
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                                 Don Logan, Sexy Beast
