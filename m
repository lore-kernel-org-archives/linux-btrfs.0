Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB643C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E6420672
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ctpccwdr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbeLQIZh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 03:25:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731707AbeLQIZh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 03:25:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBH8OC7B014476;
        Mon, 17 Dec 2018 08:25:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5bKtgLyAvjipL9fWWz9jjwoQdqYlCIbvfJjIWcU33Uc=;
 b=ctpccwdrOdWdx1s4DNpJ+wMpW+QZW8QBKrdqKpVf0Hu5cTRHpxGYDlF95CY1VLg3Q/wk
 w5J9IKEJisM16LyR4IKBZelz2DHqeom2geCHBsVTF9SC+n7PKG7+vFJZeYzI79o12DDj
 Cw1Z+M8x2tUzEV2yvyzibwoy3rk7X333HO106octoYlTQpQnifqY8bfouL1IJNRq6kY3
 HpKt1rA0g3OpDn4gJkJCEfRSDG/9Jm4q2PZp0spimsAaGUB2K/DUo1uC7XXb8vMujLXE
 7rDj1grTTvstypq65D8zC1JiWxfFbfUUS5CvK+uzpAwp9CHzMzjiy0PG+QvlfBPpuHVD zg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pcs1tcdb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 08:25:35 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBH8PTQ0027031
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 08:25:29 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBH8PT9o011574;
        Mon, 17 Dec 2018 08:25:29 GMT
Received: from [172.20.10.2] (/157.49.131.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Dec 2018 00:25:29 -0800
Subject: Re: [PATCH] Btrfs: do not overwrite error return value in the balance
 ioctl
To:     fdmanana@kernel.org
References: <20181214194541.21891-1-fdmanana@kernel.org>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <9c378108-591d-e275-8898-3c67d97156fa@oracle.com>
Date:   Mon, 17 Dec 2018 16:25:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181214194541.21891-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170080
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/15/2018 03:45 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the call to btrfs_balance() failed we would overwrite the error
> returned to user space with -EFAULT if the call to copy_to_user() failed
> as well. Fix that by calling copy_to_user() only if btrfs_balance()
> returned success.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   fs/btrfs/ioctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index abe45fd97ab5..4ad7288f77d0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4707,7 +4707,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>   	ret = btrfs_balance(fs_info, bctl, bargs);
>   	bctl = NULL;
>   
> -	if (arg) {
> +	if (ret == 0 && arg) {
>   		if (copy_to_user(arg, bargs, sizeof(*bargs)))
>   			ret = -EFAULT;
>   	}
> 

This changes the BTRFS_IOC_BALANCE_V2 semantics.

Originally, if BTRFS_IOC_BALANCE_V2 is failed/canceled we do update
bargs [1] and copy to user land, but after this patch we copy only
if the ioctl is successful. I doubt if David is OK with that.

[1]
----------
3717 int btrfs_balance(struct btrfs_fs_info *fs_info,
3718                   struct btrfs_balance_control *bctl,
3719                   struct btrfs_ioctl_balance_args *bargs)
3720 {
::

3855         ret = __btrfs_balance(fs_info);
3856
3857         mutex_lock(&fs_info->balance_mutex);
3858         clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
3859
3860         if (bargs) {
3861                 memset(bargs, 0, sizeof(*bargs));
3862                 btrfs_update_ioctl_balance_args(fs_info, bargs);
3863         }

