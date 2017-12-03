Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:51075 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdLCKru (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Dec 2017 05:47:50 -0500
Date: Sun, 3 Dec 2017 11:47:42 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171203104630.2brvt2a3lkf5m3ag@angband.pl>
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk>
 <20171202005338.GA20205@polanet.pl>
 <20171202162812.GA5324@polanet.pl>
 <20171202171819.GA4629@polanet.pl>
 <pan$4b81d$3ba1cf57$e9dd4e05$8cf6db12@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$4b81d$3ba1cf57$e9dd4e05$8cf6db12@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 03, 2017 at 01:45:45AM +0000, Duncan wrote:
> Tomasz Pala posted on Sat, 02 Dec 2017 18:18:19 +0100 as excerpted:
> >> I got ~500 small files (100-500 kB) updated partially in regular
> >> intervals:
> >> 
> >> # du -Lc **/*.rrd | tail -n1
> >> 105M    total
> 
> FWIW, I've no idea what rrd files, or rrdcached (from the grandparent post)
> are (other than that a quick google suggests that it's...
> round-robin-database...

Basically: preallocate a file, its size doesn't change since then.  Every a
few minutes, write several bytes into the file, slowly advancing.

This is indeed the worst possible case for btrfs, and nocow doesn't help the
slightest as the database doesn't wrap around before a typical snapshot
interval.

> Meanwhile, /because/ nocow has these complexities along with others (nocow
> automatically turns off data checksumming and compression for the files
> too), and the fact that they nullify some of the big reasons people might
> choose btrfs in the first place, I actually don't recommend setting
> nocow in the first place -- if usage is such than a file needs nocow,
> my thinking is that btrfs isn't a particularly good hosting choice for
> that file in the first place, a more traditional rewrite-in-place
> filesystem is likely to be a better fit.

I'd say that the only good use for nocow is "I wish I have placed this file
on a non-btrfs, but it'd be too much hassle to repartition".

If you snapshot nocow at all, you get the worst of both worlds.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ Mozilla's Hippocritic Oath: "Keep trackers off your trail"
⣾⠁⢰⠒⠀⣿⡁ blah blah evading "tracking technology" blah blah
⢿⡄⠘⠷⠚⠋⠀ "https://click.e.mozilla.org/?qs=e7bb0dcf14b1013fca3820..."
⠈⠳⣄⠀⠀⠀⠀ (same for all links)
