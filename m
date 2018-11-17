Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E503BC43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 00:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C64F20858
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 00:53:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vBUmZ729"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C64F20858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbeKQLHh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 17 Nov 2018 06:07:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729736AbeKQLHh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Nov 2018 06:07:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAH0nShY112959;
        Sat, 17 Nov 2018 00:52:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=2gZ38bPj1hMAsB0Q3k/liMPrZfGQB4H7Cb4Cs1Nlxeo=;
 b=vBUmZ729/lo+D9d91TGxeKcdi6rI7w/taf2Mj37jkZCP6FbLOoYOHDqP9D++nsV9a3MA
 do0Ua+lSI9VEJK3ksXZW21TRNQ96g0ozZA6pjes/NlwasSYIJxlbj5muT/heMHgm/i5Q
 M9ON1YCcEVpUMHEnd7Si+J8vfEV3HRYu8lUKJu1VW3zObC/XsVd1q2HxZ8Ix/xqX6at0
 KwcKUFFYddyzAsWrAGaArZWBKaawQvLSEG5ee9Nx9G3LvsJ4HysHbN+/7u5dWT/uzPHn
 Uxn/rfyfLZl4UHJnei7LgWud9xfnxbrDrLXIoC06rjnGoFaVmDXXQNFYq1uZzPGlfFoZ Bg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2nr7cshseq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Nov 2018 00:52:54 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAH0qsLi027254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Nov 2018 00:52:54 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAH0qsNf029256;
        Sat, 17 Nov 2018 00:52:54 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Nov 2018 16:52:54 -0800
Subject: Re: [PATCH 4/5] btrfs: Sink find_lock_delalloc_range's 'max_bytes'
 argument
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-5-git-send-email-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <adb1c658-6889-e2db-d03b-0ca247c669d7@oracle.com>
Date:   Sat, 17 Nov 2018 08:53:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-5-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9079 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811170005
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/26/2018 07:43 PM, Nikolay Borisov wrote:
> All callers of this function pass BTRFS_MAX_EXTENT_SIZE (128M) so let's
> reduce the argument count and make that a local variable. No functional
> changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

   Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/extent_io.c             | 11 +++++------
>   fs/btrfs/extent_io.h             |  2 +-
>   fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
>   3 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 6877a74c7469..1a9a521aefe5 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1566,8 +1566,9 @@ static noinline int lock_delalloc_pages(struct inode *inode,
>   static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>   				    struct extent_io_tree *tree,
>   				    struct page *locked_page, u64 *start,
> -				    u64 *end, u64 max_bytes)
> +				    u64 *end)
>   {
> +	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
>   	u64 delalloc_start;
>   	u64 delalloc_end;
>   	u64 found;
> @@ -1647,10 +1648,9 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>   u64 btrfs_find_lock_delalloc_range(struct inode *inode,
>   				    struct extent_io_tree *tree,
>   				    struct page *locked_page, u64 *start,
> -				    u64 *end, u64 max_bytes)
> +				    u64 *end)
>   {
> -	return find_lock_delalloc_range(inode, tree, locked_page, start, end,
> -			max_bytes);
> +	return find_lock_delalloc_range(inode, tree, locked_page, start, end);
>   }
>   #endif
>   
> @@ -3233,8 +3233,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>   		nr_delalloc = find_lock_delalloc_range(inode, tree,
>   					       page,
>   					       &delalloc_start,
> -					       &delalloc_end,
> -					       BTRFS_MAX_EXTENT_SIZE);
> +					       &delalloc_end);
>   		if (nr_delalloc == 0) {
>   			delalloc_start = delalloc_end + 1;
>   			continue;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 369daa5d4f73..7ec4f93caf78 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -549,7 +549,7 @@ int free_io_failure(struct extent_io_tree *failure_tree,
>   u64 btrfs_find_lock_delalloc_range(struct inode *inode,
>   				      struct extent_io_tree *tree,
>   				      struct page *locked_page, u64 *start,
> -				      u64 *end, u64 max_bytes);
> +				      u64 *end);
>   #endif
>   struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
>   					       u64 start);
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index 9e0f4a01be14..8ea8c2aa6696 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -107,7 +107,7 @@ static int test_find_delalloc(u32 sectorsize)
>   	start = 0;
>   	end = 0;
>   	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>   	if (!found) {
>   		test_err("should have found at least one delalloc");
>   		goto out_bits;
> @@ -138,7 +138,7 @@ static int test_find_delalloc(u32 sectorsize)
>   	start = test_start;
>   	end = 0;
>   	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>   	if (!found) {
>   		test_err("couldn't find delalloc in our range");
>   		goto out_bits;
> @@ -172,7 +172,7 @@ static int test_find_delalloc(u32 sectorsize)
>   	start = test_start;
>   	end = 0;
>   	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>   	if (found) {
>   		test_err("found range when we shouldn't have");
>   		goto out_bits;
> @@ -193,7 +193,7 @@ static int test_find_delalloc(u32 sectorsize)
>   	start = test_start;
>   	end = 0;
>   	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>   	if (!found) {
>   		test_err("didn't find our range");
>   		goto out_bits;
> @@ -234,7 +234,7 @@ static int test_find_delalloc(u32 sectorsize)
>   	 * tests expected behavior.
>   	 */
>   	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>   	if (!found) {
>   		test_err("didn't find our range");
>   		goto out_bits;
> 
