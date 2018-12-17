Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97EBC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 03:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9A6D20645
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 03:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fEIvBgW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbeLQDCV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 16 Dec 2018 22:02:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbeLQDCV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Dec 2018 22:02:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBH32AJp155102;
        Mon, 17 Dec 2018 03:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=uHpU8gKuY8NiCLDRQ89ZHjgDWELnRnYLOntEpkKsZNo=;
 b=fEIvBgW0C14+zwibi36RlS2ywuflKfJaunwWGQ/vDgtXJcI5oX/Vgtn5tyvJriD/D1j9
 OoSKtQLqhvqP1C/kIBmUrHIwWTeBG02DHuytE/J+tp9fWtxlgzhrWRbcKiBQI4E1il0i
 GSDw9io/R+rFHeq+/SiRIynq8iKKNTgAJ5un+ieRWbiaPdZaZKV+R66XGwpHPki7MzSM
 EvHOXZ8aNuYfxXABrz3TnUAxsZkXRQxzvHGUVVg0VrjAI8JeemScrZB4/utOnKMxvcy/
 IpRceUJORoxGirhlnfOSQrdugntXTJ4GcUkXXQIilwHxBtCL9dWiqcsYk+h0VBfOShL4 zg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2pct8qkfpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 03:02:10 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBH329iI010089
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 03:02:09 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBH329BD016473;
        Mon, 17 Dec 2018 03:02:09 GMT
Received: from [172.20.10.2] (/157.49.189.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 16 Dec 2018 19:02:08 -0800
Subject: Re: [PATCH -next] btrfs: remove set but not used variable 'num_pages'
To:     linux-btrfs@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, David Sterba <dsterba@suse.com>
References: <1544855467-154115-1-git-send-email-yuehaibing@huawei.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <477d62ef-0881-631a-6b18-02c5756da8ce@oracle.com>
Date:   Mon, 17 Dec 2018 11:02:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1544855467-154115-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170027
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


(cc-list-updated)

On 12/15/2018 02:31 PM, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> fs/btrfs/ioctl.c: In function 'btrfs_extent_same':
> fs/btrfs/ioctl.c:3260:6: warning:
>   variable 'num_pages' set but not used [-Wunused-but-set-variable]
> 
> It not used any more since commit 9ee8234e6220 ("Btrfs: use
> generic_remap_file_range_prep() for cloning and deduplication")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

This can be rolled up to 9ee8234e6220.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


> ---
>   fs/btrfs/ioctl.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index fab9443..15fc467 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3257,7 +3257,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>   			     struct inode *dst, u64 dst_loff)
>   {
>   	int ret;
> -	int num_pages = PAGE_ALIGN(BTRFS_MAX_DEDUPE_LEN) >> PAGE_SHIFT;
>   	u64 i, tail_len, chunk_count;
>   
>   	/* don't make the dst file partly checksummed */
> @@ -3270,8 +3269,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>   
>   	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
>   	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
> -	if (chunk_count == 0)
> -		num_pages = PAGE_ALIGN(tail_len) >> PAGE_SHIFT;
>   
>   	for (i = 0; i < chunk_count; i++) {
>   		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
> 
> 
> 
