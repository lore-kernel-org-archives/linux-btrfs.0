Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF693C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 11:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88367218A6
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 11:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HA0dFBzX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfAYLVP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 06:21:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34152 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfAYLVO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 06:21:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0PBDuIX005242;
        Fri, 25 Jan 2019 11:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=Fee63T4XG7JoLBlCXHYucVvGhRV0EAOxbP9sM+ZBwbA=;
 b=HA0dFBzXoWm+cv3qtxfQmT02Gelebtc7xHg0rL/hBmcpKx5bB3Ljf5M0TBu2KA6D2APq
 qHSkQmsTjFtSxoTGevRQi4GJGM6kmWsN8wZ3VCfuyZfHBwCrrY+A/ZUV4mtUIM8hmzCK
 D7pRt78n0e7eGNWiSa9tJ8K+NjsVWI59GUYgeNb8AtujikuqlUXMV6VC9O92QEugFaBR
 EaC5ZCKEOIUV4vU7FGl+iUPX0pxpG29jiaBnC45tFoRwNHqfkX3vxvJtUzY+EPNM4UpF
 e1BSRJrH7YGhbq/woTB0VRW0GjQExzfX7mkYfxvIPvHmdn9Hjxvvct29dHM+Np8FX/49 rA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2q3vhs56gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jan 2019 11:21:09 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0PBL8Bl030970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jan 2019 11:21:09 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0PBL8kk005332;
        Fri, 25 Jan 2019 11:21:08 GMT
Received: from [10.191.54.67] (/10.191.54.67)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Jan 2019 03:21:08 -0800
Subject: Re: [PATCH RESEND 1/2] btrfs-progs: check for no result before using
 results
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <1547608406-6430-1-git-send-email-anand.jain@oracle.com>
Message-ID: <f06e2e0b-7038-f35d-afbc-7f20d34d4aac@oracle.com>
Date:   Fri, 25 Jan 2019 19:21:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1547608406-6430-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9146 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901250094
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 1/16/19 11:13 AM, Anand Jain wrote:
> User space understands the ioctl BTRFS_IOC_DEV_REPLACE command status
> using the struct btrfs_ioctl_dev_replace_args::result, and so userspace
> initializes this to BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT, so exclude
> this value in checking for the error.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

  Ping.

> ---
>   cmds-replace.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/cmds-replace.c b/cmds-replace.c
> index b30e6c781e64..42de4de8c031 100644
> --- a/cmds-replace.c
> +++ b/cmds-replace.c
> @@ -296,6 +296,8 @@ static int cmd_replace_start(int argc, char **argv)
>   		}
>   
>   		if (start_args.result !=
> +		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT &&
> +		    start_args.result !=
>   		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
>   			error("ioctl(DEV_REPLACE_START) on '%s' returns error: %s",
>   				path,
> 
