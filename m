Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36677 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754863AbdCIPkI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 10:40:08 -0500
Subject: Re: [PATCH v3] btrfs: add missing memset while reading compressed
 inline extents
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        <linux-btrfs@vger.kernel.org>
References: <1489025563-8071-1-git-send-email-ce3g8jdj@umail.furryterror.org>
From: Chris Mason <clm@fb.com>
Message-ID: <446e5250-2a96-5f46-737f-5c142bfc1471@fb.com>
Date: Thu, 9 Mar 2017 10:39:49 -0500
MIME-Version: 1.0
In-Reply-To: <1489025563-8071-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/08/2017 09:12 PM, Zygo Blaxell wrote:
> This is a story about 4 distinct (and very old) btrfs bugs.
>

Really great write up.

[ ... ]

>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 25ac2cf..4d41a31 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6805,6 +6805,12 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>  	max_size = min_t(unsigned long, PAGE_SIZE, max_size);
>  	ret = btrfs_decompress(compress_type, tmp, page,
>  			       extent_offset, inline_size, max_size);
> +	WARN_ON(max_size + pg_offset > PAGE_SIZE);

Can you please drop this WARN_ON and make the math reflect any possible 
pg_offset?  I do agree it shouldn't be happening, but its easy to 
correct for and the WARN is likely to get lost.

> +	if (max_size + pg_offset < PAGE_SIZE) {
> +		char *map = kmap(page);
> +		memset(map + pg_offset + max_size, 0, PAGE_SIZE - max_size - pg_offset);
> +		kunmap(page);
> +	}

Both lzo and zlib have a memset to cover the gap between what they 
actually decompress and the max_size that we pass here.  That's 
important because ram_bytes may not be 100% accurate.

Can you also please toss in a comment about how the decompression code 
is responsible for the memset up to max_bytes?

-chris
