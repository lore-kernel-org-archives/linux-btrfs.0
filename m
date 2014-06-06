Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34422 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaFFOC2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 10:02:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wsuiu-0004LQ-Hu
	for linux-btrfs@vger.kernel.org; Fri, 06 Jun 2014 16:02:24 +0200
Received: from p5b00772e.dip0.t-ipconnect.de ([91.0.119.46])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 16:02:24 +0200
Received: from holger.hoffstaette by p5b00772e.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 16:02:24 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: fix leaf corruption after __btrfs_drop_extents
Date: Fri, 6 Jun 2014 14:02:07 +0000 (UTC)
Message-ID: <pan.2014.06.06.14.02.07@googlemail.com>
References: <1402035958-30013-1-git-send-email-bo.li.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 06 Jun 2014 14:25:58 +0800, Liu Bo wrote:

> Several reports about leaf corruption has been floating on the list, one
> of them points to __btrfs_drop_extents(), and we find that the leaf
> becomes corrupted after __btrfs_drop_extents(), it's really a rare case
> but it does exist.

Out of curiosity ("..what could go wrong?" :) I applied this to 3.14.6, 
rebooted and worked a bit on my btrfs drive - rsyncs, create & delete 
snapshots etc. For the first time in ages I got two kernel messages:

Jun  6 09:20:56 tux kernel: BTRFS error (device sdb1): block group 
351872745472 has wrong amount of free space
Jun  6 09:20:56 tux kernel: BTRFS error (device sdb1): failed to load 
free space cache for block group 351872745472

I remounted without inode_cache & clear_cache, worked some more and so 
far no more messages. Could the messages be related to this patch? Or am 
I just looking at a coincidental/unrelated occurrence? Dropping the 
snapshots correctly freed up several GBs, so I assume that extents were 
dropped..

thanks
Holger

