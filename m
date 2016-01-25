Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60341 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbcAYT4Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 14:56:16 -0500
Date: Mon, 25 Jan 2016 11:56:08 -0800
From: Marc MERLIN <marc@merlins.org>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <20160125195608.GJ23751@merlins.org>
References: <20160123170354.GA10113@merlins.org>
 <56A57C59.1040203@cn.fujitsu.com>
 <20160125155541.GD23751@merlins.org>
 <CAL3q7H63tfdYgDppk9WUO6S8GQXk7F9d_MSE+DkVmjDP7oAtXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H63tfdYgDppk9WUO6S8GQXk7F9d_MSE+DkVmjDP7oAtXg@mail.gmail.com>
Subject: Re: 4.4.0: btrfs-send BUG_ON(sctx->cur_ino !=
 sctx->cmp_key->objectid);
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 07:46:52PM +0000, Filipe Manana wrote:
> On Mon, Jan 25, 2016 at 3:55 PM, Marc MERLIN <marc@merlins.org> wrote:
> > I still have 2 more days before I can rebuild my broken filesystem.
> > In the meantime, I just got this new error with 4.4
> 
> Nop, not new in 4.4. I have seen 1 report of someone hitting this with
> a 4.0 kernel in the past. Not a problem with send afaics but some
> inconsistent state achieved likely after adding/modifying/deleting a
> xattr.
> 
> Nothing new, just send the output of btrfs-debug-tree -t <parent
> snapshot id> and for the send snapshot too. Also in the function that
> triggered the BUG_ON(), add a printk like the following right before
> the BUG_ON() line:
> 
> if (sctx->cur_ino != sctx->cmp_key->objectid)
>     printk(KERN_ERR "sctx->cur_ino = %llu, sctx->cmp_key->objectid =
> %llu\n", sctx->cmp_key->objectid, sctx->cmp_key->objectid);
> 
> And see the result in dmesg/syslog.

Thanks for the reply.
I may not be able to reproduce this soon or at all because I'm about to
rebuild the damaged filesystem this happened on.

The point is that my filesystem is damaged, but this is not a reason to
crash the kernel and the machine.
Can this be changed to an abort and remount read only instead?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
