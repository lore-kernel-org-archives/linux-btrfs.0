Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E13C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 10:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDAC82133F
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 10:30:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CvCVas7X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbeLQKaL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 05:30:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbeLQKaL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 05:30:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBHAT0Za116640;
        Mon, 17 Dec 2018 10:30:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=4XYFoBPGxnqzIxcZnBsI+YijXWJWJs3A4dXKYyTVQio=;
 b=CvCVas7Xnr94f0kr76DP2TjeDct1JcDt3XEu1vOnsTWMSrCjEM7Rkaz3flNsk7i2o5lL
 Dwg7Sy2Y62XMmleId4HXBP67kvIBQc93/BE8nNCSxSkAGfX16ez1ClSe6luefus9QAGz
 cTrK4lEKmI6GsV3ncXyKNDlUj1DqiOC7uTAGQG+PUJwZeOR2JZ2wNpNJUp9/tbcV71ov
 cy7sf0ykYNfsp63H+8+fafs08vjq/2HtRrphFwPqRSsevXjD1z0F6Zx0T9Ui88FD2kCA
 sMznnZoxoct8ZWvgw3xe5+Jto2C/7hVJDR9/ZrpyZPJsTrfSp4yF8ep36nP6hqwtQMDm Dg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pcs1td03r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 10:30:08 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wBHAU86Y020366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 10:30:08 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wBHAU8su026949;
        Mon, 17 Dec 2018 10:30:08 GMT
Received: from [172.20.10.2] (/157.49.131.42)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Dec 2018 02:30:08 -0800
Subject: Re: [PATCH] Btrfs: do not overwrite error return value in the device
 replace ioctl
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181214194532.21841-1-fdmanana@kernel.org>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <1a06c374-c9b2-db42-0fec-8358084fbea1@oracle.com>
Date:   Mon, 17 Dec 2018 18:30:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181214194532.21841-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170099
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/15/2018 03:45 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the call to btrfs_dev_replace_by_ioctl() failed we would overwrite the
> error returned to user space with -EFAULT if the call to copy_to_user()
> failed as well. Fix that by calling copy_to_user() only if no error
> happened before.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   fs/btrfs/ioctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0b101df822e9..abe45fd97ab5 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4401,7 +4401,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
>   		break;
>   	}
>   
> -	if (copy_to_user(arg, p, sizeof(*p)))
> +	if (ret == 0 && copy_to_user(arg, p, sizeof(*p)))

  Its the same thing here too.. we copy ret to args->result even
  if it fails. Now with this patch, if ret is non-zero, its not
  in args->result at the userland anymore.  If there
  is any tool which just checks args->result will be at problem,
  which I think is rare, should be ok. It would have been nice
  to have this design as in this patch, in the original code.

------
  530         ret = btrfs_dev_replace_start(fs_info, 
args->start.tgtdev_name,
  531                                         args->start.srcdevid,
  532                                         args->start.srcdev_name,
  533 
args->start.cont_reading_from_srcdev_mode);
  534         args->result = ret;
--------



>   		ret = -EFAULT;
>   out:
>   	kfree(p);
> 
