Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42743 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753773AbdDOSux (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 14:50:53 -0400
Date: Sat, 15 Apr 2017 20:50:49 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <chris@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: remount and conflicting ssd options?
Message-ID: <20170415185049.ig65w5pi22d42ajm@angband.pl>
References: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
 <20170415183156.mmgm6t4rygm2mt3j@angband.pl>
 <CAJCQCtR3ZcyauCnJhDNp6rSFvnRWcNy2UsWJsbPJEyR+4tsiEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtR3ZcyauCnJhDNp6rSFvnRWcNy2UsWJsbPJEyR+4tsiEA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 15, 2017 at 12:41:14PM -0600, Chris Murphy wrote:
> On Sat, Apr 15, 2017 at 12:31 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> > On Sat, Apr 15, 2017 at 12:17:25PM -0600, Chris Murphy wrote:
> >> Then later I tried
> >>
> >> mount -o remount,ssd
> >>
> >> To go back to regular ssd option, but nothing happens, mount still
> >> shows ssd_spread.
> >
> > ssd_spread implies ssd.
> 
> OK so it's possible to remount from ssd to ssd_spread but not back to
> ssd? If I trust the mount output, it's only possible to transition
> from ssd to ssd_spread, but not from ssd_spread to ssd.

Yeah.  This is a very minor problem (workaround: remount with nossd then
ssd), but in the light of Hans van Kranenburg's findings, it'd be a bad idea
to introduce new mount options the kernel would need to keep recognizing
forever, as the effect of those options needs some rethinking anyways.

> >
> >> And then if I do
> >>
> >> mount -o remount,nossd
> >>
> >> I get the above mount output with nossd,ssd_spread options which would
> >> seem to be a contradiction. At least it's confusing. So... now what?
> >>
> >> kernel 4.10.8-200.fc25.x86_64
> >
> > Already fixed in mainline.  You need linus/master from literally today if
> > your time zone is between +1 and +3 (inclusively), adjust by one day
> > accordingly if not.
> >
> > Or cherry-pick 951e79663.
> 
> OK thanks.
> 
> Is this just fixing a mount bug? Or also with kernel messaging?

The NOSSD option actually does nothing except for preventing SSD from being
enabled, so switching ssd<->nossd was only a messaging issue; there was no
way to go ssd_spread->ssd, though.

> I see the enabling of ssd and spread, but I don't see a kernel message
> when unsetting them.  For the kernel messaging to be consistent, it'd need
> to always report a message when allocation strategy is being changed.

It's working correctly now.  You are told what the new strategy is, with no
mention of what the old one was.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
