Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41687 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbdGXVSX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 17:18:23 -0400
Date: Mon, 24 Jul 2017 23:17:58 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Cloud Admin <admin@cloud.haefemeier.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Best Practice: Add new device to RAID1 pool
Message-ID: <20170724211758.zhgzyk5p2zzkcbog@angband.pl>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
 <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
 <20170724204257.GJ7140@carfax.org.uk>
 <CAJCQCtTpdn0zNmogkbDr0h4RjNvb8u21w7Sj3xjUrj77A+ss8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTpdn0zNmogkbDr0h4RjNvb8u21w7Sj3xjUrj77A+ss8w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 02:55:00PM -0600, Chris Murphy wrote:
> Egads.
> 
> Maybe Cloud Admin ought to consider using a filter to just balance the
> data chunks across the three devices, and just leave the metadata on
> the original two disks?

Balancing when adding a new disk isn't that important unless the two old
disks are almost full.

> Maybe
> sudo btrfs balance start -dusage=100 <mp>

Note that this doesn't mean "all data", merely "all data chunks < 100%
full".  It's a strictly-lesser-than comparison.

You'd want "-dusage=101" which is illegal, the right one is "-d".  I used to
believe -dusage=100 does that, myself.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
