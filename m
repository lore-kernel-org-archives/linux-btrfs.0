Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43694 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbdCCUpR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 15:45:17 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cjtXD-0003pu-CV
        for linux-btrfs@vger.kernel.org; Fri, 03 Mar 2017 21:10:39 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: raid1 degraded mount still produce single chunks, writeable
 mount not allowed
Date: Fri, 3 Mar 2017 21:10:37 +0100
Message-ID: <20170303211037.59abb4b7@jupiter.sol.kaishome.de>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
        <20170302103753.x35jhe7xgnwl6ee6@angband.pl>
        <20170303065622.2a9a244e@jupiter.sol.kaishome.de>
        <88b27891-b3fc-eef6-d793-96fd32504818@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 3 Mar 2017 07:19:06 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> On 2017-03-03 00:56, Kai Krakow wrote:
> > Am Thu, 2 Mar 2017 11:37:53 +0100
> > schrieb Adam Borowski <kilobyte@angband.pl>:
> >  
> >> On Wed, Mar 01, 2017 at 05:30:37PM -0700, Chris Murphy wrote:  
>  [...]  
> >>
> >> Well, there's Qu's patch at:
> >> https://www.spinics.net/lists/linux-btrfs/msg47283.html
> >> but it doesn't apply cleanly nor is easy to rebase to current
> >> kernels. 
>  [...]  
> >>
> >> Well, yeah.  The current check is naive and wrong.  It does have a
> >> purpose, just fails in this, very common, case.  
> >
> > I guess the reasoning behind this is: Creating any more chunks on
> > this drive will make raid1 chunks with only one copy. Adding
> > another drive later will not replay the copies without user
> > interaction. Is that true?
> >
> > If yes, this may leave you with a mixed case of having a raid1 drive
> > with some chunks not mirrored and some mirrored. When the other
> > drives goes missing later, you are loosing data or even the whole
> > filesystem although you were left with the (wrong) imagination of
> > having a mirrored drive setup...
> >
> > Is this how it works?
> >
> > If yes, a real patch would also need to replay the missing copies
> > after adding a new drive.
> >  
> The problem is that that would use some serious disk bandwidth
> without user intervention.  The way from userspace to fix this is to
> scrub the FS.  It would essentially be the same from kernel space,
> which means that if you had a multi-TB FS and this happened, you'd be
> running at below capacity in terms of bandwidth for quite some time.
> If this were to be implemented, it would have to be keyed off of the
> per-chunk degraded check (so that _only_ the chunks that need it get
> touched), and there would need to be a switch to disable it.

Well, I'd expect that a replaced drive would involve reduced bandwidth
for a while. Every traditional RAID does this. The key solution there
is that you can limit bandwidth and/or define priorities (BG rebuild
rate).

Btrfs OTOH could be a lot more smarter, only rebuilding chunks that are
affected. The kernel can already do IO priorities and some sort of
bandwidth limiting should also be possible. I think IO throttling is
already implemented in the kernel somewhere (at least with 4.10) and
also in btrfs. So the basics are there.

In a RAID setup, performance should never have priority over redundancy
by default.

If performance is an important factor, I suggest working with SSD
writeback caches. This is already possible with different kernel
techniques like mdcache or bcache. Proper hardware controllers also
support this in hardware. It's cheap to have a mirrored SSD
writeback cache of 1TB or so if your setup already contains a multiple
terabytes array. Such a setup has huge performance benefits in setups
we deploy (tho, not btrfs related).

Also, adding/replacing a drive is usually not a totally unplanned
event. Except for hot spares, a missing drive will be replaced at the
time you arrive on-site. If performance is a factor, this can be done
the same time as manually starting the process. So why not should it be
done automatically?

-- 
Regards,
Kai

Replies to list-only preferred.

