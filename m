Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1765728AbdEYMv4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 08:51:56 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4PCn8xc100938
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 08:51:55 -0400
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2anh77h31j-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 08:51:55 -0400
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 25 May 2017 22:51:51 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4PCpdfV5964088
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 22:51:47 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4PCp7N6030006
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 22:51:08 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Roman Mamedov <rm@romanrm.net>,
        Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v3 2/2] Btrfs: compression must free at least PAGE_SIZE
Date: Thu, 25 May 2017 18:21:16 +0530
In-Reply-To: <20170520184039.31362-3-nefelim4ag@gmail.com>
References: <20170520184039.31362-1-nefelim4ag@gmail.com> <20170520184039.31362-3-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1950765.ANvucQrkZu@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, May 21, 2017 12:10:39 AM IST Timofey Titovets wrote:
> Btrfs already skip store of data where compression didn't free at least one byte.
> So make logic better and make check that compression free at least one PAGE_SIZE,
> because in another case it useless to store this data compressed
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/lzo.c  | 5 ++++-
>  fs/btrfs/zlib.c | 3 ++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index bd0b0938..39678499 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -229,8 +229,11 @@ static int lzo_compress_pages(struct list_head *ws,
>  		in_len = min(bytes_left, PAGE_SIZE);
>  	}
> 
> -	if (tot_out > tot_in)
> +	/* Compression must save at least one PAGE_SIZE */
> +	if (tot_out + PAGE_SIZE > tot_in) {
> +		ret = -E2BIG;
>  		goto out;
> +	}

Apologies for the delayed response.

I am not really sure if compression code must save atleast one sectorsize
worth of space. But if other developers agree to it, then the above
'if' condition can be replaced with,

u32 sectorsize = btrfs_inode_sectorsize(mapping->host);
...
...

if (tot_out + sectorsize > tot_in) {

> 
>  	/* store the size of all chunks of compressed data */
>  	cpage_out = kmap(pages[0]);
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index 135b1082..11e117b5 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -191,7 +191,8 @@ static int zlib_compress_pages(struct list_head *ws,
>  		goto out;
>  	}
> 
> -	if (workspace->strm.total_out >= workspace->strm.total_in) {
> +	/* Compression must save at least one PAGE_SIZE */
> +	if (workspace->strm.total_out + PAGE_SIZE > workspace->strm.total_in) {
>  		ret = -E2BIG;
>  		goto out;
>  	}
> --
> 2.13.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
chandan

