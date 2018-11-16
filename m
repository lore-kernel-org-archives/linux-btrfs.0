Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F50FC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 23:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC71E20883
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 23:57:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OrAduHVD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC71E20883
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbeKQKLd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 17 Nov 2018 05:11:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44056 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbeKQKLd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Nov 2018 05:11:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAGNmmZr113923;
        Fri, 16 Nov 2018 23:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Tr+weY7kAUDdJKOvec91/FUkDJXmtKHcjQNhBflp+Ag=;
 b=OrAduHVDKVJCCCS0F923vqx0An/4z4Ox26cVpVSYsHHiAr5SLVO8lqiEIVzo5FbZzrY9
 yQrTREkTPHuJ6zyTnUbqddgaWoT+96z6QIdFGKq3P+5tmuFUORLmU0UI4+bN3MetxbxY
 zfUFg1aXytS3+APYdtSXleKrw7rVH+HIVCorKKHQz+qywDLvCfv/UYeEuKviSHK2Q6m4
 wRuSTkAhSApDshSiJAha5Pn21xW5g5IE8PPxLVTxJq9jSCw1X6DQYXFClW6UySmRGB9R
 Re7Gh/KSm/3YwVFkuCVm3kD1y+dvIpeEQfoGz7gpA7vk68Dp0utseBOSAKo1qHOCWlJ+ RA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2nr7cshsgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 23:57:02 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAGNv1lm004437
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 23:57:01 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAGNv0TY020311;
        Fri, 16 Nov 2018 23:57:01 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Nov 2018 15:57:00 -0800
Subject: Re: [PATCH 3/5] btrfs: Remove superfluous check form
 btrfs_remove_chunk
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-4-git-send-email-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <c15bdbc1-a987-0207-b415-dbe69d6996db@oracle.com>
Date:   Sat, 17 Nov 2018 07:57:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-4-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9079 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811160211
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/26/2018 07:43 PM, Nikolay Borisov wrote:
> It's unnecessary to check map->stripes[i].dev for NULL given its value
> is already set and dereferenced above the the check. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/volumes.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index dc53d94a62aa..f0db43d08456 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2797,13 +2797,11 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
>   			mutex_unlock(&fs_info->chunk_mutex);
>   		}
>   
> -		if (map->stripes[i].dev) {
> -			ret = btrfs_update_device(trans, map->stripes[i].dev);
> -			if (ret) {
> -				mutex_unlock(&fs_devices->device_list_mutex);
> -				btrfs_abort_transaction(trans, ret);
> -				goto out;
> -			}
> +		ret = btrfs_update_device(trans, device);
> +		if (ret) {
> +			mutex_unlock(&fs_devices->device_list_mutex);
> +			btrfs_abort_transaction(trans, ret);
> +			goto out;
>   		}
>   	}
>   	mutex_unlock(&fs_devices->device_list_mutex);
> 
