Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47896 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaDDUdB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 16:33:01 -0400
Date: Fri, 4 Apr 2014 13:29:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/27] btrfs-progs: Convert man page for btrfs-replace.
Message-ID: <20140404202929.GB12124@merlins.org>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1396427378-10487-15-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396427378-10487-15-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 02, 2014 at 04:29:25PM +0800, Qu Wenruo wrote:
> +If the source device is not available anymore, or if the -r option is set,
> +the data is built only using the RAID redundancy mechanisms.
> +After completion of the operation, the source device is removed from the
> +filesystem.

Woudl it make sense to add a paragraph explaining that for raid5/6,
someone should either:
1) use balance to rebuild on a new drive if one of the drives is missing
2) use btrfs device add of a new drive, then btrfs device delete of the
drive to replace, and effectively btrfs will do the same thing that
replace would

?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
