Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51365 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752354AbeAaIiY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 03:38:24 -0500
Subject: Re: [PATCH 2/2] btrfs: add read_mirror_policy parameter devid
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <20180130063020.14850-3-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f4772f0c-c53e-c859-7da9-b2181a3507c1@suse.com>
Date: Wed, 31 Jan 2018 10:38:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180130063020.14850-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.01.2018 08:30, Anand Jain wrote:
> Adds the mount option:
>   mount -o read_mirror_policy=<devid>
> 
> To set the devid of the device which should be used for read. That
> means all the normal reads will go to that particular device only.
> 
> This also helps testing and gives a better control for the test
> scripts including mount context reads.

Some code comments below. OTOH, does such policy really make sense, what
happens if the selected device fails, will the other mirror be retried?
If the answer to the previous question is positive then why do we really
care which device is going to be tried first?

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/super.c   | 21 +++++++++++++++++++++
>  fs/btrfs/volumes.c | 10 ++++++++++
>  fs/btrfs/volumes.h |  2 ++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index dfe6b3c67df3..d3aad8cccc7e 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -847,6 +847,27 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  					BTRFS_READ_MIRROR_BY_PID;
>  				break;
>  			}
> +
> +			intarg = 0;
> +			if (match_int(&args[0], &intarg) == 0) {
> +				struct btrfs_device *device;
> +
> +				device = btrfs_find_device(info, intarg,
> +							   NULL, NULL);
> +				if (!device) {
> +					btrfs_err(info,
> +					  "read_mirror_policy: invalid devid %d",
> +					  intarg);
> +					ret = -EINVAL;
> +					goto out;
> +				}
> +				info->read_mirror_policy =
> +						BTRFS_READ_MIRROR_BY_DEV;
> +				set_bit(BTRFS_DEV_STATE_READ_MIRROR,
> +					&device->dev_state);
> +				break;
> +			}
> +
>  			ret = -EINVAL;
>  			goto out;
>  		case Opt_err:
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 39ba59832f38..478623e6e074 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5270,6 +5270,16 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  		num = map->num_stripes;
>  
>  	switch(fs_info->read_mirror_policy) {
> +	case BTRFS_READ_MIRROR_BY_DEV:
> +		optimal = first;
> +		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
> +			     &map->stripes[optimal].dev->dev_state))
> +			break;
> +		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
> +			     &map->stripes[++optimal].dev->dev_state))
> +			break;
> +		optimal = first;

you set optimal 2 times, the second one seems redundant. Alongside this
patch it makes sense to also send a patch to btrfs(5) man page
describing the mount option + description of each implemented allocation
policy.

Another thing which I don't see here is how you are handling the case
when you have more than 2 devices in the RAID1 case. As it stands
currently you assume there are two devices and first test device 0 and
then device 1 and completely ignore any other devices.

> +		break;
>  	case BTRFS_READ_MIRROR_DEFAULT:
>  	case BTRFS_READ_MIRROR_BY_PID:
>  	default:
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 78f35d299a61..7281f55dea05 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -50,6 +50,7 @@ struct btrfs_pending_bios {
>  enum btrfs_read_mirror_type {
>  	BTRFS_READ_MIRROR_DEFAULT,
>  	BTRFS_READ_MIRROR_BY_PID,
> +	BTRFS_READ_MIRROR_BY_DEV,
>  };
>  
>  #define BTRFS_DEV_STATE_WRITEABLE	(0)
> @@ -57,6 +58,7 @@ enum btrfs_read_mirror_type {
>  #define BTRFS_DEV_STATE_MISSING		(2)
>  #define BTRFS_DEV_STATE_REPLACE_TGT	(3)
>  #define BTRFS_DEV_STATE_FLUSH_SENT	(4)
> +#define BTRFS_DEV_STATE_READ_MIRROR	(5)
>  
>  struct btrfs_device {
>  	struct list_head dev_list;
> 
