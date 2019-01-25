Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8C1C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 03:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B94D221855
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 03:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AXr9fk9g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfAYDkX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 22:40:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfAYDkX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 22:40:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0P3doAC080653;
        Fri, 25 Jan 2019 03:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=W7eTkN6YvPpRIkWpGbmFilXufPFJ2UYuOWc4sIfKIwU=;
 b=AXr9fk9g9Dj9DZPGehLP2NZXLAwnYD+oys69mz7eijc2j0XVr4uZ126nrGs4s461fckY
 XhMaSqQToMNCDMy2huh7MnsSwc+JHNIx9491tIZjz6W04MqdVGxs7NK0b/GcU66nBaQl
 lS5J8r9QGjBg3eQagmYUmlQQgkldgFBfYEcF2No+vp5k/+xuAYwIhQ+DdRbbBSEHs3kp
 FxkLkUiiJ9J+2stHpqoX9awhSbjHYmHnN8PvNyJfjat6EIdgblczxFpZ5+GXh/nEYogv
 GALiJ2tXvp+f51imh98tcWil55YQ3Wkop37h4tKgdxMIyPTqKeWHz/7cOerXtxkhITuC Tg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2q3uav3g3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jan 2019 03:40:18 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0P3eHwc013451
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jan 2019 03:40:17 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0P3eHfV000460;
        Fri, 25 Jan 2019 03:40:17 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Jan 2019 19:40:17 -0800
Subject: Re: [PATCH v2] Btrfs: avoid deadlock with memory reclaim due to
 allocation of devices
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20181213211725.14832-1-fdmanana@kernel.org>
 <20190111171759.19920-1-fdmanana@kernel.org>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <e99ed6ff-7ade-d690-6c90-9c2bba024c46@oracle.com>
Date:   Fri, 25 Jan 2019 11:40:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190111171759.19920-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9146 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901250026
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/12/2019 01:17 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In a few places we are allocating a device using the GFP_KERNEL flag when
> it is not safe to do so, because if reclaim is triggered it can cause a
> transaction commit while we are holding the device list mutex. This mutex
> is required in the transaction commit path (at write_all_supers() and
> btrfs_update_commit_device_size()).
> 
> So fix this by setting up a nofs memory allocation context in those cases.
> 
> Fixes: 78f2c9e6dbb14 ("btrfs: device add and remove: use GFP_KERNEL")
> Fixes: e0ae999414238 ("btrfs: preallocate device flush bio")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Change the approach to fix the problem by setting up nofs contextes
>      where needed.

  So remaining functions which still does GFP_KERNEL are..

     btrfs_init_dev_replace_tgtdev()
     btrfs_init_new_device()
     add_missing_dev()

  Normally most of the device allocations are already done at
  device_list_add(), except for the special three functions above,
  so can we simplify the fix to [1] as there isn't much toll if
  the above three were also under GFP_NOFS.

