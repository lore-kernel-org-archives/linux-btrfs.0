Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35367 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbcCFMBC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 07:01:02 -0500
Received: by mail-io0-f174.google.com with SMTP id g203so105377441iof.2
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 04:01:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160301162758.GA27786@carfax.org.uk>
References: <CAO2Nr8dqVBiOSTLxdS-E_WoKk13mJkGJ9PB7qOBDq-1YhHi-Gg@mail.gmail.com>
	<20160301162758.GA27786@carfax.org.uk>
Date: Sun, 6 Mar 2016 07:01:00 -0500
Message-ID: <CAGfcS_nXei2FszQz_-HoeOi04vhWw9YF3LKwd+2zRxmW1Wiupw@mail.gmail.com>
Subject: Re: btrfs raid
From: Rich Freeman <rich0@gentoo.org>
To: Hugo Mills <hugo@carfax.org.uk>,
        Carlos Ortega <carlos.omicron.ortega@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 1, 2016 at 11:27 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
>    Definitely don't use parity RAID on 3.19. It's not really something
> I'd trust, personally, even on 4.4, except for testing purposes.

++ - raid 5/6 are fairly unstable at this point.  Raid 1 should be just fine.

>    TBH, I wouldn't really want to be running something as old as 3.19
> either. The actual problems of running older kernels are, IME,
> considerably worse than the perceived problems of upgrading.

I think it depends on how you define "old."  I think that 3.18.28
would be fine as it is a supported longterm.  I've just upgraded to
the 4.1 series which I plan to track until a new longterm has been out
for a few months and things lok quiet.

3.19 is very problematic though, as it is no longer supported.  I'd
sooner "downgrade" to 3.18.28 (which likely has more btrfs backports
unless your distro handles them).  Or, upgrade to 4.1.19.

If you are using highly experimental features like raid5 support on
btrfs then bleeding-edge is probably better, but I've found I've had
the fewest issues sticking with the previous longterm.  I've been
bitten by a few btrfs regressions over the years and I think 3.19 was
actually around the time I got hit by one of them.  Since I've
switched to just staying on a longterm once it hits the x.x.15 version
or so I've found things to be much more reliable.

-- 
Rich
