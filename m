Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48428 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753149AbeGBReq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 13:34:46 -0400
Date: Mon, 2 Jul 2018 10:34:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Message-ID: <20180702173438.7c2vhflvtncfb5gz@merlins.org>
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <20180702151853.mwlrinipbihq46zu@merlins.org>
 <e8e78a5b-1db2-ddf0-f8ea-38f8ac9be654@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e8e78a5b-1db2-ddf0-f8ea-38f8ac9be654@gmail.com>
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 12:59:02PM -0400, Austin S. Hemmelgarn wrote:
> > Am I supposed to put LVM thin volumes underneath so that I can share
> > the same single 10TB raid5?
>
> Actually, because of the online resize ability in BTRFS, you don't
> technically _need_ to use thin provisioning here.  It makes the maintenance
> a bit easier, but it also adds a much more complicated layer of indirection
> than just doing regular volumes.

You're right that I can use btrfs resize, but then I still need an LVM
device underneath, correct?
So, if I have 10 backup targets, I need 10 LVM LVs, I give them 10%
each of the full size available (as a guess), and then I'd have to 
- btrfs resize down one that's bigger than I need
- LVM shrink the LV
- LVM grow the other LV
- LVM resize up the other btrfs

and I think LVM resize and btrfs resize are not linked so I have to do
them separately and hope to type the right numbers each time, correct?
(or is that easier now?)

I kind of linked the thin provisioning idea because it's hands off,
which is appealing. Any reason against it?

> You could (in theory) merge the LVM and software RAID5 layers, though that
> may make handling of the RAID5 layer a bit complicated if you choose to use
> thin provisioning (for some reason, LVM is unable to do on-line checks and
> rebuilds of RAID arrays that are acting as thin pool data or metadata).
 
Does LVM do built in raid5 now? Is it as good/trustworthy as mdadm
radi5?
But yeah, if it's incompatible with thin provisioning, it's not that
useful.

> Alternatively, you could increase your array size, remove the software RAID
> layer, and switch to using BTRFS in raid10 mode so that you could eliminate
> one of the layers, though that would probably reduce the effectiveness of
> bcache (you might want to get a bigger cache device if you do this).

Sadly that won't work. I have more data than will fit on raid10

Thanks for your suggestions though.
Still need to read up on whether I should do thin provisioning, or not.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
