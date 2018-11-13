Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB3EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 10:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 778DB2087A
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 10:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yTLRAvEi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 778DB2087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732287AbeKMUZY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 15:25:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731276AbeKMUZY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 15:25:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wADAP3XI043821;
        Tue, 13 Nov 2018 10:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=KKKa02Qb1uifn20GNtz8Tzh2nPb6UlQv3HK5vODFXSU=;
 b=yTLRAvEi7tAaCbGEEc9jtyuG8Yxfnr0Iz4Lv33Vq+xhxZY0Q9L5S96k0TJa5jNk3EdU0
 bspRHxwwByj1ortr4X8Famolcd0Kif922UO1B80DAomqNXEJbM0X1YPeD27+r1tr93Fz
 fL1Nf7pmWt8JRZo/0x89agiaGnwKG7BbW9bYWcISpb2/tFC3L3lrw9e3RZ1gjiun4r86
 fhwhrOD9GF9zHHHAbXi44kUMivnkEKCtqH1FHy4AlAyLZU5wTeucZ/zN7mNB79fQbJcs
 iOpEIUf8FCrC4LLg9HmMRq/CZabs5bFmTd5KPCQ91iFfu5c4GVjcpk69OB1zuzetwIDd VA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2nnwg19n8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Nov 2018 10:27:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wADARpnT003689
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Nov 2018 10:27:51 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wADARpc3019409;
        Tue, 13 Nov 2018 10:27:51 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Nov 2018 02:27:50 -0800
Subject: Re: [PATCH] btrfs: fix computation of max fs size for multiple device
 fs tests
To:     fdmanana@kernel.org, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <20181106153437.26870-1-fdmanana@kernel.org>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <4daaaa0e-b25f-4412-3b2f-0ccd578972a9@oracle.com>
Date:   Tue, 13 Nov 2018 18:27:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181106153437.26870-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9075 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811130098
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/06/2018 11:34 PM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We were sorting numerical values with the 'sort' tool without telling it
> that we are sorting numbers, giving us unexpected ordering. So just pass
> the '-n' option to the 'sort' tool.
> 
> Example:
> 
> $ echo -e "11\n9\n20" | sort
> 11
> 20
> 9
> 
> $ echo -e "11\n9\n20" | sort -n
> 9
> 11
> 20
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks for the fix.

Reviewed-by: Anand Jain <anand.jain@oracle.com>



> ---
>   tests/btrfs/124 | 2 +-
>   tests/btrfs/125 | 2 +-
>   tests/btrfs/154 | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/btrfs/124 b/tests/btrfs/124
> index ce3ad6aa..a52c65f6 100755
> --- a/tests/btrfs/124
> +++ b/tests/btrfs/124
> @@ -61,7 +61,7 @@ dev2=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
>   dev1_sz=`blockdev --getsize64 $dev1`
>   dev2_sz=`blockdev --getsize64 $dev2`
>   # get min of both
> -max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz" | sort | head -1`
> +max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz" | sort -n | head -1`
>   # Need disks with more than 2G.
>   if [ $max_fs_sz -lt 2000000000 ]; then
>   	_scratch_dev_pool_put
> diff --git a/tests/btrfs/125 b/tests/btrfs/125
> index e38de264..5ac68b67 100755
> --- a/tests/btrfs/125
> +++ b/tests/btrfs/125
> @@ -68,7 +68,7 @@ dev2_sz=`blockdev --getsize64 $dev2`
>   dev3_sz=`blockdev --getsize64 $dev3`
>   
>   # get min of both.
> -max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz\n$dev3_sz" | sort | head -1`
> +max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz\n$dev3_sz" | sort -n | head -1`
>   # Need disks with more than 2G
>   if [ $max_fs_sz -lt 2000000000 ]; then
>   	_scratch_dev_pool_put
> diff --git a/tests/btrfs/154 b/tests/btrfs/154
> index 99ea232a..cd6c688f 100755
> --- a/tests/btrfs/154
> +++ b/tests/btrfs/154
> @@ -51,7 +51,7 @@ DEV1_SZ=`blockdev --getsize64 $DEV1`
>   DEV2_SZ=`blockdev --getsize64 $DEV2`
>   
>   # get min
> -MAX_FS_SZ=`echo -e "$DEV1_SZ\n$DEV2_SZ" | sort | head -1`
> +MAX_FS_SZ=`echo -e "$DEV1_SZ\n$DEV2_SZ" | sort -n | head -1`
>   # Need disks with more than 2G
>   if [ $MAX_FS_SZ -lt 2000000000 ]; then
>   	_scratch_dev_pool_put
> 
