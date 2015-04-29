Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41833 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbbD2XVd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 19:21:33 -0400
Date: Wed, 29 Apr 2015 16:21:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: fdmanana@suse.com
Subject: 3.19.3, btrfs send/receive error: failed to clone extents
Message-ID: <20150429232130.GA23814@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting this from my send/receive job.

I'm just going to delete that one file since I don't need it anyway, but
is this a known problem or something that would need more info from me?


ERROR: failed to clone extents to merlin/.config/google-chrome-beta-42/Default/Application Cache/Cache/data_0
Invalid argument

ABORT: btrfs send -p /mnt/btrfs_pool1/home_ro.20150403_18:01:24 home_ro.20150429_15:01:24 |  btrfs receive /mnt/btrfs_pool2// failed


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
