Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:59572 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbdDID7h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 23:59:37 -0400
Date: Sun, 9 Apr 2017 05:58:54 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Icenowy Zheng <icenowy@aosc.io>, Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] btrfs: scrub: use do_div() for 64-by-32 division
Message-ID: <20170409035854.7swkcndswifd622w@angband.pl>
References: <CAOMZO5B9J15qvrsjOb-e5gk47gA=+2p2yLNLhswG+H3S0L7LXg@mail.gmail.com>
 <20170408210737.5456-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170408210737.5456-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 08, 2017 at 11:07:37PM +0200, Adam Borowski wrote:
> Unbreaks ARM and possibly other 32-bit architectures.

Turns out those "other 32-bit architectures" happen to include i386.

A modular build:

ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!

With the patch, i386 builds fine.

> Tested on amd64 where all is fine, and on arm (Odroid-U2) where scrub
> sometimes works, but, like most operations, randomly dies with some badness
> that doesn't look related: io_schedule, kunmap_high.  That badness wasn't
> there in 4.11-rc5, needs investigating, but since it's not connected to our
> issue at hand, I consider this patch sort-of tested.

Looks like current -next is pretty broken: while amd64 is ok, on an i386 box
(non-NX Pentium 4) it hangs very early during boot, way before filesystem
modules would be loaded.  Qemu boots but has random hangs.

So it looks like it's compile only for now...

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
