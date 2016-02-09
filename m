Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49756 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbcBIVnu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 16:43:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aTG4a-0007ob-4s
	for linux-btrfs@vger.kernel.org; Tue, 09 Feb 2016 22:43:48 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 22:43:48 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 22:43:48 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Use fast device only for metadata?
Date: Tue, 9 Feb 2016 22:43:41 +0100
Message-ID: <20160209224341.5bfa20b7@jupiter.sol.kaishome.de>
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba>
	<87twliri6m.fsf@thinkpad.rath.org>
	<20160209082933.52273993@jupiter.sol.kaishome.de>
	<87mvr9euhb.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 09 Feb 2016 08:09:20 -0800
schrieb Nikolaus Rath <Nikolaus@rath.org>:

> On Feb 09 2016, Kai Krakow <hurikhan77@gmail.com> wrote:
> > I'm myself using bcache+btrfs and it ran bullet proof so far, even
> > after unintentional resets or power outage. It's important tho to
> > NOT put any storage layer between bcache and your devices or
> > between btrfs and your device as there are reports it becomes
> > unstable with md or lvm involved.
> 
> Do you mean I should not use anything in the stack other than btrfs
> and bcache, or do you mean I should not put anything under bcache?

I never tried, I just use rawdevice+bcache+btrfs. Nothing stacked
below or inbetween. This works for me.

> In other words, I assume bcache on LVM is a bad idea. But what about
> LVM on bcache?

I think it makes a difference.

> Also, btrfs on LVM on disk is working fine for me, but you seem to be
> saying that it should not? Or are you talking specifically about btrfs
> on LVM on bcache?

Btrfs alone should be no problem. Any combination of all three could
get you in trouble. I suggest doing your tests and keep it as simple as
it can be.

> If there's no way to put LVM anywhere into the stack that'd be a
> bummer, I very much want to use dm-crypt (and I guess that counts as
> lvm?).

Wasn't there plans for integrating per-file encryption into btrfs (like
there's already for ext4)? I think this could pretty well obsolete your
plans - except you prefer full-device encryption.

If you don't put encryption below the bcache caching device, everything
going to the cache won't be encrypted - so that's probably what you are
having to do anyways.

But I don't know how such a setup recovers from power outage, I'm not
familiar with dm-crypt at all, how it integrates with maybe initrd etc.

But get a bigger picture let me explain how bcache works:

The caching device is treated dirty always. That means, it replays all
dirty data automatically during device discovery. Backing and caching
create a unified pair - that's why the superblock is needed. It saves
you from accidently using the backing without the cache. So even after
unclean shutdown, from the user-space view, the pair is always
consistent. Bcache will only remove persisted data from its log if it
ensured it was written correctly to the backing. The backing on its
own, however, is not guaranteed to be consistent at any time - except
you cleanly stop bcache and disconnect the pair (detach the cache).

When dm-crypt comes in, I'm not sure how this is handled - given that
the encryption key must be loaded from somewhere... Someone else may
have a better clue here.

So actually there's two questions:

1. Which order of stacking makes more sense and is more resilient to
errors?

2. Which order of stacking is exhibiting bugs?


-- 
Regards,
Kai

Replies to list-only preferred.

