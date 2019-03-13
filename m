Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F59CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 10:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6621C214AE
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 10:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vZbk7odV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfCMKdl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:33:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52300 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMKdl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 06:33:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2DAT97Y178938
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 10:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=DWJnZfvt3u/neLJgD4kn1ciay1JCF5wS8x5f+8s2aJs=;
 b=vZbk7odVvbRja4jQCHKLjHx5aij9AdU1KUmvc/LRF+NnSzOinxO0BcersAbt24gWbGvE
 bP3I1lbFOcwwd08OK8P+0kX6JLjM23BxbMd2sHWEx5Qufo1O7M2jxw4WRVRoUJ1c8P1w
 mdCEa9ZAQaMYDbm0HQ+DNxtFaUawtUgilLZjzx0Nt7SETjdxldnn9nXbaz9rKwZjAEAl
 dP4xoxp1myIdw8OmQSoJVzTzbEqRx6KcwMBGZxNQZvv4beoocmSmxNt9jiZLRguSKEhn
 rowe2NtdZlSGs0CnnrAM/0dpZukDBi1qq2qdoHYBzBwRZvNYZwwWArPo7ul4EetnL6nK pA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2r430ethp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 10:33:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2DAXdhW031356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 10:33:39 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2DAXcBJ016022
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 10:33:39 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Mar 2019 03:33:38 -0700
Subject: Re: [PATCH 2/2] btrfs: fix vanished compression property after failed
 set
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
References: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
 <1552455379-2311-2-git-send-email-anand.jain@oracle.com>
Message-ID: <60c3e0c1-52dd-5389-e244-c82776b214a1@oracle.com>
Date:   Wed, 13 Mar 2019 18:33:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <1552455379-2311-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9193 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903130077
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org




On 3/13/19 1:36 PM, Anand Jain wrote:
> The compression property resets to NULL, instead of the old value if we
> fail to set the new compression parameter.
> 
> btrfs prop get /btrfs compression
>    compression=lzo
> btrfs prop set /btrfs compression zli
>    ERROR: failed to set compression for /btrfs: Invalid argument
> btrfs prop get /btrfs compression
> 
> This is because the compression property ->validate() is successful for
> 'zli' as the strncmp() used the len passed from the userland.
> 
> Fix it by using the expected string length in strncmp().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/props.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index ef6502a94712..7aa362c2fbcf 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -277,11 +277,11 @@ static int prop_compression_validate(struct inode *inode, const char *value,
>   	if (!value)
>   		return 0;
>   
> -	if (!strncmp("lzo", value, len))
> +	if (!strncmp("lzo", value, 3))
>   		return 0;
> -	else if (!strncmp("zlib", value, len))
> +	else if (!strncmp("zlib", value, 4))
>   		return 0;
> -	else if (!strncmp("zstd", value, len))
> +	else if (!strncmp("zstd", value, 4))
>   		return 0;
>


   Nack.
Now some junk value after expected string is not an error.
such as..

btrfs prop set /btrfs compression lzo110

Thanks, Anand

>   	return -EINVAL;
> 
