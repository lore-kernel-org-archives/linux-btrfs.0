Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:51128 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaFOWWR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 18:22:17 -0400
Date: Mon, 16 Jun 2014 00:13:07 +0200
From: Lennart Poettering <lennart@poettering.net>
To: kreijack@inwind.it
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Message-ID: <20140615221307.GE24386@tango.0pointer.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
 <pan$22693$6b452195$976b783a$e4956372@cox.net>
 <20140612232453.GR9508@dastard>
 <539B78F3.9070607@libero.it>
 <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
 <539BFF47.8060006@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <539BFF47.8060006@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 14.06.14 09:52, Goffredo Baroncelli (kreijack@libero.it) wrote:

> > Which effectively means that by the time the 8 MiB is filled, each 4 KiB 
> > block has been rewritten to a new location and is now an extent unto 
> > itself.  So now that 8 MiB is composed of 2048 new extents, each one a 
> > single 4 KiB block in size.
> 
> Several people pointed fallocate as the problem. But I don't
> understand the reason.

BTW, the reason we use fallocate() in journald is not about trying to
optimize anything. It's only used for one reason: to avoid SIGBUS on
disk/quota full, since we actually write everything to the files using
mmap(). I mean, writing things with mmap() is always problematic, and
handling write errors is awfully difficult, but at least two of the most
common reasons for failure we'd like protect against in advance, under
the assumption that disk/quota full will be reported immediately by the
fallocate(), and the mmap writes later on will then necessarily succeed.

I am not really following though why this trips up btrfs though. I am
not sure I understand why this breaks btrfs COW behaviour. I mean,
fallocate() isn't necessarily supposed to write anything really, it's
mostly about allocating disk space in advance. I would claim that
journald's usage of it is very much within the entire reason why it
exists...

Anyway, happy to change these things around if necesary, but first I'd
like to have a very good explanation why fallocate() wouldn't be the
right thing to invoke here, and a suggestion what we should do instead
to cover this usecase...

Lennart

-- 
Lennart Poettering, Red Hat
