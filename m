Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36902 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751594AbeF2H2f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 03:28:35 -0400
Date: Fri, 29 Jun 2018 00:28:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20180629072831.qocyipdvmcm6cbo7@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org>
 <6a86d5d5-1d67-f34b-f809-b4e534485f3e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6a86d5d5-1d67-f34b-f809-b4e534485f3e@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 03:20:42PM +0800, Qu Wenruo wrote:
> If certain btrfs specific operations are involved, it's definitely not OK:
> 1) Balance
> 2) Quota
> 3) Btrfs check

Ok, I understand. I'll try to balance almost never then. My problems did
indeed start because I ran balance and it got stuck 2 days with 0
progress.
That still seems like a bug though. I'm ok with slow, but stuck for 2
days with only 270 snapshots or so means there is a bug, or the
algorithm is so expensive that 270 snapshots could cause it to take days
or weeks to proceed?

> > It's a backup server, it only contains data from other machines.
> > If the filesystem cannot be recovered to a working state, I will need
> > over a week to restart the many btrfs send commands from many servers.
> > This is why anything other than --repair is useless ot me, I don't need
> > the data back, it's still on the original machines, I need the
> > filesystem to work again so that I don't waste a week recreating the
> > many btrfs send/receive relationships.
> 
> Now totally understand why you need to repair the fs.

I also understand that my use case is atypical :)
But I guess this also means that using btrfs for a lot of send/receive
on a backup server is not going to work well unfortunately :-/

Now I'm wondering if I'm the only person even doing this.

> > Does the pastebin help and is 270 snapshots ok enough?
> 
> The super dump doesn't show anything wrong.
> 
> So the problem may be in the super large extent tree.
> 
> In this case, plain check result with Su's patch would help more, other
> than the not so interesting super dump.

First I tried to mount with skip balance after the partial repair, and
it hung a long time:
[445635.716318] BTRFS info (device dm-2): disk space caching is enabled
[445635.736229] BTRFS info (device dm-2): has skinny extents
[445636.101999] BTRFS info (device dm-2): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[445825.053205] BTRFS info (device dm-2): enabling ssd optimizations
[446511.006588] BTRFS info (device dm-2): disk space caching is enabled
[446511.026737] BTRFS info (device dm-2): has skinny extents
[446511.325470] BTRFS info (device dm-2): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[446699.593501] BTRFS info (device dm-2): enabling ssd optimizations
[446964.077045] INFO: task btrfs-transacti:9211 blocked for more than 120 seconds.
[446964.099802]       Not tainted 4.17.2-amd64-preempt-sysrq-20180818 #3
[446964.120004] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

So, I rebooted, and will now run Su's btrfs check without repair and
report back.

Thanks both for your help.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
