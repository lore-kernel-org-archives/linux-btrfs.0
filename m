Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58681C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 05:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11294217D4
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 05:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="5q9da7iT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfAWF2g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 00:28:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfAWF2g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 00:28:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0N5SV8m037869;
        Wed, 23 Jan 2019 05:28:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=XT78oG8kcXayh4rorp1vzAZbyhfRmazjK5I2uVVr/2s=;
 b=5q9da7iTaPU7Fm7b5j2dIX8aoNp9QAdvgHgEGY+UTKHI8gKrF/AU3vsGZr7DRqpCgBMZ
 6cRdlymdxtBHPtk5FD4mpIpDzUMy/Zb5z6a1kgTe1HraaijpVpmuC4btznolC98ZJneR
 bBmx5RvBFyXGrUIusK5ZG2ey+2skNmZ7PFSq8IZpdplzD1ZGP0yt3yYuweHGD6yBBz7Q
 hhJjWALNVP8ZKNUvtp/DHSQ/oBAyd/imPganPfEkU6RzbIvs04EsZ7Yw/cBlTJCC8ZMD
 UXcGV5ep54yhMR31g3Yua2CtL0yURHB/pRJvomTxkjXUA8BexcsD9UDF7iVq6Iik6WkZ eA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2q3vhrqgwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jan 2019 05:28:31 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0N5STTc031502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jan 2019 05:28:30 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0N5STLN031870;
        Wed, 23 Jan 2019 05:28:29 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jan 2019 21:28:29 -0800
Subject: Re: [PATCH 5/6 v2] btrfs: merge btrfs_find_device() and find_device()
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <1547739153-6916-6-git-send-email-anand.jain@oracle.com>
 <1547880535-29710-1-git-send-email-anand.jain@oracle.com>
Message-ID: <f1554171-01ee-05f2-136a-7732f6ea678a@oracle.com>
Date:   Wed, 23 Jan 2019 13:28:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1547880535-29710-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9144 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901230043
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/19/2019 02:48 PM, Anand Jain wrote:
> Both btrfs_find_device() and find_device() does the same things expect
> that latter function is not keen in seed device in the scan-context. So
> merge them.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

    A gentle ping.

Thanks, Anand

