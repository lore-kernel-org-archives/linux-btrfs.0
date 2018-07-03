Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40956 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeGCEGw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 00:06:52 -0400
Date: Mon, 2 Jul 2018 21:06:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Paul Jones <paul@pauljones.id.au>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: how to best segment a big block device in resizeable btrfs filesystems?
Message-ID: <20180703040650.GG5567@merlins.org>
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com> <20180629064354.kbaepro5ccmm6lkn@merlins.org> <20180701232202.vehg7amgyvz3hpxc@merlins.org> <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com> <20180702032259.GD5567@merlins.org> <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com> <20180702140527.wfbq5jenm67fvvjg@merlins.org> <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com> <20180702151853.mwlrinipbihq46zu@merlins.org> <MEXPR01MB12088F15449EA6CCC6FDDA0D9E420@MEXPR01MB1208.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <MEXPR01MB12088F15449EA6CCC6FDDA0D9E420@MEXPR01MB1208.ausprd01.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 12:51:30AM +0000, Paul Jones wrote:
> You could combine bcache and lvm if you are happy to use dm-cache instead (which lvm uses).
> I use it myself (but without thin provisioning) and it works well.

Interesting point. So, I used to use lvm and then lvm2 many years ago until
I got tired with its performance, especially as asoon as I took even a
single snapshot.
But that was a long time ago now, just saying that I'm a bit rusty on LVM
itself.

That being said, if I have
raid5
dm-cache
dm-crypt
dm-thin

That's still 4 block layers under btrfs.
Am I any better off using dm-cache instead of bcache, my understanding is
that it only replaces one block layer with another one and one codebase with
another.

Mmmh, a bit of reading shows that dm-cache is now used as lvmcache, which
might change things, or not.
I'll admit that setting up and maintaining bcache is a bit of a pain, I only
used it at the time because it seemed more ready then, but we're a few years
later now.

So, what do you recommend nowadays, assuming you've used both?
(given that it's literally going to take days to recreate my array, I'd
rather do it once and the right way the first time :) )

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
