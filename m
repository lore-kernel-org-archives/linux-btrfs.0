Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38112 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaIXWXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 18:23:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XWuyQ-0000iG-7A
	for linux-btrfs@vger.kernel.org; Thu, 25 Sep 2014 00:23:46 +0200
Received: from pd953e884.dip0.t-ipconnect.de ([217.83.232.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 00:23:46 +0200
Received: from holger.hoffstaette by pd953e884.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 00:23:46 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: 3.16 Managed to ENOSPC with <80% used
Date: Wed, 24 Sep 2014 22:23:33 +0000 (UTC)
Message-ID: <pan.2014.09.24.22.23.33@googlemail.com>
References: <CAPL5yKfTfzkqBT9dQBpJAjuBtq2-=QqdCn_Pzfnnd1URKA_q4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 24 Sep 2014 16:43:43 -0400, Dan Merillat wrote:

> Any idea how to recover?  I can't cut-paste but it's
> Total devices 1 FS bytes used 176.22GiB
> size 233.59GiB used 233.59GiB

The notorious -EBLOAT. But don't despair just yet.

> Basically it's been data allocation happy, since I haven't deleted
> 53GB at any point.  Unfortunately, none of the chunks are at 0% usage
> so a balance -dusage=0 finds nothing to drop.

Also try -musage=0..10, just for fun.

> Is this recoverable, or do I need to copy to another disk and back?

- if you have plenty RAM, make a big tmpfs (couple of GB), otherwise
  find some other storage to attach; any external drive is fine.

- else on tmpfs or spare fs:
  - fallocate --length <n>GiB <image>,
    where n: whatever you can spare and image: an arbitrary filename
  - losetup /dev/loop0 </path/to/image>

- btrfs device add /dev/loop0 <your hosed mountpoint>

You now have more unused space to fill up. \o/

Delete snapshots, make clean/.tar.gz some of those trees and run
balance -dusage/-musage again.

Another neat trick that will free up space is to convert to single
metadata: -mconvert=single -f (to force). A subsequent balance
with -musage=0..10 will likely free up quite some space.

When you're back in calmer waters you can btrfs device remove whatever
you added. That should fill your main drive right back up. :)

> This is a really unfortunate failure mode for BTRFS.  Usually I catch
> it before I get exactly 100% used and can use a balance to get it back
> into shape.

For now all we can do is run balance -d/-m regularly.

> What causes it to keep allocating datablocks when it's got so much
> free space?  The workload is pretty standard (for devs, at least): git
> and kernel builds, and git and android builds.

That particular workload seems to cause the block allocator to go
on a spending spree; you're not the first to see this.

Good luck!

-h

