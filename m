Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:52731 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdHSCf2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 22:35:28 -0400
Date: Sat, 19 Aug 2017 04:35:26 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: =?iso-8859-1?Q?H=E9rikz?= Nawarro <herikz.nawarro@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Moving btrfs fs disk between computers
Message-ID: <20170819023526.wbhl2wydq4bw6u75@angband.pl>
References: <CAD6NJSwG7tJSnbpyGAT41r3Y7RqPe99YQAg2yGGbMRt=EO+o-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAD6NJSwG7tJSnbpyGAT41r3Y7RqPe99YQAg2yGGbMRt=EO+o-Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 11:09:22PM -0300, Hérikz Nawarro wrote:
> Hello everyone,
> 
> Can i create a btrfs fs in a machine and move the disk to another
> machine like a ext4 or ntfs?

Yeah, no problem whatsoever, even for multi-device filesystems.
Btrfs doesn't care about what devices it is on.

There has been no new incompat features in quite a while, so old kernels
shouldn't be an issue either.

I think the only way for valid btrfs to be unmountable on another machine
with a modern kernel is to mess with page size, which is AFAIK not even
possible on x86.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                        -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 
