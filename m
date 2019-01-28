Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A373AC282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 11:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70AE421741
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 11:47:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MwB/vVwF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfA1LrK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 06:47:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35628 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfA1LrJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 06:47:09 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0SBikqw188983;
        Mon, 28 Jan 2019 11:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=sSbhKmamCPbST2baz6RM5WHYfFuOpDRgc0XvVRFL0GM=;
 b=MwB/vVwFqbZS8uq/sQeCKpudM1aH54SdlGSk1xRy8KuAoRC9MNE9+oNP+oCLFfu/R1dk
 E/m4rSKTmisDaQwVzpAJPG98bZvBp+KfCVHf+UaYcIjrPL8ZTyNtnENdw85HNB5r9jYP
 bbnGSCo5z9Kk9yI59hmtpd/gl+bzs3hW8ovnLApgQZpxJSh4yLNzCQWbwkYRaGkE9xrx
 AryqOSpcK0Kd4BiBKjdfLHGCiIuhfkXX+WvCRZcp0vkCjzjl7Xa2SOCwmPoEpM4ZfuHA
 /DOzD06w6HBg8PJbhrmlEyAzcTHBV43JGNwPTm0ELTvJvyFNTTBgs15ZRn8QCU+xiUg+ 0g== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2q8d2dwt4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jan 2019 11:47:05 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0SBkx2J020740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jan 2019 11:46:59 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0SBkwA7017643;
        Mon, 28 Jan 2019 11:46:58 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Jan 2019 03:46:58 -0800
Subject: Re: [PATCH] btrfs: oops in device_list_add()
To:     Al Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
References: <20190127045755.GH2217@ZenIV.linux.org.uk>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <4b2ff563-c3c4-843b-f0d4-f1527465be20@oracle.com>
Date:   Mon, 28 Jan 2019 19:47:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190127045755.GH2217@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9149 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901280096
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 1/27/19 12:58 PM, Al Viro wrote:
> 	alloc_fs_devices() can return ERR_PTR(-ENOMEM), so
> dereferencing its result before the check for IS_ERR() is
> a bad idea...
> 
> Fixes: d1a63002829a4
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

  nice catch.
  Reviewed-by: Anand Jain <anand.jain@oracle.com>

> ---
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 85149f27644d..72adc5643bde 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -955,11 +955,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>   		else
>   			fs_devices = alloc_fs_devices(disk_super->fsid, NULL);
>   
> -		fs_devices->fsid_change = fsid_change_in_progress;
> -
>   		if (IS_ERR(fs_devices))
>   			return ERR_CAST(fs_devices);
>   
> +		fs_devices->fsid_change = fsid_change_in_progress;
> +
>   		mutex_lock(&fs_devices->device_list_mutex);
>   		list_add(&fs_devices->fs_list, &fs_uuids);
>   
> 
