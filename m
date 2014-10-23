Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47092 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750814AbaJWEaX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 00:30:23 -0400
Received: from 65-183-131-85-dhcp.burlingtontelecom.net ([65.183.131.85]:49233 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XhA2Y-003FXF-WE
	for linux-btrfs@vger.kernel.org; Wed, 22 Oct 2014 22:30:23 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20141022200812.GA17395@hungrycats.org>
Date: Thu, 23 Oct 2014 00:30:21 -0400
Message-Id: <01D3E7DE-5420-4C97-98C4-BB0414C4972E@colorremedies.com>
References: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com> <pan$66073$b8603a2$c915bfb9$cd573e99@cox.net> <20141022200812.GA17395@hungrycats.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 22, 2014, at 4:08 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:
> 
> If you have one subvolume per user and 1000 user directories on a server,
> it's only 5 snapshots per user (last hour, last day, last week, last
> month, and last year). 


Sure. So if Btrfs is meant to address scalability, then perhaps at the moment it's falling short. As it's easy to add large drives and get very large multiple device volumes, the snapshotting needs to scale also.

I'd say per user, it's reasonable to have 24 hourly (one snapshot per hour for a day), 7 daily, 4 weekly, and 12 monthly snapshots, or 47 snapshots. That's 47,000 snapshots if it's sane for a single Btrfs volume to host 1000 users. Arguably, such a system is better off with a distributed fs: Gluster FS or GFS2 or Ceph.



Chris Murphy

