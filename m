Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:36941 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935410AbcCQJn5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 05:43:57 -0400
Received: from localhost
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 17 Mar 2016 19:13:37 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [RFC PATCH] btrfs/066: Fix race condition by making 'subvolume stress' task to exit gracefully
Date: Thu, 17 Mar 2016 14:42:36 +0530
Message-ID: <1612703.LcIZZjmlu9@localhost.localdomain>
In-Reply-To: <20160317072339.GW11419@eguan.usersys.redhat.com>
References: <1458195269-965-1-git-send-email-chandan@linux.vnet.ibm.com> <20160317072339.GW11419@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 17 Mar 2016 15:23:39 Eryu Guan wrote:
> A named pipe seems too heavy and complicated to me. How about breaking
> out the loop in _btrfs_stress_subvolume on the existence of some file?
> e.g.
> 
> _btrfs_stress_subvolume():
> 	...
> 	local stop_file=$5
> 	while [ ! -e $stop_file ]; do
> 	...
> 	done
> 
> run_test():
> 	...
> 	local stop_file=$TEST_DIR/$seq.stop.$$
> 	...
> 	# make sure the stop sign is not there
> 	rm -f $stop_file
> 	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ 
$subvol_mnt
> $stop_file & ...
> 	wait $fsstress_pid
> 	touch $stop_file
> 	kill $scrub_pid
> 	wait
>

Yes, you are right. This above method is much simpler. I will send out a patch
with the new fix.

-- 
chandan

