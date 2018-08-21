Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:38622 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbeHUPhy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 11:37:54 -0400
Received: by mail-io0-f177.google.com with SMTP id y3-v6so10792491ioc.5
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 05:17:58 -0700 (PDT)
Subject: =?UTF-8?Q?Re:_lazytime_mount_option=e2=80=94no_support_in_Btrfs?=
To: Adam Borowski <kilobyte@angband.pl>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>, waxhead@dirtcellar.net,
        Adam Hunt <voxadam@gmail.com>, linux-btrfs@vger.kernel.org
References: <ompef3$sim$1@blaine.gmane.org>
 <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
 <2641568.fxl50hTsRH@merkaba> <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
 <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com>
 <20180821120636.fatftem5qbhv22m4@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
Date: Tue, 21 Aug 2018 08:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <20180821120636.fatftem5qbhv22m4@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-21 08:06, Adam Borowski wrote:
> On Mon, Aug 20, 2018 at 08:16:16AM -0400, Austin S. Hemmelgarn wrote:
>> Also, slightly OT, but atimes are not where the real benefit is here for
>> most people.  No sane software other than mutt uses atimes (and mutt's use
>> of them is not sane, but that's a different argument)
> 
> Right.  There are two competing forks of mutt: neomutt and vanilla:
> https://github.com/neomutt/neomutt/commit/816095bfdb72caafd8845e8fb28cbc8c6afc114f
> https://gitlab.com/dops/mutt/commit/489a1c394c29e4b12b705b62da413f322406326f
> 
> So this has already been taken care of.
> 
>> so pretty much everyone who wants to avoid the overhead from them can just
>> use the `noatime` mount option.
> 
> atime updates (including relatime) are bad not only for performance, they
> also explode disk size used by snapshots (btrfs, LVM, ...) -- to the tune of
> ~5% per snapshot for some non-crafted loads.  And, are bad for media with
> low write endurance (SD cards, as used by most SoCs).
> 
> Thus, atime needs to die.
> 
>> The real benefit for most people is with mtimes, for which there is no
>> other way to limit the impact they have on performance.
> 
> With btrfs, any write already triggers metadata update (except nocow), thus
> there's little benefit of lazytime for mtimes.
But does that actually propagate all the way up to the point of updating 
the inode itself?  If so, then yes, there is not really any point.  if 
not though, then there is still a benefit.
