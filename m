Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33121 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760368AbcISMh3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 08:37:29 -0400
Received: by mail-io0-f170.google.com with SMTP id r145so89513999ior.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 05:37:28 -0700 (PDT)
Subject: Re: Is stability a joke? (wiki updated)
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
 <20160915201657.GK7138@carfax.org.uk>
 <CAJCQCtSKU78Tvak_q=3xnh-Hm6=zXs6ffd1o=uYMpBmp6CxWtA@mail.gmail.com>
 <954df3cd-0554-b86f-9dae-47517f3fbad7@gmail.com>
 <20160919025756.GD21290@hungrycats.org>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        David Sterba <dsterba@suse.cz>, Waxhead <waxhead@online.no>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <70bd3855-7fda-dfcc-587b-db88d6834fef@gmail.com>
Date: Mon, 19 Sep 2016 08:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <20160919025756.GD21290@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-18 22:57, Zygo Blaxell wrote:
> On Fri, Sep 16, 2016 at 08:00:44AM -0400, Austin S. Hemmelgarn wrote:
>> To be entirely honest, both zero-log and super-recover could probably be
>> pretty easily integrated into btrfs check such that it detects when they
>> need to be run and does so.  zero-log has a very well defined situation in
>> which it's absolutely needed (log tree corrupted such that it can't be
>> replayed), which is pretty easy to detect (the kernel obviously does so,
>> albeit by crashing).
>
> Check already includes zero-log.  It loses a little data that way, but
> that is probably better than the alternative (try to teach btrfs check
> how to replay the log tree and keep up with kernel changes).
Interesting, as I've never seen check try to zero the log (even in cases 
where it would fix things) unless it makes some other change in the FS. 
I won't dispute that it clears the log tree _if_ it makes other changes 
to the FS (it kind of has to for safety reasons), but that's the only 
circumstance that I've seen it do so (even on filesystems where the log 
tree was corrupted, but the rest of the FS was fine).
>
> There have been at least two log-tree bugs (or, more accurately,
> bugs triggered while processing the log tree during mount) in the 3.x
> and 4.x kernels.  The most recent I've encountered was in one of the
> 4.7-rc kernels.  zero-log is certainly not obsolete.
I won't dispute this, as I've had it happen myself (albeit not quite 
that recently), all I was trying to say was that it fixes a very well 
defined problem.
>
> For a filesystem where availablity is more important than integrity
> (e.g. root filesystems) it's really handy to have zero-log as a separate
> tool without the huge overhead (and regression risk) of check.
Agreed, hence my later statement that if it gets fully merged, there 
should be an option to run just that.

