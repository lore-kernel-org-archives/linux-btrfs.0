Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:37870 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753693AbcIKUuD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 16:50:03 -0400
Subject: Re: compress=lzo safe to use?
To: Martin Steigerwald <martin@lichtvoll.de>, Steven Haigh <netwiz@crc.id.au>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
 <21b8852b-fba6-6f8f-feed-7bbfa12312d2@crc.id.au> <4096253.hu8ZAHGEqT@merkaba>
Cc: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <6ef80ffd-6a56-3538-0778-a99cb4b9851e@mendix.com>
Date: Sun, 11 Sep 2016 22:49:58 +0200
MIME-Version: 1.0
In-Reply-To: <4096253.hu8ZAHGEqT@merkaba>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/2016 09:48 PM, Martin Steigerwald wrote:
> Am Sonntag, 26. Juni 2016, 13:13:04 CEST schrieb Steven Haigh:
>> On 26/06/16 12:30, Duncan wrote:
>>> Steven Haigh posted on Sun, 26 Jun 2016 02:39:23 +1000 as excerpted:
>>>> In every case, it was a flurry of csum error messages, then instant
>>>> death.
>>>
>>> This is very possibly a known bug in btrfs, that occurs even in raid1
>>> where a later scrub repairs all csum errors.  While in theory btrfs raid1
>>> should simply pull from the mirrored copy if its first try fails checksum
>>> (assuming the second one passes, of course), and it seems to do this just
>>> fine if there's only an occasional csum error, if it gets too many at
>>> once, it *does* unfortunately crash [...]

[...]

>>> different, but either way, the whole thing about too many csum errors at
>>> once triggering a system crash sure does sound familiar, here.
>>
>> Yes, I was running the compress=lzo option as well... Maybe here lays a
>> common problem?
> 
> Hmm… I found this from being referred to by reading Debian wiki page on 
> BTRFS¹.
> 
> I use compress=lzo on BTRFS RAID 1 since April 2014 and I never found an 
> issue. Steven, your filesystem wasn´t RAID 1 but RAID 5 or 6?

To quote you from the "stability a joke" thread (which I guess this
might be related to)... "For me so far even compress=lzo seems to be
stable, but well for others it may not."

So, you can use a lot of compress without problems for years.

Only if your hardware is starting to break in a specific way, causing
lots and lots of checksum errors, the kernel might not be able to handle
all of them at the same time currently.

The compress might be super stable itself, but in this case another part
of the filesystem is not perfecty able to handle certain failure
scenario's involving it.

Another way to find out about "are there issues with compression" is
looking in the kernel git history.

When searching for "compression" and "corruption", you'll find fixes
like these:

commit 0305cd5f7fca85dae392b9ba85b116896eb7c1c7
Author: Filipe Manana <fdmanana@suse.com>
Date:   Fri Oct 16 12:34:25 2015 +0100

    Btrfs: fix truncation of compressed and inlined extents

commit 808f80b46790f27e145c72112189d6a3be2bc884
Author: Filipe Manana <fdmanana@suse.com>
Date:   Mon Sep 28 09:56:26 2015 +0100

    Btrfs: update fix for read corruption of compressed and shared extents

commit 005efedf2c7d0a270ffbe28d8997b03844f3e3e7
Author: Filipe Manana <fdmanana@suse.com>
Date:   Mon Sep 14 09:09:31 2015 +0100

    Btrfs: fix read corruption of compressed and shared extents

commit 619d8c4ef7c5dd346add55da82c9179cd2e3387e
Author: Filipe Manana <fdmanana@suse.com>
Date:   Sun May 3 01:56:00 2015 +0100

    Btrfs: incremental send, fix clone operations for compressed extents

These commits fix actual data corruption issues. Still, it might be bugs
that you've never seen, even when using a kernel with these bugs for
years, because they require a certain "nasty sequence of events" to trigger.

But, when using compression you certainly want to have these commits in
the kernel you're running right now. And when the bugs caused
corruption, using a fixed kernel with not retroactively fix the corrupt
data.

Hint: "this was fixed in 4.x.y, so run that version or later" is not
always the only answer here, because you'll see that fixes like these
even show up in kernels like 3.16.y

But maybe I should continue by replying on the joke thread instead of
typing more here.

-- 
Hans van Kranenburg
