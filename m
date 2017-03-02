Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:43614 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbdCBLWd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 06:22:33 -0500
Date: Thu, 2 Mar 2017 11:37:53 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: raid1 degraded mount still produce single chunks, writeable
 mount not allowed
Message-ID: <20170302103753.x35jhe7xgnwl6ee6@angband.pl>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 01, 2017 at 05:30:37PM -0700, Chris Murphy wrote:
> [1717713.408675] BTRFS warning (device dm-8): missing devices (1)
> exceeds the limit (0), writeable mount is not allowed
> [1717713.446453] BTRFS error (device dm-8): open_ctree failed
> 
> [chris@f25s ~]$ uname -r
> 4.9.8-200.fc25.x86_64
> 
> I thought this was fixed. I'm still getting a one time degraded rw
> mount, after that it's no longer allowed, which really doesn't make
> any sense because those single chunks are on the drive I'm trying to
> mount.

Well, there's Qu's patch at:
https://www.spinics.net/lists/linux-btrfs/msg47283.html
but it doesn't apply cleanly nor is easy to rebase to current kernels.

> I don't understand what problem this proscription is trying to
> avoid. If it's OK to mount rw,degraded once, then it's OK to allow it
> twice. If it's not OK twice, it's not OK once.

Well, yeah.  The current check is naive and wrong.  It does have a purpose,
just fails in this, very common, case.

For people needing to recover their filesystem at this moment there's
https://www.spinics.net/lists/linux-btrfs/msg62473.html
but it removes the protection you still want for other cases.

This problem pops up way too often, thus I guess that if not the devs, then
at least us in the peanut gallery should do the work reviving the real
solution.  Obviously, I for one am shortish on tuits at the moment...

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
