Return-Path: <SRS0=vb8r=PN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB65C43387
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 06:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95E0C208E3
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 06:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w80cIOnQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfAEGCS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 5 Jan 2019 01:02:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35308 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbfAEGCS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2019 01:02:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x055x0V1008621;
        Sat, 5 Jan 2019 06:02:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=pZK8RXbAfmfw1dwA+9wg0SxRLuSX6vBjkv8o1Vn1OzA=;
 b=w80cIOnQ2g6QK52KHwLfe43kC9og3X2Kj92H63JxkRRVWGCn1tPUZIR5/Tetbjk7XjH7
 EJvu1HF99ae9Da5wYpPMmB0AhZql4sQ8P70FcuBPScNp7952HT87GR1GmTn1GQ1ZWYzL
 bxXkfR/YADPmZmv9v/WvsBmU0uGh6Hvokvg8J06/uGBsizUI8JzZ0npPi2lByzkPgJf4
 lr8ZpKj5r6HzgxhNqFeMYr2EI/NvCveBfPDBv7/nJjoCXXy1JvfNkpbIgLpJn9/ibiij
 AzVPqrgafrdA/mGgKjQ2iAAIzYufPc62gs+38wGyyvhgdiTgQJ1+PG7NqylDLour2oyQ Gw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2ptm0tr8ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Jan 2019 06:02:14 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0562DOd024535
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 5 Jan 2019 06:02:13 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0562DIU025003;
        Sat, 5 Jan 2019 06:02:13 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Jan 2019 22:02:12 -0800
Subject: Re: [PATCH 1/7] btrfs: Remove inode argument from async_cow_submit
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
 <20190103085005.32053-2-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <79855009-a86f-c055-56d1-2ee06e9efbc5@oracle.com>
Date:   Sat, 5 Jan 2019 14:02:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190103085005.32053-2-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9126 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901050052
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/03/2019 04:49 PM, Nikolay Borisov wrote:
> We already pass the async_cow struct that holds a reference to the
> inode. Exploit this fact and remove the extra inode argument. No
> functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

  Reviewed-by: Anand Jain <anand.jain@oracle.com>


> ---
>   fs/btrfs/inode.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 38c0f385a617..43baca50fba5 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -714,9 +714,9 @@ static void free_async_extent_pages(struct async_extent *async_extent)
>    * queued.  We walk all the async extents created by compress_file_range
>    * and send them down to the disk.
>    */
> -static noinline void submit_compressed_extents(struct inode *inode,
> -					      struct async_cow *async_cow)
> +static noinline void submit_compressed_extents(struct async_cow *async_cow)
>   {
> +	struct inode *inode = async_cow->inode;
>   	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>   	struct async_extent *async_extent;
>   	u64 alloc_hint = 0;
> @@ -1167,7 +1167,7 @@ static noinline void async_cow_submit(struct btrfs_work *work)
>   		cond_wake_up_nomb(&fs_info->async_submit_wait);
>   
>   	if (async_cow->inode)
> -		submit_compressed_extents(async_cow->inode, async_cow);
> +		submit_compressed_extents(async_cow);
>   }
>   
>   static noinline void async_cow_free(struct btrfs_work *work)
> 
