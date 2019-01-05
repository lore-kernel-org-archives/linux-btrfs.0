Return-Path: <SRS0=vb8r=PN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98439C43387
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 06:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 632B521871
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 06:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U2Y5EMiq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfAEGRp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 5 Jan 2019 01:17:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfAEGRp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2019 01:17:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x056H9Kc175885;
        Sat, 5 Jan 2019 06:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=c6Jo/DwfRY9aCRIIl1AuAafbRriIHQEJuk9C1bOUMo4=;
 b=U2Y5EMiqmGdzocbriS6QZ1IHVxL6nPBbPnZSNvyngmRjgQcmdjjKZs9g3hjLKWf1VV/n
 o3YrkJgvDJ+qxjkKkf04lZl3NpmAGfHuhONOUqf9KHRYxwOnLWEnu4pzdSrVI2B77PXN
 iDBz1cOdKqhmf0NvEyvPbPWRM+X6Ugbsv6pVtMzyzPTHi29LxbakwQbcvQQQu2Tecsev
 VdpkPrBnNwmRJi/7Qfr79THy1cSj7c/+weraBFYy+cgbm2jwFwBkoQz2VVi5nMPwsMZ3
 6GippIN0tNDUsmmir6Sp7CYqJAalvpkKVKm99waPvq+Pg5b6zi1NyUrsUKpNkwUPFXyK JQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2ptn7qg4tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Jan 2019 06:17:41 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x056HZ46015697
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 5 Jan 2019 06:17:35 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x056HZt3030985;
        Sat, 5 Jan 2019 06:17:35 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Jan 2019 22:17:35 -0800
Subject: Re: [PATCH 2/7] btrfs: Remove isize local variable in
 compress_file_range
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
 <20190103085005.32053-3-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <4a305171-3be6-c085-001a-0f98521499b8@oracle.com>
Date:   Sat, 5 Jan 2019 14:17:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190103085005.32053-3-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9126 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901050054
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/03/2019 04:50 PM, Nikolay Borisov wrote:
> It's used only once so just inline the call to i_size_read.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

> ---
>   fs/btrfs/inode.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 43baca50fba5..97ad494d0b3c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -453,7 +453,6 @@ static noinline void compress_file_range(struct inode *inode,
>   	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>   	u64 blocksize = fs_info->sectorsize;
>   	u64 actual_end;
> -	u64 isize = i_size_read(inode);
>   	int ret = 0;
>   	struct page **pages = NULL;
>   	unsigned long nr_pages;
> @@ -467,7 +466,7 @@ static noinline void compress_file_range(struct inode *inode,
>   	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
>   			SZ_16K);
>   
> -	actual_end = min_t(u64, isize, end + 1);
> +	actual_end = min_t(u64, i_size_read(inode), end + 1);
>   again:
>   	will_compress = 0;
>   	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
> 
