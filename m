Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbcD2Qmt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 12:42:49 -0400
Date: Fri, 29 Apr 2016 18:42:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 1/2] btrfs: create degraded-RAID1 chunks
Message-ID: <20160429164234.GE29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
 <1461812780-538-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461812780-538-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 11:06:19AM +0800, Anand Jain wrote:
> When RAID1 is degraded, newer chunks should be degraded-RAID1
> chunks instead of single chunks.
> 
> The bug is because the devs_min for raid1 was wrong it should
> be 1, instead of 2.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 38 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e2b54d546b7c..8b87ed6eb381 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -56,7 +56,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.sub_stripes	= 1,
>  		.dev_stripes	= 1,
>  		.devs_max	= 2,
> -		.devs_min	= 2,
> +		.devs_min	= 1,

I think we should introduce another way how to determine the lower limit
for the degraded mounts. We need the proper raidX constraints and use
the degraded limits only if in case of the degraded mount.

>  		.tolerated_failures = 1,

Which is exactly the tolerated_failures:

  degraded_devs_min == devs_min - tolerated_failures

which works for all raid levels with redundancy.

>  		.devs_increment	= 2,
>  		.ncopies	= 2,
