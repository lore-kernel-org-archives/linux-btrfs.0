Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860EFC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40CC422419
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QQVgERvN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40CC422419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbeKNXZn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:25:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbeKNXZn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:25:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAEDIgRT116397;
        Wed, 14 Nov 2018 13:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=EqvXIYMLpUnluT+MuXzr2iaCEK4/qPpOTXpy24QcAmY=;
 b=QQVgERvNG5P1tO3nu1okG8Z+Mx9WWQClZOQY6YFius4cYlniRb15kwIbFivBdCgBfgxv
 NARE3na8BEKldtxIytgFw7HYjQpzMmlq1W94TezOWPJOgTMeCgg8WodZbXcZ7t4B+Mrn
 s46J3yWjzV/LygxefO1pfg5QdJNwXIjJqdWZbmPAnuerVryudN5hMZR3Iticmye/56F8
 xNwvMAJVB1awxeTM9+KWyu8BFgoGHYioF4/dtX63emGQnHC42q70Tek5aq+4LTSsKlVr
 aBUVfWLM/pDgCF10k/Q1iwn15jd8EX5Xzlh97R0WU8we7Wl6MCnaJPQdV9MEVdrgQvO8 8Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2nr7cs3bvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 13:22:26 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDMOrU002533
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 13:22:25 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAEDMOXa006475;
        Wed, 14 Nov 2018 13:22:24 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 05:22:24 -0800
Subject: Re: [PATCH] Btrfs: ensure path name is null terminated at
 btrfs_control_ioctl
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181114113524.7102-1-fdmanana@kernel.org>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <76f99c2a-4433-d2cf-f3d0-82ce2ce2d7af@oracle.com>
Date:   Wed, 14 Nov 2018 21:22:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181114113524.7102-1-fdmanana@kernel.org>
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



On 11/14/2018 07:35 PM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We were using the path name received from user space without checking that
> it is null terminated. While btrfs-progs is well behaved and does proper
> validation and null termination, someone could call the ioctl and pass
> a non-null terminated patch, leading to buffer overrun problems in the
> kernel.
> 
> So just set the last byte of the path to a null character, similar to what
> we do in other ioctls (add/remove/resize device, snapshot creation, etc).
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/super.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 6601c9aa5e35..8ad145820ea8 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2235,6 +2235,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>   	vol = memdup_user((void __user *)arg, sizeof(*vol));
>   	if (IS_ERR(vol))
>   		return PTR_ERR(vol);
> +	vol->name[BTRFS_PATH_NAME_MAX] = '\0';
>   
>   	switch (cmd) {
>   	case BTRFS_IOC_SCAN_DEV:
> 
