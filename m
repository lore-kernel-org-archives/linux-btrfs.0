Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60930 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbcAYUzI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 15:55:08 -0500
Date: Mon, 25 Jan 2016 12:55:00 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <20160125205500.GK23751@merlins.org>
References: <20160123170354.GA10113@merlins.org>
 <56A57C59.1040203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56A57C59.1040203@cn.fujitsu.com>
Subject: Re: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0,
 corrupt 189, gen 0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 09:37:29AM +0800, Qu Wenruo wrote:
> >+David, +Qu
> >about
> >1) kernel crash on BUG_ON
> 
> From your code mentioned, and your second kernel warning, it's out
> of memory.
> Such case also happened when I was debugging in-band de-dup patches.
 
Right. So it's obviously a bug since it's on a lightly loaded server
with 8GB of RAM, and this only started happeening after my FS started
having problems.

> Things seems that by some method, btrfs used a lot of memory for
> dirty page caches. Maybe metadata pages.
> 
> Normally when such case happens, VFS should trigger a sync to free
> dirty pages, but btrfs seems to either delayed the sync due to
> running trans or the VFS sync is already too late.
 
Oh, I see.

> But it's also possible that large leafsize is related to such problem.
> The larger leafsize is, the harder to alloc continuous memory for kmalloc().

So basically, we seem to understand how we get there, but not quite why,
or how to fix it, correct?

> If you're using old version btrfsck, then it's possible such error
> is a false alert. Update btrfsck and try again is a good idea.
 
I had 4.3 as the latest in debian unstable, but now I see 4.4 just came
out, so I installed it.

> Even if it's not a false alert, mail list says it shouldn't cause
> huge problem, only known problems happens is related to scrub.
> And there is already some user reporting balance can fix it,
> although you need to balance all chunks.

Thanks for that tip.
 
> >3) say more about "root 45948 inode 204452 errors 1000, some csum missing",
> >that they aren't being fixed, and whether they're a big deal or not.
> 
> Personally speaking, I didn't consider it as a big problem itself.
> If csum is missing/corrupted, btrfsck --init-csum-tree can rebuild it.

Any idea why check --repair isn't fixing them too, is that expected?

gargamel:~# btrfs --version
btrfs-progs v4.4
gargamel:~# btrfs check --repair --init-csum-tree -p /dev/mapper/dshelf1 2>&1  | tee check7
Reinit crc root
crc refilling failed   <<<< is that bad?
enabling repair mode
Creating a new CRC tree
Checking filesystem on /dev/mapper/dshelf1
UUID: 6358304a-2234-4243-b02d-4944c9af47d7

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