> ---
> v2: use bool instead of int.
>      use positive meaning instead of negative.
>      conflict fix: due to 1b3922a8bc7 in misc-next.
> 
> 	if (dev->disk_total_bytes == 0) {
> -		dev = find_device(fs_info->fs_devices->seed, devid, NULL);
> +		dev = btrfs_find_device(fs_info->fs_devices->seed, devid, NULL,
> +					NULL, false);
>   fs/btrfs/dev-replace.c |  4 +--
>   fs/btrfs/ioctl.c       |  4 +--
>   fs/btrfs/scrub.c       |  4 +--
>   fs/btrfs/volumes.c     | 73 +++++++++++++++++++++++++-------------------------
>   fs/btrfs/volumes.h     |  3 ++-
>   5 files changed, 44 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 6f0fe3623381..975cbf011593 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -112,10 +112,10 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
>   	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
>   	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
>   		dev_replace->srcdev = btrfs_find_device(fs_info->fs_devices,
> -							src_devid, NULL, NULL);
> +							src_devid, NULL, NULL, true);
>   		dev_replace->tgtdev = btrfs_find_device(fs_info->fs_devices,
>   							BTRFS_DEV_REPLACE_DEVID,
> -							NULL, NULL);
> +							NULL, NULL, true);
>   		/*
>   		 * allow 'btrfs dev replace_cancel' if src/tgt device is
>   		 * missing
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index fd5f97aeb35c..3f9d7be30bf4 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1642,7 +1642,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
>   		btrfs_info(fs_info, "resizing devid %llu", devid);
>   	}
>   
> -	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
> +	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
>   	if (!device) {
>   		btrfs_info(fs_info, "resizer unable to find device %llu",
>   			   devid);
> @@ -3179,7 +3179,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
>   
>   	rcu_read_lock();
>   	dev = btrfs_find_device(fs_info->fs_devices, di_args->devid, s_uuid,
> -				NULL);
> +				NULL, true);
>   
>   	if (!dev) {
>   		ret = -ENODEV;
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 72044efc610a..b320910c6740 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3835,7 +3835,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>   		return PTR_ERR(sctx);
>   
>   	mutex_lock(&fs_info->fs_devices->device_list_mutex);
> -	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
> +	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
>   	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
>   		     !is_dev_replace)) {
>   		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> @@ -4012,7 +4012,7 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
>   	struct scrub_ctx *sctx = NULL;
>   
>   	mutex_lock(&fs_info->fs_devices->device_list_mutex);
> -	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
> +	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
>   	if (dev)
>   		sctx = dev->scrub_ctx;
>   	if (sctx)
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5b37044503c0..df1a077aeb80 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -415,27 +415,6 @@ static struct btrfs_device *__alloc_device(void)
>   	return dev;
>   }
>   
> -/*
> - * Find a device specified by @devid or @uuid in the list of @fs_devices, or
> - * return NULL.
> - *
> - * If devid and uuid are both specified, the match must be exact, otherwise
> - * only devid is used.
> - */
> -static struct btrfs_device *find_device(struct btrfs_fs_devices *fs_devices,
> -		u64 devid, const u8 *uuid)
> -{
> -	struct btrfs_device *dev;
> -
> -	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
> -		if (dev->devid == devid &&
> -		    (!uuid || !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE))) {
> -			return dev;
> -		}
> -	}
> -	return NULL;
> -}
> -
>   static noinline struct btrfs_fs_devices *find_fsid(
>   		const u8 *fsid, const u8 *metadata_fsid)
>   {
> @@ -990,8 +969,9 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>   		device = NULL;
>   	} else {
>   		mutex_lock(&fs_devices->device_list_mutex);
> -		device = find_device(fs_devices, devid,
> -				disk_super->dev_item.uuid);
> +		device = btrfs_find_device(fs_devices, devid,
> +					   disk_super->dev_item.uuid, NULL,
> +					   false);
>   
>   		/*
>   		 * If this disk has been pulled into an fs devices created by
> @@ -2419,10 +2399,10 @@ static struct btrfs_device *btrfs_find_device_by_path(
>   	dev_uuid = disk_super->dev_item.uuid;
>   	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
>   		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
> -					   disk_super->metadata_uuid);
> +					   disk_super->metadata_uuid, true);
>   	else
>   		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
> -					   disk_super->fsid);
> +					   disk_super->fsid, true);
>   
>   	brelse(bh);
>   	if (!device)
> @@ -2442,7 +2422,7 @@ struct btrfs_device *btrfs_find_device_by_devspec(
>   
>   	if (devid) {
>   		device = btrfs_find_device(fs_info->fs_devices, devid, NULL,
> -					   NULL);
> +					   NULL, true);
>   		if (!device)
>   			return ERR_PTR(-ENOENT);
>   		return device;
> @@ -2584,7 +2564,7 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
>   		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
>   				   BTRFS_FSID_SIZE);
>   		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
> -					   fs_uuid);
> +					   fs_uuid, true);
>   		BUG_ON(!device); /* Logic error */
>   
>   		if (device->fs_devices->seeding) {
> @@ -6637,19 +6617,36 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>   	return BLK_STS_OK;
>   }
>   
> +/*
> + * Find a device specified by @devid or @uuid in the list of @fs_devices, or
> + * return NULL.
> + *
> + * If devid and uuid are both specified, the match must be exact, otherwise
> + * only devid is used.
> + *
> + * If seed is true, traverse through the seed devices.
> + */
>   struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
> -				       u64 devid, u8 *uuid, u8 *fsid)
> +				       u64 devid, u8 *uuid, u8 *fsid,
> +				       bool seed)
>   {
>   	struct btrfs_device *device;
>   
>   	while (fs_devices) {
>   		if (!fsid ||
>   		    !memcmp(fs_devices->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
> -			device = find_device(fs_devices, devid, uuid);
> -			if (device)
> -				return device;
> +			list_for_each_entry(device, &fs_devices->devices,
> +					    dev_list) {
> +				if (device->devid == devid && (!uuid ||
> +				    !memcmp(device->uuid, uuid,
> +				    BTRFS_UUID_SIZE)))
> +					return device;
> +			}
>   		}
> -		fs_devices = fs_devices->seed;
> +		if (seed)
> +			fs_devices = fs_devices->seed;
> +		else
> +			return NULL;
>   	}
>   	return NULL;
>   }
> @@ -6895,7 +6892,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>   				   btrfs_stripe_dev_uuid_nr(chunk, i),
>   				   BTRFS_UUID_SIZE);
>   		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices,
> -							devid, uuid, NULL);
> +							devid, uuid, NULL, true);
>   		if (!map->stripes[i].dev &&
>   		    !btrfs_test_opt(fs_info, DEGRADED)) {
>   			free_extent_map(em);
> @@ -7035,7 +7032,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
>   	}
>   
>   	device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
> -				   fs_uuid);
> +				   fs_uuid, true);
>   	if (!device) {
>   		if (!btrfs_test_opt(fs_info, DEGRADED)) {
>   			btrfs_report_missing_device(fs_info, devid,
> @@ -7625,7 +7622,8 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
>   	int i;
>   
>   	mutex_lock(&fs_devices->device_list_mutex);
> -	dev = btrfs_find_device(fs_info->fs_devices, stats->devid, NULL, NULL);
> +	dev = btrfs_find_device(fs_info->fs_devices, stats->devid, NULL, NULL,
> +				true);
>   	mutex_unlock(&fs_devices->device_list_mutex);
>   
>   	if (!dev) {
> @@ -7839,7 +7837,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
>   	}
>   
>   	/* Make sure no dev extent is beyond device bondary */
> -	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
> +	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
>   	if (!dev) {
>   		btrfs_err(fs_info, "failed to find devid %llu", devid);
>   		ret = -EUCLEAN;
> @@ -7848,7 +7846,8 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
>   
>   	/* It's possible this device is a dummy for seed device */
>   	if (dev->disk_total_bytes == 0) {
> -		dev = find_device(fs_info->fs_devices->seed, devid, NULL);
> +		dev = btrfs_find_device(fs_info->fs_devices->seed, devid, NULL,
> +					NULL, false);
>   		if (!dev) {
>   			btrfs_err(fs_info, "failed to find seed devid %llu",
>   				  devid);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 46ee8eafdc92..c8ddcf4ae1f2 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -435,7 +435,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
>   int btrfs_grow_device(struct btrfs_trans_handle *trans,
>   		      struct btrfs_device *device, u64 new_size);
>   struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
> -				       u64 devid, u8 *uuid, u8 *fsid);
> +				       u64 devid, u8 *uuid, u8 *fsid,
> +				       bool seed);
>   int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
>   int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
>   int btrfs_balance(struct btrfs_fs_info *fs_info,
> 
