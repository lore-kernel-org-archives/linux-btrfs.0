Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35976 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964783AbbLGOro (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 09:47:44 -0500
Received: by iofh3 with SMTP id h3so183343244iof.3
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 06:47:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$519f9$af10e2cb$f1ea2d14$435d0b5a@cox.net>
References: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
	<CAJCQCtQX5Ov6YKZ=SdxaGSPaGa0sEFF6gz89WsDm9qegmykGkA@mail.gmail.com>
	<pan$519f9$af10e2cb$f1ea2d14$435d0b5a@cox.net>
Date: Mon, 7 Dec 2015 08:47:43 -0600
Message-ID: <CA+pSGYeYwC=eWmSuC4MXsSz1qVvWqzxxv7KzxkhQ84BKUDO-MA@mail.gmail.com>
Subject: Re: Scrub on btrfs single device only to detect errors, not correct them?
From: Jon Panozzo <jonp@lime-technology.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And I'll throw this question out to everyone:

Let's say I have a means of providing parity for a btrfs device, but
in a way that's external to btrfs (imagine a btrfs single device as
part of a hardware or software RAID).  If BTRFS detected an error
during a scrub, and parity wasn't updated as a result (say the result
of bitrot on the btrfs device), couldn't parity be used to repair the
broken bit(s)?  If so, the big question is how to use scrub to
determine the sector/bit (forgive me if I'm using wrong terminology)
at the block level that needs to be fixed.  I think my theory is sound
in principle, but not sure if it's possible to correlate a scrub-found
uncorrectable error to a physical location on the block device.

- Jon

On Sun, Dec 6, 2015 at 9:48 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Sun, 06 Dec 2015 13:42:57 -0700 as excerpted:
>
>> On Sun, Dec 6, 2015 at 12:15 PM, Jon Panozzo <jonp@lime-technology.com>
>> wrote:
>>> Just to confirm, is the sole purpose of supporting scrub on single
>>> btrfs devices to detect errors, but not to correct them?
>>
>> If that single device metadata profile is DUP, then it will correct
>> those. If there is only one copy of anything, then it just reports.
>> Scrub works on all data, but a passive scrub happens anytime something
>> is read.
>
> ... And more to the point, expanding on that, on a single device btrfs,
> data is single mode by default, so scrub for it (as opposed to metadata)
> is error-detect-only as mentioned.
>
> However, while the default mode separates data and metadata, and in that
> mode, historically (there's a patch to change this, adding the missing
> option) data was single-only, mixed-bg mode (the mkfs.btrfs --mixed
> option) puts data and metadata both in the same shared block-group type,
> which can then be either dup or single mode.
>
> Obviously duplicating data as well as metadata means you can only store
> half as much data, since it's all stored twice, but that will let scrub
> correct errors in cases where only one of the two copies doesn't verify
> checksum, but the other one does.
>
> And as mentioned above, there's a patch in process now, that will remove
> the single-device restriction of data (as opposed to metadata) to single
> mode, allowing the choice of dup mode for data as well as metadata.
>
>
> Also, in addition to the mixed-mode workaround to get dup data, it's
> possible, altho rather inefficient in performance terms, to partition a
> physical device such that two equal sized partitions are made available
> as logical devices, and then mkfs.btrf -d raid1 -m raid1 the two logical
> devices into a single btrfs, raid1 for both data and metadata, so btrfs
> creates two copies that way, again letting scrub correct errors when only
> one of the two fails to verify against checksum.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
