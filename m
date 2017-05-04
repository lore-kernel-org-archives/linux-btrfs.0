Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39243 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932207AbdEDDzn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 23:55:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d67ra-0003Li-7D
        for linux-btrfs@vger.kernel.org; Thu, 04 May 2017 05:55:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
Date: Thu, 4 May 2017 03:55:28 +0000 (UTC)
Message-ID: <pan$d0afb$8cb8ad66$8322610b$459f2144@cox.net>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
        <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 03 May 2017 16:18:34 -0600 as excerpted:

> On Wed, May 3, 2017 at 2:28 PM, Alexandru Guzu <alexguzu@gmail.com>
> wrote:
> 
>> In a VirtualBox VM, I converted a EXT4 fs to BTRFS that is now running
>> on Ubuntu 16.04 (Kernel 4.4.0-72). I was able to use the system for
>> several weeks. I even did kernel updates, compression, deduplication
>> without issues.
> 
> Which version of btrfs-progs? The convert code was totally rewritten for
> btrfs-progs 4.6, and it has had a number of significant fixes since
> then. I'd say 4.8.2 is about the minimum I'd recommend. But if it were
> me I'd use the current release, 4.10.2.
> 
> But that alone may not fix it, I think you need a newer kernel...

Well, while the 4.4 LTS kernel series /is/ getting a bit long in the 
tooth by now, it's still the second newest LTS series available, 4.9 
being the newest.

And on-list we've long recommended staying within the latest two series 
in either the LTS or current kernel series, which means the 4.4 series 
should still be reasonably supported.  

So if there's a problem with his 4.4, it means one of three things:

a) We're regressing on our stability efforts and are no longer trying to 
support the second newest LTS kernel series.

I would hope not.  If so, it means we /are/ actually regressing in our 
stability efforts, as AFAIK we've been supporting the two latest LTS 
series since we formally peeled off the experimental label and started 
actually doing stable series backports in the 3.12-ish era.

OTOH, giving up on the penultimate LTS /would/ mean less backport and 
support hassles for anything older than the latest 4.9 LTS series, as we 
could simply tell people the same thing we're telling them about older 
versions now, that btrfs is under fast enough development and unstable 
enough that if they choose to run it, they really should try to stay 
reasonably current, and that they need to upgrade, and we can forget 
about it until/unless they do.

b) A recent patch that should have been marked for stable either wasn't, 
or is still in the stable queue.

This is certainly possible, tho along with most here I track current (or 
development), not LTS stable, and would be unlikely to know the status of 
stable backports.  This being the reality, perhaps we /should/ just give 
up on the second newest LTS.

This one's obviously the most worrying from the point of view of this 
list, assuming we /are/ still trying to support the 4.4 series as the 
penultimate LTS series available.

c) It's the still supported 4.4-LTS, but whatever his 4.4.0-72 converts 
to in upstream version numbers is behind the current release (4.4.66 ATM 
according to kernel.org) in one or more current btrfs stable-series 
patches.

That's something the poster would have to track down with his distro, 
since they obviously chose to use non-transparent versioning that doesn't 
correspond to upstream in that regard, so people not on that distro have 
little way of knowing without going the extra distance to attempt looking 
it up on the distro site (and why should they, the distro obviously chose 
non-transparency), and people /on/ the distro might be able to look it 
up, but probably won't know either unless they actually do, /because/ of 
that non-transparency choice.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

