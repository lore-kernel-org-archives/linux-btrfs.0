Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F82C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 09:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4003D218AF
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 09:38:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UbclhiUQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfAaJim (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 04:38:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42412 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfAaJim (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 04:38:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0V9YOni141288;
        Thu, 31 Jan 2019 09:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Mg8kBD6FtAG9nGAIfS3nhDnhb4blThg/pfVIoaYWCoY=;
 b=UbclhiUQ9m0erhtQfBm3UGQcXYedDY+UXlMRIgn3Wz138dYxYlEbGAhSGNk7ZL/8DLdx
 c8HTX50mG4abV4iaaGPp2UBsWMIjJwCDzJgN0UlMZTdLdayyOdJHlj/mjvcmYAu8O67h
 Eq8bxDZ2gF8rNE75dqIYTE+G30aUWvdFthxNUPuGJZvY/zeIqG2rsY4QcQWHe1li+oKG
 Tr8AFxbCLWYr5U1xFswpTRZ21n7M1EYAb9AWsxmdZv+frJXlOcVJx21m1t8CYFELMgBN
 6kWNLe2k5620gkNBqG18641tGN1JAyw/gScNdnh5R5XKlb7K0+5j+5h//ZK03f/9JjJS Yw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2q8g6rfbhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Jan 2019 09:38:37 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0V9cbVJ004183
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Jan 2019 09:38:37 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0V9cbkC028679;
        Thu, 31 Jan 2019 09:38:37 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Jan 2019 01:38:36 -0800
Subject: Re: [PATCH 1/2] btrfs: Don't search devid for every
 verify_one_dev_extent() call
To:     Qu Wenruo <wqu@suse.com>
References: <20190130074000.16638-1-wqu@suse.com>
 <20190130074000.16638-2-wqu@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <0e26c715-357b-d834-c6e9-3e395aed070a@oracle.com>
Date:   Thu, 31 Jan 2019 17:38:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190130074000.16638-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9152 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1901310076
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org




On 1/30/19 3:39 PM, Qu Wenruo wrote:

> verify_one_dev_extent() will call btrfs_find_device() for each dev
> extent, this waste some CPU time just searching the devices list.


> Move the search one level up, into the btrfs_verify_dev_extents(), so
> for each device we only call btrfs_find_device() once.


This does not apply on misc-next. Looks like this patch's branch is 
missing the seed fix.

Looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/volumes.c | 26 ++++++++++++++++----------
>   1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2576b1a379c9..8e932d7d2fe6 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7761,13 +7761,14 @@ static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripes)
>   }
>   
>   static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
> -				 u64 chunk_offset, u64 devid,
> -				 u64 physical_offset, u64 physical_len)
> +				 struct btrfs_device *dev,
> +				 u64 chunk_offset, u64 physical_offset,
> +				 u64 physical_len)
>   {
>   	struct extent_map_tree *em_tree = &fs_info->mapping_tree.map_tree;
>   	struct extent_map *em;
>   	struct map_lookup *map;
> -	struct btrfs_device *dev;
> +	u64 devid = dev->devid;
>   	u64 stripe_len;
>   	bool found = false;
>   	int ret = 0;
> @@ -7819,12 +7820,6 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
>   	}
>   
>   	/* Make sure no dev extent is beyond device bondary */
> -	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
> -	if (!dev) {
> -		btrfs_err(fs_info, "failed to find devid %llu", devid);
> -		ret = -EUCLEAN;
> -		goto out;
> -	}
>   	if (physical_offset + physical_len > dev->disk_total_bytes) {
>   		btrfs_err(fs_info,
>   "dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
> @@ -7874,6 +7869,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>   {
>   	struct btrfs_path *path;
>   	struct btrfs_root *root = fs_info->dev_root;
> +	struct btrfs_device *device = NULL;
>   	struct btrfs_key key;
>   	u64 prev_devid = 0;
>   	u64 prev_dev_ext_end = 0;
> @@ -7917,6 +7913,16 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>   		devid = key.objectid;
>   		physical_offset = key.offset;
>   
> +		if (!device || devid != device->devid) {
> +			device = btrfs_find_device(fs_info, devid, NULL, NULL);
> +			if (!device) {
> +				btrfs_err(fs_info, "failed to find devid %llu",
> +					  devid);
> +				ret = -EUCLEAN;
> +				goto out;
> +			}
> +		}
> +
>   		dext = btrfs_item_ptr(leaf, slot, struct btrfs_dev_extent);
>   		chunk_offset = btrfs_dev_extent_chunk_offset(leaf, dext);
>   		physical_len = btrfs_dev_extent_length(leaf, dext);
> @@ -7930,7 +7936,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>   			goto out;
>   		}
>   
> -		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
> +		ret = verify_one_dev_extent(fs_info, device, chunk_offset,
>   					    physical_offset, physical_len);
>   		if (ret < 0)
>   			goto out;
> 
