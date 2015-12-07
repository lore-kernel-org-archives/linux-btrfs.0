Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35393 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbbLGPMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 10:12:12 -0500
Received: by ioc74 with SMTP id 74so183539455ioc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 07:12:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56659F48.6000800@gmail.com>
References: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
	<CAJCQCtQX5Ov6YKZ=SdxaGSPaGa0sEFF6gz89WsDm9qegmykGkA@mail.gmail.com>
	<pan$519f9$af10e2cb$f1ea2d14$435d0b5a@cox.net>
	<CA+pSGYeYwC=eWmSuC4MXsSz1qVvWqzxxv7KzxkhQ84BKUDO-MA@mail.gmail.com>
	<56659F48.6000800@gmail.com>
Date: Mon, 7 Dec 2015 09:12:11 -0600
Message-ID: <CA+pSGYdE8FxCGjR_=gU58jej6AuMMZ-wn6EzyE_g0n7Trqb_Hw@mail.gmail.com>
Subject: Re: Scrub on btrfs single device only to detect errors, not correct them?
From: Jon Panozzo <jonp@lime-technology.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is what I was thinking as well.  In my particular use-case,
parity is only really used today to reconstruct an entire device due
to a device failure.  I think if btrfs scrub detected errors on a
single device, I could do a "reverse reconstruct" where instead of
syncing TO the parity disk, I sync FROM the parity disk TO the btrfs
single device with the error, replacing physical blocks that are out
of sync with parity (thus repairing the scrub-found errrors).  The
downside to this approach is I would have to perform the reverse-sync
against the entire btrfs block device, which could be much more
time-consuming than if I could single out the specific block addresses
and just sync those.  That said, I guess option A is better than no
option at all.

I would be curious if any of the devs or other members of this mailing
list have tried to correlate btrfs internal block addresses to a true
block-address on the device being used.  Any interesting articles /
links that show how to do this?  Not expecting much, but if someone
does know, I'd be very grateful.

- Jon

On Mon, Dec 7, 2015 at 9:01 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-12-07 09:47, Jon Panozzo wrote:
>>
>> And I'll throw this question out to everyone:
>>
>> Let's say I have a means of providing parity for a btrfs device, but
>> in a way that's external to btrfs (imagine a btrfs single device as
>> part of a hardware or software RAID).  If BTRFS detected an error
>> during a scrub, and parity wasn't updated as a result (say the result
>> of bitrot on the btrfs device), couldn't parity be used to repair the
>> broken bit(s)?  If so, the big question is how to use scrub to
>> determine the sector/bit (forgive me if I'm using wrong terminology)
>> at the block level that needs to be fixed.  I think my theory is sound
>> in principle, but not sure if it's possible to correlate a scrub-found
>> uncorrectable error to a physical location on the block device.
>>
> In theory, this is possible, but it's _really_ tricky to do right. BTRFS
> uses it's own internal block addressing that is mostly independent from
> what's done at the block device level, which makes things non-trivial to map
> to actual addresses.  On top of that, it's non-trivial to get a address for
> a block that failed the scrub operation.  It's probably easier to just run a
> check on the lower-level device if scrub reports errors.  If that fails,
> then it's probably fixable by the lower level directly, if it passes, then
> the issue is probably a bug in BTRFS.
>
>
