Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:44192 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbeIGTM0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 15:12:26 -0400
Date: Fri, 7 Sep 2018 16:31:07 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: dduper - Offline btrfs deduplication tool
Message-ID: <20180907143107.gsixosfbswlqcbly@angband.pl>
References: <20180824043139.GA8263@giis.co.in>
 <CAGqmi74eMiHe7HK_oueaj0JZmy1Kp1NoOCrU0yheEE8MjngLKA@mail.gmail.com>
 <20180907035728.GA7717@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180907035728.GA7717@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 09:27:28AM +0530, Lakshmipathi.G wrote:
> > One question:
> > Why not ioctl_fideduperange?
> > i.e. you kill most of benefits from that ioctl - atomicity.
> > 
> I plan to add fideduperange as an option too. User can
> choose between fideduperange and ficlonerange call.
> 
> If I'm not wrong, with fideduperange, kernel performs
> comparsion check before dedupe. And it will increase
> time to dedupe files.

You already read the files to md5sum them, so you have no speed gain.
You get nasty data-losing races, and risk collisions as well.  md5sum is
safe against random occurences (compared eg. to the chance of lightning
hitting you today), but is exploitable by a hostile user.  On the other
hand, full bit-to-bit comparison is faster and 100% safe.

You can't skip verification -- the checksums are only 32-bit.  They have a
1:4G chance to mismatch, which means you can expect one false positive with
64K extents, rising quadratically as the number of files grows.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
