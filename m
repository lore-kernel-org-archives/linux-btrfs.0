Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:60562 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752831AbeA0Pid (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 10:38:33 -0500
Date: Sat, 27 Jan 2018 16:38:30 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: kreijack@inwind.it
Cc: Tomasz Pala <gotar@polanet.pl>,
        "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180127153830.drkujabq4iin6tw2@angband.pl>
References: <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <0df2d269-e442-d383-7b4b-bccdfcb7c608@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <0df2d269-e442-d383-7b4b-bccdfcb7c608@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 03:36:48PM +0100, Goffredo Baroncelli wrote:
> I think that the real problem relies that the mounting a btrfs filesystem
> cannot be a responsibility of systemd (or whichever rc-system). 
> Unfortunately in the past it was thought that it would be sufficient to
> assemble a devices list in the kernel, then issue a simple mount...

Yeah... every device that comes online may have its own idea what devices
are part of the filesystem.  There's also a quite separate question whether
we have enough chunks for a degraded mount (implemented by Qu), which
requires reading the chunk tree.

> In the past[*] I proposed a mount helper, which would perform all the
> device registering and mounting in degraded mode (depending by the
> option).  My idea is that all the policies should be placed only in one
> place.  Now some policies are in the kernel, some in udev, some in
> systemd...  It is a mess.  And if something goes wrong, you have to look
> to several logs to understand which/where is the problem..

Since most of the logic needs to be in the kernel anyway, I believe it'd be
best to keep as much as possible in the kernel, and let the userspace
request at most "try regular/degraded mount, block/don't block".  Anything
else would be duplicating functionality.

> I have to point out that there is not a sane default for mounting in
> degraded mode or not.  May be that now RAID1/10 are "mount-degraded"
> friendly, so it would be a sane default; but for other (raid5/6) I think
> that this is not mature enough.  And it is possible to exist hybrid
> filesystem (both RAID1/10 and RAID5/6)

Not yet: if one of the devices comes a bit late, btrfs won't let it into the
filesystem yet (patches to do so have been proposed), and if you run
degraded for even a moment, a very lengthy action is required.  That lengthy
action could be improved -- we can note the last generation when the raid
was complete[1], and scrub/balance only extents newer than that[2] -- but
that's a SMOC then SMOR, and I don't see volunteers yet.

Thus, auto-degrading without a hearty timeout first is currently sitting
strongly in the "do not want" land.

> Mounting in degraded mode would be better for a root filesystem, than a
> non-root one (think about remote machine)....

I for one use ext4-on-md for root, and btrfs raid for the actual data.  It's
not like production servers see much / churn anyway.


Meow!

[1]. Extra fun for raid6 (or possible future raid1×N where N>2 modes):
there's "fully complete", "degraded missing A", "degraded missing B",
"degraded missing A and B".

[2]. NOCOW extents would require an artificial generation bump upon writing
to whenever the level of degradeness changes.
-- 
⢀⣴⠾⠻⢶⣦⠀ The bill with 3 years prison for mentioning Polish concentration
⣾⠁⢰⠒⠀⣿⡁ camps is back.  What about KL Warschau (operating until 1956)?
⢿⡄⠘⠷⠚⠋⠀ Zgoda?  Łambinowice?  Most ex-German KLs?  If those were "soviet
⠈⠳⣄⠀⠀⠀⠀ puppets", Bereza Kartuska?  Sikorski's camps in UK (thanks Brits!)?
