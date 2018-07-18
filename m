Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45750 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbeGRA76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 20:59:58 -0400
Date: Tue, 17 Jul 2018 17:24:51 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check (not lowmem) and OOM-like hangs (4.17.6)
Message-ID: <20180718002451.GF10237@merlins.org>
References: <20180717203257.GA10237@merlins.org> <20180717205905.GB10237@merlins.org> <8a0fbf2d-ee13-f6d6-a046-5dfba936aa87@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8a0fbf2d-ee13-f6d6-a046-5dfba936aa87@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 08:05:51AM +0800, Qu Wenruo wrote:
> No OOM triggers? That's a little strange.
> Maybe it's related to how kernel handles memory over-commit?
 
Yes, I think you are correct.

> And for the hang, I think it's related to some memory allocation failure
> and error handler just didn't handle it well, so it's causing deadlock
> for certain page.

That indeed matches what I'm seeing.

> ENOMEM handling is pretty common but hardly verified, so it's not that
> strange, but we must locate the problem.

I seem to be getting deadlocks in the kernel, so I'm hoping that at least
it's checked there, but maybe not?

> In my system, at least I'm not using btrfs as root fs, and for the
> memory eating program I normally ensure it's eating all the memory +
> swap, so OOM killer is always triggered, maybe that's the cause.
> 
> So in your case, maybe it's btrfs not really taking up all memory, thus
> OOM killer not triggered.

Correct, the swap is not used.

> Any kernel dmesg about OOM killer triggered?
 
Nothing at all. It never gets triggered.

> > Here is my system when it virtually died:
> > ER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> > root     31006 21.2 90.7 29639020 29623180 pts/19 D+ 13:49   1:35 ./btrfs check /dev/mapper/dshelf2

See how btrs was taking 29GB in that ps output (that's before it takes
everything and I can't even type ps anymore)
Note that VSZ is almost equal to RSS. Nothing gets swapped.

Then see free output:

> >              total       used       free     shared    buffers     cached
> > Mem:      32643788   32180100     463688          0      44664     119508
> > -/+ buffers/cache:   32015928     627860
> > Swap:     15616764     443676   15173088
> 
> For swap, it looks like only some other program's memory is swapped out,
> not btrfs'.

That's exactly correct. btrfs check never goes to swap, I'm not sure why,
and because there is virtual memory free, maybe that's why OOM does not
trigger?
So I guess I can probably "fix" my problem by removing swap, but ultimately
it would be useful to know why memory taken by btrfs check does not end up
in swap.

> And unfortunately, I'm not so familiar with OOM/MM code outside of
> filesystem.
> Any help from other experienced developers would definitely help to
> solve why memory of 'btrfs check' is not swapped out or why OOM killer
> is not triggered.

Do you have someone from linux-vm you might be able to ask, or should we Cc
this thread there?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
