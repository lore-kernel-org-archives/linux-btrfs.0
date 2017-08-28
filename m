Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34072 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdH1V3O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 17:29:14 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dmRag-0008OZ-V5
        for linux-btrfs@vger.kernel.org; Mon, 28 Aug 2017 23:29:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: status of inline deduplication in btrfs
Date: Mon, 28 Aug 2017 21:28:47 +0000 (UTC)
Message-ID: <pan$97c0c$6f0cc0cc$83840fc3$8f219b74@cox.net>
References: <CAP9W88g3Pr=JYqj=QOKpeP=6uKaQkXsx9xegefeJsZ+wApiZ9g@mail.gmail.com>
        <7e12fa55-d01a-6c02-f798-2b63cf3b4a6d@jp.fujitsu.com>
        <CAP9W88gfFUj3QBjmztDjYamR9MKSh7Gsv66X7vJ-M9FNq3F=eA@mail.gmail.com>
        <pan$e34b7$dc9b9508$835301e3$9a80c4d6@cox.net>
        <20170826161524.xz5xylimnqfucdte@angband.pl>
        <CAP9W88geH+nqhjb=qRkU2WSfXG0x9dz-O_6QC-zfdc31UQ3-CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

shally verma posted on Mon, 28 Aug 2017 12:49:10 +0530 as excerpted:

> On Sat, Aug 26, 2017 at 9:45 PM, Adam Borowski <kilobyte@angband.pl>
> wrote:
>> On Sat, Aug 26, 2017 at 01:36:35AM +0000, Duncan wrote:
>>> The second has to do with btrfs scaling issues due to reflinking,
>>> which of course is the operational mechanism for both snapshotting and
>>> dedup.
>>> Snapshotting of course reflinks the entire subvolume, so it's
>>> reflinking on a /massive/ scale.  While normal file operations aren't
>>> affected much,
>>> btrfs maintenance operations such as balance and check scale badly
>>> enough with snapshotting (due to the reflinking) that keeping the
>>> number of snapshots per subvolume under 250 or so is strongly
>>> recommended, and keeping them to double-digits or even single-digits
>>> is recommended if possible.
>>>
>>> Dedup works by reflinking as well, but its effect on btrfs maintenance
>>> will be far more variable, depending of course on how effective the
>>> deduping, and thus the reflinking, is.  But considering that
>>> snapshotting is effectively 100% effective deduping of the entire
>>> subvolume (until the snapshot and active copy begin to diverge, at
>>> least), that tends to be the worst case, so figuring a full two-copy
>>> dedup as equivalent to one snapshot is a reasonable estimate of
>>> effect.
>>>  If dedup only catches 10%, only once, than it would be 10% of a
>>> snapshot's effect.  If it's 10% but there's 10 duplicated instances,
>>> that's the effect of a single snapshot. Assuming of course that the
>>> dedup domain is the same as the subvolume that's being snapshotted.
> 
> This looks to me a debate between using inline dedup Vs snapshotting or
> more precisely, doing a dedupe via snapshots?
> Did I understand it correct? if yes, does it mean people are still in
> thoughts if current design and proposal to inline dedup is right way to
> go for?

Not that I'm aware of and it wasn't my intent to leave that impression.

What I'm saying is that btrfs uses the same underlying mechanism, 
reflinking, for both snapshotting and dedup.

A rather limited but perhaps useful analogy from an /entirely/ different 
area might be that both single-person bicycles and full-size truck/
trailer rigs use the same underlying mechanism, wheels with tires turning 
against the ground, to move, while they have vastly different uses and 
neither one can replace the other.

And just as the common to both cases tire has the limitation that it can 
be punctured and go flat, that applies to both due to the common 
mechanism used to move, so reflinking has certain limitations that apply 
to both snapshotting and dedup, due to the common mechanism used in the 
implementation.

Of course taking the analogy much further than that will likely result in 
comically absurd conclusions, but hopefully when kept within its limits 
it's useful to convey my point, two technologies with very different 
usage at the surface level, taking advantage of a common implementation 
mechanism underneath.

And because the underlying mechanism is the same, its limits become the 
limits of both overlying solutions, however they otherwise differ.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

