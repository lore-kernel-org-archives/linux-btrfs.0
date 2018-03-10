Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50704 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbeCJIQL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 03:16:11 -0500
Date: Sat, 10 Mar 2018 09:16:06 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: zerofree btrfs support?
Message-ID: <20180310081606.7c2u2dtopijujhbz@angband.pl>
References: <1520650525.5641.47.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1520650525.5641.47.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 10, 2018 at 03:55:25AM +0100, Christoph Anton Mitterer wrote:
> Just wondered... was it ever planned (or is there some equivalent) to
> get support for btrfs in zerofree?

Do you want zerofree for thin storage optimization, or for security?

For the former, you can use fstrim; this is enough on any modern SSD; on HDD
you can rig the block device to simulate TRIM by writing zeroes.  I'm sure
one of dm-* can do this, if not -- should be easy to add, there's also
qemu-nbd which allows control over discard, but incurs a performance penalty
compared to playing with the block layer.

For zerofree for security, you'd need defrag (to dislodge partial pinned
extents) first, and do a full balance to avoid data left in metadata nodes
and in blocks beyond file ends (note that zerofree doesn't do this on
traditional filesystems either).


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
