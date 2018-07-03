Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sy3aus01on0063.outbound.protection.outlook.com ([104.47.117.63]:44096
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751776AbeGCE0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 00:26:41 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: how to best segment a big block device in resizeable btrfs
 filesystems?
Date: Tue, 3 Jul 2018 04:26:37 +0000
Message-ID: <MEXPR01MB12086D9C06E08053398B0F5B9E420@MEXPR01MB1208.ausprd01.prod.outlook.com>
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <20180702151853.mwlrinipbihq46zu@merlins.org>
 <MEXPR01MB12088F15449EA6CCC6FDDA0D9E420@MEXPR01MB1208.ausprd01.prod.outlook.com>
 <20180703040650.GG5567@merlins.org>
In-Reply-To: <20180703040650.GG5567@merlins.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: Marc MERLIN <marc@merlins.org>
> Sent: Tuesday, 3 July 2018 2:07 PM
> To: Paul Jones <paul@pauljones.id.au>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: how to best segment a big block device in resizeable btrfs
> filesystems?
> 
> On Tue, Jul 03, 2018 at 12:51:30AM +0000, Paul Jones wrote:
> > You could combine bcache and lvm if you are happy to use dm-cache
> instead (which lvm uses).
> > I use it myself (but without thin provisioning) and it works well.
> 
> Interesting point. So, I used to use lvm and then lvm2 many years ago until I
> got tired with its performance, especially as asoon as I took even a single
> snapshot.
> But that was a long time ago now, just saying that I'm a bit rusty on LVM
> itself.
> 
> That being said, if I have
> raid5
> dm-cache
> dm-crypt
> dm-thin
> 
> That's still 4 block layers under btrfs.
> Am I any better off using dm-cache instead of bcache, my understanding is
> that it only replaces one block layer with another one and one codebase with
> another.

True, I didn't think of it like that.

> Mmmh, a bit of reading shows that dm-cache is now used as lvmcache, which
> might change things, or not.
> I'll admit that setting up and maintaining bcache is a bit of a pain, I only used it
> at the time because it seemed more ready then, but we're a few years later
> now.
> 
> So, what do you recommend nowadays, assuming you've used both?
> (given that it's literally going to take days to recreate my array, I'd rather do it
> once and the right way the first time :) )

I don't have any experience with this, but since it's the internet let me tell you how I'd do it anyway ğŸ˜
raid5
dm-crypt
lvm (using thin provisioning + cache)
btrfs

The cache mode on lvm requires you to set up all your volumes first, then add caching to those volumes last. If you need to modify the volume then you have to remove the cache, make your changes, then re-add the cache. It sounds like a pain, but having the cache separate from the data is quite handy.
Given you are running a backup server I don't think the cache would really do much unless you enable writeback mode. If you can split up your filesystem a bit to the point that btrfs check doesn't OOM that will seriously help performance as well. Rsync might be feasible again.

Paul.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
