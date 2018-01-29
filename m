Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42538 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbeA2LY7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 06:24:59 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1eg7YW-0005rR-Pf
        for linux-btrfs@vger.kernel.org; Mon, 29 Jan 2018 12:24:56 +0100
Date: Mon, 29 Jan 2018 12:24:56 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
References: <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180129085404.GA2500@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 09:54:04AM +0100, Tomasz Pala wrote:
> On Sun, Jan 28, 2018 at 17:00:46 -0700, Chris Murphy wrote:
> 
> > systemd can't possibly need to know more information than a person
> > does in the exact same situation in order to do the right thing. No
> > human would wait 10 minutes, let alone literally the heat death of the
> > planet for "all devices have appeared" but systemd will. And it does
> 
> We're already repeating - systemd waits for THE btrfs-compound-device,
> not ALL the block-devices.

Because there is NO compound device.  You can't wait for something that
doesn't exist.  The user wants a filesystem, not some mythical compound
device, and as knowing whether we have enough requires doing most of mount
work, we can as well complete the mount instead of backing off and
reporting, so you can then racily repeat the work.

> Just like it 'waits' for someone to plug USB pendrive in.

Plugging an USB pendrive is an event -- there's no user request.  On the
other hand, we already know we want to mount -- the user requested so either
by booting ("please mount everything in fstab") or by an explicit mount
command.

So any event (the user's request) has already happened.  A rc system, of
which systemd is one, knows whether we reached the "want root filesystem" or
"want secondary filesystems" stage.  Once you're there, you can issue the
mount() call and let the kernel do the work.

> It is a btrfs choice to not expose compound device as separate one (like
> every other device manager does)

Btrfs is not a device manager, it's a filesystem.

> it is a btrfs drawback that doesn't provice anything else except for this
> IOCTL with it's logic

How can it provide you with something it doesn't yet have?  If you want the
information, call mount().  And as others in this thread have mentioned,
what, pray tell, would you want to know "would a mount succeed?" for if you
don't want to mount?

> it is a btrfs drawback that there is nothing to push assembling into "OK,
> going degraded" state

The way to do so is to timeout, then retry with -o degraded.

> I've told already - pretend the /dev/sda1 device doesn't
> exist until assembled.

It does... you're confusing a block device (a _part_ of the filesystem) with
the filesystem itself.  MD takes a bunch of such block devices and provides
you with another block devices, btrfs takes a bunch of block devices and
provides you with a filesystem.

> If this overlapping usage was designed with 'easier mounting' on mind,
> this is simply bad design.

No other rc system but systemd has a problem.

> > that by its own choice, its own policy. That's the complaint. It's
> > choosing to do something a person wouldn't do, given identical
> > available information.
> 
> You are expecting systemd to mix in functions of kernel and udev.
> There is NO concept of 'assembled stuff' in systemd AT ALL.
> There is NO concept of 'waiting' in udev AT ALL.
> If you want to do some crazy interlayer shortcuts just implement btrfsd.

No, I don't want systemd, or any userspace daemon, to try knowing kernel
stuff better than the kernel.  Just call mount(), and that's it.

Let me explain via a car analogy.  There is a flood that covers many roads,
the phone network is unreliable, and you want to drive to help relatives at
place X.

You can ask someone who was there yesterday how to get there (ie, ask a
device; it can tell you "when I was a part of the filesystem last time, its
layout was such and such").  Usually, this is reliable (you don't reshape an
array every day), but if there's flooding (you're contemplating a degraded
mount), yesterday's data being stale shouldn't be a surprise.

So, you climb into the car and drive.  It's possible that the road you
wanted to take has changed, it's also possible some other roads you didn't
even know about are now driveable.  Once you have X in sight, do you retrace
all the way home, tell your mom (systemd) who's worrying but has no way to
help, that the road is clear, and only then get to X?  Or do you stop,
search for a spot with working phone coverage to phone mom asking for
advice, despite her having no informations you don't have?  The reasonable
thing to do (and what all other rc systems do) is to get to X, help the
relatives, and only then tell mom that all is ok.

But with mom wanting to control everything, things can go worse.  If you,
without mom's prior knowledge (the user typed "mount" by hand) manage to
find a side road to X, she shouldn't tell you "I hear you telling me you're
at X -- as the road is flooded, that's impossible, so get home this instant"
(ie, systemd thinking the filesystem not being complete, despite it being
already mounted).

> > There's nothing the kernel is doing that's
> > telling systemd to wait for goddamn ever.
> 
> There's nothing the kernel is doing that's
> telling udev there IS a degraded device assembled to be used.

Because there is no device.

