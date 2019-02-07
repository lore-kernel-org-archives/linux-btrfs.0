Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51008C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 21:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D9162080A
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 21:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SQQuBXuG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfBGVi2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 16:38:28 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfBGVi2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 16:38:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x17LXh6e166364;
        Thu, 7 Feb 2019 21:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=eY+qHU8nJjuzhr8K1VB1wHLGTSji2WgY+s0WEaIX+xs=;
 b=SQQuBXuGT6Dd63SNKvnklEvCVLFFUrKpoYH4GbG+YQmoUk9CcZX7kBq42/gsx3ORVNET
 1nepyVwXlOuJTcioqPQt55mzHGeXd/Jw7zyf4ZwMOW7eth7pPv40BkB61Gwc5wngfgyF
 qlmPv1sQIN4U14h68WeEDmXr42gzWUKTkvDgcFvb95CotEtbspMGohJP04xCc54ssiyV
 TTZuK+1A/FpqFi2mI7MCNDeGnlfSXPLXRxd2cWn/RAg+zNPnk8SCu0cHJ9LNbkHY2UM3
 Sg1B8oyQqOmSOuTwerZQeI+o3DMVdiJrB+n/sYcvZoNIDygVqIUswI5VVQCQ1gLiTP5f pg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qd98nhhsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Feb 2019 21:38:24 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x17LcMgR015959
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Feb 2019 21:38:23 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x17LcMLd023868;
        Thu, 7 Feb 2019 21:38:22 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 13:38:22 -0800
Subject: Re: [PATCH RESEND 1/2] btrfs-progs: check for no result before using
 results
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <1548929141-10695-1-git-send-email-anand.jain@oracle.com>
Message-ID: <d2c82791-7bd7-ffa5-a90b-a65fe41d7030@oracle.com>
Date:   Fri, 8 Feb 2019 05:38:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1548929141-10695-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9160 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902070155
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Ping?

Thanks, Anand

On 1/31/19 6:05 PM, Anand Jain wrote:
> User space understands the ioctl BTRFS_IOC_DEV_REPLACE command status
> using the struct btrfs_ioctl_dev_replace_args::result, and so userspace
> initializes this to BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT, so exclude
> this value in checking for the error.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
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
