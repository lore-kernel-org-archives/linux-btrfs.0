Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726981AbeHUT0m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 15:26:42 -0400
Date: Tue, 21 Aug 2018 18:05:47 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: lazytime mount =?utf-8?B?b3B0aW9u4oCU?= =?utf-8?Q?no?= support
 in Btrfs
Message-ID: <20180821160547.GF24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ompef3$sim$1@blaine.gmane.org>
 <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
 <2641568.fxl50hTsRH@merkaba>
 <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
 <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com>
 <20180821120636.fatftem5qbhv22m4@angband.pl>
 <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
 <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
 <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 10:10:04AM -0400, Austin S. Hemmelgarn wrote:
> On 2018-08-21 09:32, Janos Toth F. wrote:
> >>>> so pretty much everyone who wants to avoid the overhead from them can just
> >>>> use the `noatime` mount option.
> > 
> > It would be great if someone finally fixed this old bug then:
> > https://bugzilla.kernel.org/show_bug.cgi?id=61601
> > Until then, it seems practically impossible to use both noatime (this
> > can't be added as rootflag in the command line and won't apply if the
> > kernel already mounted the root as RW) and space-cache-v2 (has to be
> > added as a rootflag along with RW to take effect) for the root
> > filesystem (at least without an init*fs, which I never use, so can't
> > tell).
> > 
> Last I knew, it was fixed.  Of course, it's been quite a while since I 
> last tried this, as I run locally patched kernels that have `noatime` as 
> the default instead of `relatime`.

I'm using VMs without initrd, tested the rootflags=noatime and it still
fails, the same way as in the bugreport.

As the 'noatime' mount option is part of the mount(2) API (passed as a
bit via mountflags), the remaining option in the filesystem is to
whitelist the generic options and ignore them. But this brings some
layering violation question.

On the other hand, this would be come confusing as the user expectation
is to see the effects of 'noatime'.
