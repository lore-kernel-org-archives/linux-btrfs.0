Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC93C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 01:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1689922545
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 01:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X58dum9M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1689922545
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbeKNL2Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 06:28:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40440 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbeKNL2Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 06:28:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAE1OIlv167203;
        Wed, 14 Nov 2018 01:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=qm0fzH85AW/Tmg84CbQaOOWeuJe6l46IbyvVEamaJ60=;
 b=X58dum9MTFElQkZ4i7GULMEUp3aFpo3Ol8uX0ZtOy74dSp+KvL6klrbIqPVcAjYPhjSF
 8b5kOuPM/94/R9B/DWw/EzmrhObSYctkuUb6oicDc8Zlz5L0h3xd+9BqPuddy+PSuUwb
 TDe9mI4Yur0CmIP5lvhsYSLD09Wgpg978Jq9vcrhOnTf6ZtdqRmqdBGqL6Ll/czrR9ut
 dVeToBT37iNIitsi3t9jY+LzRUVE4m70aV2XFpJN73sJNDwQELxRUffNW5UdPskgFxA3
 uu2w4PtHTNk5fVZumQa+Qc+5dj8pKyP9gQcTePGjPI/7aPpjd37MWX9KTYgYhAW4rHvF NQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nr7cs0hr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 01:27:24 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAE1RNtq020173
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 01:27:24 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAE1RN5K016899;
        Wed, 14 Nov 2018 01:27:23 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Nov 2018 17:27:22 -0800
Subject: Re: [PATCH V7] Btrfs: enhance raid1/10 balance heuristic
To:     Timofey Titovets <timofey.titovets@synesis.ru>,
        linux-btrfs@vger.kernel.org
Cc:     nborisov@suse.com, Timofey Titovets <nefelim4ag@gmail.com>,
        David Sterba <dsterba@suse.com>
References: <20181112115839.13969-1-timofey.titovets@synesis.ru>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <a1854e9d-b3f3-f751-0364-118dc98da057@oracle.com>
Date:   Wed, 14 Nov 2018 09:27:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181112115839.13969-1-timofey.titovets@synesis.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140011
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



I am ok with the least used path approach here for the IO routing
that's probably most reasonable in generic configurations. It can
be default read mirror policy as well.

But as I mentioned. Not all configurations would agree to the heuristic
approach here. For example: To make use of the SAN storage cache to
get high IO throughput read must access based on the LBA, And this
heuristic would make matter worst. There are plans to add more
options read_mirror_policy [1].

[1]
https://patchwork.kernel.org/patch/10403299/

I would rather provide the configuration tune-ables to the use
cases rather than fixing it using heuristic. Heuristic are good
only with the known set of IO pattern for which heuristic is
designed for.

This is not the first time you are assuming heuristic would provide
the best possible performance in all use cases. As I mentioned
in the compression heuristic there was no problem statement that
you wanted to address using heuristic, theoretically the integrated
compression heuristic would have to do a lot more computation when
all the file-extents are compressible, its not convenience to me
how compression heuristic would help on a desktop machine where
most of the files are compressible.

IMO heuristic are good only for a set of types of workload. Giving
an option to move away from it for the manual tuning is desired.

Thanks, Anand


