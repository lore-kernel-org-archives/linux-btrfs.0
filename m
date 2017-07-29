Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:38294 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753112AbdG2DDF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 23:03:05 -0400
Received: by mail-lf0-f44.google.com with SMTP id y15so97166562lfd.5
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 20:03:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$ec007$3f43fe2a$2f099431$cc969edd@cox.net>
References: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
 <20170726160717.GA32451@localhost.localdomain> <CANznX5Hx57JbwS75usDHwWBHbmiLj7dVHrfgZ5Swn=8zX=2iHw@mail.gmail.com>
 <pan$ec007$3f43fe2a$2f099431$cc969edd@cox.net>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Sat, 29 Jul 2017 05:02:48 +0200
Message-ID: <CANznX5GNuSXRNq7Zo7pghi4AM=jh_C9yGLd-zdi7P88xRE5Tqw@mail.gmail.com>
Subject: Re: write corruption due to bio cloning on raid5/6
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The read-only scrub finished without errors/hangs (with kernel
4.12.3). So, I guess the hangs were caused by:
1: other bug in 4.13-RC1
2: crazy-random SATA/disk-controller issue
3: interference between various btrfs tools [*]
4: something in the background did DIO write with 4.13-RC1 (but all
affected content was eventually overwritten/deleted between the scrub
attempts)

[*] I expected scrub to finish in ~5 rather than ~40 hours (and didn't
expect interference issues), so I didn't disable the scheduled
maintenance script which deletes old files, recursively defrags the
whole fs and runs a balance with usage=33 filters. I guess either of
those (especially balance) could potentially cause scrub to hang.

On Thu, Jul 27, 2017 at 10:44 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Janos Toth F. posted on Thu, 27 Jul 2017 16:14:47 +0200 as excerpted:
>
>> * This is off-topic but raid5 scrub is painful. The disks run at
>> constant ~100% utilization while performing at ~1/5 of their sequential
>> read speeds. And despite explicitly asking idle IO priority when
>> launching scrub, the filesystem becomes unbearably slow (while scrub
>> takes a days or so to finish ... or get to the point where it hung the
>> last time around, close to the end).
>
> That's because basically all the userspace scrub command does is make the
> appropriate kernel calls to have it do the real scrub.  So priority-
> idling the userspace scrub doesn't do what it does on normal userspace
> jobs that do much of the work themselves.
>
> The problem is that idle-prioritizing the kernel threads actually doing
> the work could risk a deadlock due to lock inversion, since they're
> kernel threads and aren't designed with the idea of people messing with
> their priority in mind.
>
> Meanwhile, that's yet another reason btrfs raid56 mode isn't recommended
> at this time.  Try btrfs raid1 or raid10 mode instead, or possible btrfs
> raid1, single or raid0 mode on top of a pair of mdraid5s or similar.  Tho
> parity-raid mode in general (that is, not btrfs-specific) is known for
> being slow in various cases, with raid10 normally being the best
> performing closest alternative.  (Tho in the btrfs-specific case, btrfs
> raid1 on top of a pair of mdraid/dmraid/whatever raid0s, is the normally
> recommended higher performance reasonably low danger alternative.)

If this applies to all RAID flavors then I consider the built-in help
and the manual pages of scrub misleading (if it's RAID56-only, the
manual should still mention how RAID56 is an exception).

Also, a resumed scrub seems to skip a lot of data. It picks up where
it left but then prematurely reports a job well done. I remember
noticing a similar behavior with balance cancel/resume on RAID5 a few
years ago (it went on for a few more chunks but left the rest alone
and reported completion --- I am not sure if that's fixed now or these
have a common root cause).
