Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38118 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaEJJ0i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 05:26:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wj3Y9-00008z-Su
	for linux-btrfs@vger.kernel.org; Sat, 10 May 2014 11:26:33 +0200
Received: from ppp-93-104-20-164.dynamic.mnet-online.de ([93.104.20.164])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 May 2014 11:26:33 +0200
Received: from tom by ppp-93-104-20-164.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 May 2014 11:26:33 +0200
To: linux-btrfs@vger.kernel.org
From: Tom Kuther <tom@kuther.net>
Subject: Re: URGENT: my laptop's boot ssd btrfs crashed, what do you need off it?
Date: Sat, 10 May 2014 09:26:22 +0000 (UTC)
Message-ID: <loom.20140510T112209-573@post.gmane.org>
References: <20140507233959.GB11401@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN <marc <at> merlins.org> writes:

> 
> Details:
> My system didn't crash, but the filesystem went read only, and of course
> couldn't syslog the error.
> Thankfully I was saved by remote syslog which did work:
> 
> kernel: [545039.443412] ------------[ cut here ]------------
> kernel: [545039.443429] WARNING: CPU: 2 PID: 556 at fs/btrfs/inode.c:4927
btrfs_invalidate_inode

The same thing happened to me just right now. Also on my SSD, also at
"fs/btrfs/inode.c:4927 btrfs_invalidate_inode", also on 3.14.

Is this maybe the (in)famous snapshots bug that got fixed in 3.15?



