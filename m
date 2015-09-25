Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from portkey.s.itsis.si ([78.47.12.76]:36045 "EHLO
	portkey.s.itsis.si" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672AbbIYRlX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 13:41:23 -0400
Received: by ioiz6 with SMTP id z6so118004004ioi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 10:41:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_nnhJ5m4gcz=APY7boNj1d+oxGyKOedUxSWOgV0MH65dw@mail.gmail.com>
References: <4362384.AA8xu4anSN@hoefnix>
	<56052E0D.3090702@gmail.com>
	<CAGfcS_nFn=AH6Y-4dFQEmy42KVJLBvLuaEHRtoYrBDUtNategw@mail.gmail.com>
	<CAEp_DRB7zaHmJnghJzVR++_OO+4mrM_+jCjrYAQJcNUXpM=bAQ@mail.gmail.com>
	<CAGfcS_nnhJ5m4gcz=APY7boNj1d+oxGyKOedUxSWOgV0MH65dw@mail.gmail.com>
Date: Fri, 25 Sep 2015 19:41:07 +0200
Message-ID: <CAEp_DRDwextJgRjaS5kMuqXtAzTYwBMuhQ1ePBV3ByGe5sBtYQ@mail.gmail.com>
Subject: Re: Latest kernel to use?
From: Bostjan Skufca <bostjan@a2o.si>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Sjoerd <sjoerd@sjomar.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for heart-warming recommendation, this is also what I generally do.

In this case (and I remember vaguely) the reasoning for going with
3.19.x at the time was that I was hitting some btrfs issues around
3.16 and at the same time eyeing btrfs changesets going into mainline.
This, combined with general recommendation for using latest kernels
for btrfs and that systems were doing backups mainly (so, no
btrfs-related bugs if at all possible, the rest is unimportant),
resulted in what is now stable configuration.

Downgrading - well, no :)

For such systems (backend/backup servers), I tend to upgrade kernels when:
a) some exploit is discovered, or
b) feature present in newer kernel is needed.

I understand the difference between mainline and stable, but I haven't
had problems with mainline 'since forever'.

b.

On 25 September 2015 at 19:00, Rich Freeman <r-btrfs@thefreemanclan.net> wrote:
> On Fri, Sep 25, 2015 at 9:25 AM, Bostjan Skufca <bostjan@a2o.si> wrote:
>>
>> Similar here: I am sticking with 3.19.2 which has proven to work fine for me
>
> I'd recommend still tracking SOME stable series.  I'm sure there were
> fixes in 3.19 for btrfs (to say nothing of other subsystems) that
> you're missing with that version.  3.19 is also unsupported at this
> time.  You might want to consider moving to either 3.18.21 or 4.1.8
> and tracking those series instead.  I doubt you'd give up much moving
> back to 3.18 and there have been a bunch of btrfs fixes in that series
> (though it seems to me that 3.18 has been slower to receive btrfs
> patches than some of the other series).
>
> I'm on the fence right now about making the move to 4.1.  Maybe in a
> few releases I'll be there, depending on what the noise on the lists
> sounds like.
>
> There was a time when you were better off on bleeding-edge linux for
> btrfs.  If you REALLY want to run btrfs raid5 or something like that
> then I'd say that is still your best strategy.  However, if you stick
> with features that have been around for a year the longterm kernels
> seem a lot less likely to hit you with a regression, as long as you
> don't switch to a new one the day it is declared as such.
>
> --
> Rich
