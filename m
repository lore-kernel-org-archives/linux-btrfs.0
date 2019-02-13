Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1F8C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 16:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1527521904
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 16:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NE53d4hw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbfBMQCy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:02:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729502AbfBMQCx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 11:02:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1DFn27i080102;
        Wed, 13 Feb 2019 16:02:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Fr6CD+55smMmtfRUGPpisdWSREBKHgKCT1hyx0m45K8=;
 b=NE53d4hwlBrg2ny3eYFTtIPSg4TkQdluoxFzY+KevdxE9RYtooR6OhBCK2oIyl7pLLqK
 qIhutUMO3t8tkiooGIV5qsPNuxz3n5Mbn+YUZ1KTmmFwViCAfSanLUD9xtzCVFCGatWT
 EK1E14zbhH7AsEBptW0tXvRtlJ6z51/LjD/9K7G99nAu5tsgU4cqYlm2W3O8XXHFX7xE
 3zIpFu/O//H1XV2KTBvdxwS1TaH35QOQyTB/vKJj2Dey8RTPHIZy9u/rE70SEiPTteQu
 edMWAI2qHQ5K474aIPk5U28vYevlLnBv6ysRCHJHPEer1icpvf6O1+TmOTLmyM9DiHFc EA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qhree2w8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Feb 2019 16:02:49 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1DG2hht008124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Feb 2019 16:02:44 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1DG2hGQ032036;
        Wed, 13 Feb 2019 16:02:43 GMT
Received: from [172.20.10.2] (/157.45.214.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Feb 2019 08:02:43 -0800
Subject: Re: [PATCH] btrfs: scrub: add assertions for worker pointers
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
 <20190212171540.11518-1-dsterba@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <9049a31d-703e-9800-8bde-6d86867e9e82@oracle.com>
Date:   Thu, 14 Feb 2019 00:02:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190212171540.11518-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902130114
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/13/19 1:15 AM, David Sterba wrote:
> The scrub worker pointers are not NULL iff the scrub is running, so
> reset them back once the last reference is dropped. Add assertions to
> the initial phase of scrub to verify that.

makes sense.

> Signed-off-by: David Sterba <dsterba@suse.com>


Reviewed-by: Anand Jain <anand.jain@oracle.com>



> ---
>   fs/btrfs/ctree.h | 4 ++++
>   fs/btrfs/scrub.c | 7 +++++++
>   2 files changed, 11 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7efa1edb30cd..f92f97304e69 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1075,6 +1075,10 @@ struct btrfs_fs_info {
>   	atomic_t scrubs_paused;
>   	atomic_t scrub_cancel_req;
>   	wait_queue_head_t scrub_pause_wait;
> +	/*
> +	 * The worker pointers are NULL iff the refcount is 0, ie. scrub is not
> +	 * running.
> +	 */
>   	refcount_t scrub_workers_refcnt;
>   	struct btrfs_workqueue *scrub_workers;
>   	struct btrfs_workqueue *scrub_wr_completion_workers;
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index d20150d68a90..669bedfec4a9 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3744,17 +3744,20 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
>   	lockdep_assert_held(&fs_info->scrub_lock);
>   
>   	if (refcount_read(&fs_info->scrub_workers_refcnt) == 0) {
> +		ASSERT(fs_info->scrub_workers == NULL);
>   		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
>   				flags, is_dev_replace ? 1 : max_active, 4);
>   		if (!fs_info->scrub_workers)
>   			goto fail_scrub_workers;
>   
> +		ASSERT(fs_info->scrub_wr_completion_workers == NULL);
>   		fs_info->scrub_wr_completion_workers =
>   			btrfs_alloc_workqueue(fs_info, "scrubwrc", flags,
>   					      max_active, 2);
>   		if (!fs_info->scrub_wr_completion_workers)
>   			goto fail_scrub_wr_completion_workers;
>   
> +		ASSERT(fs_info->scrub_parity_workers == NULL);
>   		fs_info->scrub_parity_workers =
>   			btrfs_alloc_workqueue(fs_info, "scrubparity", flags,
>   					      max_active, 2);
> @@ -3934,6 +3937,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>   		scrub_workers = fs_info->scrub_workers;
>   		scrub_wr_comp = fs_info->scrub_wr_completion_workers;
>   		scrub_parity = fs_info->scrub_parity_workers;
> +
> +		fs_info->scrub_workers = NULL;
> +		fs_info->scrub_wr_completion_workers = NULL;
> +		fs_info->scrub_parity_workers = NULL;
>   	}
>   	mutex_unlock(&fs_info->scrub_lock);
>   
> 