On 11/12/2018 07:58 PM, Timofey Titovets wrote:
> From: Timofey Titovets <nefelim4ag@gmail.com>
> 
> Currently btrfs raid1/10 balancer bаlance requests to mirrors,
> based on pid % num of mirrors.
> 
> Make logic understood:
>   - if one of underline devices are non rotational
>   - Queue length to underline devices
> 
> By default try use pid % num_mirrors guessing, but:
>   - If one of mirrors are non rotational, repick optimal to it
>   - If underline mirror have less queue length then optimal,
>     repick to that mirror
> 
> For avoid round-robin request balancing,
> lets round down queue length:
>   - By 8 for rotational devs
>   - By 2 for all non rotational devs
> 
> Some bench results from mail list
> (Dmitrii Tcvetkov <demfloro@demfloro.ru>):
> Benchmark summary (arithmetic mean of 3 runs):
>           Mainline     Patch
> ------------------------------------
> RAID1  | 18.9 MiB/s | 26.5 MiB/s
> RAID10 | 30.7 MiB/s | 30.7 MiB/s
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from first HDD (quite slow HDD):
> Jobs: 1 (f=1): [r(1)][100.0%][r=8456KiB/s,w=0KiB/s][r=264,w=0 IOPS]
>    read: IOPS=265, BW=8508KiB/s (8712kB/s)(499MiB/60070msec)
>    lat (msec): min=2, max=825, avg=60.17, stdev=65.06
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from second HDD (much more modern):
> Jobs: 1 (f=1): [r(1)][8.7%][r=11.9MiB/s,w=0KiB/s][r=380,w=0 IOPS]
>    read: IOPS=378, BW=11.8MiB/s (12.4MB/s)(710MiB/60051msec)
>    lat (usec): min=416, max=644286, avg=42312.74, stdev=48518.56
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from an SSD:
> Jobs: 1 (f=1): [r(1)][100.0%][r=436MiB/s,w=0KiB/s][r=13.9k,w=0 IOPS]
>    read: IOPS=13.9k, BW=433MiB/s (454MB/s)(25.4GiB/60002msec)
>    lat (usec): min=343, max=16319, avg=1152.52, stdev=245.36
> ------------------------------------------------------------------------
> With the patch, 2 HDDs:
> Jobs: 1 (f=1): [r(1)][100.0%][r=17.5MiB/s,w=0KiB/s][r=560,w=0 IOPS]
>    read: IOPS=560, BW=17.5MiB/s (18.4MB/s)(1053MiB/60052msec)
>    lat (usec): min=435, max=341037, avg=28511.64, stdev=30000.14
> ------------------------------------------------------------------------
> With the patch, HDD(old one)+SSD:
> Jobs: 1 (f=1): [r(1)][100.0%][r=371MiB/s,w=0KiB/s][r=11.9k,w=0 IOPS]
>    read: IOPS=11.6k, BW=361MiB/s (379MB/s)(21.2GiB/60084msec)
>    lat  (usec): min=363, max=346752, avg=1381.73, stdev=6948.32
> 
> Changes:
>    v1 -> v2:
>      - Use helper part_in_flight() from genhd.c
>        to get queue length
>      - Move guess code to guess_optimal()
>      - Change balancer logic, try use pid % mirror by default
>        Make balancing on spinning rust if one of underline devices
>        are overloaded
>    v2 -> v3:
>      - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
>    v3 -> v4:
>      - Rebased on latest misc-next
>    v4 -> v5:
>      - Rebased on latest misc-next
>    v5 -> v6:
>      - Fix spelling
>      - Include bench results
>    v6 -> v7:
>      - Fixes based on Nikolay Borisov review:
>        * Assume num == 2
>        * Remove "for" loop based on that assumption, where possible
>        * No functional changes
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> ---
>   block/genhd.c      |   1 +
>   fs/btrfs/volumes.c | 100 ++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 100 insertions(+), 1 deletion(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index be5bab20b2ab..939f0c6a2d79 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -81,6 +81,7 @@ void part_in_flight(struct request_queue *q, struct hd_struct *part,
>   				atomic_read(&part->in_flight[1]);
>   	}
>   }
> +EXPORT_SYMBOL_GPL(part_in_flight);
>   
>   void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
>   		       unsigned int inflight[2])
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f4405e430da6..a6632cc2bfab 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -13,6 +13,7 @@
>   #include <linux/raid/pq.h>
>   #include <linux/semaphore.h>
>   #include <linux/uuid.h>
> +#include <linux/genhd.h>
>   #include <linux/list_sort.h>
>   #include "ctree.h"
>   #include "extent_map.h"
> @@ -5159,6 +5160,102 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>   	return ret;
>   }
>   
> +/**
> + * bdev_get_queue_len - return rounded down in flight queue length of bdev
> + *
> + * @bdev: target bdev
> + * @round_down: round factor big for hdd and small for ssd, like 8 and 2
> + */
> +static int bdev_get_queue_len(struct block_device *bdev, int round_down)
> +{
> +	int sum;
> +	struct hd_struct *bd_part = bdev->bd_part;
> +	struct request_queue *rq = bdev_get_queue(bdev);
> +	uint32_t inflight[2] = {0, 0};
> +
> +	part_in_flight(rq, bd_part, inflight);
> +
> +	sum = max_t(uint32_t, inflight[0], inflight[1]);
> +
> +	/*
> +	 * Try prevent switch for every sneeze
> +	 * By roundup output num by some value
> +	 */
> +	return ALIGN_DOWN(sum, round_down);
> +}
> +
> +/**
> + * guess_optimal - return guessed optimal mirror
> + *
> + * Optimal expected to be pid % num_stripes
> + *
> + * That's generaly ok for spread load
> + * Add some balancer based on queue length to device
> + *
> + * Basic ideas:
> + *  - Sequential read generate low amount of request
> + *    so if load of drives are equal, use pid % num_stripes balancing
> + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
> + *    and repick if other dev have "significant" less queue length
> + *  - Repick optimal if queue length of other mirror are less
> + */
> +static int guess_optimal(struct map_lookup *map, int num, int optimal)
> +{
> +	int i;
> +	int round_down = 8;
> +	/* Init for missing bdevs */
> +	int qlen[2] = { INT_MAX, INT_MAX };
> +	bool is_nonrot[2] = { false, false };
> +	bool all_bdev_nonrot = true;
> +	bool all_bdev_rotate = true;
> +	struct block_device *bdev;
> +
> +	ASSERT(num == 2);
> +
> +	/* Check accessible bdevs */
> +	for (i = 0; i < 2; i++) {
> +		bdev = map->stripes[i].dev->bdev;
> +		if (bdev) {
> +			qlen[i] = 0;
> +			is_nonrot[i] = blk_queue_nonrot(bdev_get_queue(bdev));
> +			if (is_nonrot[i])
> +				all_bdev_rotate = false;
> +			else
> +				all_bdev_nonrot = false;
> +		}
> +	}
> +
> +	/*
> +	 * Don't bother with computation
> +	 * if only one of two bdevs are accessible
> +	 */
> +	if (qlen[0] == INT_MAX)
> +		return 1;
> +	if (qlen[1] == INT_MAX)
> +		return 0;
> +
> +	if (all_bdev_nonrot)
> +		round_down = 2;
> +
> +	for (i = 0; i < 2; i++) {
> +		bdev = map->stripes[i].dev->bdev;
> +		qlen[i] = bdev_get_queue_len(bdev, round_down);
> +	}
> +
> +	/* For mixed case, pick non rotational dev as optimal */
> +	if (all_bdev_rotate == all_bdev_nonrot) {
> +		if (is_nonrot[0])
> +			optimal = 0;
> +		else
> +			optimal = 1;
> +	}
> +
> +	if (qlen[optimal] > qlen[(optimal + 1) % 2])
> +		optimal = i;
> +
> +	return optimal;
> +}
> +
>   static int find_live_mirror(struct btrfs_fs_info *fs_info,
>   			    struct map_lookup *map, int first,
>   			    int dev_replace_is_ongoing)
> @@ -5177,7 +5274,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>   	else
>   		num_stripes = map->num_stripes;
>   
> -	preferred_mirror = first + current->pid % num_stripes;
> +	preferred_mirror = first + guess_optimal(map, num_stripes,
> +						 current->pid % num_stripes);
>   
>   	if (dev_replace_is_ongoing &&
>   	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
> 
