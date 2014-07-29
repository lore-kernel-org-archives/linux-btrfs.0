Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaG2M5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 08:57:24 -0400
Date: Tue, 29 Jul 2014 14:57:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-porgs: fix xfstest btrfs/023 random failure
Message-ID: <20140729125723.GR1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405589304-7174-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405589304-7174-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 05:28:24PM +0800, Anand Jain wrote:
> xfstest btrfs/023 which does the following tests
> 
> create_group_profile "raid0"
> check_group_profile "RAID0"
> 
> create_group_profile "raid1"
> check_group_profile "RAID1"
> 
> create_group_profile "raid10"
> check_group_profile "RAID10"
> 
> create_group_profile "raid5"
> check_group_profile "RAID5"
> 
> create_group_profile "raid6"
> check_group_profile "RAID6"
> 
> fails randomly with the error as below
> 
>  ERROR: device scan failed '/dev/sde' - Invalid argument
> 
> since failure is at random group profile it indicates to me that
> btrfs kernel did not see the newly created btrfs on the device
> 
> To note: I have the following patch on the kernel which
> is not yet integrated, but its not related to this bug.
> 
> btrfs: RFC: code optimize use btrfs_get_bdev_and_sb() at btrfs_scan_one_device

I guess the error was caused by this patch, and the fsync just made the
race window smaller. If you still think the fsync is useful, please
update the changelog.
