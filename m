Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49764 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab2FYO6k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 10:58:40 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1SjAkS-0007sD-Er
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 07:58:40 -0700
Date: Mon, 25 Jun 2012 07:58:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Knowing how much space is taken by each snapshot?
Message-ID: <20120625145840.GB19337@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

My btrfs pool looks like this:
usr
usr_daily_20120622_00:01:01
usr_daily_20120623_00:18:25
usr_daily_20120624_00:01:01
usr_daily_20120625_00:01:01
usr_hourly_20120625_05:00:02
usr_hourly_20120625_06:00:01
usr_hourly_20120625_07:00:01
usr_weekly_20120610_00:02:01
usr_weekly_20120617_00:02:01
usr_weekly_20120624_00:02:01

Sometimes I run low on space and I have to start dropping snapshots. I
realize that due to COW blocks, it's hard to say exactly how much space each
snapshot uses, but is there some way to get an idea how much each snapshot
will free if I delete it?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
