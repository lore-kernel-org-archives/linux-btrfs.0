Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57599 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaIYVWF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 17:22:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XXGUB-0000qx-6C
	for linux-btrfs@vger.kernel.org; Thu, 25 Sep 2014 23:21:59 +0200
Received: from pd953e787.dip0.t-ipconnect.de ([217.83.231.135])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 23:21:59 +0200
Received: from holger.hoffstaette by pd953e787.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 23:21:59 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: 3.16 Managed to ENOSPC with <80% used
Date: Thu, 25 Sep 2014 21:21:47 +0000 (UTC)
Message-ID: <pan.2014.09.25.21.21.47@googlemail.com>
References: <CAPL5yKfTfzkqBT9dQBpJAjuBtq2-=QqdCn_Pzfnnd1URKA_q4A@mail.gmail.com>
	<pan.2014.09.24.22.23.33@googlemail.com>
	<CAPL5yKdt7eTk-+0NP2Y9Aa8zNQqJpujTm31z_ee04OS3DocMXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 25 Sep 2014 17:05:11 -0400, Dan Merillat wrote:

> Deleting files or dropping snapshots is difficult when it's wedged as
> well, a lot of disk activity (journal thrash?) and no persistent
> progress - a reboot brigs the deleted files back.  I eventually
> managed to empty a single data chunk and after that it was a trivial
> recovery.

That's why I mentioned adding a second device - that will immediately
allow cleanup with headroom. An additional 8GB tmpfs volume can works
wonders.

>> That particular workload seems to cause the block allocator to go
>> on a spending spree; you're not the first to see this.
> 
> I could see normal-user usage patterns getting ignored, but this is
> the patterns of the people working on BTRFS.   Maybe they need to
> remove their balance cronjobs for a while. :)

Well..some remedy is coming:
https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/fs/btrfs?h=integration&id=47ab2a6c689913db23ccae38349714edf8365e0a

Not sure how many preliminaries that patch needs, but if you are
comfortable with patching/building your kernel you could give that
a try. I'm sure Josef would love some feedback.

Glad you're back on track. :)

Holger

