Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:20871 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2KILXN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2012 06:23:13 -0500
Message-ID: <509CE79F.4050906@giantdisaster.de>
Date: Fri, 09 Nov 2012 12:23:11 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: David Pottage <David.Pottage@Sophos.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 24/26] Btrfs: increase BTRFS_MAX_MIRRORS by one for dev
 replace
References: <cover.1352217243.git.sbehrens@giantdisaster.de> <38ed30105397e5c706e38c95f52007a2c156fefb.1352217244.git.sbehrens@giantdisaster.de> <E33B72079F3EBA4C91E325F2AE20429518BAA4CD@abn-exch1b.green.sophos>
In-Reply-To: <E33B72079F3EBA4C91E325F2AE20429518BAA4CD@abn-exch1b.green.sophos>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 9 Nov 2012 10:47:39 +0000, David Pottage wrote:
> Are you assuming the user is only replacing one device at once?
> 
> If the user is upgrading their disc array to increase the capacity (or speed), then it would make sense for them to replace all the drives in the array at once. Is that supported?
> 
> For example, could a user with a 4 drive array of 1Tb drives, fit 4 new 2Tb drives, then call btrfs replace mountpoint <old> <new> 4 times, leave the system overnight to copy the data, and remove the old drives in the morning.

Yes, one device at once.

"btrfs replace start ... & btrfs replace start ..." is not supported.

"btrfs replace start -B ... ; btrfs replace start -B ..." is the
designated way to replace multiple disks.

