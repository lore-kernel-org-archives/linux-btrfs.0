Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33125 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbcAYVVb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 16:21:31 -0500
Date: Mon, 25 Jan 2016 13:21:24 -0800
From: Marc MERLIN <marc@merlins.org>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <20160125212124.GL23751@merlins.org>
References: <20160123170354.GA10113@merlins.org>
 <56A57C59.1040203@cn.fujitsu.com>
 <20160125155541.GD23751@merlins.org>
 <CAL3q7H63tfdYgDppk9WUO6S8GQXk7F9d_MSE+DkVmjDP7oAtXg@mail.gmail.com>
 <20160125195608.GJ23751@merlins.org>
 <CAL3q7H5rj4j10d34Wm_RxVf1yj4kg0tabCEHQdJrL2LyWUorCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5rj4j10d34Wm_RxVf1yj4kg0tabCEHQdJrL2LyWUorCQ@mail.gmail.com>
Subject: Re: 4.4.0: btrfs-send BUG_ON(sctx->cur_ino !=
 sctx->cmp_key->objectid);
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 08:24:06PM +0000, Filipe Manana wrote:
> > The point is that my filesystem is damaged, but this is not a reason to
> > crash the kernel and the machine.
> 
> I've seen that happen on a non-damaged filesystem, for which I didn't
> get an image nor debug-tree's output before it got recreated. That's
> what I want to figure out, how/why it happened.
 
I'll see what I can do, this is going to take a lot of time on my end,
just before a trip and a system I have to bring back to working order
before I leave.

> > Can this be changed to an abort and remount read only instead?
> 
> Like many other bug_on's yes.

So, would you be able to first add the printk you requested to all
kernels since this info seems required for you to know more?
And then to change the BUG_ON into some kind of abort?
Crashing the kernel causes collateral damage, including getting the logs
you need to debug for many people without serial console :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
