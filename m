Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35834 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeF2G7S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 02:59:18 -0400
Date: Thu, 28 Jun 2018 23:59:03 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20180629065903.xgwpvaa2vuiys75r@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 02:29:10PM +0800, Qu Wenruo wrote:
> > If --repair doesn't work, check is useless to me sadly.
> 
> Not exactly.
> Although it's time consuming, I have manually patched several users fs,
> which normally ends pretty well.
 
Ok I understand now.

> > Agreed, I doubt I have over or much over 100 snapshots though (but I
> > can't check right now).
> > Sadly I'm not allowed to mount even read only while check is running:
> > gargamel:~# mount -o ro /dev/mapper/dshelf2 /mnt/mnt2
> > mount: /dev/mapper/dshelf2 already mounted or /mnt/mnt2 busy

Ok, so I just checked now, 270 snapshots, but not because I'm crazy,
because I use btrfs send a lot :)

> This looks like super block corruption?
> 
> What about "btrfs inspect dump-super -fFa /dev/mapper/dshelf2"?

Sure, there you go: https://pastebin.com/uF1pHTsg

> And what about "skip_balance" mount option?
 
I have this in my fstab :)

> Another problem is, with so many snapshots, balance is also hugely
> slowed, thus I'm not 100% sure if it's really a hang.

I sent another thread about this last week, balance got hung after 2
days of doing nothing and just moving a single chunk.

Ok, I was able to remount the filesystem read only. I was wrong, I have
270 snapshots:
gargamel:/mnt/mnt# btrfs subvolume list . | grep -c 'path backup/'
74
gargamel:/mnt/mnt# btrfs subvolume list . | grep -c 'path backup-btrfssend/'
196

It's a backup server, I use btrfs send for many machines and for each btrs
send, I keep history, maybe 10 or so backups. So it adds up in the end.

Is btrfs unable to deal with this well enough?

> If for that usage, btrfs-restore would fit your use case more,
> Unfortunately it needs extra disk space and isn't good at restoring
> subvolume/snapshots.
> (Although it's much faster than repairing the possible corrupted extent
> tree)

It's a backup server, it only contains data from other machines.
If the filesystem cannot be recovered to a working state, I will need
over a week to restart the many btrfs send commands from many servers.
This is why anything other than --repair is useless ot me, I don't need
the data back, it's still on the original machines, I need the
filesystem to work again so that I don't waste a week recreating the
many btrfs send/receive relationships.

> > Is that possible at all?
> 
> At least for file recovery (fs tree repair), we have such behavior.
> 
> However, the problem you hit (and a lot of users hit) is all about
> extent tree repair, which doesn't even goes to file recovery.
> 
> All the hassle are in extent tree, and for extent tree, it's just good
> or bad. Any corruption in extent tree may lead to later bugs.
> The only way to avoid extent tree problems is to mount the fs RO.
> 
> So, I'm afraid it is at least impossible for recent years.

Understood, thanks for answering.

Does the pastebin help and is 270 snapshots ok enough?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
