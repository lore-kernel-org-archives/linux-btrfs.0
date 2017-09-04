Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34446 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753953AbdIDTw7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 15:52:59 -0400
Received: by mail-oi0-f42.google.com with SMTP id h70so10584756oic.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 12:52:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170904184229.cjarg6p7tbgy7gka@angband.pl>
References: <20170904151154.vkhshc57t2mi2sze@angband.pl> <CAGqmi762p8wKRv3Gz0Z5BABUvKLn7-8XhB6=v-gbdqsGMV8rUg@mail.gmail.com>
 <20170904184229.cjarg6p7tbgy7gka@angband.pl>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 4 Sep 2017 22:52:18 +0300
Message-ID: <CAGqmi76KhL7QosRQ5yE86_Q7NCxSRcG_rypODwhwazPJRv71Rg@mail.gmail.com>
Subject: Re: \o/ compsize
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-04 21:42 GMT+03:00 Adam Borowski <kilobyte@angband.pl>:
> On Mon, Sep 04, 2017 at 07:07:25PM +0300, Timofey Titovets wrote:
>> 2017-09-04 18:11 GMT+03:00 Adam Borowski <kilobyte@angband.pl>:
>> > Here's an utility to measure used compression type + ratio on a set of files
>> > or directories: https://github.com/kilobyte/compsize
>> >
>> > It should be of great help for users, and also if you:
>> > * muck with compression levels
>> > * add new compression types
>> > * add heurestics that could err on withholding compression too much
>>
>> Packaged to AUR:
>> https://aur.archlinux.org/packages/compsize-git/
>
> Cool!  I'd wait until people say the code is sane (I don't really know these
> ioctls) but if you want to make poor AUR folks our beta testers, that's ok.

This just are too handy =)

> However, one issue: I did not set a license; your packaging says GPL3.
> It would be better to have something compatible with btrfs-progs which are
> GPL2-only.  What about GPL2-or-higher?

Sorry for license, just copy-paste error, fixed

> After adding some related info (like wasted space in pinned extents, reuse
> of extents), it'd be nice to have this tool inside btrfs-progs, either as a
> part of "fi du" or another command.

That will be useful =)

P.S.
your code work amazing fast on my ssd and data %)
150Gb data
-O0 2.12s
-O2 0.51s

-- 
Have a nice day,
Timofey.
