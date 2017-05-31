Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55525 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdEaGrX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 02:47:23 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dFxPX-0006ll-Mm
        for linux-btrfs@vger.kernel.org; Wed, 31 May 2017 08:47:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Debugging Deadlocks?
Date: Wed, 31 May 2017 06:47:09 +0000 (UTC)
Message-ID: <pan$36b2c$8dfce5e1$e29079a0$42822241@cox.net>
References: <CAMp4zn9Qqx_T03-Vn6zZxo3OkTRfWeHrgOkefmc4JdzzfswAyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sargun Dhillon posted on Tue, 30 May 2017 09:12:39 -0700 as excerpted:

> We've been running BtrFS for a couple months now in production on
> several clusters. We're running on Canonical's 4.8 kernel, and
> currently, in the process of moving to our own patchset atop vanilla
> 4.10+. I'm glad to say it's been a fairly good experience for us. Bar
> some performance issues, it's been largely smooth sailing.
> 
> There has been one class of persistent issues that has been plaguing our
> cluster is deadlocks.

Being just a list regular and btrfs (personal) user, not a dev or big-
time production user, I can't say I've seen a deadlocks problem either 
here or reported in significant numbers on-list, but beyond that I can't 
help there.

I'm replying, however, regarding your kernel choices.

Good for getting off kernel 4.8, as in mainline kernel terms that's only 
a short-term stable release and support has now ended.

But I'm slightly concerned with your kernel 4.10+ choice on production 
clusters.  4.9 is the most recent mainline and therefore btrfs LTS kernel 
series, and as such, what I was expecting.

Now don't get me wrong, 4.10+ is appropriate ATM as well, and if you're 
planning to stay current, within the 2-latest-current-kernel-cycles list 
recommendation, I'd consider it preferred.

However, most large-scale production deployments tend to prefer a 
somewhat slower upgrade cycle than that, in which case 4.9 is preferred 
as the latest mainline LTS series.

As far as LTS series go, this list tries to support the latest two LTS 
series, as it does the latest two current stable series.  While that's 
rather shorter than the LTS series support in general, it's in keeping 
with the fact that btrfs remains still stabilizing and as such under 
heavy development, tho it's far more stable than it was back in the 
kernel 3.x or early 4.x era.

At present that means 4.9 and the previous 4.4, altho in practice 4.4 was 
long enough ago that we prefer 4.9 unless there's some definite reason 
it's not going to work for you.

But you're not talking as old as 4.4 in any case, so it's a question of 
4.9 LTS and staying with that series for awhile, or 4.10+, but upgrading 
every 10 weeks or so as a new kernel series is released and the second-
back, now 4.10 as 4.11 is the newest, becomes the third back and thus 
slips out of both mainline stable release and btrfs list primary support 
range.

If you're comfortable with a ten-week upgrade cycle on the scale you're 
running in production, then by all means, go 4.10 or 4.11 at this point 
and do the upgrades, as that's preferable here for those where it's 
acceptable, but if not, then I'd strongly recommend the 4.9 LTS series 
for now, and upgrading LTS kernel series once a year or whatever, after 
the next LTS series comes out and has had a release or two to shake out 
the early bugs.

OTOH if there's something you really need 4.10 for but would otherwise 
prefer LTS, then yes, go current now and try to do the 10-week cycle, 
until the next LTS, then if desired stick with it and drop back to annual 
or whatever LTS series upgrades.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

