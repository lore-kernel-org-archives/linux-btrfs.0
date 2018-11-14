Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9A8C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F3D82145D
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YSequufe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F3D82145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbeKNXWr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:22:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47268 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbeKNXWr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:22:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAEDIgRB116397;
        Wed, 14 Nov 2018 13:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hL/gcBcOKBDQU4NXokJZWlJrnyG3+tIfoXO3jDXigg4=;
 b=YSequufed0gu4KgcigB+3mOCXn/jGi5U7nEZzyl7Bi7hMOIvmOJIREukFcxIDzY8XlXJ
 GcKwsRDz9Vp3t3m5wAKeBmNbZjL7WAGgzQCofnRpvAwjZNDjqXC5qCSaliJ3LKUSy1xU
 zxRpe3Pe9C+/J60HSJmzDf5ooUB9tu1qvwvA4DPFIXE1aXO00yJFrUuRdAYXQO+XlNb+
 OM68/wPiBEbzXTJ0SKCvaD9729UBaptPPqqpWXYCv94Roe5CO+OxHRg3AOPiY7rXy8+O
 hyZqRu4DDKr/ILpJgSe5/+PiEB+kbt4hBm692BYz4bzyD0NbrcW9Nog+D6aRo26snxON IQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nr7cs3bgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 13:19:26 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDJPsC000508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 13:19:25 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDJPNl004737;
        Wed, 14 Nov 2018 13:19:25 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 05:19:25 -0800
Subject: Re: [PATCH] btrfs: Fix suspicious RCU usage warning in
 device_list_add
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181114072456.4746-1-lufq.fnst@cn.fujitsu.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <80806de4-b8ae-b0ec-cf2d-793076642ca8@oracle.com>
Date:   Wed, 14 Nov 2018 21:19:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181114072456.4746-1-lufq.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140121
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/14/2018 03:24 PM, Lu Fengqi wrote:
> =============================
> WARNING: suspicious RCU usage
> 4.20.0-rc2+ #23 Tainted: G           O
> -----------------------------
> fs/btrfs/volumes.c:886 suspicious rcu_dereference_check() usage!
> 
> Use btrfs_info_in_rcu instead of pr_info for the required lock/unlock of
> RCU string.
> 
> Fixes: 1f265fc6f58b ("btrfs: harden agaist duplicate fsid on scanned devices")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

  Thanks Lu. I missed it.
  Reviewed-by: Anand Jain <anand.jain@oracle.com>


> ---
>   fs/btrfs/volumes.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2186300bab91..6039ae5c549e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -873,15 +873,15 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>   			if (device->bdev != path_bdev) {
>   				bdput(path_bdev);
>   				mutex_unlock(&fs_devices->device_list_mutex);
> -				pr_warn(
> -		"BTRFS: duplicate device fsid:devid for %pU:%llu old:%s new:%s\n",
> +				btrfs_warn_in_rcu(device->fs_info,
> +			"duplicate device fsid:devid for %pU:%llu old:%s new:%s\n",
>   					disk_super->fsid, devid,
>   					rcu_str_deref(device->name), path);
>   				return ERR_PTR(-EEXIST);
>   			}
>   			bdput(path_bdev);
> -			pr_info(
> -			"BTRFS: device fsid %pU devid %llu moved old:%s new:%s\n",
> +			btrfs_info_in_rcu(device->fs_info,
> +			"device fsid %pU devid %llu moved old:%s new:%s\n",
>   				disk_super->fsid, devid,
>   				rcu_str_deref(device->name), path);
>   		}
> 
