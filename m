Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.sophos.com ([216.47.234.212]:51283 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab2KIK5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2012 05:57:10 -0500
From: David Pottage <David.Pottage@Sophos.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 24/26] Btrfs: increase BTRFS_MAX_MIRRORS by one for dev
 replace
Date: Fri, 9 Nov 2012 10:47:39 +0000
Message-ID: <E33B72079F3EBA4C91E325F2AE20429518BAA4CD@abn-exch1b.green.sophos>
References: <cover.1352217243.git.sbehrens@giantdisaster.de>
 <38ed30105397e5c706e38c95f52007a2c156fefb.1352217244.git.sbehrens@giantdisaster.de>
In-Reply-To: <38ed30105397e5c706e38c95f52007a2c156fefb.1352217244.git.sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Stefan Behrens
Sent: 06 November 2012 16:39
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 24/26] Btrfs: increase BTRFS_MAX_MIRRORS by one for dev replace

> This change of the define is effective in all modes, it is required and used only in the case when a
> device replace procedure is running. The reason is that during an active device replace procedure,
> the target device of the copy operation is a mirror for the filesystem data as well that can be used
> to read data in order to repair read errors on other disks.

Are you assuming the user is only replacing one device at once?

If the user is upgrading their disc array to increase the capacity (or speed), then it would make sense for them to replace all the drives in the array at once. Is that supported?

For example, could a user with a 4 drive array of 1Tb drives, fit 4 new 2Tb drives, then call btrfs replace mountpoint <old> <new> 4 times, leave the system overnight to copy the data, and remove the old drives in the morning.



________________________________

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