> There's nothing a userspace-thing is doing that's
> telling udev to mark degraded device as mountable.
> 
> There is NO DEVICE to be mounted, so systemd doesn't mount it.
> 
> The difference is:
> 
> YOU think that sda1 device is ephemeral, as it's covered by sda1 btrfs
> device that COULD BE mounted.

sda1 is there, it's not ephemeral.  You also shouldn't label filesystems by
whatever device was used for the initial mount, as this can change at
runtime -- and, if it does change, it's likely the admin will reuse sda1
for something else -- perhaps another btrfs filesystem.

> Just don't expect people will break their code with broken designs just
> to overcome your own limitations. If you want systemd to mount degraded
> btrfs volume, just MAKE IT REGISTER in the system.

Sorry but my crystal ball is broken.  I don't know whether the mount will
succeed yet.  And per the car analogy above, it's pointless to go back and
report that the device is mountable, if all we care about is to mount it.

> So for the last time: nobody will break his own code to patch missing
> code from other (actively maintained) subsystem.

I expect that a rc system doesn't get nosy trying to know things it has no
reason to know about.  All other rc systems don't care, why should systemd
be different?

> If you expect degraded mounts, there are 2 choices:
> 
> 1. implement degraded STATE _some_where_ - udev would handle falling
>    back to degraded mount after specified timeout,

STATE of what?  The filesystem doesn't exist yet.

> 2. change this IOCTL to _always_ return 1 - udev would register any
>    btrfs device, but you will get random behaviour of mounting
>    degraded/populated. But you should expect that since there is no
>    concept of any state below.

If the ioctl, which has only a vague guess, doesn't do what you want, don't
call it.  As it's btrfs specific already, there's no special casing on your
part.

> Actually, this is ridiculous - you expect the degradation to be handled
> in some 3rd party software?! In init system? With the only thing you got
> is 'degraded' mount option?!
> What next - moving MD and LVM logic into systemd?

It's not init system's job.  So it shouldn't try to micromanage, but just
mount().

> This is not systemd's job - there are
> btrfs-specific kernel cmdline options to be parsed (allowing degraded
> volumes), there is tracking of volume health required.
> Yes, device-manager needs to track it's components, RAID controller
> needs to track minimum required redundancy. It's not only about
> mounting. But doing the degraded mounting is easy, only this one
> particular ioctl needs to be fixed:
> 
> 1. counted devices<all	=> not_ready

Count is unreliable.  It usually gives a good answer, but if you're
contemplating mounting degraded, this is precisely the case it might be
wrong.

> 2. counted devices<all BUT
> - 'go degraded' received from userspace or kernel cmdline OR
> - volume IS mounted and doesn't report errors (i.e. mount -o degraded
>   DID succeeded)	=> ok_degraded

Then you don't want that ioctl, but mount().  And what would you even want
to use that hypothetical "ok_degraded" state for?

> 3. counted devices==all => ok
> 
> 
> If btrfs DISTINGUISHES these two states, systemd would be able to use them.

As per the car analogy above, mom doesn't need to know whether all roads
were dry, merely whether you are at the relatives' house.  The filesystem
either is mounted or it isn't.

> You might ask why this is important for the state to be kept inside some
> btrfs-related stuff, like kernel or btrfsd, while the systemd timer
> could do the same and 'just mount degraded'. The answear is simple:
> systemd.timer is just a sane default CONFIGURATION, that can be EASILY
> changed by system administrator. But somewhere, sometime, someone would
> have a NEED for totally different set of rules for handling degraded
> volumes, just like MD or LVM does. This would be totally irresponsible
> to hardcode any mount-degraded rule inside systemd itself.

It's not rocket science to edit an init script if knobs it exposes are not
configurable enough for your needs.  If systemd decides to hide this
functionality, it needs to provide the admin with some way to override.

We're talking about issuing a mount call, it's not _that_ complicated.

> That is exactly why this must go through the udev - udev is responsible
> for handling devices in Linux world. How can I register btrfs device
> in udev, since it's overlapping the block device? I can't - the ioctl
> is one-way, doesn't accept any userspace feedback.

But there's no device to register.  There's a filesystem, and those do have
a well-defined interface: they appear in /proc/mounts and a bunch of other
places.  That cow is not a duck, so it shouldn't quack.  ext4 or xfs don't
quack either, and no one considers them buggy for not quacking.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ The bill with 3 years prison for mentioning Polish concentration
⣾⠁⢰⠒⠀⣿⡁ camps is back.  What about KL Warschau (operating until 1956)?
⢿⡄⠘⠷⠚⠋⠀ Zgoda?  Łambinowice?  Most ex-German KLs?  If those were "soviet
⠈⠳⣄⠀⠀⠀⠀ puppets", Bereza Kartuska?  Sikorski's camps in UK (thanks Brits!)?
