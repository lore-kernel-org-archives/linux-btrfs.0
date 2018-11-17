Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ECBC43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 01:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAF4520858
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 01:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ih0hS5+/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAF4520858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbeKQLRK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 17 Nov 2018 06:17:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52830 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbeKQLRK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Nov 2018 06:17:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAH10NCq155460;
        Sat, 17 Nov 2018 01:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=9apKkUzL6sDavLxJ5JN0f5H1pXVdF0+tP9HjWVB1mTs=;
 b=Ih0hS5+/TIlwsRe/mxgD+dkIk8wOxcLRD8j4lNYVLFBF/3WjNd4xk26kuN/g+PUqZmH/
 /2MyZb31Wrmc+pB6d/WcasOhpmWVHwiurh5aREE6pXz7Lj3x42Jara1H38NHLbKgvk/y
 oiSazCZEvb6unV7/CtcIsiVmdrKjW+cUxNPV5i5Ds+02WqwnllsL2hEsVb7XrSGnn89k
 LtBLXe2tSEofxSP5QWpp///IvDysfoh/vkn3afAjkCqizMmJz1naw2jS9mPQkzAnicMO
 TmkJ+wEWO8Z9nWSiJ8rWhdhLixlPfH9Fhyziz+ePl6Yd6I08XAHcTAdvle6fbga1GAEp PQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nr7cshvfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Nov 2018 01:02:27 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAH12PnZ015033
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Nov 2018 01:02:26 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAH12PwT008505;
        Sat, 17 Nov 2018 01:02:25 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Nov 2018 17:02:25 -0800
Subject: Re: [PATCH 5/5] btrfs: Replace BUG_ON with ASSERT in
 find_lock_delalloc_range
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-6-git-send-email-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <c9c00cc5-64b0-1860-53c5-a9d54c6d06f6@oracle.com>
Date:   Sat, 17 Nov 2018 09:02:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-6-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9079 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811170006
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/26/2018 07:43 PM, Nikolay Borisov wrote:
> lock_delalloc_pages should only return 2 values - 0 in case of success
> and -EAGAIN if the range of pages to be locked should be shrunk due to
> some of gone. Manual inspections confirms that this is
> indeed the case since __process_pages_contig is where lock_delalloc_pages
> gets its return value. The latter always returns 0  or -EAGAIN so the
> invariant holds. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/extent_io.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1a9a521aefe5..94bc53472031 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1606,6 +1606,7 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>   	/* step two, lock all the pages after the page that has start */
>   	ret = lock_delalloc_pages(inode, locked_page,
>   				  delalloc_start, delalloc_end);
> +	ASSERT(!ret || ret == -EAGAIN);
>   	if (ret == -EAGAIN) {
>   		/* some of the pages are gone, lets avoid looping by
>   		 * shortening the size of the delalloc range we're searching
> @@ -1621,7 +1622,6 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>   			goto out_failed;
>   		}
>   	}
> -	BUG_ON(ret); /* Only valid values are 0 and -EAGAIN */
>   
>   	/* step three, lock the state bits for the whole range */
>   	lock_extent_bits(tree, delalloc_start, delalloc_end, &cached_state);
> 
