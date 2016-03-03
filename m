Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37379 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbcCCJK7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 04:10:59 -0500
Received: by mail-ig0-f176.google.com with SMTP id z8so13126942ige.0
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 01:10:58 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <pan$91701$3af360aa$c931211b$9c451328@cox.net>
References: <1456933778-7944-1-git-send-email-fdmanana@kernel.org>
	<pan$91701$3af360aa$c931211b$9c451328@cox.net>
Date: Thu, 3 Mar 2016 09:10:58 +0000
Message-ID: <CAL3q7H7zawdrwbnnwr4nRg5PTj3BqRjDpZJo+idxCANMs185LA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix loading of orphan roots leading to BUG_ON
From: Filipe Manana <fdmanana@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 3, 2016 at 4:31 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> fdmanana posted on Wed, 02 Mar 2016 15:49:38 +0000 as excerpted:
>
>> When looking for orphan roots during mount we can end up hitting a
>> BUG_ON() (at root-item.c:btrfs_find_orphan_roots()) if a log tree is
>> replayed and qgroups are enabled.
>
> This should hit 4.6, right?  Will it hit 4.5 before release?

It's not the first time you do a similar question, and if it's
targeted at me, all I can tell you is I don't know. It's the
maintainers (Chris, Josef, David)  who decide when to pick patches and
for which releases.

>
> Because I wasn't sure of current quota functionality status, but this bug
> obviously resets the counter on my ongoing "two kernel cycles with no
> known quota bugs before you try to use quotas" recommendation.

You shouldn't spread such affirmation with such a level of certainty
every time a user reports a problem.
There are many bugs affecting the last 2 to 3 releases, but there are
also many bugs present since btrfs was added to the linux kernel tree,
and many others present for 2+ years, etc.

>
> Meanwhile, what /is/ current quota feature status?  Other than this bug,
> is it now considered known bug free, or is more quota reworking and/or
> bug fixing known to be needed for 4.6 and beyond?
>
> IOW, given that two release cycles no known bugs counter, are we
> realistically looking at that being 4.8, or are we now looking at 4.9 or
> beyond for reasonable quota stability?

I don't know. I generally don't look actively look at qgroups, and I'm
not a user either.
You can only take conclusions based on user bug reports. Probably
there aren't more bugs for qgroups than there are for send/receive or
even non-btrfs specific features for example.

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



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
