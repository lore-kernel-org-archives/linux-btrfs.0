Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43972 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932194AbeGCFmS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 01:42:18 -0400
Date: Mon, 2 Jul 2018 22:42:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: Paul Jones <paul@pauljones.id.au>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: how to best segment a big block device in resizeable btrfs filesystems?
Message-ID: <20180703054216.GJ5567@merlins.org>
References: <20180701232202.vehg7amgyvz3hpxc@merlins.org> <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com> <20180702032259.GD5567@merlins.org> <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com> <20180702140527.wfbq5jenm67fvvjg@merlins.org> <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com> <20180702151853.mwlrinipbihq46zu@merlins.org> <MEXPR01MB12088F15449EA6CCC6FDDA0D9E420@MEXPR01MB1208.ausprd01.prod.outlook.com> <20180703040650.GG5567@merlins.org> <MEXPR01MB12086D9C06E08053398B0F5B9E420@MEXPR01MB1208.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <MEXPR01MB12086D9C06E08053398B0F5B9E420@MEXPR01MB1208.ausprd01.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 04:26:37AM +0000, Paul Jones wrote:
> I don't have any experience with this, but since it's the internet let me tell you how I'd do it anyway 😝

That's the spirit :)

> raid5
> dm-crypt
> lvm (using thin provisioning + cache)
> btrfs
> 
> The cache mode on lvm requires you to set up all your volumes first, then
> add caching to those volumes last. If you need to modify the volume then
> you have to remove the cache, make your changes, then re-add the cache. It
> sounds like a pain, but having the cache separate from the data is quite
> handy.

I'm ok enough with that.

> Given you are running a backup server I don't think the cache would
> really do much unless you enable writeback mode. If you can split up your
> filesystem a bit to the point that btrfs check doesn't OOM that will
> seriously help performance as well. Rsync might be feasible again.

I'm a bit warry of write caching with the issues I've had. I may do
write-through, but not writeback :)

But caching helps indeed for my older filesystems that are still backed up
via rsync because the source fs is ext4 and not btrfs.

Thanks for the suggestions
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