[1]
--------------------------------------------
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b2c1d26f577e..3c350ab6535b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -387,7 +387,7 @@ static struct btrfs_device *__alloc_device(void)
  {
         struct btrfs_device *dev;

-       dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+       dev = kzalloc(sizeof(*dev), GFP_NOFS);
         if (!dev)
                 return ERR_PTR(-ENOMEM);

@@ -395,7 +395,7 @@ static struct btrfs_device *__alloc_device(void)
          * Preallocate a bio that's always going to be used for 
flushing device
          * barriers and matches the device lifespan
          */
-       dev->flush_bio = bio_alloc_bioset(GFP_KERNEL, 0, NULL);
+       dev->flush_bio = bio_alloc_bioset(GFP_NOFS, 0, NULL);
         if (!dev->flush_bio) {
                 kfree(dev);
                 return ERR_PTR(-ENOMEM);
--------------------------------------------

Thanks.



>   fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++---
>   1 file changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2576b1a379c9..663566baae78 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -14,6 +14,7 @@
>   #include <linux/semaphore.h>
>   #include <linux/uuid.h>
>   #include <linux/list_sort.h>
> +#include <linux/sched/mm.h>
>   #include "ctree.h"
>   #include "extent_map.h"
>   #include "disk-io.h"
> @@ -988,20 +989,29 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>   	}
>   
>   	if (!device) {
> +		unsigned int nofs_flag;
> +
>   		if (fs_devices->opened) {
>   			mutex_unlock(&fs_devices->device_list_mutex);
>   			return ERR_PTR(-EBUSY);
>   		}
>   
> +		/*
> +		 * Setup nofs context because we are holding the device list
> +		 * mutex, which is required for a transaction commit.
> +		 */
> +		nofs_flag = memalloc_nofs_save();
>   		device = btrfs_alloc_device(NULL, &devid,
>   					    disk_super->dev_item.uuid);
>   		if (IS_ERR(device)) {
> +			memalloc_nofs_restore(nofs_flag);
>   			mutex_unlock(&fs_devices->device_list_mutex);
>   			/* we can safely leave the fs_devices entry around */
>   			return device;
>   		}
>   
> -		name = rcu_string_strdup(path, GFP_NOFS);
> +		name = rcu_string_strdup(path, GFP_KERNEL);
> +		memalloc_nofs_restore(nofs_flag);
>   		if (!name) {
>   			btrfs_free_device(device);
>   			mutex_unlock(&fs_devices->device_list_mutex);
> @@ -1137,11 +1147,19 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
>   	/* We have held the volume lock, it is safe to get the devices. */
>   	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
>   		struct rcu_string *name;
> +		unsigned int nofs_flag;
>   
> +		/*
> +		 * Setup nofs context because we are holding the device list
> +		 * mutex, which is required for a transaction commit.
> +		 */
> +		nofs_flag = memalloc_nofs_save();
>   		device = btrfs_alloc_device(NULL, &orig_dev->devid,
>   					    orig_dev->uuid);
> -		if (IS_ERR(device))
> +		if (IS_ERR(device)) {
> +			memalloc_nofs_restore(nofs_flag);
>   			goto error;
> +		}
>   
>   		/*
>   		 * This is ok to do without rcu read locked because we hold the
> @@ -1151,12 +1169,14 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
>   			name = rcu_string_strdup(orig_dev->name->str,
>   					GFP_KERNEL);
>   			if (!name) {
> +				memalloc_nofs_restore(nofs_flag);
>   				btrfs_free_device(device);
>   				goto error;
>   			}
>   			rcu_assign_pointer(device->name, name);
>   		}
>   
> +		memalloc_nofs_restore(nofs_flag);
>   		list_add(&device->dev_list, &fs_devices->devices);
>   		device->fs_devices = fs_devices;
>   		fs_devices->num_devices++;
> @@ -1262,6 +1282,7 @@ static void btrfs_close_one_device(struct btrfs_device *device)
>   	struct btrfs_fs_devices *fs_devices = device->fs_devices;
>   	struct btrfs_device *new_device;
>   	struct rcu_string *name;
> +	unsigned int nofs_flag;
>   
>   	if (device->bdev)
>   		fs_devices->open_devices--;
> @@ -1277,17 +1298,23 @@ static void btrfs_close_one_device(struct btrfs_device *device)
>   
>   	btrfs_close_bdev(device);
>   
> +	/*
> +	 * Setup nofs context because we are holding the device list
> +	 * mutex, which is required for a transaction commit.
> +	 */
> +	nofs_flag = memalloc_nofs_save();
>   	new_device = btrfs_alloc_device(NULL, &device->devid,
>   					device->uuid);
>   	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
>   
>   	/* Safe because we are under uuid_mutex */
>   	if (device->name) {
> -		name = rcu_string_strdup(device->name->str, GFP_NOFS);
> +		name = rcu_string_strdup(device->name->str, GFP_KERNEL);
>   		BUG_ON(!name); /* -ENOMEM */
>   		rcu_assign_pointer(new_device->name, name);
>   	}
>   
> +	memalloc_nofs_restore(nofs_flag);
>   	list_replace_rcu(&device->dev_list, &new_device->dev_list);
>   	new_device->fs_devices = device->fs_devices;
>   
> 
