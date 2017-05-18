Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:44879 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbdERD37 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:29:59 -0400
Date: Thu, 18 May 2017 05:29:57 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: =?utf-8?Q?=C5=81ukasz_Wr=C3=B3blewski?= <lw@nri.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID 6 corrupted
Message-ID: <20170518032956.axcluisxusxelmx6@angband.pl>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
 <pan$3156f$ad60295$88e5604$e6cc7e68@cox.net>
 <20170517101523.ylmw4qo2wjsnibfh@angband.pl>
 <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 04:09:38AM +0200, Łukasz Wróblewski wrote:
> Thanks guys.
> 
> I will try when stable 4.12 comes out.

It won't come out for ~2.5 months.  I'd recommend building the -rc,
recovering, then going back to a stable kernel.

> Unfortunately I do not have a backup.
> Fortunately, these data are not so critical.
> Some private photos and videos of youth.
> However, I would be very happy if I could get it back.

Usually, the first step should be duplicating the entire filesystem, so
attempts at recovery won't break things further.  As it's a home setup,
I doubt you have 5 spare disks at hand or can readily obtain them, so it
depends how much you care about that data.  Without copies, I'd suggest
doing safe and safeish things first.

> Theoretically, if the devid 4 drive returned to
> 50127310-d15c-49ca-8cdd-8798ea0fda2e. In the absence of a single disk
> recovery should be easy.

The drive's fsid being wrong makes it very likely to not being helpful for
the recovery at all, thus forcing the fsid back sounds like one of less safe
things to do.  In theory, 3/5 healthy disks should be fine for recovering
raid6 (assuming no write hole nastiness), thus it's only a matter of whether
the implementation is up to scratch.  It'd be interesting to see how 4.12
fares.


As the Master Species say, meow!
-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
