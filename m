Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45316 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863AbcBIWir convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 17:38:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 07600207C2
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 17:38:47 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id B1E566800F1
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 17:38:46 -0500 (EST)
Received: from thinkpad.rath.org (thinkpad [192.168.12.2])
	by ebox.rath.org (Postfix) with ESMTPS id D43F51CED45
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 22:38:45 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Use fast device only for metadata?
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba> <87twliri6m.fsf@thinkpad.rath.org>
	<20160209082933.52273993@jupiter.sol.kaishome.de>
	<87mvr9euhb.fsf@vostro.rath.org>
	<20160209224341.5bfa20b7@jupiter.sol.kaishome.de>
Date: Tue, 09 Feb 2016 14:38:45 -0800
In-Reply-To: <20160209224341.5bfa20b7@jupiter.sol.kaishome.de> (Kai Krakow's
	message of "Tue, 9 Feb 2016 22:43:41 +0100")
Message-ID: <87vb5xpkzu.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 09 2016, Kai Krakow <hurikhan77@gmail.com> wrote:
>> If there's no way to put LVM anywhere into the stack that'd be a
>> bummer, I very much want to use dm-crypt (and I guess that counts as
>> lvm?).
>
> Wasn't there plans for integrating per-file encryption into btrfs (like
> there's already for ext4)? I think this could pretty well obsolete your
> plans - except you prefer full-device encryption.

Well, it could obsolete it once the plan turns into an implementation,
but not today :-).

> If you don't put encryption below the bcache caching device, everything
> going to the cache won't be encrypted - so that's probably what you are
> having to do anyways.

No, I could use put separate encryption layers between bcache and the
disk - for both the backing and the caching device.

> But I don't know how such a setup recovers from power outage, I'm not
> familiar with dm-crypt at all, how it integrates with maybe initrd
> etc.

Initrd is not a concern. You can put on it whatever is needed to set up
the stack.

As far as power outages is concerned, I think dm-crypt doesn't change
anything - it's an intermediate layer with no caching. Any write gets
passed through synchronously.

> The caching device is treated dirty always. That means, it replays all
> dirty data automatically during device discovery. Backing and caching
> create a unified pair - that's why the superblock is needed. It saves
> you from accidently using the backing without the cache. So even after
> unclean shutdown, from the user-space view, the pair is always
> consistent. Bcache will only remove persisted data from its log if it
> ensured it was written correctly to the backing. The backing on its
> own, however, is not guaranteed to be consistent at any time - except
> you cleanly stop bcache and disconnect the pair (detach the cache).
>
> When dm-crypt comes in, I'm not sure how this is handled - given that
> the encryption key must be loaded from somewhere... Someone else may
> have a better clue here.

The encryption keys are supplied by userspace when setting up the
device. 


> So actually there's two questions:
>
> 1. Which order of stacking makes more sense and is more resilient to
> errors?

I think in an ideal world (i.e, no software bugs), inserting dm-crypt
anywhere in the stack will not make a difference at all even when there
is a crash. Thus...

> 2. Which order of stacking is exhibiting bugs?

..indeed becomes the important question. Now if only someone had an
answer :-).


Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
