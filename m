Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:46981 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933936AbdJQRG2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 13:06:28 -0400
Date: Tue, 17 Oct 2017 19:06:26 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Zoltan <zoltan1980@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Is it safe to use btrfs on top of different types of devices?
Message-ID: <20171017170626.amfrohfyqlujdueu@angband.pl>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
 <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
 <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
 <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
 <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 17, 2017 at 08:40:20AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-10-17 07:42, Zoltan wrote:
> > On Tue, Oct 17, 2017 at 1:26 PM, Austin S. Hemmelgarn
> > <ahferroin7@gmail.com> wrote:
> > 
> > > I forget sometimes that people insist on storing large volumes of data on
> > > unreliable storage...
> > 
> > In my opinion the unreliability of the storage is the exact reason for
> > wanting to use raid1. And I think any problem one encounters with an
> > unreliable disk can likely happen with more reliable ones as well,
> > only less frequently, so if I don't feel comfortable using raid1 on an
> > unreliable medium then I wouldn't trust it on a more reliable one
> > either.

> The thing is that you need some minimum degree of reliability in the other
> components in the storage stack for it to be viable to use any given storage
> technology.  If you don't meet that minimum degree of reliability, then you
> can't count on the reliability guarantees of the storage technology.

The thing is, reliability guarantees required vary WILDLY depending on your
particular use cases.  On one hand, there's "even an one-minute downtime
would cost us mucho $$$s, can't have that!" -- on the other, "it died? 
Okay, we got backups, lemme restore it after the weekend".

Lemme tell you a btrfs blockdev disconnects story.
I have an Odroid-U2, a cheap ARM SoC that, despite being 5 years old and
costing mere $79 (+$89 eMMC...) still beats the performance of much newer
SoCs that have far better theoretical specs, including subsequent Odroids.
After ~1.5 year of CPU-bound stress tests for one program, I switched this
machine to doing Debian package rebuilds, 24/7/365¼, for QA purposes.
Being a moron, I did not realize until pretty late that high parallelism to
keep all cores utilized is still a net performance loss when a memory-hungry
package goes into a swappeathon, even despite the latter being fairly rare.
Thus, I can say disk utilization was pretty much 100%, with almost as much
writing as reading.  The eMMC card endured all of this until very recently
(nowadays it sadly throws errors from time to time).

Thus, I switched the machine to NBD (albeit it sucks on 100Mbit eth).  Alas,
the network driver allocates memory with GFP_NOIO which causes NBD
disconnects (somehow, this doesn't ever happen on swap where GFP_NOIO would
be obvious but on regular filesystem where throwing out userspace memory is
safe).  The disconnects happen around once per week.

It's a single-device filesystem, thus disconnects are obviously fatal.  But,
they never caused even a single bit of damage (as scrub goes), thus proving
btrfs handles this kind of disconnects well.  Unlike times past, the kernel
doesn't get confused thus no reboot is needed, merely an unmount, "service
nbd-client restart", mount, restart the rebuild jobs.

I also can recreate this filesystem and the build environment on it with
just a few commands, thus, unlike /, there's no need for backups.  But I
had no need to recreate it yet.

This is single-device not RAID5, but it's a good example for an use case
where an unreliable storage medium is acceptable (even if the GFP_NOIO issue
is still worth fixing).


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Imagine there are bandits in your house, your kid is bleeding out,
⢿⡄⠘⠷⠚⠋⠀ the house is on fire, and seven big-ass trumpets are playing in the
⠈⠳⣄⠀⠀⠀⠀ sky.  Your cat demands food.  The priority should be obvious...
