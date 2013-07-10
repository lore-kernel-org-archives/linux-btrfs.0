Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:51504 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3GJMXS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 08:23:18 -0400
Message-ID: <51DD5234.40907@giantdisaster.de>
Date: Wed, 10 Jul 2013 14:23:16 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: num_tolerated_disk_barrier_failures is incorrect
 for RAID6
References: <1373457270-18909-1-git-send-email-idryomov@gmail.com>
In-Reply-To: <1373457270-18909-1-git-send-email-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 10 Jul 2013 14:54:30 +0300, Ilya Dryomov wrote:
> Currently num_tolerated_disk_barrier_failures gets the value of
> fs_devices->num_devices in the RAID6 case.  But, RAID6 can tolerate only
> two simultaneous failures, so set it to 2.
> 
> CC: Stefan Behrens <sbehrens@giantdisaster.de>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/btrfs/disk-io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b8b60b6..aecf788 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3258,7 +3258,7 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
>  					    BTRFS_BLOCK_GROUP_RAID10)) {
>  						num_tolerated_disk_barrier_failures = 1;
>  					} else if (flags &
> -						   BTRFS_BLOCK_GROUP_RAID5) {
> +						   BTRFS_BLOCK_GROUP_RAID6) {
>  						num_tolerated_disk_barrier_failures = 2;
>  					}
>  				}
> 

ELATE :), Henrik Nordvik already fixed it with commit 15b0a89d7.

