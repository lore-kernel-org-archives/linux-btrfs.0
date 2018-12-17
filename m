Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79CDC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 09:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A6920672
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 09:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mF3EFVAk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbeLQJCC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 04:02:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbeLQJCC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 04:02:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBH8xZ6h040569;
        Mon, 17 Dec 2018 09:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=LWRhTlhycV/ryN510xpOfXuDPO+vqm5WzH4fiwQ6wes=;
 b=mF3EFVAkfIZfnlm57qDJ3o2DZDp0+j9jAecpd0lIXGzkOYRJj+FWhoSdh3cg+NVtv+NF
 i2pLITqN+5uVqsd+ZqAa1S2Kgzd0/t7sit4hL4HMkrAaovkvZQVWF+ecbcngdHU1FI+Y
 XMG4lhUTieZp7BHBTPNyupOYnpNYC7LxBg6A61u4u4AQWJg6E6g06jf8fKsNWWA9Bs8H
 jYmYorZry/QcpMvbf5YACPYzGoe6KdgERntV6aC3L4fsTT6g0IaZo7+xPWHnRJ/gJNOa
 uzgpzQAwS09FsjfixFEp+48MCvll1BlUBZElTqp0K6pT4CpiDRpp7tChtqyeyleyLHaU cw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2pcs1tchmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 09:02:00 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wBH91xIs031639
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 09:01:59 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBH91xZT013380;
        Mon, 17 Dec 2018 09:01:59 GMT
Received: from [172.20.10.2] (/157.49.131.42)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Dec 2018 01:01:58 -0800
Subject: Re: [PATCH] Btrfs: do not overwrite error return value in scrub
 progress ioctl
To:     fdmanana@kernel.org
References: <20181214194513.21741-1-fdmanana@kernel.org>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <0cefc6e0-ec1f-4d5b-ffd0-968d62a2abac@oracle.com>
Date:   Mon, 17 Dec 2018 17:02:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181214194513.21741-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170085
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/15/2018 03:45 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the call to btrfs_scrub_progress() failed we would overwrite the error
> returned to user space with -EFAULT if the call to copy_to_user() failed
> as well. Fix that by calling copy_to_user() only if btrfs_scrub_progress()
> returned success.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

> ---
>   fs/btrfs/ioctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 01d18e1a393e..76848214a39f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4331,7 +4331,7 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_fs_info *fs_info,
>   
>   	ret = btrfs_scrub_progress(fs_info, sa->devid, &sa->progress);
>   
> -	if (copy_to_user(arg, sa, sizeof(*sa)))
> +	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
>   		ret = -EFAULT;
>   
>   	kfree(sa);
> 
