Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:58290 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754789AbcITVon (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 17:44:43 -0400
Date: Tue, 20 Sep 2016 23:44:36 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: splat in split_leaf with integrity checking
Message-ID: <20160920214436.GA14662@angband.pl>
References: <20160920013927.GA17326@angband.pl>
 <20160920022146.GB28802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920022146.GB28802@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 07:21:47PM -0700, Liu Bo wrote:
> On Tue, Sep 20, 2016 at 03:39:27AM +0200, Adam Borowski wrote:
> > Hi!
> > I just had the following splat in 4.8-rc6 for the third time in a week:
> 
> Sorry for the trouble, this is caused by my patch and here are two fixes[1]
> to get it right with integrity check (not sure if they've been queued yet).
> 
> Here is a discussion that explains why we remove it[2].
> 
> [1] https://patchwork.kernel.org/patch/9320077/
>     https://patchwork.kernel.org/patch/9311541/
> 
> [2] http://www.spinics.net/lists/linux-btrfs/msg58506.html

Thanks!  I should have noticed these posts and not bother you; anyway, I've
applied the patches and stress-tested during the day, just in case they
break something.  All seems to work fine now -- and as I had a splat just
after posting this when copying that big file, and another during the kernel
compile, the bug would likely have triggered by now.


Meow!
-- 
Second "wet cat laying down on a powered-on box-less SoC on the desk" close
shave in a week.  Protect your ARMs, folks!
