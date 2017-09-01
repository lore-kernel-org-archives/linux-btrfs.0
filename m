Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:38046 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbdIANm5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 09:42:57 -0400
Received: by mail-qt0-f172.google.com with SMTP id w42so1135521qtg.5
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 06:42:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831201124.GD30990@carfax.org.uk>
References: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
 <20170831183302.GB30990@carfax.org.uk> <CAJ_hD5D49amQEq7YMu=d-EhRK-CkJerbT=uAc1+rpg+_12KFsQ@mail.gmail.com>
 <20170831185922.GC30990@carfax.org.uk> <CAJ_hD5DLufKpJPHpvFhsq8fj-oL++=NMkMPEHe9y=dCcsbUwtg@mail.gmail.com>
 <20170831201124.GD30990@carfax.org.uk>
From: Eric Wolf <19wolf@gmail.com>
Date: Fri, 1 Sep 2017 09:42:36 -0400
Message-ID: <CAJ_hD5ADewQN5Uh6YcoMmLpZ+nu-HOMREh6dxeETWBraoo21oQ@mail.gmail.com>
Subject: Re: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
To: Hugo Mills <hugo@carfax.org.uk>, Eric Wolf <19wolf@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 31, 2017 at 4:11 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Aug 31, 2017 at 03:21:07PM -0400, Eric Wolf wrote:
>> I've previously confirmed it's a bad ram module which I have already
>> submitted an RMA for. Any advice for manually fixing the bits?
>
>    What I'd do... use a hex editor and the contents of ctree.h as
> documentation to find the byte in question, change it back to what it
> should be, mount the FS, try reading the directory again, look up the
> csum failure in dmesg, edit the block again to fix up the csum, and
> it's done. (Yes, I've done this before, and I'm a massive nerd).
>
>    It's also possible to use Hans van Kranenberg's btrfs-python to fix
> up this kind of thing, but I've not done it myself. There should be a
> couple of talk-throughs from Hans in various archives -- both this
> list (find it on, say, http://www.spinics.net/lists/linux-btrfs/), and
> on the IRC archives (http://logs.tvrrug.org.uk/logs/%23btrfs/latest.html).
>
>> Sorry for top leveling, not sure how mailing lists work (again sorry
>> if this message is top leveled, how do I ensure it's not?)
>
>    Just write your answers _after_ the quoted text that you're
> replying to, not before. It's a convention, rather than a technical
> thing...
>
>    Hugo.
>
>>
>>
>>
>> On Thu, Aug 31, 2017 at 2:59 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >    (Please don't top-post; edited for conversation flow)
>> >
>> > On Thu, Aug 31, 2017 at 02:44:39PM -0400, Eric Wolf wrote:
>> >> On Thu, Aug 31, 2017 at 2:33 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >> > On Thu, Aug 31, 2017 at 01:53:58PM -0400, Eric Wolf wrote:
>> >> >> I'm having issues with a bad block(?) on my root ssd.
>> >> >>
>> >> >> dmesg is consistently outputting "BTRFS critical (device sda2):
>> >> >> corrupt leaf, bad key order: block=293438636032, root=1, slot=11"
>> >> >>
>> >> >> "btrfs scrub stat /" outputs "scrub status for b2c9ff7b-[snip]-48a02cc4f508
>> >> >> scrub started at Wed Aug 30 11:51:49 2017 and finished after 00:02:55
>> >> >> total bytes scrubbed: 53.41GiB with 2 errors
>> >> >> error details: verify=2
>> >> >> corrected errors: 0, uncorrectable errors: 2, unverified errors: 0"
>> >> >>
>> >> >> Running "btrfs check --repair /dev/sda2" from a live system stalls
>> >> >> after telling me corrupt leaf etc etc then "11 12". CPU usage hits
>> >> >> 100% and disk activity remains at 0.
>> >> >
>> >> >    This error is usually attributable to bad hardware. Typically RAM,
>> >> > but might also be marginal power regulation (blown capacitor
>> >> > somewhere) or a slightly broken CPU.
>> >> >
>> >> >    Can you show us the output of "btrfs-debug-tree -b 293438636032 /dev/sda2"?
>> >
>> >    Here's the culprit:
>> >
>> > [snip]
>> >> item 10 key (890553 EXTENT_DATA 0) itemoff 14685 itemsize 269
>> >>    inline extent data size 248 ram 248 compress 0
>> >> item 11 key (890554 INODE_ITEM 0) itemoff 14525 itemsize 160
>> >>    inode generation 5386763 transid 5386764 size 135 nbytes 135
>> >>    block group 0 mode 100644 links 1 uid 100000 gid 100000
>> >>    rdev 0 flags 0x0
>> >> item 12 key (856762 INODE_REF 31762) itemoff 14496 itemsize 29
>> >>    inode ref index 2745 namelen 19 name: dpkg.statoverride.0
>> >> item 13 key (890554 EXTENT_DATA 0) itemoff 14340 itemsize 156
>> >>    inline extent data size 135 ram 135 compress 0
>> > [snip]
>> >
>> >    Note the objectid field -- the first number in the brackets after
>> > "key" for each item. This sequence of values should be non-decreasing.
>> > Thus, item 12 should have an objectid of 890554 to match the items
>> > either side of it, and instead it has 856762.
>> >
>> >    In hex, these are:
>> >
>> >>>> hex(890554)
>> > '0xd96ba'
>> >>>> hex(856762)
>> > '0xd12ba'
>> >
>> >    Which means you've had two bitflips close together:
>> >
>> >>>> hex(856762 ^ 890554)
>> > '0x8400'
>> >
>> >    Given that everything else is OK, and it's just one byte affected
>> > in the middle of a load of data that's really quite sensitive to
>> > errors, it's very unlikely that it's the result of a misplaced pointer
>> > in the kernel, or some other subsystem accidentally walking over that
>> > piece of RAM. It is, therefore, almost certainly your hardware that's
>> > at fault.
>> >
>> >    I would strongly suggest running memtest86 on your machine -- I'd
>> > usually say a minimum of 8 hours, or longer if you possibly can (24
>> > hours), or until you have errors reported. If you get errors reported
>> > in the same place on multiple passes, then it's the RAM. If you have
>> > errors scattered around seemingly at random, then it's probably your
>> > power regulation (PSU or motherboard).
>> >
>> >    Sadly, btrfs check on its own won't be able to fix this, as it's
>> > two bits flipped. (It can cope with one bit flipped in the key, most
>> > of the time, but not two). It can be fixed manually, if you're
>> > familiar with a hex editor and the on-disk data structures.
>> >
>> >    Hugo.
>> >
>
> --
> Hugo Mills             | "There's a Martian war machine outside -- they want
> hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                           Stephen Franklin, Babylon 5


I think I may have top leveled again.. So anyway, I have my hex editor
open, but am completely lost as what to do?
