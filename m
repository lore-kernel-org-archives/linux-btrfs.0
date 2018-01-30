Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:45114 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751805AbeA3Ngd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 08:36:33 -0500
Date: Tue, 30 Jan 2018 14:36:31 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130133631.GA23152@polanet.pl>
References: <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As I won't repeat myself, I've cut all the stuff I've already described
in detail before. Just read the previous mails.


On Mon, Jan 29, 2018 at 12:24:56 +0100, Adam Borowski wrote:

> How can it provide you with something it doesn't yet have?  If you want the
> information, call mount().  And as others in this thread have mentioned,
> what, pray tell, would you want to know "would a mount succeed?" for if you
> don't want to mount?

First of all I need the instruction: "SHOULD I TRY TO FORCE-MOUNT".

Don't you see the obvious difference between "following _environmental_
rules" and "reinventing the logic for every possible mounting initiator"?

>> it is a btrfs drawback that there is nothing to push assembling into "OK,
>> going degraded" state
> 
> The way to do so is to timeout, then retry with -o degraded.

There is no such logic in systemd core.
Systemd won't implement device-management and fallbacks.

You might just send the appropriate event for such request. I've already said how
to write such timer and how to implement fallback logic in udev/systemd
rules. systemd won't write units for every piece of software in the
wild. mdadm provides it's own rules (I gave links), LVN provides his,
so JUST WRITE THE RULES.

Then you'll see what's missing inside btrfs for them to be effective.

> It does... you're confusing a block device (a _part_ of the filesystem) with
> the filesystem itself.  MD takes a bunch of such block devices and provides
> you with another block devices, btrfs takes a bunch of block devices and
> provides you with a filesystem.

It cames with consequences. Described before, so ENOREPEAT.

>> If this overlapping usage was designed with 'easier mounting' on mind,
>> this is simply bad design.
> 
> No other rc system but systemd has a problem.

This statement is ultimately FALSE.
1. My SysV init didn't handle this - until being patched with btrfs-specific code,
2. SysV init systems in other distros didn't handle this - until being reworked in btrfs in mind,
3. my geninitrd doesn't handle this - noone was willing to write the ADDITIONAL btrfs-specific code,
4. dracut deesn't didn't handle this - at least without having extra code for btrfs case.

Systemd won't reimplement this in 5th, 10th, 20th place - there is a
SINGLE place that should implement state machine, just like this IS
handled by MD or LVM.

> No, I don't want systemd, or any userspace daemon, to try knowing kernel
> stuff better than the kernel.  Just call mount(), and that's it.

mount fails. Now it's YOUR job to retrigger degraded.

> Let me explain via a car analogy.  There is a flood that covers many roads,

Yeah, the great car analogies.
Do you have separate engine for every wheel?
Do you have separate break pedal for every wheel?
Do you have separate door opening logic (and different key) for every doors?

>> There's nothing the kernel is doing that's
>> telling udev there IS a degraded device assembled to be used.
> 
> Because there is no device.

I call it ephemeral device, you call it assembled volume, naming
convention doesn't matter. But easies understanding what others are
trying to explain to you.

>> YOU think that sda1 device is ephemeral, as it's covered by sda1 btrfs
>> device that COULD BE mounted.
> 
> sda1 is there, it's not ephemeral.

And after appearing it DOES NOT MOUNT. Quest failed. That's what's
happening.

>> So for the last time: nobody will break his own code to patch missing
>> code from other (actively maintained) subsystem.
> 
> I expect that a rc system doesn't get nosy trying to know things it has no
> reason to know about.  All other rc systems don't care, why should systemd
> be different?

All other rc systems fail miserably or have a tons of code repeating
functionality. How many rc systems were you involved in?

>> 1. implement degraded STATE _some_where_ - udev would handle falling
>>    back to degraded mount after specified timeout,
> 
> STATE of what?  The filesystem doesn't exist yet.

Paraphrasing you: how can I mount something that doesn't exist?

>> 2. change this IOCTL to _always_ return 1 - udev would register any
>>    btrfs device, but you will get random behaviour of mounting
>>    degraded/populated. But you should expect that since there is no
>>    concept of any state below.
> 
> If the ioctl, which has only a vague guess, doesn't do what you want, don't
> call it.  As it's btrfs specific already, there's no special casing on your
> part.

Without the "waiting for IOCTL OK response" btrfs mount would fail after
first device appears in system and mount happens before the next
components are available.

This COULD be done in systemd - provided there is some btrfsd that
retriggers mounting later (with or without degraded).

>> Actually, this is ridiculous - you expect the degradation to be handled
>> in some 3rd party software?! In init system? With the only thing you got
>> is 'degraded' mount option?!
>> What next - moving MD and LVM logic into systemd?
> 
> It's not init system's job.  So it shouldn't try to micromanage, but just
> mount().

As described above this would randomly fail for every multidevice setup.

You might either PREVENT race conditions (waiting for IOCTL), or make
these races irrevelant (by keeping track of components and retriggering
mounts).

Btrfs makes both impossible and expects systemd to implement it's own
logic.

>> 1. counted devices<all	=> not_ready
> 
> Count is unreliable.  It usually gives a good answer, but if you're
> contemplating mounting degraded, this is precisely the case it might be
> wrong.

Could you please respond after reading what's written below?

>> 2. counted devices<all BUT
>> - 'go degraded' received from userspace or kernel cmdline OR
>> - volume IS mounted and doesn't report errors (i.e. mount -o degraded
>>   DID succeeded)	=> ok_degraded
> 
> Then you don't want that ioctl, but mount().

There is no mount LOOP. mount() is called ONCE per device, if it fails,
then it is considered FAILED until REtriggered.

Just stop this flame and write 10 lines of retrigger rules. This would
greatly improve your comprehension of the problem.

> And what would you even want to use that hypothetical "ok_degraded" state for?

Could you just look into mdadm rules? This is obvious: for the same
purpose as mdadm invokes last-resort.

> It's not rocket science to edit an init script if knobs it exposes are not
> configurable enough for your needs. 

How many init scripts were you involved in?

> If systemd decides to hide this
> functionality, it needs to provide the admin with some way to override.

There is - udev roules and systemd units I've mentioned. Just use them.

> We're talking about issuing a mount call, it's not _that_ complicated.

So just do it! https://github.com/systemd/systemd

Please, go ahead with some PoC implementation, as this is REALLY hard to 
discuss init systems/scripts corner cases with someone that has
apparently never written a single line of such code.

-- 
Tomasz Pala <gotar@pld-linux.org>
