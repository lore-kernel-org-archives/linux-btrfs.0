Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:41034 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965506AbeF1ORd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 10:17:33 -0400
Message-ID: <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Date: Thu, 28 Jun 2018 16:17:29 +0200
In-Reply-To: <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
         <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2018-06-28 at 22:09 +0800, Qu Wenruo wrote:
> > [   72.168662] WARNING: CPU: 0 PID: 242 at /build/linux-
> > uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565
> > btrfs_update_device+0x1b2/0x1c0It
> looks like it's the old WARN_ON() for unaligned device size.
> Would you please verify if it is the case?

# blockdev --getsize64 /dev/sdb2 /dev/sda2
999131127296
999131127296


Since getsize64 returns bytes and not sectors, I suppose it would need
to be aligned to 1024 by the least?

999131127296 / 1024 = 975713991,5

So it's not.


> If so, "btrfs rescue fix-device-size" should handle it pretty well.

I guess this needs to be done with the fs unmounted?
Anything to consider since I have RAID1 (except from running it on both
devices)?


Also, it's a bit strange that this error occurred never before (though
the btrfs-restore manpage says the kernel would check for this since
4.11).

It would further be nice if btrfs-check would warn about this.


Thanks,
Chris.
