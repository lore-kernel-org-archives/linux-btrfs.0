Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:53059 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdCCLxf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 06:53:35 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.88)
        (envelope-from <kilobyte@angband.pl>)
        id 1cjkD3-0002PK-TE
        for linux-btrfs@vger.kernel.org; Fri, 03 Mar 2017 11:13:13 +0100
Date: Fri, 3 Mar 2017 11:13:13 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: raid1 degraded mount still produce single chunks, writeable
 mount not allowed
Message-ID: <20170303101313.x4qlv4ddhal6vffl@angband.pl>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <20170302103753.x35jhe7xgnwl6ee6@angband.pl>
 <20170303065622.2a9a244e@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170303065622.2a9a244e@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 03, 2017 at 06:56:22AM +0100, Kai Krakow wrote:
> > > I don't understand what problem this proscription is trying to
> > > avoid. If it's OK to mount rw,degraded once, then it's OK to allow
> > > it twice. If it's not OK twice, it's not OK once.  
> > 
> > Well, yeah.  The current check is naive and wrong.  It does have a
> > purpose, just fails in this, very common, case.
> 
> I guess the reasoning behind this is: Creating any more chunks on this
> drive will make raid1 chunks with only one copy. Adding another drive
> later will not replay the copies without user interaction. Is that true?
> 
> If yes, this may leave you with a mixed case of having a raid1 drive
> with some chunks not mirrored and some mirrored. When the other drives
> goes missing later, you are loosing data or even the whole filesystem
> although you were left with the (wrong) imagination of having a
> mirrored drive setup...

Ie, you want a degraded mount to create degraded raid1 chunks rather than
single ones?  Good idea, it would solve the most common case with least
surprise to the user.

But there are other scenarios where Qu's patch[-set] is needed.  For
example, if you try to convert a single-disk filesystem to raid1, yet the
new shiny disk you just added decides to remind you of words "infant
mortality" halfway during conversion.

Or, if you have degraded raid1 chunks and something bad happens during
recovery.  Having the required number of devices, despite passing the
current bogus check, doesn't mean you can continue.  Qu's patch checks
whether at least one copy of every chunk is present.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
