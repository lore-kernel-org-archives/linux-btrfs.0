Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36003 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbcBJBM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 20:12:28 -0500
Received: by mail-lf0-f48.google.com with SMTP id 78so2607883lfy.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 17:12:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vb5xpkzu.fsf@thinkpad.rath.org>
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba>
	<87twliri6m.fsf@thinkpad.rath.org>
	<20160209082933.52273993@jupiter.sol.kaishome.de>
	<87mvr9euhb.fsf@vostro.rath.org>
	<20160209224341.5bfa20b7@jupiter.sol.kaishome.de>
	<87vb5xpkzu.fsf@thinkpad.rath.org>
Date: Wed, 10 Feb 2016 02:12:27 +0100
Message-ID: <CAPmG0jY6MVxxW2QZhE1HZqKga0UWOWUde1ZQ3nAmzP1ESyHp+Q@mail.gmail.com>
Subject: Re: Use fast device only for metadata?
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 9, 2016 at 11:38 PM, Nikolaus Rath <Nikolaus@rath.org> wrote:
> On Feb 09 2016, Kai Krakow <hurikhan77@gmail.com> wrote:
>>> If there's no way to put LVM anywhere into the stack that'd be a
>>> bummer, I very much want to use dm-crypt (and I guess that counts as
>>> lvm?).
>>
>> Wasn't there plans for integrating per-file encryption into btrfs (like
>> there's already for ext4)? I think this could pretty well obsolete your
>> plans - except you prefer full-device encryption.
>
> Well, it could obsolete it once the plan turns into an implementation,
> but not today :-).
>
>> If you don't put encryption below the bcache caching device, everything
>> going to the cache won't be encrypted - so that's probably what you are
>> having to do anyways.
>
> No, I could use put separate encryption layers between bcache and the
> disk - for both the backing and the caching device.
>
>> But I don't know how such a setup recovers from power outage, I'm not
>> familiar with dm-crypt at all, how it integrates with maybe initrd
>> etc.
>
> Initrd is not a concern. You can put on it whatever is needed to set up
> the stack.
>
> As far as power outages is concerned, I think dm-crypt doesn't change
> anything - it's an intermediate layer with no caching. Any write gets
> passed through synchronously.
>
>> The caching device is treated dirty always. That means, it replays all
>> dirty data automatically during device discovery. Backing and caching
>> create a unified pair - that's why the superblock is needed. It saves
>> you from accidently using the backing without the cache. So even after
>> unclean shutdown, from the user-space view, the pair is always
>> consistent. Bcache will only remove persisted data from its log if it
>> ensured it was written correctly to the backing. The backing on its
>> own, however, is not guaranteed to be consistent at any time - except
>> you cleanly stop bcache and disconnect the pair (detach the cache).
>>
>> When dm-crypt comes in, I'm not sure how this is handled - given that
>> the encryption key must be loaded from somewhere... Someone else may
>> have a better clue here.
>
> The encryption keys are supplied by userspace when setting up the
> device.
>
>
>> So actually there's two questions:
>>
>> 1. Which order of stacking makes more sense and is more resilient to
>> errors?
>
> I think in an ideal world (i.e, no software bugs), inserting dm-crypt
> anywhere in the stack will not make a difference at all even when there
> is a crash. Thus...

Most sense to me made dm-crypt between bcache and btrfs. And that
works fine I can say. Actually, I have been using the following since
kernel 4.4.0-rc4 was there:
rawdevice + bcache + iscsi + dm-crypt + btrfs

This way, the IP link transports encrypted data (although it is only a
local short ethernetcable+switch). It works fine, scrubs are still
with 0 errors and the last btrfs check did not report any errors.
(It also works well with AoE, top perfomance after I put MTU's to 9000 )

>> 2. Which order of stacking is exhibiting bugs?
>
> ..indeed becomes the important question. Now if only someone had an
> answer :-).
