Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:36350 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932426AbdJRL7H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 07:59:07 -0400
Date: Wed, 18 Oct 2017 13:59:05 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Zoltan <zoltan1980@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Is it safe to use btrfs on top of different types of devices?
Message-ID: <20171018115905.f5ndvyp5rcu4ykhv@angband.pl>
References: <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
 <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
 <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
 <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
 <20171017170626.amfrohfyqlujdueu@angband.pl>
 <1d5e9875-1c1e-f67e-1f5b-0741555d9517@gmail.com>
 <20171017202135.xdop4eko6utircmz@angband.pl>
 <213a404f-90e6-a3f8-4867-4e9fcf24426c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <213a404f-90e6-a3f8-4867-4e9fcf24426c@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 18, 2017 at 07:30:55AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-10-17 16:21, Adam Borowski wrote:
> > > > It's a single-device filesystem, thus disconnects are obviously fatal.  But,
> > > > they never caused even a single bit of damage (as scrub goes), thus proving
> > > > btrfs handles this kind of disconnects well.  Unlike times past, the kernel
> > > > doesn't get confused thus no reboot is needed, merely an unmount, "service
> > > > nbd-client restart", mount, restart the rebuild jobs.
> > > That's expected behavior though.  _Single_ device BTRFS has nothing to get
> > > out of sync most of the time, the only time there's any possibility of an
> > > issue is when you die after writing the first copy of a block that's in a
> > > dup profile chunk, but even that is not very likely to cause problems
> > > (you'll just lose at most the last <commit-time> worth of data).
> > 
> > How come?  In a DUP profile, the writes are: chunk 1, chunk2, barrier,
> > superblock.  The two prior writes may be arbitrarily reordered -- both
> > between each other or even individual sectors inside the chunks, but unless
> > the disk lies about barriers, there's no way to have any corruption, thus
> > running scrub is not needed.
> If the device dies after writing chunk 1 but before the barrier, you end up
> needing scrub.  How much of a failure window is present is largely a
> function of how fast the device is, but there is a failure window there.

CoW is there to ensure there is _no_ failure window.  The new content
doesn't matter until there are live pointers to it -- from the filesystem's
point of view we merely scribbled something on an unused part of the block
device.  Only after all pieces are in place (as ensured by the barrier), the
superblock is updated with a reference to the new metadata->data chain.

Thus, no matter when a disconnect happens, after a crash you get either
uncorrupted old version or uncorrupted new version.

No scrub is ever needed for this reason on single device or on RAID1 that
didn't run degraded.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Imagine there are bandits in your house, your kid is bleeding out,
⢿⡄⠘⠷⠚⠋⠀ the house is on fire, and seven big-ass trumpets are playing in the
⠈⠳⣄⠀⠀⠀⠀ sky.  Your cat demands food.  The priority should be obvious...
