Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49826 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750816AbdAJFem (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 00:34:42 -0500
Subject: Re: mkfs.btrfs/balance small-btrfs chunk size RFC
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c455ea6d-2c30-8f94-4726-e1a4ccc0abf8@cn.fujitsu.com>
Date: Tue, 10 Jan 2017 13:34:27 +0800
MIME-Version: 1.0
In-Reply-To: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/10/2017 11:55 AM, Duncan wrote:
> This post is triggered by a balance problem due to oversized chunks that
> I have currently.
>
> Proposal 1: Ensure maximum chunk sizes are less than 1/8 the size of the
> filesystem (down to where they can't be any smaller, at least).

In fact, kernel created new chunks are ensured to be less than 1/10 of 
the total rw bytes of the fs.
Which only limits on chunk size, so it may take 1/5 if using DUP/RAID1.

>
> Proposal 2: Drastically reduce default system chunk size on small btrfs.

Although btrfs_alloc_chunk() has similar 10% limit, but it doesn't work 
in your case.

I'm not sure what's going wrong but I'll look into it after fixing the 
dev-replace bug.

Thanks,
Qu

>
> Here's the real-life scenario:  My /boot is 256 MiB mixed-bg-mode DUP.
>
> Unfortunately, mkfs.btrfs apparently creates the first mixed chunk as 64
> MiB, making it unbalancable.  64 MiB duped due to dup mode is 128 MiB,
> exactly half the btrfs size.  But there's also a 16 MiB system chunk,
> duped to 32 MiB, so even with a still-empty fs immediately after creation
> I can't balance that chunk (which isn't entirely empty apparently in
> ordered to keep it from being erased by the kernel auto-clean or a
> balance, leaving no record of the chunk mode), because the 1/4 the btrfs
> chunk dups to 1/2 the btrfs, and with the system chunk as well, there's
> not half the btrfs left in ordered to create a second chunk along with
> its dup to balance into.
>
> But if I fill the btrfs enough to create another mixed chunk, it's only
> 16 MiB in size, duped to 32 MiB, and btrfs usage shows it going from 64
> MiB to 80 MiB (16 MiB change, the additional chunk size), with the
> resulting duped size going from 128 MiB to 160 MiB (32 MiB change, the
> additional chunk duped size).
>
> Now if those first chunks were 32 MiB or even the 16 MiB of the second,
> there'd obviously be more of them used for the same file content, but as
> long as I kept enough unallocated space on the btrfs to handle twice the
> size (due to dup) of the largest chunk, I could still balance all chunks,
> something that's flat impossible when the first mixed chunk dups to half
> the btrfs, and there has to be room for the system chunk as well.
>
> So if the maximum created chunk size was limited to 1/8 the btrfs size,
> it would dup to 1/4 the size, and balances should actually be possible.
>
> As for proposal 2...
>
> The system chunk size is 16 MiB, duped to 32 MiB, despite only a single 4
> KiB block actually being used.  Locking up 16 MiB, duped to 32 MiB thus
> 1/8 the entire btrfs space of 256 MiB, for a single 4 KiB block, duped to
> 8 KiB, 1/20th of 1 percent of that system chunk used if my math is
> correct, is ridiculous on a sub-GiB btrfs.
>
> I don't know what the minimum chunk size actually is, but something like
> 1 MiB system chunk size, if possible, would be far more reasonable in the
> sub-GiB btrfs context.  Otherwise 2 or even 4 MiB, the latter of which
> would dup to 8 MiB, would be tolerable, but a 16 MiB system chunk for a
> single 4 KiB block... and then dup /that/... just ridiculous.
>
> It wouldn't be quite so bad if the global reserve (reported at 16 MiB)
> came from the system chunk instead of metadata (mixed-chunk here), and
> putting that in the system chunk would make sense since it's effectively
> system-reserved space, but of course it doesn't work that way, and I'd
> guess changing that would be a hairy nightmare, far worse than simply
> clamping down on created chunk sizes a bit, and likely practically
> impossible to implement at this stage.
>
>
> But I'd expect clamping down on created chunk size, simply adding a check
> to ensure it's under 1/8 the full btrfs size (down to the minimum allowed
> chunk size, of course), to be quite practical and reasonably easy to
> implement.  Similarly altho I'm less sure of how small the minimum system
> chunk size can be, I expect maximum system chunk size can reasonably be
> limited to say 4 MiB, if not 1 or 2 MiB, on sub-GiB btrfs.
>
> So RFC, how realistic and simple does this look to the devs actually
> doing the code?  Is it a small enough job it could qualify as a bug fix
> (as it arguably is, given that the btrfs is /created/ with chunks that
> are impossible to balance, at present, or at least was around 4.8 time,
> as I believe that's about when I created the btrfs), be tested and make
> it into released code within say five kernel cycles, a year's time?
> Obviously I'm hoping so. =:^)
>


