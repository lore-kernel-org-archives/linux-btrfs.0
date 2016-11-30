Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:36709 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756778AbcK3TJZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 14:09:25 -0500
Received: by mail-yb0-f177.google.com with SMTP id v78so19907198ybe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 11:09:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19671a71-5d1c-c42e-db3d-c870ec08b2ff@gmail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de> <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
 <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com> <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
 <b13f13a4-639d-d460-7642-c8f8fe646832@googlemail.com> <19671a71-5d1c-c42e-db3d-c870ec08b2ff@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 30 Nov 2016 12:09:23 -0700
Message-ID: <CAJCQCtRnqp15QZ9V+AtBu1_7QwChdoRMs0nHg3stWnJOyy8qMw@mail.gmail.com>
Subject: Re: Convert from RAID 5 to 10
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wilson Meier <wilson.meier@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2016 at 7:37 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> The stability info could be improved, but _absolutely none_ of the things
> mentioned as issues with raid1 are specific to raid1.  And in general, in
> the context of a feature stability matrix, 'OK' generally means that there
> are no significant issues with that specific feature, and since none of the
> issues outlined are specific to raid1, it does meet that description of
> 'OK'.

Maybe the gotchas page needs a one or two liner for each profile's
gotchas compared to what the profile leads the user into believing.
The overriding gotcha with all Btrfs multiple device support is the
lack of monitoring and notification other than kernel messages; and
the raid10 actually being more like raid0+1 I think it certainly a
gotcha, however 'man mkfs.btrfs' contains a grid that very clearly
states raid10 can only safely lose 1 device.


> Looking at this another way, I've been using BTRFS on all my systems since
> kernel 3.16 (I forget what exact vintage that is in regular years).  I've
> not had any data integrity or data loss issues as a result of BTRFS itself
> since 3.19, and in just the past year I've had multiple raid1 profile
> filesystems survive multiple hardware issues with near zero issues (with the
> caveat that I had to re-balance after replacing devices to convert a few
> single chunks to raid1), and that includes multiple disk failures and 2 bad
> PSU's plus about a dozen (not BTRFS related) kernel panics and 4 unexpected
> power loss events.  I also have exhaustive monitoring, so I'm replacing bad
> hardware early instead of waiting for it to actually fail.

Possibly nothing aids predictably reliable storage stacks than healthy
doses of skepticism and awareness of all limitations. :-D

-- 
Chris Murphy
