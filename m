Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55883 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814AbaH0XeK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 19:34:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XMmjA-0001ZX-E4
	for linux-btrfs@vger.kernel.org; Thu, 28 Aug 2014 01:34:08 +0200
Received: from pd953eff5.dip0.t-ipconnect.de ([217.83.239.245])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 01:34:08 +0200
Received: from holger.hoffstaette by pd953eff5.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 01:34:08 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: fallocate fail on btrfs
Date: Wed, 27 Aug 2014 23:33:55 +0000 (UTC)
Message-ID: <pan.2014.08.27.23.33.55@googlemail.com>
References: <CADw2B2PYPJdcLWvkufY71kvAdCdgXhsdO2Gizf8hXAruppxXPA@mail.gmail.com>
	<pan$427a1$f65bd1f8$7ddfd94c$6b06de1b@cox.net>
	<CADw2B2NX8XY3V_vD-7eN9vj0tHtEfJwdsS4bovQ0cOHus_9Q-g@mail.gmail.com>
	<CADw2B2MJS-pkd+XfwLTpq_pqzQzLWnkzxLcaw8UYjnS-jOF25g@mail.gmail.com>
	<CADw2B2M3+M6-W-bqyQNYXLX4ug0=t9kNOp320UU3G2iN-CGbHQ@mail.gmail.com>
	<CADw2B2MmR41K3_qEeHUg0ZQAEojK4T3PTFUeUQxLLxsEiEa8_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 27 Aug 2014 15:58:49 -0700, G. Richard Bellamy wrote:

> [..snip..]

I can use fallocate on btrfs as you tried in your first post, with or 
without --keep-size, and it does the right things without errors. Running 
kernel 3.14+ (patched btrfs), util-linux-2.24.2 on Gentoo.

> There are two things going wrong here.
> 
> 1. The "open" command fallocate is using isn't passing along the O_CREAT
> flag properly.
> https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/sys-
> utils/fallocate.c#n368
> CODE: fd = open(filename, O_RDWR | (!dig && !mode ? O_CREAT : 0), 0644);
> STRACE: open("test.test", O_RDWR) = -1 ENOENT (No such file or
> directory)

When you have fallocate.c open in cgit, go to its log and you will find a 
recent commit:

https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/sys-
utils/fallocate.c?id=575718a04aa0c053875041dc387e360f2dcaa70d

aka: "fallocate: use O_CREAT only for the default behavior"

Seems to me you need to downgrade util-linux and/or complain to the util-
linux folks. In fact downgrade util-linux first (cfdisk in 2.25 eats 
partitions) and try fallocate again on whatever kernel you have running, 
just to rule out btrfs.

-h

