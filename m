Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34654 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1758730AbdELSg7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 14:36:59 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d9FQl-0002Vt-Ae
        for linux-btrfs@vger.kernel.org; Fri, 12 May 2017 20:36:47 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs/SSD
Date: Fri, 12 May 2017 20:36:44 +0200
Message-ID: <20170512203644.26e068e5@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 12 May 2017 15:02:20 +0200
schrieb Imran Geriskovan <imran.geriskovan@gmail.com>:

> On 5/12/17, Duncan <1i5t5.duncan@cox.net> wrote:
> > FWIW, I'm in the market for SSDs ATM, and remembered this from a
> > couple weeks ago so went back to find it.  Thanks. =:^)
> >
> > (I'm currently still on quarter-TB generation ssds, plus spinning
> > rust for the larger media partition and backups, and want to be rid
> > of the spinning rust, so am looking at half-TB to TB, which seems
> > to be the pricing sweet spot these days anyway.)  
> 
> Since you are taking ssds to mainstream based on your experience,
> I guess your perception of data retension/reliability is better than
> that of spinning rust. Right? Can you eloborate?
> 
> Or an other criteria might be physical constraints of spinning rust
> on notebooks which dictates that you should handle the device
> with care when running.
> 
> What was your primary motivation other than performance?

Personally, I don't really trust SSDs so much. They are much more
robust when it comes to physical damage because there are no physical
parts. That's absolutely not my concern. Regarding this, I trust SSDs
better than HDDs.

My concern is with fail scenarios of some SSDs which die unexpected and
horribly. I found some reports of older Samsung SSDs which failed
suddenly and unexpected, and in a way that the drive completely died:
No more data access, everything gone. HDDs start with bad sectors and
there's a good chance I can recover most of the data except a few
sectors.

When SSD blocks die, they are probably huge compared to a sector (256kB
to 4MB usually because that's erase block sizes). If this happens, the
firmware may decide to either allow read-only access or completely deny
access. There's another situation where dying storage chips may
completely mess up the firmware and there's no longer any access to
data.

That's why I don't trust any of my data to them. But I still want the
benefit of their speed. So I use SSDs mostly as frontend caches to
HDDs. This gives me big storage with fast access. Indeed, I'm using
bcache successfully for this. A warm cache is almost as fast as native
SSD (at least it feels almost that fast, it will be slower if you threw
benchmarks at it).


-- 
Regards,
Kai

Replies to list-only preferred.

