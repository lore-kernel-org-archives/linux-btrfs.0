Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41173 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756038AbdLPDVX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 22:21:23 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eQ32G-0006ns-77
        for linux-btrfs@vger.kernel.org; Sat, 16 Dec 2017 04:21:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: exclusive subvolume space missing
Date: Sat, 16 Dec 2017 03:21:04 +0000 (UTC)
Message-ID: <pan$daba3$1a46428e$8d941aa3$5ef253e8@cox.net>
References: <20171202012324.GB20205@polanet.pl>
        <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
        <20171202022153.GA7727@polanet.pl>
        <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
        <20171202093301.GA28256@polanet.pl>
        <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
        <20171210112738.GA24090@polanet.pl>
        <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
        <20171211114043.GA5097@polanet.pl>
        <7ea3ab01-eb63-4875-7496-a4ad833c5854@gmx.com>
        <20171215082214.GA13892@polanet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Pala posted on Fri, 15 Dec 2017 09:22:14 +0100 as excerpted:

> I wonder how this one db-library behaves:
> 
> $  find . -name \*.sqlite | xargs ls -gGhS | head -n1
> -rw-r--r-- 1  15M 2017-12-08 12:14
> ./.mozilla/firefox/vni9ojqi.default/extension-data/ublock0.sqlite
> 
> $  ~/fiemap ./.mozilla/firefox/*.default/extension-data/ublock0.sqlite |
> head -n1
> File ./.mozilla/firefox/vni9ojqi.default/extension-data/ublock0.sqlite
> has 128 extents:
> 
> 
> At least every $HOME/{.{,c}cache,tmp} should be +C...

Many admins will put tmp, and sometimes cache or selected parts of it, on 
tmpfs anyway... thereby both automatically clearing it on reboot, and 
allowing enforced size control as necessary.

>> And if possible, use nocow for this file.
> 
> Actually, this should be officially advised to use +C for entire /var
> tree and every other tree that might be exposed for hostile write
> patterns, like /home or /tmp (if held on btrfs).
> 
> I'd say, that from security point of view the nocow should be default,
> unless specified for mount or specific file... Currently, if I mount
> with nocow, there is no way to whitelist trusted users or secure
> location, and until btrfs-specific options could be handled per
> subvolume, there is really no alternative.

Nocow disables many reasons people run btrfs in the first place, 
including checksumming and damage-detection, with auto-repair from other 
copies where available (raid1/10 and dup modes primarily), as well as 
btrfs transparent compression, for users using that.  Additionally, 
snapshotting, another feature people use btrfs for, turns nocow into cow1 
(cow the first time a block is written after a snapshot), since 
snapshotting locks down the previous extent in ordered to maintain the 
snapshotted reference.

And given that any user can create a snapshot any time they want (even if 
you lock down the btrfs executable, if they're malevolent users and not 
locked to only running specifically whitelisted executables, they can 
always get a copy of the executable elsewhere), and /home or individual 
user subvols may well be auto-snapshotted already, setting nocow isn't 
likely to be of much security value at all.

So nocow is, as one regular wrote, most useful for "this really should go 
on something other than btrfs, but I'm too lazy to set it up that way and 
I'm already on btrfs, so the nocow band-aid is all I got.  And yes, I try 
using my screwdriver as a hammer too, because that's what I have there 
too!"

In that sort of case, just use some other filesystem more appropriate to 
the use-case, and you won't have to worry about btrfs issues, cow-
triggered or otherwise, in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

